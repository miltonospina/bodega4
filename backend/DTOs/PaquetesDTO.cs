using System;
using System.Collections.Generic;

namespace b4backend.DTOs
{
    public partial class PaquetesDTO
    {

        public int Id { get; set; }
        public string Lote { get; set; }
        public int ProductoId { get; set; }
        public int ClienteId { get; set; }
        public int? Bultos { get; set; }

        public virtual ClientesDTO Cliente { get; set; }
        public virtual ProductosDTO Producto { get; set; }
        public virtual List<MovimientosDTO> Movimientos { get; set; }
    }
}
