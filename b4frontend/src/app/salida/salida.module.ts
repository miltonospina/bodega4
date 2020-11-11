import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SalidaComponent } from './components/salida/salida.component';
import { SalidaRoutingModule } from './salida-routing.module';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatRadioModule } from '@angular/material/radio';
import { MatCardModule } from '@angular/material/card';
import { ReactiveFormsModule } from '@angular/forms';



@NgModule({
  declarations: [SalidaComponent],
  imports: [
    CommonModule,
    SalidaRoutingModule,
    MatInputModule,
    MatButtonModule,
    MatSelectModule,
    MatRadioModule,
    MatCardModule,
    ReactiveFormsModule
  ]
})
export class SalidaModule { }
