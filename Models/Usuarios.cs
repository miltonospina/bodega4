using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class Usuarios
    {
        public Usuarios()
        {
            Movimientos = new HashSet<Movimientos>();
        }

        public int Id { get; set; }
        public string Username { get; set; }
        public string Nombre { get; set; }
        public string Rol { get; set; }
        public string Password { get; set; }
        public DateTime Fecharegistro { get; set; }
        public string Identificacion { get; set; }
        public string Correo { get; set; }
        public string Telefono { get; set; }

        public virtual ICollection<Movimientos> Movimientos { get; set; }
    }
}
