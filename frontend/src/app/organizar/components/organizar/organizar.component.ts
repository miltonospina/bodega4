import { AfterViewInit, Component, OnInit, ViewChild, ChangeDetectorRef } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';
import { MatSnackBar } from '@angular/material/snack-bar';
import { BodegaService } from 'src/app/core/services/bodega.service';
import { DialogoOrganizarComponent } from '../dialogo-organizar/dialogo-organizar.component';
import { OrganizarDataSource, OrganizarItem } from './organizar-datasource';

@Component({
  selector: 'app-organizar',
  templateUrl: './organizar.component.html',
  styleUrls: ['./organizar.component.css']
})
export class OrganizarComponent implements AfterViewInit, OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @ViewChild(MatTable) table: MatTable<OrganizarItem>;
  dataSource: OrganizarDataSource;

  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  constructor(
    private bodegaService: BodegaService,
    public snackBar: MatSnackBar,
    public dialog: MatDialog,
    private changeDetectorRefs: ChangeDetectorRef) { }

  displayedColumns = [
    'nivel',
    'columna',
    'espacios',
    'acciones'];

  ngOnInit() {
    this.dataSource = new OrganizarDataSource(this.bodegaService);
  }

  ngAfterViewInit() {
    this.dataSource.sort = this.sort;
    this.dataSource.paginator = this.paginator;
    this.table.dataSource = this.dataSource;
  }

  openOrganizarDialogo(tunel: OrganizarItem): void {
    const dialogRef = this.dialog.open(DialogoOrganizarComponent);

    dialogRef.afterClosed().subscribe(result => {
      if (result === true) {
        this.organizar(tunel);
      }
    });
  }

  organizar(tunel: OrganizarItem): void {
    // primero preguntar
    this.bodegaService.organizarPaquetes(tunel).
      subscribe(rs => {
        if (rs.status === 'OK') {
          this.dataSource.loadReporte();
          this.table.renderRows();
          this.dataSource.sort.direction = 'desc';
          this.snackBar.open(rs.mensaje, 'Ok', { duration: 3000 });
        } else {
          this.snackBar.open(rs.mensaje, 'Ok', { duration: 3000 });
        }
      });
  }
}
