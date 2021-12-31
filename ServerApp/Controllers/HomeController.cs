using Microsoft.AspNetCore.Mvc;
using ServerApp.Models;
using System.Diagnostics;
using System.Linq;
using Microsoft.Extensions.Logging;
namespace ServerApp.Controllers {
    public class HomeController : Controller {
        private DataContext context;
        private readonly ILogger _logger;
        public HomeController(DataContext ctx,ILogger<HomeController> logger) {
            context = ctx;
            _logger = logger;
        }
        public IActionResult Index() {
            //_logger.LogInformation(22,"Log message in the Index() method");
            this._logger.LogInformation("ahdfdfdfdfdfdd");
            return View(context.Products.First());
        }
        public IActionResult Privacy() {
            return View();
        }
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None,NoStore = true)]
        public IActionResult Error() {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id
            ?? HttpContext.TraceIdentifier });
        }
    }
}