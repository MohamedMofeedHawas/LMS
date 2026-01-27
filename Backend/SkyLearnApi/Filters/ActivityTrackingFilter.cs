using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Serilog;
using SkyLearnApi.Helpers;
using SkyLearnApi.Services.Interfaces;

namespace SkyLearnApi.Filters
{
     
    /// Global action filter that handles cross-cutting concerns:
    /// - Stopwatch timing
    /// - Structured logging (request/response)
    /// - Analytics tracking
    /// - Exception logging
    /// 
    /// Issue #8 fix: Removes repetitive boilerplate from controllers.
     
    public class ActivityTrackingFilter : IAsyncActionFilter
    {
        private readonly IActivityService _activityService;

        public ActivityTrackingFilter(IActivityService activityService)
        {
            _activityService = activityService;
        }

        public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            var stopwatch = Stopwatch.StartNew();
            var controllerName = context.RouteData.Values["controller"]?.ToString() ?? "Unknown";
            var actionName = context.RouteData.Values["action"]?.ToString() ?? "Unknown";
            var httpMethod = context.HttpContext.Request.Method;
            var path = context.HttpContext.Request.Path.ToString();

            // Get user ID from claims
            var userIdClaim = context.HttpContext.User.FindFirst("UserId")?.Value;
            int? userId = int.TryParse(userIdClaim, out var id) ? id : null;

            // Log request start
            Log.Information(
                "Request started: {HttpMethod} {Path} - Controller: {Controller}, Action: {Action}, UserId: {UserId}",
                httpMethod, path, controllerName, actionName, userId);

            ActionExecutedContext? resultContext = null;
            Exception? exception = null;

            try
            {
                resultContext = await next();
                exception = resultContext.Exception;
            }
            catch (Exception ex)
            {
                exception = ex;
                throw;
            }
            finally
            {
                stopwatch.Stop();
                var elapsedMs = stopwatch.ElapsedMilliseconds;
                var statusCode = GetStatusCode(context.HttpContext, resultContext, exception);

                // Log request completion
                if (exception != null && !resultContext?.ExceptionHandled == true)
                {
                    Log.Error(exception,
                        "Request failed: {HttpMethod} {Path} - Controller: {Controller}, Action: {Action}, StatusCode: {StatusCode}, Duration: {Duration}ms",
                        httpMethod, path, controllerName, actionName, statusCode, elapsedMs);
                }
                else
                {
                    Log.Information(
                        "Request completed: {HttpMethod} {Path} - Controller: {Controller}, Action: {Action}, StatusCode: {StatusCode}, Duration: {Duration}ms",
                        httpMethod, path, controllerName, actionName, statusCode, elapsedMs);
                }

                // Track activity for non-GET requests or significant GET requests
                if (ShouldTrackActivity(httpMethod, actionName))
                {
                    var activityName = MapToActivityAction(controllerName, actionName, httpMethod);
                    var entityInfo = ExtractEntityInfo(context, resultContext);

                    await _activityService.TrackAsync(
                        activityName,
                        userId: userId,
                        entityName: controllerName,
                        entityId: entityInfo.EntityId,
                        description: $"{httpMethod} {path}",
                        metadata: new
                        {
                            controller = controllerName,
                            action = actionName,
                            statusCode,
                            requestArgs = SanitizeArguments(context.ActionArguments)
                        },
                        processingTimeMs: elapsedMs);
                }
            }
        }

        private static int GetStatusCode(HttpContext httpContext, ActionExecutedContext? resultContext, Exception? exception)
        {
            if (exception != null && resultContext?.ExceptionHandled != true)
            {
                return exception switch
                {
                    KeyNotFoundException => 404,
                    UnauthorizedAccessException => 401,
                    ArgumentException => 400,
                    _ => 500
                };
            }

            if (resultContext?.Result is ObjectResult objectResult)
            {
                return objectResult.StatusCode ?? 200;
            }

            if (resultContext?.Result is StatusCodeResult statusCodeResult)
            {
                return statusCodeResult.StatusCode;
            }

            return httpContext.Response.StatusCode;
        }

        private static bool ShouldTrackActivity(string httpMethod, string actionName)
        {
            // Always track mutations
            if (httpMethod is "POST" or "PUT" or "PATCH" or "DELETE")
                return true;

            // Track specific view actions
            var trackedActions = new[] { "GetById", "GetAll", "Get" };
            return trackedActions.Any(a => actionName.Contains(a, StringComparison.OrdinalIgnoreCase));
        }

        private static string MapToActivityAction(string controller, string action, string httpMethod)
        {
            // Map controller + action to activity action name
            var entityName = controller.Replace("Controller", "");

            return (httpMethod, action.ToLower()) switch
            {
                ("POST", "create") => $"{entityName}Created",
                ("POST", _) => $"{entityName}Created",
                ("PUT", _) => $"{entityName}Updated",
                ("PATCH", _) => $"{entityName}Updated",
                ("DELETE", _) => $"{entityName}Deleted",
                (_, "getbyid") => $"{entityName}Viewed",
                (_, "get") => $"{entityName}Viewed",
                (_, "getall") => $"{entityName}ListViewed",
                _ => $"{entityName}{action}"
            };
        }

        private static (int? EntityId, object? EntityData) ExtractEntityInfo(
            ActionExecutingContext context, 
            ActionExecutedContext? resultContext)
        {
            // Try to get entity ID from route
            int? entityId = null;
            if (context.ActionArguments.TryGetValue("id", out var idObj) && idObj is int id)
            {
                entityId = id;
            }

            // Try to get created entity ID from result
            if (resultContext?.Result is ObjectResult { Value: not null } result)
            {
                var idProperty = result.Value.GetType().GetProperty("Id");
                if (idProperty?.GetValue(result.Value) is int createdId)
                {
                    entityId = createdId;
                }
            }

            return (entityId, null);
        }

        private static Dictionary<string, object?> SanitizeArguments(IDictionary<string, object?> arguments)
        {
            // Remove sensitive data from logging
            var sensitiveKeys = new[] { "password", "token", "secret", "key" };

            return arguments
                .Where(kvp => !sensitiveKeys.Any(k => 
                    kvp.Key.Contains(k, StringComparison.OrdinalIgnoreCase)))
                .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
        }
    }
}
