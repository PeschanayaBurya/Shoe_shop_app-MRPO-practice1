using System.ComponentModel.DataAnnotations.Schema;

namespace Shoe_shop_app.Models
{
    [Table("users")]
    public class User
    {
        [Column("userid")]
        public int UserID { get; set; }
        
        [Column("fullname")]
        public string FullName { get; set; } = null!;
        
        [Column("login")]
        public string Login { get; set; } = null!;
        
        [Column("password")]
        public string Password { get; set; } = null!;
        
        [Column("roleid")]
        public int RoleID { get; set; }
        
        public Role? Role { get; set; }
    }
    
    [Table("roles")]
    public class Role
    {
        [Column("roleid")]
        public int RoleID { get; set; }
        
        [Column("namerole")]
        public string NameRole { get; set; } = null!;
        
        public ICollection<User>? Users { get; set; }
    }
}