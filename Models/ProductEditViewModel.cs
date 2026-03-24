using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Shoe_shop_app.Models
{
    public class ProductEditViewModel
    {
        public bool IsEditMode { get; set; }

        [Display(Name = "Артикул")]
        public string VendorCode { get; set; } = string.Empty;

        [Required(ErrorMessage = "Enter product name.")]
        [Display(Name = "Название товара")]
        public string ProductName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Select category.")]
        [Range(1, int.MaxValue, ErrorMessage = "Select category.")]
        [Display(Name = "Категория")]
        public int? CategoryID { get; set; }

        [Required(ErrorMessage = "Enter product description.")]
        [Display(Name = "Описание")]
        public string Description { get; set; } = string.Empty;

        [Required(ErrorMessage = "Select manufacturer.")]
        [Range(1, int.MaxValue, ErrorMessage = "Select manufacturer.")]
        [Display(Name = "Производитель")]
        public int? ManufacturerID { get; set; }

        [Required(ErrorMessage = "Select supplier.")]
        [Range(1, int.MaxValue, ErrorMessage = "Select supplier.")]
        [Display(Name = "Поставщик")]
        public int? SupplierID { get; set; }

        [Required(ErrorMessage = "Enter price.")]
        [Range(typeof(decimal), "0.01", "1000000000", ErrorMessage = "Price must be greater than 0.")]
        [Display(Name = "Цена")]
        public decimal Price { get; set; }

        [Required(ErrorMessage = "Enter unit.")]
        [Display(Name = "Единицы измерения")]
        public string Unit { get; set; } = string.Empty;

        [Range(0, int.MaxValue, ErrorMessage = "Stock amount cannot be negative.")]
        [Display(Name = "Количество на складе")]
        public int QuantityInStock { get; set; }

        [Range(0, 100, ErrorMessage = "Discount must be between 0 and 100.")]
        [Display(Name = "Текущая скидка, %")]
        public int CurrentDiscount { get; set; }

        [Display(Name = "Фото товара")]
        public IFormFile? PhotoFile { get; set; }

        public string? ExistingPhoto { get; set; }

        public IEnumerable<SelectListItem> Categories { get; set; } = Enumerable.Empty<SelectListItem>();
        public IEnumerable<SelectListItem> Manufacturers { get; set; } = Enumerable.Empty<SelectListItem>();
        public IEnumerable<SelectListItem> Suppliers { get; set; } = Enumerable.Empty<SelectListItem>();
    }
}
