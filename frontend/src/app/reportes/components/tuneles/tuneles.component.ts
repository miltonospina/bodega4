import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';
import { BodegaService } from 'src/app/core/services/bodega.service';
import { TunelesDataSource, TunelesItem } from './tuneles-datasource';

@Component({
  selector: 'app-tuneles',
  templateUrl: './tuneles.component.html',
  styleUrls: ['./tuneles.component.css']
})
export class TunelesComponent implements AfterViewInit, OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @ViewChild(MatTable) table: MatTable<TunelesItem>;
  dataSource: TunelesDataSource;

  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  constructor(private bodegaService: BodegaService) { }

  displayedColumns = [
    'fechaIngreso',
    'nivel',
    'columna',
    'codigo',
    'producto',
    'lote',
    'estibas',
    'bultos',
    'cliente'];

  ngOnInit() {
    this.dataSource = new TunelesDataSource(this.bodegaService);
  }

  ngAfterViewInit() {
    this.dataSource.sort = this.sort;
    this.dataSource.paginator = this.paginator;
    this.table.dataSource = this.dataSource;
  }
}
