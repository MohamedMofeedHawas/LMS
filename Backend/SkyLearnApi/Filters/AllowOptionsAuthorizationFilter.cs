using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace SkyLearnApi.Filters
{
    public class AllowOptionsAuthorizationFilter : IAsyncAuthorizationFilter
    {
        public Task OnAuthorizationAsync(AuthorizationFilterContext context)
        {
            if (HttpMethods.IsOptions(context.HttpContext.Request.Method))
            {
                context.Result = new OkResult();
            }

            return Task.CompletedTask;
        }
    }
}
