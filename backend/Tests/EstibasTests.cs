
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
            /*var connection = Effort.DbConnectionFactory.CreateTransient();
            var context = new EntityContext(connection);
            _bodega4 = new Bodega4(context);*/
        }

        [TestMethod]
        public void Ingreso_TrueResult()
        {
            //Arrange
            Movimientos movimiento = new Movimientos();
            movimiento.Columna = 1;
            movimiento.Nivel = 1;
            movimiento.Id = 1150642;
            movimiento.PaquetesId = 356773;
            
            //Act
            _bodega4.ingreso(movimiento);

            //Assert
            Assert.IsTrue(_bodega4.maxPosicion(movimiento) == 45);
        }
    }
}