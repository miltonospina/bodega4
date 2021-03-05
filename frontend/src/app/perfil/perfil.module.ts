import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PerfilRoutingModule} from './perfil-routing.module';
import { PerfilComponent } from './components/perfil/perfil.component';
import {MatCardModule} from '@angular/material/card';
import {MatButtonModule} from '@angular/material/button';

@NgModule({
  declarations: [PerfilComponent],
  imports: [
    CommonModule,
    PerfilRoutingModule,
    MatCardModule,
    MatButtonModule
  ]
})
export class PerfilModule { }