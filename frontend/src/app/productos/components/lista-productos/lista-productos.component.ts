import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';
import { Producto } from 'src/app/core/models/producto.model';
import { ProductosService } from 'src/app/core/services/productos.service';
import { DialogoEliminarProductoComponent } from '../../dialogo-eliminar-producto/dialogo-eliminar-producto.component';
import { ListaProductosDataSource } from './lista-productos-datasource';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-lista-productos',
  templateUrl: './lista-productos.component.html',
  styleUrls: ['./lista-productos.component.css']
})
export class ListaProductosComponent implements AfterViewInit, OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @ViewChild(MatTable) table: MatTable<Producto>;
  dataSource: ListaProductosDataSource;

  constructor(
    private productosService: ProductosService,
    public snackBar: MatSnackBar,
    public dialog: MatDialog) { }

  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  displayedColumns = [
    'codigo',
    'nombre',
    'pesoUnd',
    'peso',
    'unidad',
    'clase',
    'acciones'];

  ngOnInit(): void {
    this.dataSource = new ListaProductosDataSource(this.productosService);
  }

  ngAfterViewInit(): void {
    this.dataSource.sort = this.sort;
    this.dataSource.paginator = this.paginator;
    this.table.dataSource = this.dataSource;
  }

  openDialog(producto: Producto): void {
    const dialogRef = this.dialog.open(DialogoEliminarProductoComponent);

    dialogRef.afterClosed().subscribe(result => {
      if (result === true) {
        this.borrar(producto);
      }
    });
  }

  borrar(producto: Producto): void {
    // primero preguntar
    this.productosService.deleteProducto(producto.id).
      subscribe(rs => {
        if (rs.id) {
          this.dataSource.loadListado();
          this.snackBar.open('Producto eliminado exitosamente', 'Ok', { duration: 3000 });
        } else {
          this.snackBar.open(rs, 'Ok', { duration: 3000 });
        }
      });
  }
}
