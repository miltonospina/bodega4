import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { JwtHelperService } from '@auth0/angular-jwt';

export const TOKEN_NAME = 'jwt_token';


@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient) { }

  getToken(): string {
    return localStorage.getItem(TOKEN_NAME);
  }

  setToken(token: string): void {
    localStorage.setItem(TOKEN_NAME, token);
  }

  deleteToken(): void{
    localStorage.removeItem(TOKEN_NAME);
  }

  getTokenExpirationDate(token: string): Date {
    const helper = new JwtHelperService();
    const expirationDate = helper.getTokenExpirationDate(token);
    return expirationDate;
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
