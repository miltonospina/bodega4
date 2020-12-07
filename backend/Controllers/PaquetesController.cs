using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using b4backend.Models;

namespace b4backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaquetesController : ControllerBase
    {
        private readonly bodega4Context _context;

        public PaquetesController(bodega4Context context)
        {
            _context = context;
        }

        // GET: api/Paquetes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Paquetes>>> GetPaquetes()
        {
            return await _context.Paquetes.ToListAsync();
        }

        // GET: api/Paquetes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Paquetes>> GetPaquetes(int id)
        {
            var paquetes = await _context.Paquetes.FindAsync(id);

            if (paquetes == null)
            {
                return NotFound();
            }

            return paquetes;
        }

        // PUT: api/Paquetes/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPaquetes(int id, Paquetes paquetes)
        {
            if (id != paquetes.Id)
            {
                return BadRequest();
            }

            _context.Entry(paquetes).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PaquetesExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Paquetes
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Paquetes>> PostPaquetes(Paquetes paquetes)
        {
            _context.Paquetes.Add(paquetes);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPaquetes", new { id = paquetes.Id }, paquetes);
        }

        // DELETE: api/Paquetes/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Paquetes>> DeletePaquetes(int id)
        {
            var paquetes = await _context.Paquetes.FindAsync(id);
            if (paquetes == null)
            {
                return NotFound();
            }

            _context.Paquetes.Remove(paquetes);
            await _context.SaveChangesAsync();

            return paquetes;
        }

        private bool PaquetesExists(int id)
        {
            return _context.Paquetes.Any(e => e.Id == id);
        }
    }
}
