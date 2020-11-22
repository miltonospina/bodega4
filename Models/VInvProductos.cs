using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class VInvProductos
    {
        public string Clase { get; set; }
        public int CodProducto { get; set; }
        public string Producto { get; set; }
        public int? Cantidad { get; set; }
        public float? Peso { get; set; }
        public string Unidad { get; set; }
    }
}
