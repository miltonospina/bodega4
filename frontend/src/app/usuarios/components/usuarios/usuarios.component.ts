import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/core/services/auth.service';
import { MatTableDataSource } from '@angular/material/table';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-usuarios',
  templateUrl: './usuarios.component.html',
  styleUrls: ['./usuarios.component.css']
})
export class UsuariosComponent implements OnInit {

  listData : MatTableDataSource<any>;
  displayedColumns: string[] = ['email', 'role', 'actions'];
  searchKey: string;

  constructor(
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.authService.obtenerUsuarios().subscribe(
      (res) => {
        this.listData = new MatTableDataSource(res);
      });
  }

  onSearchClear() {
    this.searchKey = "";
    this.applyFilter();
  }

  applyFilter() {
    this.listData.filter = this.searchKey.trim().toLowerCase();
  }

  async addUser(){
    var email, rol, password, confirmPassword = '';
    const { value: formValues } = await Swal.fire({
      title: 'Registrar usuario',
      html:
        '<input type="email "id="email" class="swal2-input" placeholder="✉ Escriba el email" required>' +
        '<select class="swal2-input" name="rol" id="rol">' +
          '<option value="" disabled selected>Escoja el rol del usuario</option>' +
          '<option value="Administrador">Administrador</option>' + 
          '<option value="Operador">Operador</option>' +
        '</select>' +
        '<input type="password" id="password" class="swal2-input" placeholder="🗝 Escriba la contraseña" required>' +
        '<input type="password" id="confirmPassword" class="swal2-input" placeholder="🗝 Confirme la contraseña" required>',
      focusConfirm: false,
      preConfirm: () => {
        return [
          email = (<HTMLInputElement>document.getElementById('email')).value,
          rol = (<HTMLInputElement>document.getElementById('rol')).value,
          password = (<HTMLInputElement>document.getElementById('password')).value,
          confirmPassword = (<HTMLInputElement>document.getElementById('confirmPassword')).value
        ]
      }
    })
      
    if (formValues) {
      if(email == '' || password == '' || confirmPassword == '') {
        Swal.fire(
          'Por favor complete todo los campos',
          '',
          'warning'
        )
      }else if(!this.validateEmail(email)) {
        Swal.fire(
          'Email inválido',
          '',
          'error'
        )
      }else if(password != confirmPassword) {
        Swal.fire(
          'Las contraseñas no coinciden',
          '',
          'error'
        )
      }else if(this.validarClave(password)) {
        this.authService.crearUsuario(email, password, rol).then(
          function() {
            Swal.fire(
              'Usuario registrado satisfactoriamente',
              '',
              'success'
            )
          },
          function () {
            Swal.fire(
              'No se pudo registrar el usuario',
              '',
              'error'
            )
          }
        )
        
      }else {
        Swal.fire(
          'La contraseña es muy débil',
          'Recuerde incluir mínimo 8 caracteres, números, letras mayúsculas y minísculas además de un caracter especial',
          'warning'
        )
      }
    }
    this.ngOnInit();
  }

  validateEmail(email: string) {
    const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
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
