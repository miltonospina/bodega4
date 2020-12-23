import { DataSource } from '@angular/cdk/collections';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { map } from 'rxjs/operators';
import { Observable, of as observableOf, merge } from 'rxjs';
import { Producto } from 'src/app/core/models/producto.model';
import { ProductosService } from 'src/app/core/services/productos.service';

/**
 * Data source for the ListaProductos view. This class should
 * encapsulate all logic for fetching and manipulating the displayed data
 * (including sorting, pagination, and filtering).
 */
export class ListaProductosDataSource extends DataSource<Producto> {
  data: Producto[] = [];
  paginator: MatPaginator;
  sort: MatSort;

  constructor(private productosService: ProductosService) {
    super();
  }

  /**
   * Connect this data source to the table. The table will only update when
   * the returned stream emits new items.
   * @returns A stream of the items to be rendered.
   */
  connect(): Observable<Producto[]> {
    const dataMutations = [
      this.productosService.getProductos(),
      this.data,
      this.paginator.page,
      this.sort.sortChange
    ];
    this.loadListado();
    return merge(...dataMutations).pipe(map(() => {
      return this.getPagedData(this.getSortedData([...this.data]));
    }));
  }

  /**
   *  Called when the table is being destroyed. Use this function, to clean up
   * any open connections or free any held resources that were set up during connect.
   */
  disconnect(): void { }

  /**
   * Paginate the data (client-side). If you're using server-side pagination,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getPagedData(data: Producto[]): Producto[] {
    const startIndex = this.paginator.pageIndex * this.paginator.pageSize;
    return data.splice(startIndex, this.paginator.pageSize);
  }

  /**
   * Sort the data (client-side). If you're using server-side sorting,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getSortedData(data: Producto[]): Producto[] {
    if (!this.sort.active || this.sort.direction === '') {
      return data;
    }

    return data.sort((a, b) => {
      const isAsc = this.sort.direction === 'asc';
      switch (this.sort.active) {
        case 'id': return compare(+a.id, +b.id, isAsc);
        case 'nombre': return compare(+a.nombre, +b.nombre, isAsc);
        case 'pesoUnd': return compare(+a.pesoUnd, +b.pesoUnd, isAsc);
        case 'peso': return compare(+a.peso, +b.peso, isAsc);
        case 'unidad': return compare(+a.unidad, +b.unidad, isAsc);
        case 'clase': return compare(+a.clase.nombre, +b.clase.nombre, isAsc);
        default: return 0;
      }
    });
  }

  loadListado(): void {
    this.productosService.getProductos()
      .subscribe(res => {
        this.data = res;
      });
  }
}


/** Simple sort comparator for example ID/Name columns (for client-side sorting). */
function compare(a: string | number, b: string | number, isAsc: boolean): number {
  return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
}
