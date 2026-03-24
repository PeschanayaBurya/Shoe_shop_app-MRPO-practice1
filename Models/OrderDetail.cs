using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("orderdetails")]
    public class OrderDetail
    {
        [Column("orderdetailid")]
        public int OrderDetailID { get; set; }

        [ForeignKey("Order")]
        [Column("orderid")]
        public int OrderID { get; set; }

        [Column("productvendorcode")]
        public string ProductVendorCode { get; set; } = null!;

        [Column("quantity")]
        public int Quantity { get; set; }

        public Order Order { get; set; }
    }
}
