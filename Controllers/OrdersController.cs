using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Shoe_shop_app.Models;

namespace Shoe_shop_app.Controllers
{
    public class OrdersController : Controller
    {
        private readonly DatabaseContext _context;

        public OrdersController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var userRoleId = GetUserRoleId();
            if (!IsManagerOrAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "У вас нет доступа к разделу заказов.";
                return RedirectToAction("Index", "Products");
            }

            SetLayoutUserInfo(userRoleId);
            ViewBag.CanEditOrders = IsAdmin(userRoleId);

            var orders = await _context.Orders
                .Include(o => o.Status)
                .Include(o => o.PickupPoint)
                .OrderByDescending(o => o.OrderDate)
                .ThenByDescending(o => o.OrderID)
                .ToListAsync();

            return View(orders);
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var userRoleId = GetUserRoleId();
            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "Добавлять заказы может только администратор.";
                return RedirectToAction(nameof(Index));
            }

            SetLayoutUserInfo(userRoleId);

            var model = new OrderEditViewModel
            {
                IsEditMode = false,
                PickupCode = await GenerateNextOrderArticleAsync()
            };
            await PopulateStatusesAsync(model);
            return View("Edit", model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(OrderEditViewModel model)
        {
            var userRoleId = GetUserRoleId();
            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "Добавлять заказы может только администратор.";
                return RedirectToAction(nameof(Index));
            }

            SetLayoutUserInfo(userRoleId);
            model.IsEditMode = false;

            if (model.DeliveryDate.HasValue && model.DeliveryDate.Value.Date < model.OrderDate.Date)
            {
                ModelState.AddModelError(nameof(model.DeliveryDate), "Дата выдачи не может быть раньше даты заказа.");
            }

            if (!ModelState.IsValid)
            {
                await PopulateStatusesAsync(model);
                return View("Edit", model);
            }

            var pickupPoint = await GetOrCreatePickupPointAsync(model.PickupAddress);
            var order = new Order
            {
                PickupCode = model.PickupCode.Trim(),
                StatusID = model.StatusID,
                PickupPointID = pickupPoint.PickupPointID,
                OrderDate = model.OrderDate.Date,
                DeliveryDate = model.DeliveryDate?.Date
            };

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Заказ успешно добавлен.";
            return RedirectToAction(nameof(Index));
        }

        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var userRoleId = GetUserRoleId();
            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "Редактировать заказы может только администратор.";
                return RedirectToAction(nameof(Index));
            }

            SetLayoutUserInfo(userRoleId);

            var order = await _context.Orders
                .Include(o => o.PickupPoint)
                .FirstOrDefaultAsync(o => o.OrderID == id);

            if (order == null)
            {
                TempData["ErrorMessage"] = "Заказ не найден.";
                return RedirectToAction(nameof(Index));
            }

            var model = new OrderEditViewModel
            {
                IsEditMode = true,
                OrderID = order.OrderID,
                PickupCode = order.PickupCode,
                StatusID = order.StatusID,
                PickupAddress = FormatAddress(order.PickupPoint),
                OrderDate = order.OrderDate,
                DeliveryDate = order.DeliveryDate
            };

            await PopulateStatusesAsync(model);
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(OrderEditViewModel model)
        {
            var userRoleId = GetUserRoleId();
            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "Редактировать заказы может только администратор.";
                return RedirectToAction(nameof(Index));
            }

            SetLayoutUserInfo(userRoleId);
            model.IsEditMode = true;

            if (model.DeliveryDate.HasValue && model.DeliveryDate.Value.Date < model.OrderDate.Date)
            {
                ModelState.AddModelError(nameof(model.DeliveryDate), "Дата выдачи не может быть раньше даты заказа.");
            }

            if (!ModelState.IsValid)
            {
                await PopulateStatusesAsync(model);
                return View(model);
            }

            var order = await _context.Orders.FirstOrDefaultAsync(o => o.OrderID == model.OrderID);
            if (order == null)
            {
                TempData["ErrorMessage"] = "Заказ не найден.";
                return RedirectToAction(nameof(Index));
            }

            var pickupPoint = await GetOrCreatePickupPointAsync(model.PickupAddress);
            order.PickupCode = model.PickupCode.Trim();
            order.StatusID = model.StatusID;
            order.PickupPointID = pickupPoint.PickupPointID;
            order.OrderDate = model.OrderDate.Date;
            order.DeliveryDate = model.DeliveryDate?.Date;

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Заказ успешно обновлен.";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var userRoleId = GetUserRoleId();
            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "Удалять заказы может только администратор.";
                return RedirectToAction(nameof(Index));
            }

            var order = await _context.Orders
                .Include(o => o.OrderDetails)
                .FirstOrDefaultAsync(o => o.OrderID == id);

            if (order == null)
            {
                TempData["ErrorMessage"] = "Заказ не найден.";
                return RedirectToAction(nameof(Index));
            }

            _context.Orders.Remove(order);
            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Заказ удален.";
            return RedirectToAction(nameof(Index));
        }

        private async Task PopulateStatusesAsync(OrderEditViewModel model)
        {
            model.Statuses = await _context.OrderStatuses
                .OrderBy(s => s.StatusID)
                .Select(s => new SelectListItem
                {
                    Value = s.StatusID.ToString(),
                    Text = s.StatusName
                })
                .ToListAsync();
        }

        private async Task<string> GenerateNextOrderArticleAsync()
        {
            var maxId = await _context.Orders
                .OrderByDescending(o => o.OrderID)
                .Select(o => o.OrderID)
                .FirstOrDefaultAsync();

            return $"ORD-{maxId + 1:0000}";
        }

        private async Task<PickupPoint> GetOrCreatePickupPointAsync(string pickupAddress)
        {
            var trimmedAddress = pickupAddress.Trim();

            var existing = await _context.PickupPoints
                .FirstOrDefaultAsync(p => p.Street != null && p.Street == trimmedAddress);

            if (existing != null)
            {
                return existing;
            }

            var pickupPoint = new PickupPoint
            {
                Street = trimmedAddress
            };

            _context.PickupPoints.Add(pickupPoint);
            await _context.SaveChangesAsync();
            return pickupPoint;
        }

        private static string FormatAddress(PickupPoint? pickupPoint)
        {
            if (pickupPoint == null)
            {
                return string.Empty;
            }

            var formatted = pickupPoint.FullAddress;
            return string.IsNullOrWhiteSpace(formatted) ? (pickupPoint.Street ?? string.Empty) : formatted;
        }

        private int GetUserRoleId()
        {
            var roleValue = HttpContext.Session.GetString("UserRoleId");
            return int.TryParse(roleValue, out var roleId) ? roleId : AppRoles.GuestId;
        }

        private string GetUserFullName()
        {
            return HttpContext.Session.GetString("UserFullName") ?? AppRoles.GuestDisplayName;
        }

        private static bool IsAdmin(int roleId)
        {
            return roleId == AppRoles.AdminId;
        }

        private static bool IsManagerOrAdmin(int roleId)
        {
            return roleId == AppRoles.AdminId || roleId == AppRoles.ManagerId;
        }

        private void SetLayoutUserInfo(int userRoleId)
        {
            ViewBag.UserRoleId = userRoleId;
            ViewBag.UserFullName = GetUserFullName();
        }
    }
}
