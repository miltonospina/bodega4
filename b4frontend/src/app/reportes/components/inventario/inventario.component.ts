import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';
import { BodegaService } from 'src/app/core/services/bodega.service';
import { InventarioDataSource, InventarioItem } from './inventario-datasource';

@Component({
  selector: 'app-inventario',
  templateUrl: './inventario.component.html',
  styleUrls: ['./inventario.component.css']
})
export class InventarioComponent implements AfterViewInit, OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @ViewChild(MatTable) table: MatTable<InventarioItem>;
  dataSource: InventarioDataSource;

  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  constructor(private bodegaService: BodegaService) { }

  displayedColumns = [
    'fechaIngreso',
    'nivel',
    'columna',
    'posicion',
    'clase',
    'producto',
    'paquetesId',
    'bultos',
    'cliente'];

  ngOnInit() {
    this.dataSource = new InventarioDataSource(this.bodegaService);
  }

  ngAfterViewInit() {
    this.dataSource.sort = this.sort;
    this.dataSource.paginator = this.paginator;
    this.table.dataSource = this.dataSource;
  }
}
