using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Shoe_shop_app.Models;

namespace Shoe_shop_app.Controllers
{
    public class AccountController : Controller
    {
        private readonly DatabaseContext _context;

        public AccountController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            User? user;
            try
            {
                user = await _context.Users
                    .Include(u => u.Role)
                    .FirstOrDefaultAsync(u => u.Login == model.Login && u.Password == model.Password);
            }
            catch
            {
                ModelState.AddModelError(string.Empty, "Database connection error. Check PostgreSQL login/password in appsettings.json.");
                return View(model);
            }

            if (user == null || user.Role == null)
            {
                ModelState.AddModelError(string.Empty, "Invalid login or password.");
                return View(model);
            }

            HttpContext.Session.SetString("UserID", user.UserID.ToString());
            HttpContext.Session.SetString("UserFullName", user.FullName);
            HttpContext.Session.SetString("UserRoleName", user.Role.NameRole);
            HttpContext.Session.SetString("UserRoleId", user.RoleID.ToString());

            return RedirectToAction("Index", "Products");
        }

        [HttpGet]
        public IActionResult GuestLogin()
        {
            HttpContext.Session.SetString("UserRoleName", AppRoles.GuestDisplayName);
            HttpContext.Session.SetString("UserFullName", AppRoles.GuestDisplayName);
            HttpContext.Session.SetString("UserRoleId", AppRoles.GuestId.ToString());
            return RedirectToAction("Index", "Products");
        }

        [HttpGet]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction(nameof(Login));
        }
    }
}
