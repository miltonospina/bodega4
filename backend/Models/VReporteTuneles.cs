using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class VReporteTuneles
    {
        public DateTime FechaIngreso { get; set; }
        public int Nivel { get; set; }
        public int Columna { get; set; }
        public string Producto { get; set; }
        public string CodigoProvidencia { get; set; }
        public string Lote { get; set; }
        public string Cliente { get; set; }
        public int Estibas { get; set; }
        public int sbultos { get; set; }
    }
}
