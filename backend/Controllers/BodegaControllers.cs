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
    public class BodegaController : ControllerBase
    {
        private readonly bodega4Context _context;
        private Bodega4 _bodega4;

        public BodegaController(bodega4Context context)
        {
            _context = context;
            _bodega4 = new Bodega4(_context);
        }

        // GET: api/Layout
        [HttpGet]
        public ActionResult Getlayout()
        {   
            return Ok(new {
                niveles = _bodega4.getNiveles(),
                columnas = _bodega4.getColumnas(),
                posiciones = _bodega4.getPosiciones()
            });            
        }

        [HttpGet("{col}/{niv}")]
        public ActionResult getDisponible(int col, int niv){

            Movimientos entrada = new Movimientos();
            entrada.Columna = col;
            entrada.Nivel = niv;

            object rs = _bodega4.simularIngreso(entrada);
            return Ok(new { respuesta = rs });
        }




    }
}
