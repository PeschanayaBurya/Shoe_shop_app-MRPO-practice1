using System.ComponentModel.DataAnnotations.Schema; 

namespace Shoe_shop_app.Models
{
    [Table("products")]
    public class Product
    {
        [Column("vendorcode")]
        public string VendorCode { get; set; } = null!;
        
        [Column("productname")]
        public string ProductName { get; set; } = null!;
        
        [Column("price")]
        public decimal Price { get; set; }
        
        [Column("supplierid")]
        public int? SupplierID { get; set; }
        
        [Column("manufacturerid")]
        public int? ManufacturerID { get; set; }
        
        [Column("categoryid")]
        public int? CategoryID { get; set; }
        
        [Column("currentdiscount")]
        public int CurrentDiscount { get; set; }
        
        [Column("quantityinstock")]
        public int QuantityInStock { get; set; }
        
        [Column("description")]
        public string? Description { get; set; }
        
        [Column("photo")]
        public string? Photo { get; set; }

        [Column("unit")]
        public string? Unit { get; set; }
        
        public Category? Category { get; set; }
        public Manufacturer? Manufacturer { get; set; }
        public Supplier? Supplier { get; set; }
    }
}
