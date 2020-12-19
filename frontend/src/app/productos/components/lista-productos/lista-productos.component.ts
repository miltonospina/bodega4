import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';
import { Producto } from 'src/app/core/models/producto.model';
import { ProductosService } from 'src/app/core/services/productos.service';
import { ListaProductosDataSource } from './lista-productos-datasource';

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

  constructor(private productosService: ProductosService) { }

  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  displayedColumns = [
    'id',
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
}
