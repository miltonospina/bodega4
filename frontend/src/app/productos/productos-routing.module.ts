import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { EditarProductoComponent } from './components/editar-producto/editar-producto.component';
import { ListaProductosComponent } from './components/lista-productos/lista-productos.component';
import { NuevoProductoComponent } from './components/nuevo-producto/nuevo-producto.component';

const routes: Routes = [
  {
    path: '',
    component: ListaProductosComponent
  },
  {
    path: 'nuevo',
    component: NuevoProductoComponent
  },
  {
    path: 'editar/:id',
    component: EditarProductoComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProductosRoutingModule { }
