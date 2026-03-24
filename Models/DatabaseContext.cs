using Microsoft.EntityFrameworkCore;

namespace Shoe_shop_app.Models
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext(DbContextOptions<DatabaseContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Manufacturer> Manufacturers { get; set; }
        public DbSet<Supplier> Suppliers { get; set; }
        public DbSet<Order> Orders { get; set; } 
        public DbSet<OrderStatus> OrderStatuses { get; set; }
        public DbSet<PickupPoint> PickupPoints { get; set; }
        public DbSet<OrderDetail> OrderDetails { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Product>().ToTable("products");
            modelBuilder.Entity<Category>().ToTable("categories");
            modelBuilder.Entity<Manufacturer>().ToTable("manufacturers");
            modelBuilder.Entity<Supplier>().ToTable("suppliers");
            modelBuilder.Entity<User>().ToTable("users");
            modelBuilder.Entity<Role>().ToTable("roles");
            modelBuilder.Entity<Order>().ToTable("orders");
            modelBuilder.Entity<OrderStatus>().ToTable("orderstatuses");
            modelBuilder.Entity<PickupPoint>().ToTable("pickuppoints");
            modelBuilder.Entity<OrderDetail>().ToTable("orderdetails");

            modelBuilder.Entity<Product>()
                .HasKey(p => p.VendorCode);

            modelBuilder.Entity<Order>()
                .HasKey(o => o.OrderID);

            modelBuilder.Entity<OrderStatus>()
                .HasKey(s => s.StatusID);

            modelBuilder.Entity<PickupPoint>()
                .HasKey(p => p.PickupPointID);

            modelBuilder.Entity<OrderDetail>()
                .HasKey(od => od.OrderDetailID);

            modelBuilder.Entity<OrderDetail>()
                .HasOne(od => od.Order)
                .WithMany(o => o.OrderDetails)
                .HasForeignKey(od => od.OrderID)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Order>()
                .HasOne(o => o.Status)
                .WithMany(s => s.Orders)
                .HasForeignKey(o => o.StatusID)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Order>()
                .HasOne(o => o.PickupPoint)
                .WithMany(p => p.Orders)
                .HasForeignKey(o => o.PickupPointID)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Product>()
                .HasOne(p => p.Category)
                .WithMany(c => c.Products)
                .HasForeignKey(p => p.CategoryID)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Product>()
                .HasOne(p => p.Manufacturer)
                .WithMany(m => m.Products)
                .HasForeignKey(p => p.ManufacturerID)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Product>()
                .HasOne(p => p.Supplier)
                .WithMany(s => s.Products)
                .HasForeignKey(p => p.SupplierID)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithMany(r => r.Users)
                .HasForeignKey(u => u.RoleID)
                .HasPrincipalKey(r => r.RoleID);

            modelBuilder.Entity<OrderDetail>()
                .Property(od => od.ProductVendorCode)
                .HasColumnName("productvendorcode");
        }
    }
}
