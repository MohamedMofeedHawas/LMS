namespace SkyLearnApi.Services.Base;

public interface ICurrentUserService
{
    int? UserId { get; }
    string? Email { get; }
    string? FullName { get; }
    int? DepartmentId { get; }
    string? AcademicYear { get; }
    string? Jti { get; }
    string? GroupName { get; }
    bool IsActive { get; }
    bool IsAuthenticated { get; }
    IEnumerable<string> Roles { get; }
    IEnumerable<string> Claims { get; }
    string? IpAddress { get; }

    DateTime? ExpiresAt { get; }

    bool IsInRole(string role);
    bool HasClaim(string claimType, string? claimValue = null);
}



public class CurrentUserService(IHttpContextAccessor httpContextAccessor) : ICurrentUserService
{
    private ClaimsPrincipal? User => httpContextAccessor.HttpContext?.User;

    public int? UserId
    {
        get
        {
            var userId = User?.FindFirst(e => e.Type == SystemClaim.UserId)?.Value;
            return int.TryParse(userId, out var id) ? id : null;
        }
    }

    public string? UserName => User?.FindFirst(SystemClaim.UserName)?.Value;

    public string? Email => User?.FindFirst(SystemClaim.Email)?.Value;

    public string? FullName => User?.FindFirst(SystemClaim.FullName)?.Value;

    public int? DepartmentId
    {
        get
        {
            var departmentId = User?.FindFirst(e => e.Type == SystemClaim.DepartmentId)?.Value;
            return int.TryParse(departmentId, out var id) ? id : null;
        }
    }

    public string? AcademicYear => User?.FindFirst(SystemClaim.AcademicYear)?.Value;

    public string? Jti => User?.FindFirst(SystemClaim.Jti)?.Value;

    public string? GroupName => User?.FindFirst(SystemClaim.GroupName)?.Value;

    public bool IsActive
    {
        get
        {
            var isActiveClaim = User?.FindFirst("IsActive")?.Value;
            return bool.TryParse(isActiveClaim, out var isActive) && isActive;
        }
    }

    public bool IsAuthenticated => User?.Identity?.IsAuthenticated ?? false;

    public IEnumerable<string> Roles
    {
        get
        {
            return User?.FindAll(SystemClaim.Role)
                .Select(c => c.Value)
                .ToList() ?? Enumerable.Empty<string>();
        }
    }

    public IEnumerable<string> Claims
    {
        get
        {
            return User?.Claims
                .Select(c => $"{c.Type}:{c.Value}")
                .ToList() ?? Enumerable.Empty<string>();
        }
    }

    public string? IpAddress
    {
        get
        {
            var context = httpContextAccessor.HttpContext;
            if (context == null) return null;

            var ipAddress = context.Request.Headers["X-Forwarded-For"].FirstOrDefault();
            ipAddress = string.IsNullOrEmpty(ipAddress) ? context.Connection.RemoteIpAddress?.ToString() :
                ipAddress.Split(',').FirstOrDefault()?.Trim();

            return ipAddress;
        }
    }

    public DateTime? ExpiresAt
    {
        get
        {
            var value = User?.FindFirst("exp")?.Value;
            return string.IsNullOrEmpty(value)
                ? null
                : DateTimeOffset.FromUnixTimeSeconds(long.Parse(value)).UtcDateTime;
        }
    }

    public bool IsInRole(string role)
    {
        if (string.IsNullOrWhiteSpace(role)) return false;
        return User?.IsInRole(role) ?? false;
    }

    public bool HasClaim(string claimType, string? claimValue = null)
    {
        if (string.IsNullOrWhiteSpace(claimType)) return false;

        if (string.IsNullOrWhiteSpace(claimValue))
        {
            return User?.HasClaim(c => c.Type == claimType) ?? false;
        }

        return User?.HasClaim(claimType, claimValue) ?? false;
    }
}
