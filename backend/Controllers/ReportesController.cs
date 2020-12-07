using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using b4backend.Models;
using b4backend.BLL;

namespace b4backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReportesController : ControllerBase
    {
        private readonly bodega4Context _context;

        public ReportesController(bodega4Context context)
        {
            _context = context;
        }

        [HttpGet("visual/{nivel}")]
        public async Task<ActionResult<IEnumerable<VReporteVisual>>> getVisual(int nivel)
        {
            return await _context.VReporteVisual
            .Where(i => i.Nivel == nivel)
            .ToListAsync();
        }


        [HttpGet("inventario")]
        public async Task<ActionResult<IEnumerable<VInventario>>> getInventario()
        {
            return await _context.VInventario
            .ToListAsync();
        }

        [HttpGet("productos")]
        public async Task<ActionResult<IEnumerable<VInvProductos>>> getReporteProductos()
        {
            return await _context.VInvProductos
            .ToListAsync();
        }
    }
}
