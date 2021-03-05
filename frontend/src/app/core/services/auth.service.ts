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
  private username : string;
  private rol : string;
  userData$ = this.userData.asObservable();

  constructor(private http: HttpClient) { }

  getToken(): string {
    return localStorage.getItem(TOKEN_NAME);
  }

  setToken(token: string): void {
    localStorage.setItem(TOKEN_NAME, token);
    const data = this.getTokenData(token);
    this.user = {userName: data.sub, email: data.email, id: data.nameid };
    this.username = data.sub;

    const decodedToken = jwt_decode(token);
    this.rol = decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']

    this.userData.next(this.user);


    console.log(this.user);

  }

  getUserName(): string {
    console.log(this.rol)
    return this.username;
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


  login(email: string, password: string): Promise<any> {
    return this.http
      .post(`${environment.urlApi}Account/Login`, { email, password })
      .toPromise()
      .then(res => res);
  }
}
