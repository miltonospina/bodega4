using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using b4backend.Models;
using b4backend.BIZ;

namespace b4backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EstibasController : ControllerBase
    {
        private readonly bodega4Context _context;
        private Bodega4 _bodega4;

        public EstibasController(bodega4Context context)
        {
            _context = context;
            _bodega4 = new Bodega4(_context);
        }


        // POST: api/Estibas
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Movimientos>> PostEstibas(Movimientos ingreso)
        {
            Object rs = _bodega4.ingreso(ingreso);
            if (rs is string)
            {
                return NotFound(rs);
            }
            else
            {
                _context.Paquetes.Add(ingreso.Paquetes);
                _context.Movimientos.Add(ingreso);
                await _context.SaveChangesAsync();
                return CreatedAtAction("GetMovimientos", "Movimientos", new { id = ingreso.Id }, ingreso);
            }
        }

        // DELETE: api/Estibas/5/5
        [HttpDelete("{columna}/{nivel}")]
        public async Task<ActionResult<Paquetes>> DeleteEstibas(int columna, int nivel)
        {
            Movimientos salida = new Movimientos();
            salida.Columna = columna;
            salida.Nivel = nivel;

            Object rs = _bodega4.salida(salida);
            if (rs is string)
            {
                return NotFound(rs);
            }
            else
            {
                _context.Movimientos.Add(salida);
                await _context.SaveChangesAsync();
                return CreatedAtAction("GetMovimientos", "Movimientos", new { id = salida.Id }, salida);
            }
        }

        private bool PaquetesExists(int id)
        {
            return _context.Paquetes.Any(e => e.Id == id);
        }
    }
}
