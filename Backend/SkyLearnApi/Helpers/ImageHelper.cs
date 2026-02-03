

namespace SkyLearnApi.Helpers
{
    public static class ImageHelper
    {
        public static async Task<string> SaveImageAsync(IFormFile image, string folderName, IWebHostEnvironment environment)
        {
            if (image == null || image.Length == 0)
                throw new Exception("Invalid image file.");

            
            var folderPath = Path.Combine(environment.WebRootPath, "uploads", folderName);

            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            
            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(image.FileName)}";
            var filePath = Path.Combine(folderPath, fileName);

            
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await image.CopyToAsync(stream);
            }

            
            return $"/uploads/{folderName}/{fileName}";
        }

        public static void DeleteImage(string imageUrl, IWebHostEnvironment environment)
        {
            if (string.IsNullOrEmpty(imageUrl)) return;

            var fullPath = Path.Combine(environment.WebRootPath, imageUrl.TrimStart('/'));
            if (File.Exists(fullPath))
                File.Delete(fullPath);
        }
    }
}
