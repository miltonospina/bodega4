using System;
using System.Collections.Generic;
using b4backend.Models;
using System.Linq;

namespace b4backend.BIZ
{
    public class Bodega4
    {
        int columnas = 12;
        int niveles = 10;
        int posiciones = 47;


        private readonly bodega4Context _context;

        public Bodega4(bodega4Context context)
        {
            _context = context;
        }

        private Boolean existePosicion(Movimientos mov)
        {
            return mov.Columna > 0 &&
                mov.Nivel > 0 &&
                mov.Columna <= this.columnas &&
                mov.Nivel <= this.niveles;
        }

        private int maxPosicion(Movimientos mov)
        {
            int respuesta;
            if (existePosicion(mov))
            {
                var tunel = _context.VMinimoPos
                .Where(s => s.Columna == mov.Columna)
                .Where(s => s.Nivel == mov.Nivel)
                .FirstOrDefault();

                if (tunel != null)
                {
                    respuesta = (int)tunel.Minimo;
                }
                else
                {
                    respuesta = this.posiciones + 1;
                }
            }
            else
            {
                respuesta = -1;
            }
            return respuesta;
        }



        public object ingreso(Movimientos ingreso)
        {
            int rs = maxPosicion(ingreso);
            if (rs == 1)
            {
                return ("No hay posiciones disponibles.");
            }
            else if (rs == -1)
            {
                return ("No existe la posición seleccionada.");
            }
            else
            {
                ingreso.Posicion = rs - 1;
                ingreso.Fecha = DateTime.Now;
                ingreso.Sentido = 1;
                return ingreso;
            }
        }


        public object salida(Movimientos salida)
        {
            int rs = maxPosicion(salida);

            if (rs == (this.posiciones + 1))
            {
                return ("El tunel seleccionado está vacio.");
            }
            else if (rs == -1)
            {
                return ("No existe el tunel seleccionado.");
            }
            else
            {
                int paqueteId = ubicarEn(salida);
                if (paqueteId != -1)
                {
                    salida.PaquetesId = paqueteId;
                    salida.Posicion = rs;
                    salida.Fecha = DateTime.Now;
                    salida.Sentido = -1;
                    return salida;
                }
                else
                {
                    return "La posición seleccionada no está ocupada.";
                }
            }
        }


        private int ubicarEn(Movimientos mov)
        {
            var posActual = _context.VMinimoPos
                .Where(s => s.Columna == mov.Columna)
                .Where(s => s.Nivel == mov.Nivel)
                .FirstOrDefault();

            if (posActual != null)
            {
                var paqueteActual = _context.VPosicionesActual
                .Where(s => s.Columna == posActual.Columna)
                .Where(s => s.Nivel == posActual.Nivel)
                .Where(s => s.Posicion == posActual.Minimo)
                .FirstOrDefault();

                return paqueteActual.PaquetesId;
            }
            else
            {
                return -1;
            }
        }
    }
}
