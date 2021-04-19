using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using b4backend.Models;
using b4backend.BLL;
using Microsoft.AspNetCore.Authorization;
using System.ComponentModel.DataAnnotations;

namespace b4backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Administrador, Operador")]
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
            return Ok(new
            {
                niveles = _bodega4.getNiveles(),
                columnas = _bodega4.getColumnas(),
                posiciones = _bodega4.getPosiciones()
            });
        }

        [HttpGet("{col}/{niv}")]
        public ActionResult getDisponible(int col, int niv)
        {

            Movimientos entrada = new Movimientos();
            entrada.Columna = col;
            entrada.Nivel = niv;

            object rs = _bodega4.simularIngreso(entrada);
            return Ok(new { respuesta = rs });
        }

        [HttpPost("migracion")]
        public ActionResult migracion([FromBody] migrationModel[] listado)
        {

            _context.Movimientos.RemoveRange(_context.Movimientos);

            _context.Paquetes.RemoveRange(_context.Paquetes);

            //por cada paquete

            int l = listado.Length;
            int c = 0;

            foreach (migrationModel item in listado)
            {
                c++;
                Movimientos ingreso = new Movimientos();
                ingreso.Paquetes = new Paquetes();
                ingreso.Paquetes.Lote = item.lote;
                ingreso.Paquetes.Bultos = item.bultos;

                Console.WriteLine(c + "/" + l + " pr: " + item.codigo_producto);
                ingreso.Paquetes.Producto = _context.Productos.First(p => p.CodigoProvidencia == item.codigo_producto);


                ingreso.Paquetes.Cliente = _context.Clientes.First(c => c.Nombre == item.cliente);

                _context.Paquetes.Add(ingreso.Paquetes);

                ingreso.Fecha = item.fechaingreso;
                ingreso.Nivel = item.nivel;
                ingreso.Columna = item.columna;
                ingreso.Posicion = item.posicion;
                ingreso.Sentido = 1;

                ingreso.Usuarios = _context.Usuarios.Find(16);

                _context.Movimientos.Add(ingreso);

                _context.SaveChanges();

            }

            return Ok(new { largo = listado.Length });
        }


    }

    public class migrationModel
    {

        [Required]
        public int columna { get; set; }
        [Required]
        public int nivel { get; set; }
        [Required]
        public int posicion { get; set; }
        [Required]
        public int paquete { get; set; }
        [Required]
        public DateTime fechaingreso { get; set; }
        [Required]
        public string lote { get; set; }
        [Required]
        public string nombre { get; set; }

        [Required]
        public string codigo_producto { get; set; }

        [Required]
        public string cliente { get; set; }

        [Required]
        public int bultos { get; set; }
    }
}
