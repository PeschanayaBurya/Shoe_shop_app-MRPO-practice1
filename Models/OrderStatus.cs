using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("orderstatuses")]
    public class OrderStatus
    {
        [Column("statusid")]
        public int StatusID { get; set; }

        [Column("statusname")]
        public string StatusName { get; set; } = string.Empty;

        public ICollection<Order> Orders { get; set; } = new List<Order>();
    }
}
