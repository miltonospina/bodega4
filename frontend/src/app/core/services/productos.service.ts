import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Producto } from '../models/producto.model';
import { Clase } from '../models/clase.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ProductosService {

  constructor(private http: HttpClient) { }

  getAllProductos(): Observable<Clase[]> {
    return this.http.get<Clase[]>(`${environment.urlApi}clases/productos`);
  }

  getProducto(id: string): Observable<Producto> {
    return this.http.get<Producto>(`${environment.urlApi}clientes/${id}`);
  }
}
