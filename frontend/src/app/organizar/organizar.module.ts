import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OrganizarComponent } from './components/organizar/organizar.component';
import { DialogoOrganizarComponent } from './components/dialogo-organizar/dialogo-organizar.component';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatSortModule } from '@angular/material/sort';
import { OrganizarRoutingModule } from './organizar-routing.module';
import { MatIconModule } from '@angular/material/icon';
import { MatDialogModule } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatSnackBarModule } from '@angular/material/snack-bar';




@NgModule({
  declarations: [OrganizarComponent, DialogoOrganizarComponent],
  imports: [
    CommonModule,
    MatTableModule,
    MatPaginatorModule,
    MatSortModule,
    MatButtonModule,
    MatSnackBarModule,
    OrganizarRoutingModule,
    MatIconModule,
    MatDialogModule
  ]
})
export class OrganizarModule { }
