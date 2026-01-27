using System;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace SkyLearnApi.DTOs.Auth
{
    public class UpdateProfileRequestDto
    {
        public DateTime? DateOfBirth { get; set; }
        public string? City { get; set; }
        public IFormFile? ProfileImage { get; set; }
    }
}
