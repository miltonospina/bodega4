import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IngresoComponent } from './components/ingreso/ingreso.component';
import { IngresoRoutingModule } from './ingreso-routing.module';

import { ReactiveFormsModule } from '@angular/forms';
import { MaterialModule} from '../material/material.module';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatSliderModule } from '@angular/material/slider';
import { MatCheckboxModule } from '@angular/material/checkbox';


@NgModule({
  declarations: [IngresoComponent],
  imports: [
    CommonModule,
    IngresoRoutingModule,
    MaterialModule,
    ReactiveFormsModule,
    MatSnackBarModule,
    MatSliderModule,
    MatCheckboxModule
  ]
})
export class IngresoModule { }
