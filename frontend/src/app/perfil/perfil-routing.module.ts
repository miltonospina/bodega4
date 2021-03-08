import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { PerfilComponent } from './components/perfil/perfil.component';
import { CambioContrasenaComponent } from './components/cambioContrasena/cambio-contrasena.component'

const routes: Routes = [
  {
    path: '',
    component: PerfilComponent
  },
  {
    path: 'cambioContrasena',
    component: CambioContrasenaComponent
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PerfilRoutingModule { }
