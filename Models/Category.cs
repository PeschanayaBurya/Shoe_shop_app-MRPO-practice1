using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("categories")]
    public class Category
    {
        [Column("categoryid")]
        public int CategoryID { get; set; }
        
        [Column("categoryname")]
        public string CategoryName { get; set; } = null!;
        
        public ICollection<Product> Products { get; set; }
    }
}