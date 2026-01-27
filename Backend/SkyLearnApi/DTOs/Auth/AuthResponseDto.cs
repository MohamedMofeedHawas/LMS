namespace SkyLearnApi.Dtos
{
    public class AuthResponseDto
    {
        public string Message { get; set; } = "Login successful";
        public string Token { get; set; } = null!;
        public DateTime ExpiresIn { get; set; }
        public UserDto User { get; set; } = null!;
    }

    public class UserDto
    {
        public int Id { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public string? Gender { get; set; }
        public string? City { get; set; }
        public string? ProfileImageUrl { get; set; }
    }
}
