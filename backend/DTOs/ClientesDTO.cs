using System;
using System.Collections.Generic;

namespace b4backend.DTOs
{
    public partial class ClientesDTO
    {
        public int Id { get; set; }
        public string Nombre { get; set; }

        public virtual List<PaquetesDTO> Paquetes { get; set; }
    }
}
