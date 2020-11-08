import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MenuComponent } from './components/menu/menu.component';
import { VisualComponent } from './components/visual/visual.component';
import { ProductosComponent } from './components/productos/productos.component';
import { InventarioComponent } from './components/inventario/inventario.component';
import { ReportesRoutingModule } from './reportes-routing.module';



@NgModule({
  declarations: [MenuComponent, VisualComponent, ProductosComponent, InventarioComponent],
  imports: [
    CommonModule,
    ReportesRoutingModule
  ]
})
export class ReportesModule { }
