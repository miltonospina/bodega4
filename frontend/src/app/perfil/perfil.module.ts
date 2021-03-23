import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PerfilRoutingModule} from './perfil-routing.module';
import { PerfilComponent } from './components/perfil/perfil.component';
import {MatCardModule} from '@angular/material/card';
import {MatButtonModule} from '@angular/material/button';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatIconModule} from '@angular/material/icon';
import {MatInputModule} from '@angular/material/input';
import {MatDialogModule} from '@angular/material/dialog';
import {CambioContrasenaDialog} from './components/perfil/perfil.component';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [PerfilComponent, CambioContrasenaDialog],
  imports: [
    CommonModule,
    PerfilRoutingModule,
    MatCardModule,
    MatButtonModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatDialogModule,
    FormsModule
  ]
})
export class PerfilModule { }