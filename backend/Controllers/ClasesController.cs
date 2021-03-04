using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using b4backend.Models;
using Microsoft.AspNetCore.Authorization;

namespace b4backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Administrador, Operador")]
    public class ClasesController : ControllerBase
    {
        private readonly bodega4Context _context;

        public ClasesController(bodega4Context context)
        {
            _context = context;
        }

        // GET: api/Clases
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Clases>>> GetClases()
        {
            return await _context.Clases.ToListAsync();
        }

        // GET: api/Clases/productos
        [HttpGet("productos")]
        public async Task<ActionResult<IEnumerable<Clases>>> GetProductos()
        {
            return await _context.Clases
                .Include(s => s.Productos)
                .ToListAsync();
        }

        // GET: api/Clases/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Clases>> GetClases(int id)
        {
            var clases = await _context.Clases.FindAsync(id);

            if (clases == null)
            {
                return NotFound();
            }

            return clases;
        }

        // PUT: api/Clases/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutClases(int id, Clases clases)
        {
            if (id != clases.Id)
            {
                return BadRequest();
            }

            _context.Entry(clases).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ClasesExists(id))
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

        // POST: api/Clases
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Clases>> PostClases(Clases clases)
        {
            _context.Clases.Add(clases);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetClases", new { id = clases.Id }, clases);
        }

        // DELETE: api/Clases/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Clases>> DeleteClases(int id)
        {
            var clases = await _context.Clases.FindAsync(id);
            if (clases == null)
            {
                return NotFound();
            }

            _context.Clases.Remove(clases);
            await _context.SaveChangesAsync();

            return clases;
        }

        private bool ClasesExists(int id)
        {
            return _context.Clases.Any(e => e.Id == id);
        }
    }
}
