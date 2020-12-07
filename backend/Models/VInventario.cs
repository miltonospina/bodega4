using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class VInventario
    {
        public DateTime? FechaIngreso { get; set; }
        public int Nivel { get; set; }
        public int Columna { get; set; }
        public int Posicion { get; set; }
        public string Clase { get; set; }
        public string Producto { get; set; }
        public int PaquetesId { get; set; }
        public int? Bultos { get; set; }
        public string Cliente { get; set; }
    }
}
