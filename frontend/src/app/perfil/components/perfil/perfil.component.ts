import { Component, OnInit, Inject} from '@angular/core';
import { AuthService } from 'src/app/core/services/auth.service'
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import Swal from 'sweetalert2';
export interface DialogData {
  hide1 : boolean, hide2 : boolean, hide3 : boolean,
  password1 : string, password2 : string, password3: string
}

@Component({
  selector: 'app-perfil',
  templateUrl: './perfil.component.html',
  styleUrls: ['./perfil.component.css']
})
export class PerfilComponent implements OnInit {

  username: string;
  rol: string;
  id : string;
  password1: string; password2: string; password3: string

  constructor(
    private authService : AuthService,
    public dialog: MatDialog
  ) { }

  ngOnInit(): void {
    this.username = this.authService.getData()[0];
    this.rol = this.authService.getData()[1];
    this.id = this.authService.getData()[2];
  }

  openDialog() {
    const dialogRef = this.dialog.open(CambioContrasenaDialog, {
      width: '20%',
      height: '330px',
      data: {
        hide1 : true, hide2 : true, hide3 : true,
        password1 : '', password2 : '', password3: ''
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      this.password1 = result[0];
      this.password2 = result[1];
      this.password3 = result[2];
      if(this.password2 === this.password3) {
        this.authService.cambiarContrasena(this.password1, this.password2, this.id).then(
          function () { 
            Swal.fire(
              'Contraseña actualizada',
              '',
              'success'
            )
          }, 
          function () {
            Swal.fire(
              'Error',
              'No se pudo actualizar la contraseña',
              'error'
            )
          });
      }else {
        Swal.fire(
          'Error',
          'Las contraseñas no coinciden',
          'error'
        )
      }
    });
  }

}
@Component({
  selector: 'dialog-elements-example-dialog',
  templateUrl: 'dialog-data-example-dialog.html',
})
export class CambioContrasenaDialog {
  constructor(
    public dialogRef: MatDialogRef<CambioContrasenaDialog>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {}

    onNoClick(): void {
      this.dialogRef.close();
    }
}
