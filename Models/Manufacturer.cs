using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("manufacturers")]
    public class Manufacturer
    {
        [Column("manufacturerid")]
        public int ManufacturerID { get; set; }
        [Column("name")] 
        public string Name { get; set; }
        
        // Навигационное свойство
        public ICollection<Product> Products { get; set; }
    }
}