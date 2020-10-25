using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class Clientes
    {
        public Clientes()
        {
            Paquetes = new HashSet<Paquetes>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }

        public virtual ICollection<Paquetes> Paquetes { get; set; }
    }
}
