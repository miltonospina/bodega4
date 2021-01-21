import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { InventarioComponent } from './components/inventario/inventario.component';
import { MenuComponent } from './components/menu/menu.component';
import { ProductosComponent } from './components/productos/productos.component';
import { TunelesComponent } from './components/tuneles/tuneles.component';
import { VisualComponent } from './components/visual/visual.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'menu',
    pathMatch: 'full'
  },
  {
    path: 'menu',
    component: MenuComponent
  },
  {
    path: 'visual',
    component: VisualComponent
  },
  {
    path: 'inventario',
    component: InventarioComponent
  },
  {
    path: 'productos',
    component: ProductosComponent
  },
  {
    path: 'tuneles',
    component: TunelesComponent
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportesRoutingModule { }
