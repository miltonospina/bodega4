using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class Paquetes
    {
        public Paquetes()
        {
            Movimientos = new HashSet<Movimientos>();
        }

        public Paquetes(Paquetes o){
            Movimientos = new HashSet<Movimientos>();
            this.Lote = o.Lote;
            this.ProductoId = o.ProductoId;
            this.ClienteId = o.ClienteId;
            this.Bultos = o.Bultos;
        }

        public int Id { get; set; }
        public string Lote { get; set; }
        public int ProductoId { get; set; }
        public int ClienteId { get; set; }
        public int? Bultos { get; set; }

        public virtual Clientes Cliente { get; set; }
        public virtual Productos Producto { get; set; }
        public virtual ICollection<Movimientos> Movimientos { get; set; }

    }
}
