import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/core/services/auth.service'

@Component({
  selector: 'app-perfil',
  templateUrl: './perfil.component.html',
  styleUrls: ['./perfil.component.css']
})
export class PerfilComponent implements OnInit {

  username: string;

  constructor(
    private authService : AuthService
  ) { }

  ngOnInit(): void {
    this.username = this.authService.getUserName();
  }

}
