import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { OrganizarComponent } from './components/organizar/organizar.component';

const routes: Routes = [
  {
    path: '',
    component: OrganizarComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class OrganizarRoutingModule { }
