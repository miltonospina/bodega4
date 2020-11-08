import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ClientesService } from './services/clientes.service';
import { ProductosService } from './services/productos.service';


@NgModule({
  declarations: [],
  imports: [
    CommonModule,
  ],
  exports: [
    ClientesService,
    ProductosService,
  ]
})
export class CoreModule { }
