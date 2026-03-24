using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("pickuppoints")]
    public class PickupPoint
    {
        [Column("pickuppointid")]
        public int PickupPointID { get; set; }

        [Column("index")]
        public string? Index { get; set; }

        [Column("city")]
        public string? City { get; set; }

        [Column("street")]
        public string? Street { get; set; }

        [Column("numberhome")]
        public string? NumberHome { get; set; }

        public ICollection<Order> Orders { get; set; } = new List<Order>();

        [NotMapped]
        public string FullAddress
        {
            get
            {
                var parts = new[] { Index, City, Street, NumberHome }
                    .Where(p => !string.IsNullOrWhiteSpace(p));
                return string.Join(", ", parts);
            }
        }
    }
}
