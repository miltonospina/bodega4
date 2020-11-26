import { Cliente } from '../models/cliente.model';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ClientesService {

  constructor(private http: HttpClient) { }

  getAllClientes(): Observable<Cliente[]> {
    return this.http.get<Cliente[]>(`${environment.urlApi}clientes`);
  }

  getCliente(id: string): Observable<Cliente> {
    return this.http.get<Cliente>(`${environment.urlApi}clientes/${id}`);
  }
}
