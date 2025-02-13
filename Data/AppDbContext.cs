
using Microsoft.EntityFrameworkCore;

namespace TestAppASP.Data
{
    using Microsoft.EntityFrameworkCore;
    using TestAppASP.Models;

    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Producto> Productos { get; set; }
    }

}

