using System;
using b4backend.BLL;
using b4backend.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    [TestClass]
    public class EstibasTests
    {
        private readonly bodega4Context _context;
        private Bodega4 _bodega4;

        [TestInitialize]
        public void SetUp()
        {   
            //Create in memory database
            DbContextOptions<bodega4Context> options = new DbContextOptionsBuilder<bodega4Context>().
                UseInMemoryDatabase(databaseName: "BODEGA_AZU_IPSA").Options;

            bodega4Context context = new bodega4Context(options);
            _bodega4 = new Bodega4(context);
        }

        [TestMethod]
        public void Ingreso_TrueResult()
        {
            //Arrange
            Movimientos movimiento = new Movimientos();
            movimiento.Columna = 1;
            movimiento.Nivel = 1;
            
            System.Console.WriteLine("POSICIÓN ESPERADA 1: "+_bodega4.minPosicion(movimiento));
            //Act
            _bodega4.ingreso(movimiento);

            System.Console.WriteLine("POSICIÓN ESPERADA 2: "+_bodega4.minPosicion(movimiento));
            //Assert
            Assert.IsTrue(_bodega4.minPosicion(movimiento) == 28);
        }
    }
}