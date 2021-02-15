import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuard } from './auth.guard';
import { LayoutComponent } from './layout/layout.component';
import { LoginComponent } from './login/login/login.component';
import { PageNotFoundComponent } from './shared/components/page-not-found/page-not-found.component';

const routes: Routes = [
  {
    path: '',
    component: LayoutComponent,
    children: [
      {
        path: 'ingreso',
        loadChildren: () => import('./ingreso/ingreso.module').then(m => m.IngresoModule)
      },
      {
        path: 'salida',
        loadChildren: () => import('./salida/salida.module').then(m => m.SalidaModule)
      },
      {
        path: 'reportes',
        loadChildren: () => import('./reportes/reportes.module').then(m => m.ReportesModule)
      },
      {
        path: 'productos',
        loadChildren: () => import('./productos/productos.module').then(m => m.ProductosModule)
      },
      {
        path: '',
        redirectTo: 'ingreso',
        pathMatch: 'full',
      }
    ],
    canActivate: [AuthGuard]
  },
  {
    path: 'login',
    component: LoginComponent
  },
  {
    path: '**',
    component: PageNotFoundComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { relativeLinkResolution: 'legacy' })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
