import { DataSource } from '@angular/cdk/collections';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { map } from 'rxjs/operators';
import { Observable, of as observableOf, merge } from 'rxjs';
import { BodegaService } from 'src/app/core/services/bodega.service';

export interface InventarioItem {
  fechaIngreso: string;
  nivel: number;
  columna: number;
  posicion: number;
  clase: string;
  producto: string;
  paquetesId: number;
  bultos: number;
  cliente: string;
}


/**
 * Data source for the Inventario view. This class should
 * encapsulate all logic for fetching and manipulating the displayed data
 * (including sorting, pagination, and filtering).
 */
export class InventarioDataSource extends DataSource<InventarioItem> {
  data: InventarioItem[] = [];
  paginator: MatPaginator;
  sort: MatSort;

  constructor(private bodegaService: BodegaService) {
    super();
  }

  /**
   * Connect this data source to the table. The table will only update when
   * the returned stream emits new items.
   * @returns A stream of the items to be rendered.
   */
  connect(): Observable<InventarioItem[]> {
    const dataMutations = [
      this.bodegaService.getInventario(),
      this.paginator.page,
      this.sort.sortChange
    ];
    this.loadReporte();
    return merge(...dataMutations).pipe(map(() => {
      console.log('Lo segundo');
      return this.getPagedData(this.getSortedData([...this.data]));
    }));
  }

  /**
   *  Called when the table is being destroyed. Use this function, to clean up
   * any open connections or free any held resources that were set up during connect.
   */
  disconnect() { }

  /**
   * Paginate the data (client-side). If you're using server-side pagination,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getPagedData(data: InventarioItem[]) {
    const startIndex = this.paginator.pageIndex * this.paginator.pageSize;
    return data.splice(startIndex, this.paginator.pageSize);
  }

  /**
   * Sort the data (client-side). If you're using server-side sorting,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getSortedData(data: InventarioItem[]) {
    if (!this.sort.active || this.sort.direction === '') {
      return data;
    }

    return data.sort((a, b) => {
      const isAsc = this.sort.direction === 'asc';
      switch (this.sort.active) {
        case 'producto': return compare(a.producto, b.producto, isAsc);
        case 'clase': return compare(+a.clase, +b.clase, isAsc);
        case 'nivel': return compare(+a.nivel, +b.nivel, isAsc);
        case 'columna': return compare(+a.columna, +b.columna, isAsc);
        case 'posicion': return compare(+a.posicion, +b.posicion, isAsc);
        case 'cliente': return compare(+a.cliente, +b.cliente, isAsc);
        case 'fechaIngreso': return compare(+a.fechaIngreso, +b.fechaIngreso, isAsc);
        case 'paquetesId': return compare(+a.paquetesId, +b.paquetesId, isAsc);
        default: return 0;
      }
    });
  }

  private loadReporte(): void{
    console.log('Crea el subscribe');
    this.bodegaService.getInventario()
    .subscribe(res => {
      this.data = res;
      console.log('Llego la data');
    });
  }
}

/** Simple sort comparator for example ID/Name columns (for client-side sorting). */
function compare(a: string | number, b: string | number, isAsc: boolean) {
  return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
}
