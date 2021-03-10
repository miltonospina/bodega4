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
      if(this.password1 === '' || this.password2 === '' || this.password3 === '') {
        Swal.fire(
          'Por favor llenar todos los campos',
          '',
          'warning'
        )
      }else {
        if(this.password2 === this.password3) {
          if(this.validarClave(this.password2)) {
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
                  'No se pudo actualizar la contraseña',
                  '',
                  'error'
                )
              });
          }else{
            Swal.fire(
              'La contraseña es muy débil',
              'Recuerde incluir mínimo 8 caracteres, números, letras mayúsculas y minísculas además de un caracter especial',
              'warning'
            )
          }
        }else {
          Swal.fire(
            'Las contraseñas no coinciden',
            '',
            'warning'
          )
        }
      }
      
    });
  }

  validarClave(password: string) {
    if(password.length >= 8) {		
      var mayuscula = false;
      var minuscula = false;
      var numero = false;
      var caracter_raro = false;
      
      for(var i = 0;i<password.length;i++) {
        if(password.charCodeAt(i) >= 65 && password.charCodeAt(i) <= 90) {
          mayuscula = true;
        } else if(password.charCodeAt(i) >= 97 && password.charCodeAt(i) <= 122) {
          minuscula = true;
        } else if(password.charCodeAt(i) >= 48 && password.charCodeAt(i) <= 57) {
          numero = true;
        } else {
          caracter_raro = true;
        }
      } if(mayuscula == true && minuscula == true && caracter_raro == true && numero == true) {
        return true;
      }
    }
    return false;
  }

}
@Component({
  selector: 'cambiarContrasenaDialog',
  templateUrl: 'cambiarContrasenaDialog.html',
})
export class CambioContrasenaDialog {
  constructor(
    public dialogRef: MatDialogRef<CambioContrasenaDialog>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {}

    onNoClick(): void {
      this.dialogRef.close();
    }
}
