using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Shoe_shop_app.Models
{
    public class OrderEditViewModel
    {
        public bool IsEditMode { get; set; }

        [Display(Name = "ID")]
        public int? OrderID { get; set; }

        [Required(ErrorMessage = "Enter order article.")]
        [Display(Name = "Артикул заказа")]
        public string PickupCode { get; set; } = string.Empty;

        [Required(ErrorMessage = "Select order status.")]
        [Display(Name = "Статус заказа")]
        public int? StatusID { get; set; }

        [Required(ErrorMessage = "Enter pickup address.")]
        [Display(Name = "Адрес пункта выдачи")]
        public string PickupAddress { get; set; } = string.Empty;

        [Required(ErrorMessage = "Select order date.")]
        [Display(Name = "Дата заказа")]
        [DataType(DataType.Date)]
        public DateTime OrderDate { get; set; } = DateTime.Today;

        [Display(Name = "Дата доставки")]
        [DataType(DataType.Date)]
        public DateTime? DeliveryDate { get; set; }

        public IEnumerable<SelectListItem> Statuses { get; set; } = Enumerable.Empty<SelectListItem>();
    }
}
