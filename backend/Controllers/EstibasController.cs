using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using b4backend.Models;
using b4backend.BLL;
using b4backend.Objects;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;

namespace b4backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Administrador, Operador")]
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
        public async Task<ActionResult<Movimientos>> DeleteEstibas(int columna, int nivel)
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
                salida = (Movimientos)rs;
                _context.Movimientos.Add((Movimientos)salida);
                await _context.SaveChangesAsync();
                return CreatedAtAction("GetMovimientos", "Movimientos", new { id = salida.Id }, salida);
            }
        }


        // PUT : api/estibas/5/5
        [HttpPut("{columna}/{nivel}")]
        public async Task<ActionResult<Movimientos>> SalidaParcial(int columna, int nivel, Movimientos mvt)
        {
            Movimientos salida = new Movimientos();
            salida.Columna = columna;
            salida.Nivel = nivel;
            salida.UsuariosId = mvt.UsuariosId;

            //Movimientos actual = await _context.Movimientos.FindAsync(Id);


            Object[] rs = _bodega4.salidaParcial(salida, (int)mvt.Paquetes.Bultos);
            if (rs[0] is string)
            {
                return NotFound(rs);
            }
            else
            {
                Movimientos mSalida = (Movimientos)rs[0];
                Movimientos mEntrada = (Movimientos)rs[1];

                _context.Movimientos.Add(mSalida);
                _context.Paquetes.Add(mEntrada.Paquetes);
                _context.Movimientos.Add(mEntrada);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetMovimientos", "Movimientos", new { id = mSalida.Id }, salida);
            }
        }

        // GET: api/Estibas/5/5
        [HttpGet("{columna}/{nivel}")]
        public async Task<ActionResult> getPrimero(int columna, int nivel)
        {
            Movimientos mov = new Movimientos();
            mov.Columna = columna;
            mov.Nivel = nivel;

            object rs = await _bodega4.getPrimero(mov);
            return Ok(new { respuesta = rs });
        }

        // POST: api/estibas/multiples
        [HttpPost("multiple")]
        public async Task<ActionResult<Movimientos>> entradaMultiple(dataIngresoMultiple data)
        {
            Object rs = _bodega4.ingresoMultiple(data.ingreso, data.cantidad);
            if (rs is string)
            {
                return NotFound(rs);
            }
            else
            {
                List<Movimientos> lista = (List<Movimientos>)rs;
                lista.ForEach(async ingreso =>
                {
                    ingreso.Paquetes = new Paquetes(ingreso.Paquetes);

                    await _context.Movimientos.AddAsync(ingreso);
                });
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetMovimientos", "Movimientos", new { id = 0 }, rs);
            }
        }

        // DELETE: api/Estibas/multiple
        [HttpDelete("multiple")]
        public async Task<ActionResult<Movimientos>> DeleteMultiple(dataSalidaMultiple data)
        {
            Movimientos salida = new Movimientos();
            salida.Columna = data.columna;
            salida.Nivel = data.nivel;

            Object rs = _bodega4.salidaMultiple(salida, data.cantidad);
            if (rs is string)
            {
                return NotFound(rs);
            }
            else
            {
                List<Movimientos> lista = (List<Movimientos>)rs;
                lista.ForEach(async salida =>
                {
                    salida.UsuariosId = data.UsuariosId;
                    await _context.Movimientos.AddAsync(salida);
                });
                await _context.SaveChangesAsync();
                return CreatedAtAction("GetMovimientos", "Movimientos", new { id = 0 }, lista);
            }
        }

        private bool PaquetesExists(int id)
        {
            return _context.Paquetes.Any(e => e.Id == id);
        }
    }
}
