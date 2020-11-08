import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IngresoComponent } from './components/ingreso/ingreso.component';
import { IngresoRoutingModule } from './ingreso-routing.module';



@NgModule({
  declarations: [IngresoComponent],
  imports: [
    CommonModule,
    IngresoRoutingModule
  ]
})
export class IngresoModule { }
