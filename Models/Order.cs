using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("orders")]
    public class Order
    {
        [Column("orderid")]
        public int OrderID { get; set; }
        
        [Column("orderdate")]
        public DateTime OrderDate { get; set; }
        
        [Column("deliverydate")]
        public DateTime? DeliveryDate { get; set; }
        
        [Column("pickuppointid")]
        public int? PickupPointID { get; set; }
        
        [Column("userid")]
        public int? UserID { get; set; }
        
        [Column("pickupcode")]
        public string PickupCode { get; set; }
        
        [Column("statusid")]
        public int? StatusID { get; set; }
        
        public ICollection<OrderDetail> OrderDetails { get; set; }
    }
}