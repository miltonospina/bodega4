import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SalidaComponent } from './components/salida/salida.component';
import { SalidaRoutingModule } from './salida-routing.module';



@NgModule({
  declarations: [SalidaComponent],
  imports: [
    CommonModule,
    SalidaRoutingModule
  ]
})
export class SalidaModule { }
