using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class Clases
    {
        public Clases()
        {
            Productos = new HashSet<Productos>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Nombrecss { get; set; }

        public virtual ICollection<Productos> Productos { get; set; }
    }
}
