using System;
using System.Collections.Generic;

namespace b4backend.DTOs
{
    public class ClasesDTO
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Nombrecss { get; set; }

        public virtual List<ProductosDTO> Productos { get; set; }
    }
}
