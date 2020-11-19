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
    }
}
