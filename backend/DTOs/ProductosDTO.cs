using System;
using System.Collections.Generic;

namespace b4backend.DTOs
{
    public partial class ProductosDTO
    {
        public int Id { get; set; }
        public string CodigoProvidencia { get; set; }
        public int ClaseId { get; set; }
        public string Nombre { get; set; }
        public float? PesoUnd { get; set; }
        public float? Peso { get; set; }
        public string Unidad { get; set; }
        public int? Bultos { get; set; }

        public virtual ClasesDTO Clase { get; set; }
        public virtual List<PaquetesDTO> Paquetes { get; set; }
    }
}
