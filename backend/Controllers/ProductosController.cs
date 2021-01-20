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
    public class ProductosController : ControllerBase
    {
        private readonly bodega4Context _context;

        public ProductosController(bodega4Context context)
        {
            _context = context;
        }

        // GET: api/Productos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Productos>>> GetProductos()
        {
            var x = await _context.Productos
            .Include(p => p.Clase)
            .ToListAsync();

            x.ForEach(p => p.Clase.Productos = null);
            return x;
        }

        // GET: api/Productos/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Productos>> GetProductos(int id)
        {
            var productos = await _context.Productos.FindAsync(id);

            if (productos == null)
            {
                return NotFound();
            }

            return productos;
        }

        // PUT: api/Productos/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProductos(int id, Productos productos)
        {
            if (id != productos.Id)
            {
                return BadRequest();
            }

            _context.Entry(productos).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductosExists(id))
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

        // POST: api/Productos
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Productos>> PostProductos(Productos productos)
        {
            _context.Productos.Add(productos);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProductos", new { id = productos.Id }, productos);
        }

        // DELETE: api/Productos/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Productos>> DeleteProductos(int id)
        {
            var productos = await _context.Productos.FindAsync(id);
            if (productos == null)
            {
                return NotFound();
            }

            _context.Productos.Remove(productos);
            await _context.SaveChangesAsync();

            return productos;
        }

        private bool ProductosExists(int id)
        {
            return _context.Productos.Any(e => e.Id == id);
        }
    }
}
