import { DataSource } from '@angular/cdk/collections';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { map } from 'rxjs/operators';
import { Observable, of as observableOf, merge } from 'rxjs';
import { BodegaService } from 'src/app/core/services/bodega.service';

// TODO: Replace this with your own data model type
export interface ProductosItem {
  clase: string;
  producto: string;
  cantidad: number;
  peso: number;
  unidad: string;
}
/**
 * Data source for the Productos view. This class should
 * encapsulate all logic for fetching and manipulating the displayed data
 * (including sorting, pagination, and filtering).
 */
export class ProductosDataSource extends DataSource<ProductosItem> {
  data: ProductosItem[] = [];
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
  connect(): Observable<ProductosItem[]> {
    // Combine everything that affects the rendered data into one update
    // stream for the data-table to consume.
    const dataMutations = [
      this.bodegaService.getReporteProductos(),
      this.paginator.page,
      this.sort.sortChange
    ];
    this.loadReporte();
    return merge(...dataMutations).pipe(map(() => {
      return this.getPagedData(this.getSortedData([...this.data]));
    }));
  }

  /**
   *  Called when the table is being destroyed. Use this function, to clean up
   * any open connections or free any held resources that were set up during connect.
   */
  disconnect() {}

  /**
   * Paginate the data (client-side). If you're using server-side pagination,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getPagedData(data: ProductosItem[]) {
    const startIndex = this.paginator.pageIndex * this.paginator.pageSize;
    return data.splice(startIndex, this.paginator.pageSize);
  }

  /**
   * Sort the data (client-side). If you're using server-side sorting,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getSortedData(data: ProductosItem[]) {
    if (!this.sort.active || this.sort.direction === '') {
      return data;
    }
/*
clase: string;
  producto: string;
  cantidad: number;
  peso: number;
  unidad: string;
*/
    return data.sort((a, b) => {
      const isAsc = this.sort.direction === 'asc';
      switch (this.sort.active) {
        case 'clase': return compare(a.clase, b.clase, isAsc);
        case 'producto': return compare(+a.producto, +b.producto, isAsc);
        case 'cantidad': return compare(+a.cantidad, +b.cantidad, isAsc);
        case 'peso': return compare(+a.peso, +b.peso, isAsc);
        case 'unidad': return compare(+a.unidad, +b.unidad, isAsc);
        default: return 0;
      }
    });
  }


  private loadReporte(): void{
    this.bodegaService.getReporteProductos()
    .subscribe(res => {
      this.data = res;
    });
  }
}

/** Simple sort comparator for example ID/Name columns (for client-side sorting). */
function compare(a: string | number, b: string | number, isAsc: boolean) {
  return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
}
