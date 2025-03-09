using Microsoft.AspNetCore.Mvc;

namespace ExampleApi.Controllers
{
    [ApiController]    
    [Route("api/[controller]")]
    public class MovieController : ControllerBase
    {
        [HttpGet]        
        public IActionResult Index()
        {
            return Ok("OK");
        }

        [HttpPost]
        [RequestSizeLimit(100_000_000)]
        public async Task<IActionResult> Upload([FromForm] List<IFormFile> files)
        {
            if (files == null || files.Count == 0)
            {
                return BadRequest("No files were uploaded.");
            }

            var uploadPath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads");
            if (!Directory.Exists(uploadPath))
            {
                Directory.CreateDirectory(uploadPath);
            }

            foreach (var file in files)
            {
                var filePath = Path.Combine(uploadPath, file.FileName);
                using var stream = new FileStream(filePath, FileMode.Create);
                await file.CopyToAsync(stream);
            }

            return Ok("Files uploaded successfully.");
        }
    }
}
