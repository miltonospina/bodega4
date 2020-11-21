using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace b4backend.Models
{
    public partial class bodega4Context : DbContext
    {
        public bodega4Context()
        {
        }

        public bodega4Context(DbContextOptions<bodega4Context> options)
            : base(options)
        {
        }

        public virtual DbSet<Clases> Clases { get; set; }
        public virtual DbSet<Clientes> Clientes { get; set; }
        public virtual DbSet<Movimientos> Movimientos { get; set; }
        public virtual DbSet<Opciones> Opciones { get; set; }
        public virtual DbSet<Paquetes> Paquetes { get; set; }
        public virtual DbSet<Productos> Productos { get; set; }
        public virtual DbSet<Usuarios> Usuarios { get; set; }
        public virtual DbSet<VFechaIngreso> VFechaIngreso { get; set; }
        public virtual DbSet<VInvProductos> VInvProductos { get; set; }
        public virtual DbSet<VInventario> VInventario { get; set; }
        public virtual DbSet<VMinimoPos> VMinimoPos { get; set; }
        public virtual DbSet<VPaquetesActuales> VPaquetesActuales { get; set; }
        public virtual DbSet<VPosicionesActual> VPosicionesActual { get; set; }
        public virtual DbSet<VReporteVisual> VReporteVisual { get; set; }

        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Clases>(entity =>
            {
                entity.ToTable("clases", "bodega4");

                entity.Property(e => e.Nombre)
                    .IsRequired()
                    .HasColumnName("nombre")
                    .HasMaxLength(50);

                entity.Property(e => e.Nombrecss)
                    .IsRequired()
                    .HasColumnName("nombrecss")
                    .HasMaxLength(20);
            });

            modelBuilder.Entity<Clientes>(entity =>
            {
                entity.ToTable("clientes", "bodega4");

                entity.Property(e => e.Nombre)
                    .IsRequired()
                    .HasColumnName("nombre")
                    .HasMaxLength(255);
            });

            modelBuilder.Entity<Movimientos>(entity =>
            {
                entity.ToTable("movimientos", "bodega4");

                entity.Property(e => e.Columna).HasColumnName("columna");

                entity.Property(e => e.Fecha)
                    .HasColumnName("fecha")
                    .HasColumnType("datetime2(3)");

                entity.Property(e => e.Nivel).HasColumnName("nivel");

                entity.Property(e => e.PaquetesId).HasColumnName("paquetesId");

                entity.Property(e => e.Posicion).HasColumnName("posicion");

                entity.Property(e => e.Sentido).HasColumnName("sentido");

                entity.Property(e => e.UsuariosId).HasColumnName("usuariosId");

                entity.HasOne(d => d.Paquetes)
                    .WithMany(p => p.Movimientos)
                    .HasForeignKey(d => d.PaquetesId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_movimientos_paquetes");

                entity.HasOne(d => d.Usuarios)
                    .WithMany(p => p.Movimientos)
                    .HasForeignKey(d => d.UsuariosId)
                    .HasConstraintName("FK_movimientos_usuarios");
            });

            modelBuilder.Entity<Opciones>(entity =>
            {
                entity.ToTable("opciones", "bodega4");

                entity.Property(e => e.Nombre)
                    .IsRequired()
                    .HasColumnName("nombre")
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Valor)
                    .IsRequired()
                    .HasColumnName("valor")
                    .HasMaxLength(191)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Paquetes>(entity =>
            {
                entity.ToTable("paquetes", "bodega4");

                entity.HasIndex(e => e.ClienteId)
                    .HasName("cliente");

                entity.HasIndex(e => e.ProductoId)
                    .HasName("tipo");

                entity.Property(e => e.Bultos).HasColumnName("bultos");

                entity.Property(e => e.ClienteId).HasColumnName("clienteId");

                entity.Property(e => e.Lote)
                    .IsRequired()
                    .HasColumnName("lote")
                    .HasMaxLength(30);

                entity.Property(e => e.ProductoId).HasColumnName("productoId");

                entity.HasOne(d => d.Cliente)
                    .WithMany(p => p.Paquetes)
                    .HasForeignKey(d => d.ClienteId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_paquetes_clientes");

                entity.HasOne(d => d.Producto)
                    .WithMany(p => p.Paquetes)
                    .HasForeignKey(d => d.ProductoId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_paquetes_productos");
            });

            modelBuilder.Entity<Productos>(entity =>
            {
                entity.ToTable("productos", "bodega4");

                entity.Property(e => e.Bultos).HasColumnName("bultos");

                entity.Property(e => e.ClaseId).HasColumnName("claseId");

                entity.Property(e => e.Nombre)
                    .IsRequired()
                    .HasColumnName("nombre")
                    .HasMaxLength(50);

                entity.Property(e => e.Peso).HasColumnName("peso");

                entity.Property(e => e.PesoUnd).HasColumnName("peso_und");

                entity.Property(e => e.Unidad)
                    .HasColumnName("unidad")
                    .HasMaxLength(10);

                entity.HasOne(d => d.Clase)
                    .WithMany(p => p.Productos)
                    .HasForeignKey(d => d.ClaseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_productos_clases");
            });

            modelBuilder.Entity<Usuarios>(entity =>
            {
                entity.ToTable("usuarios", "bodega4");

                entity.Property(e => e.Correo)
                    .IsRequired()
                    .HasColumnName("correo")
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Fecharegistro)
                    .HasColumnName("fecharegistro")
                    .HasColumnType("date");

                entity.Property(e => e.Identificacion)
                    .IsRequired()
                    .HasColumnName("identificacion")
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.Nombre)
                    .IsRequired()
                    .HasColumnName("nombre")
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasColumnName("password")
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Rol)
                    .IsRequired()
                    .HasColumnName("rol")
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.Telefono)
                    .IsRequired()
                    .HasColumnName("telefono")
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasColumnName("username")
                    .HasMaxLength(20)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<VFechaIngreso>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_fecha_ingreso", "bodega4");

                entity.Property(e => e.FechaIngreso)
                    .HasColumnName("fecha_ingreso")
                    .HasColumnType("datetime2(3)");

                entity.Property(e => e.PaquetesId).HasColumnName("paquetesId");
            });

            modelBuilder.Entity<VInvProductos>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_inv_productos", "bodega4");

                entity.Property(e => e.Cantidad).HasColumnName("cantidad");

                entity.Property(e => e.Clase)
                    .IsRequired()
                    .HasColumnName("clase")
                    .HasMaxLength(50);

                entity.Property(e => e.CodProducto).HasColumnName("cod_producto");

                entity.Property(e => e.Peso).HasColumnName("peso");

                entity.Property(e => e.Producto)
                    .IsRequired()
                    .HasColumnName("producto")
                    .HasMaxLength(50);

                entity.Property(e => e.Unidad)
                    .HasColumnName("unidad")
                    .HasMaxLength(10);
            });

            modelBuilder.Entity<VInventario>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_inventario", "bodega4");

                entity.Property(e => e.Bultos).HasColumnName("bultos");

                entity.Property(e => e.Clase)
                    .IsRequired()
                    .HasColumnName("clase")
                    .HasMaxLength(50);

                entity.Property(e => e.Cliente)
                    .IsRequired()
                    .HasColumnName("cliente")
                    .HasMaxLength(255);

                entity.Property(e => e.Columna).HasColumnName("columna");

                entity.Property(e => e.FechaIngreso)
                    .HasColumnName("fecha_ingreso")
                    .HasColumnType("datetime2(3)");

                entity.Property(e => e.Nivel).HasColumnName("nivel");

                entity.Property(e => e.PaquetesId).HasColumnName("paquetesId");

                entity.Property(e => e.Posicion).HasColumnName("posicion");

                entity.Property(e => e.Producto)
                    .IsRequired()
                    .HasColumnName("producto")
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<VMinimoPos>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_minimo_pos", "bodega4");

                entity.Property(e => e.Columna).HasColumnName("columna");

                entity.Property(e => e.Minimo).HasColumnName("minimo");

                entity.Property(e => e.Nivel).HasColumnName("nivel");
            });

            modelBuilder.Entity<VPaquetesActuales>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_paquetes_actuales", "bodega4");

                entity.Property(e => e.MovimientosId).HasColumnName("movimientosId");

                entity.Property(e => e.PaquetesId).HasColumnName("paquetesId");
            });

            modelBuilder.Entity<VPosicionesActual>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_posiciones_actual", "bodega4");

                entity.Property(e => e.Columna).HasColumnName("columna");

                entity.Property(e => e.MovimientosId).HasColumnName("movimientosId");

                entity.Property(e => e.Nivel).HasColumnName("nivel");

                entity.Property(e => e.PaquetesId).HasColumnName("paquetesId");

                entity.Property(e => e.Posicion).HasColumnName("posicion");

                entity.Property(e => e.Sentido).HasColumnName("sentido");
            });

            modelBuilder.Entity<VReporteVisual>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("v_reporte_visual", "bodega4");

                entity.Property(e => e.Columna).HasColumnName("columna");

                entity.Property(e => e.MovimientosId).HasColumnName("movimientosId");

                entity.Property(e => e.Nivel).HasColumnName("nivel");

                entity.Property(e => e.Nombrecss)
                    .IsRequired()
                    .HasColumnName("nombrecss")
                    .HasMaxLength(20);

                entity.Property(e => e.PaquetesId).HasColumnName("paquetesId");

                entity.Property(e => e.Posicion).HasColumnName("posicion");

                entity.Property(e => e.Sentido).HasColumnName("sentido");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
