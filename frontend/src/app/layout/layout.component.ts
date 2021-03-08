import { Component, OnInit } from '@angular/core';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Observable } from 'rxjs';
import { map, shareReplay } from 'rxjs/operators';
import { AuthService } from '../core/services/auth.service';
import { Router } from '@angular/router';
import { Usuario } from '../core/models/usuario';

@Component({
  selector: 'app-layout',
  templateUrl: './layout.component.html',
  styleUrls: ['./layout.component.css']
})
export class LayoutComponent implements OnInit{
  usuarioActual: Usuario;
  username: string;
  rol: string;

  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset)
    .pipe(
      map(result => result.matches),
      shareReplay()
  );

  constructor(
    private breakpointObserver: BreakpointObserver,
    private authService: AuthService,
    private router: Router) {
      this.authService.userData$.subscribe(usuario => this.usuarioActual = usuario);
  }

  ngOnInit(): void {
    this.username = this.authService.getData()[0];
    this.rol = this.authService.getData()[1];
  }

  salir(): void {
    this.authService.deleteToken();
    this.router.navigate(['/login']);
  }

}
