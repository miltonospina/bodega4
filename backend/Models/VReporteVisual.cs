using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class VReporteVisual
    {
        public int Sentido { get; set; }
        public int Nivel { get; set; }
        public int Columna { get; set; }
        public int Posicion { get; set; }
        public int PaquetesId { get; set; }
        public int? MovimientosId { get; set; }
        public string Nombrecss { get; set; }
    }
}
