using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Shoe_shop_app.Models;

namespace Shoe_shop_app.Controllers
{
    public class ProductsController : Controller
    {
        private const string ProductEditLockSessionKey = "ProductEditLock";
        private readonly DatabaseContext _context;
        private readonly IWebHostEnvironment _environment;

        public ProductsController(DatabaseContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var userRoleId = GetUserRoleId();
            SetLayoutUserInfo(userRoleId);
            ViewBag.CanManageFilters = IsManagerOrAdmin(userRoleId);
            ViewBag.CanEdit = IsAdmin(userRoleId);

            try
            {
                var products = await _context.Products
                    .Include(p => p.Category)
                    .Include(p => p.Manufacturer)
                    .Include(p => p.Supplier)
                    .OrderBy(p => p.ProductName)
                    .ToListAsync();

                ViewBag.Suppliers = await _context.Suppliers
                    .OrderBy(s => s.Name)
                    .ToListAsync();

                return View(products);
            }
            catch
            {
                TempData["ErrorMessage"] = "Ошибка подключения к базе данных. Проверьте логин и пароль PostgreSQL в файле appsettings.json.";
                ViewBag.Suppliers = new List<Supplier>();
                return View(new List<Product>());
            }
        }

        [HttpGet]
        public async Task<IActionResult> ListPartial(string? search, int? supplierId, string? sortOrder)
        {
            var userRoleId = GetUserRoleId();
            if (!IsManagerOrAdmin(userRoleId))
            {
                return Forbid();
            }

            var query = _context.Products
                .Include(p => p.Category)
                .Include(p => p.Manufacturer)
                .Include(p => p.Supplier)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                var normalizedSearch = search.Trim().ToLower();
                query = query.Where(p =>
                    p.VendorCode.ToLower().Contains(normalizedSearch) ||
                    p.ProductName.ToLower().Contains(normalizedSearch) ||
                    (p.Description != null && p.Description.ToLower().Contains(normalizedSearch)) ||
                    (p.Unit != null && p.Unit.ToLower().Contains(normalizedSearch)) ||
                    (p.Category != null && p.Category.CategoryName.ToLower().Contains(normalizedSearch)) ||
                    (p.Manufacturer != null && p.Manufacturer.Name.ToLower().Contains(normalizedSearch)) ||
                    (p.Supplier != null && p.Supplier.Name.ToLower().Contains(normalizedSearch)));
            }

            if (supplierId.HasValue)
            {
                query = query.Where(p => p.SupplierID == supplierId.Value);
            }

            query = sortOrder switch
            {
                "stock_asc" => query.OrderBy(p => p.QuantityInStock),
                "stock_desc" => query.OrderByDescending(p => p.QuantityInStock),
                _ => query.OrderBy(p => p.ProductName)
            };

            ViewBag.CanEdit = IsAdmin(userRoleId);
            try
            {
                var products = await query.ToListAsync();
                return PartialView("_ProductsList", products);
            }
            catch
            {
                return PartialView("_ProductsList", new List<Product>());
            }
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var userRoleId = GetUserRoleId();
            SetLayoutUserInfo(userRoleId);

            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "У вас нет разрешения на добавление товаров.";
                return RedirectToAction(nameof(Index));
            }

            if (!TryAcquireEditLock("new"))
            {
                TempData["WarningMessage"] = "Редактор товара уже открыт. Закройте его, прежде чем открыть другой.";
                return RedirectToAction(nameof(Index));
            }

            var model = await BuildProductEditModelAsync();
            model.VendorCode = await GenerateNextVendorCodeAsync();
            model.IsEditMode = false;
            return View("Edit", model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ProductEditViewModel model)
        {
            var userRoleId = GetUserRoleId();
            SetLayoutUserInfo(userRoleId);

            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "У вас нет разрешения на добавление товаров.";
                return RedirectToAction(nameof(Index));
            }

            model.IsEditMode = false;
            model.VendorCode = await GenerateNextVendorCodeAsync();

            if (!ModelState.IsValid)
            {
                await PopulateSelectListsAsync(model);
                return View("Edit", model);
            }

            var (photoFileName, photoValidationError) = await SavePhotoIfValidAsync(model.PhotoFile);
            if (!string.IsNullOrEmpty(photoValidationError))
            {
                ModelState.AddModelError(nameof(model.PhotoFile), photoValidationError);
                await PopulateSelectListsAsync(model);
                return View("Edit", model);
            }

            try
            {
                var product = new Product
                {
                    VendorCode = model.VendorCode,
                    ProductName = (model.ProductName ?? string.Empty).Trim(),
                    CategoryID = model.CategoryID,
                    Description = (model.Description ?? string.Empty).Trim(),
                    ManufacturerID = model.ManufacturerID,
                    SupplierID = model.SupplierID,
                    Price = model.Price,
                    Unit = (model.Unit ?? string.Empty).Trim(),
                    QuantityInStock = model.QuantityInStock,
                    CurrentDiscount = model.CurrentDiscount,
                    Photo = photoFileName
                };

                _context.Products.Add(product);
                await _context.SaveChangesAsync();
                ReleaseEditLock();

                TempData["SuccessMessage"] = "Товар успешно добавлен.";
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                ModelState.AddModelError(string.Empty, "Не удалось добавить товар. Проверьте значения и повторите попытку.");
                await PopulateSelectListsAsync(model);
                return View("Edit", model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var userRoleId = GetUserRoleId();
            SetLayoutUserInfo(userRoleId);

            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "У вас нет прав на редактирование товаров.";
                return RedirectToAction(nameof(Index));
            }

            if (string.IsNullOrWhiteSpace(id))
            {
                TempData["ErrorMessage"] = "Не удается открыть товар: отсутствует идентификатор.";
                return RedirectToAction(nameof(Index));
            }

            if (!TryAcquireEditLock(id))
            {
                TempData["WarningMessage"] = "Редактор товара уже открыт. Закройте его, прежде чем открыть другой.";
                return RedirectToAction(nameof(Index));
            }

            var product = await _context.Products
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.VendorCode == id);

            if (product == null)
            {
                ReleaseEditLock();
                TempData["ErrorMessage"] = "Товар не найден.";
                return RedirectToAction(nameof(Index));
            }

            var model = await BuildProductEditModelAsync(product);
            model.IsEditMode = true;
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(ProductEditViewModel model)
        {
            var userRoleId = GetUserRoleId();
            SetLayoutUserInfo(userRoleId);

            if (!IsAdmin(userRoleId))
            {
                TempData["ErrorMessage"] = "У вас нет прав на редактирование товаров.";
                return RedirectToAction(nameof(Index));
            }

            model.IsEditMode = true;

            if (!ModelState.IsValid)
            {
                await PopulateSelectListsAsync(model);
                return View(model);
            }

            var product = await _context.Products.FirstOrDefaultAsync(p => p.VendorCode == model.VendorCode);
            if (product == null)
            {
                ReleaseEditLock();
                TempData["ErrorMessage"] = "Товар не найден.";
                return RedirectToAction(nameof(Index));
            }

            var (newPhotoFileName, photoValidationError) = await SavePhotoIfValidAsync(model.PhotoFile);
            if (!string.IsNullOrEmpty(photoValidationError))
            {
                ModelState.AddModelError(nameof(model.PhotoFile), photoValidationError);
                model.ExistingPhoto = product.Photo;
                await PopulateSelectListsAsync(model);
                return View(model);
            }

            try
            {
                product.ProductName = (model.ProductName ?? string.Empty).Trim();
                product.CategoryID = model.CategoryID;
                product.Description = (model.Description ?? string.Empty).Trim();
                product.ManufacturerID = model.ManufacturerID;
                product.SupplierID = model.SupplierID;
                product.Price = model.Price;
                product.Unit = (model.Unit ?? string.Empty).Trim();
                product.QuantityInStock = model.QuantityInStock;
                product.CurrentDiscount = model.CurrentDiscount;

                if (!string.IsNullOrWhiteSpace(newPhotoFileName))
                {
                    DeleteProductPhoto(product.Photo);
                    product.Photo = newPhotoFileName;
                }

                await _context.SaveChangesAsync();
                ReleaseEditLock();

                TempData["SuccessMessage"] = "Товар успешно обновлен.";
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                ModelState.AddModelError(string.Empty, "Не удалось сохранить изменения. Проверьте значения и повторите попытку.");
                model.ExistingPhoto = product.Photo;
                await PopulateSelectListsAsync(model);
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string vendorCode)
        {
            if (!IsAdmin(GetUserRoleId()))
            {
                TempData["ErrorMessage"] = "У вас нет прав на удаление товаров.";
                return RedirectToAction(nameof(Index));
            }

            if (string.IsNullOrWhiteSpace(vendorCode))
            {
                TempData["ErrorMessage"] = "Не удается удалить товар: отсутствует идентификатор.";
                return RedirectToAction(nameof(Index));
            }

            var product = await _context.Products.FirstOrDefaultAsync(p => p.VendorCode == vendorCode);
            if (product == null)
            {
                TempData["ErrorMessage"] = "Товар не найден";
                return RedirectToAction(nameof(Index));
            }

            var isUsedInOrders = await _context.OrderDetails.AnyAsync(od => od.ProductVendorCode == vendorCode);
            if (isUsedInOrders)
            {
                TempData["WarningMessage"] = "Удаление заблокировано: товар используется в заказах.";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                DeleteProductPhoto(product.Photo);
                _context.Products.Remove(product);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Товар успешно удален.";
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                TempData["ErrorMessage"] = "Не удалось удалить товар. Попробуйте еще раз.";
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpGet]
        public IActionResult CancelEdit()
        {
            ReleaseEditLock();
            return RedirectToAction(nameof(Index));
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

        private async Task<ProductEditViewModel> BuildProductEditModelAsync(Product? product = null)
        {
            var model = new ProductEditViewModel
            {
                VendorCode = product?.VendorCode ?? string.Empty,
                ProductName = product?.ProductName ?? string.Empty,
                CategoryID = product?.CategoryID,
                Description = product?.Description ?? string.Empty,
                ManufacturerID = product?.ManufacturerID,
                SupplierID = product?.SupplierID,
                Price = product?.Price ?? 0,
                Unit = product?.Unit ?? string.Empty,
                QuantityInStock = product?.QuantityInStock ?? 0,
                CurrentDiscount = product?.CurrentDiscount ?? 0,
                ExistingPhoto = product?.Photo
            };

            await PopulateSelectListsAsync(model);
            return model;
        }

        private async Task PopulateSelectListsAsync(ProductEditViewModel model)
        {
            model.Categories = await _context.Categories
                .OrderBy(c => c.CategoryName)
                .Select(c => new SelectListItem { Value = c.CategoryID.ToString(), Text = c.CategoryName })
                .ToListAsync();

            model.Manufacturers = await _context.Manufacturers
                .OrderBy(m => m.Name)
                .Select(m => new SelectListItem { Value = m.ManufacturerID.ToString(), Text = m.Name })
                .ToListAsync();

            model.Suppliers = await _context.Suppliers
                .OrderBy(s => s.Name)
                .Select(s => new SelectListItem { Value = s.SupplierID.ToString(), Text = s.Name })
                .ToListAsync();
        }

        private async Task<string> GenerateNextVendorCodeAsync()
        {
            var existingCodes = await _context.Products.Select(p => p.VendorCode).ToListAsync();

            var maxNumber = 0;
            foreach (var code in existingCodes)
            {
                var digits = new string(code.Where(char.IsDigit).ToArray());
                if (int.TryParse(digits, out var parsedNumber) && parsedNumber > maxNumber)
                {
                    maxNumber = parsedNumber;
                }
            }

            var nextNumber = maxNumber + 1;
            var nextCode = $"P{nextNumber:0000}";
            while (await _context.Products.AnyAsync(p => p.VendorCode == nextCode))
            {
                nextNumber++;
                nextCode = $"P{nextNumber:0000}";
            }

            return nextCode;
        }

        private async Task<(string? fileName, string? validationError)> SavePhotoIfValidAsync(IFormFile? photoFile)
        {
            if (photoFile == null || photoFile.Length == 0)
            {
                return (null, null);
            }

            var extension = Path.GetExtension(photoFile.FileName);
            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".bmp", ".gif" };
            if (!allowedExtensions.Contains(extension.ToLower()))
            {
                return (null, "Allowed image formats: JPG, JPEG, PNG, BMP, GIF.");
            }

            var fileName = $"{Guid.NewGuid()}{extension.ToLower()}";
            var productsImagesPath = Path.Combine(_environment.WebRootPath, "img", "products");
            Directory.CreateDirectory(productsImagesPath);

            var filePath = Path.Combine(productsImagesPath, fileName);
            await using var fileStream = new FileStream(filePath, FileMode.Create);
            await photoFile.CopyToAsync(fileStream);

            return (fileName, null);
        }

        private void DeleteProductPhoto(string? fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName))
            {
                return;
            }

            var filePath = Path.Combine(_environment.WebRootPath, "img", "products", fileName);
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }
        }

        private bool TryAcquireEditLock(string lockValue)
        {
            var currentLockValue = HttpContext.Session.GetString(ProductEditLockSessionKey);
            if (string.IsNullOrWhiteSpace(currentLockValue))
            {
                HttpContext.Session.SetString(ProductEditLockSessionKey, lockValue);
                return true;
            }

            return currentLockValue == lockValue;
        }

        private void ReleaseEditLock()
        {
            HttpContext.Session.Remove(ProductEditLockSessionKey);
        }

        private void SetLayoutUserInfo(int userRoleId)
        {
            ViewBag.UserRoleId = userRoleId;
            ViewBag.UserFullName = GetUserFullName();
        }
    }
}
