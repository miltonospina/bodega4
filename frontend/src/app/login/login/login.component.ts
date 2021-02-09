import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/core/services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  @Input() error: string | null;
  @Output() submitEM = new EventEmitter();

  form: FormGroup = new FormGroup({
    email: new FormControl(''),
    password: new FormControl(''),
  });

  constructor(
    private authService: AuthService,
    private router: Router) { }

  ngOnInit(): void {
  }

  submit(): any {
    if (this.form.valid) {
      this.authService.login(this.form.value.email, this.form.value.password)
      .then(rs => {
        this.authService.setToken(rs.token);
        this.router.navigate(['/']);
      })
      .catch(err => {
        console.log(err);
        this.error = err.error.mensaje;
      });
    }
  }

}
