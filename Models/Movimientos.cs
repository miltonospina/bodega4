using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class Movimientos
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public int Sentido { get; set; }
        public int Nivel { get; set; }
        public int Columna { get; set; }
        public int Posicion { get; set; }
        public int PaquetesId { get; set; }
        public int? UsuariosId { get; set; }

        public virtual Paquetes Paquetes { get; set; }
        public virtual Usuarios Usuarios { get; set; }
    }
}
