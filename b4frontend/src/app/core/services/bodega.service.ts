import { Injectable } from '@angular/core';
import { Bodega } from '../models/bodega';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class BodegaService {

  constructor(private http: HttpClient) { }

  getLayout(): Observable<Bodega> {
    return this.http.get<Bodega>(`${environment.urlApi}bodega`);
  }

  getDisponibilidad(col: number, niv: number): Observable<any> {
    return this.http.get<Bodega>(`${environment.urlApi}bodega/${col}/${niv}`);
  }

  ingresarEstibas(obj): Observable<any>{
    return this.http.post<Bodega>(`${environment.urlApi}estibas`, obj);
  }

  salidaEstibas(col: number, niv: number): Observable<any>{
    return this.http.delete(`${environment.urlApi}estibas/${col}/${niv}`);
  }

  salidaParcialEstibas(col: number, niv: number, paquete: object): Observable<any>{
    return this.http.put(`${environment.urlApi}estibas/${col}/${niv}`, paquete);
  }

  getPrimero(col: number, niv: number): Observable<any> {
    return this.http.get(`${environment.urlApi}estibas/${col}/${niv}`);
  }

  getVisual(niv: number): Observable<any> {
    return this.http.get(`${environment.urlApi}reportes/visual/${niv}`);
  }
}
