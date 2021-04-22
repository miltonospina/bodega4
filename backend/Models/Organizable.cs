using System;
using System.Collections.Generic;

namespace b4backend.Models
{
    public partial class Organizable
    {
        public Organizable()
        {
        }

        public Organizable(VMinimoPos i, int maxPosiciones){
            this.Nivel = i.Nivel;
            this.Columna = i.Columna;
            this.EspaciosVacios = (int) (maxPosiciones - i.Minimo);
        }


        public int Nivel { get; set; }
        public int Columna { get; set; }
        public int EspaciosVacios { get; set; }

    }
}
