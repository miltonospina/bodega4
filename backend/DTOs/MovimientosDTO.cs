using System;
using System.Collections.Generic;

namespace b4backend.DTOs
{
    public partial class MovimientosDTO
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public int Sentido { get; set; }
        public int Nivel { get; set; }
        public int Columna { get; set; }
        public int Posicion { get; set; }
        public int PaquetesId { get; set; }
        public int? UsuariosId { get; set; }

        public virtual PaquetesDTO Paquetes { get; set; }
        public virtual UsuariosDTO Usuarios { get; set; }
    }
}
