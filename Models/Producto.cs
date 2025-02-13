using System.ComponentModel.DataAnnotations;

namespace TestAppASP.Models
{
    public class Producto
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        public string Nombre { get; set; } = string.Empty; 

        [Required(ErrorMessage = "El precio es obligatorio.")]
        [Range(1, 10000, ErrorMessage = "El precio debe estar entre 1 y 10,000.")]
        public decimal Precio { get; set; }

        [Required(ErrorMessage = "La fecha es obligatoria.")]
        [DataType(DataType.Date)]
        public DateTime FechaRegistro { get; set; }

        [Required(ErrorMessage = "El correo es obligatorio.")]
        [EmailAddress(ErrorMessage = "Formato de email inválido.")]
        public string Email { get; set; } = string.Empty; 
    }


}
