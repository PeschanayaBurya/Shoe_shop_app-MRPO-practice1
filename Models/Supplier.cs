using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("suppliers")]
    public class Supplier
    {
        [Column("supplierid")]
        public int SupplierID { get; set; }
        [Column("name")] 
        public string Name { get; set; }
        
        // Навигационное свойство
        public ICollection<Product> Products { get; set; }
    }
}