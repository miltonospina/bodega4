import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { JwtHelperService } from '@auth0/angular-jwt';
import { Usuario } from '../models/usuario';
import jwt_decode from 'jwt-decode';

export const TOKEN_NAME = 'jwt_token';


@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private user: Usuario;
  private userData = new BehaviorSubject<Usuario>(null);
  userData$ = this.userData.asObservable();

  constructor(private http: HttpClient) { }

  getToken(): string {
    return localStorage.getItem(TOKEN_NAME);
  }

  setToken(token: string): void {
    localStorage.setItem(TOKEN_NAME, token);
    const data = this.getTokenData(token);
    this.user = {userName: data.sub, email: data.email, id: data.nameid };  
    const decodedToken = jwt_decode(token);
    this.userData.next(this.user);

    localStorage.setItem("id", data.nameid);
    localStorage.setItem("username", data.sub);
    localStorage.setItem("rol", decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']);
  }

  getData(): string[] {
    let data = [localStorage.getItem("username"), localStorage.getItem("rol"), localStorage.getItem("id")];
    return data;
  }

  deleteToken(): void{
    localStorage.removeItem(TOKEN_NAME);
    this.user = null;
  }

  getTokenExpirationDate(token: string): Date {
    const helper = new JwtHelperService();
    const expirationDate = helper.getTokenExpirationDate(token);
    return expirationDate;
  }

  getTokenData(token: string): any {
    const helper = new JwtHelperService();
    const data = helper.decodeToken(token);
    return data;
  }

  isTokenExpired(token?: string): boolean {
    if (!token) { token = this.getToken(); }
    if (!token) { return true; }

    const date = this.getTokenExpirationDate(token);
    if (date === undefined) { return false; }
    return !(date.valueOf() > new Date().valueOf());
  }

  registrarUsuario(email: string, password: string): Observable<any> {
    return this.http.post(`${environment.urlApi}Account/Register`, { email, password });
  }

  crearUsuario(email: string, password: string, rol: string): Promise<any> {
    var model = {
      email: email,
      username: email,
      password: password,
      role: rol
    }
    return this.http.post(`${environment.urlApi}Account/Register`, model).toPromise();
  }

  obtenerUsuarios(): Observable<any> {
    return this.http.get(`${environment.urlApi}Account/getUsers`);
  }

  eliminarUsuario(id: string): Promise<any> {
    return this.http.delete(`${environment.urlApi}Account/deletUser/${id}`).toPromise();
  }

  restaurarContrasena(id: string, password: string): Promise<any> {
    var model = {
      id:id,
      password: password
    };
    return this.http.post(`${environment.urlApi}Account/restaurarContrasena`, model).toPromise();
  }

  cambiarContrasena(password1 : string, password2: string, id: string): Promise<any>{
    var model = {
      id: id,
      oldPassword: password1,
      newPassword: password2
    }
    return this.http.post(`${environment.urlApi}Account/cambiarContrasena`, model).toPromise();
  }

  login(email: string, password: string): Promise<any> {
    return this.http
      .post(`${environment.urlApi}Account/Login`, { email, password })
      .toPromise()
      .then(res => res);
  }
}
