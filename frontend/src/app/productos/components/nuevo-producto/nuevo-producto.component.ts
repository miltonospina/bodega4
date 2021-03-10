import { OnInit } from '@angular/core';
import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { Clase } from 'src/app/core/models/clase.model';
import { Producto } from 'src/app/core/models/producto.model';
import { ProductosService } from 'src/app/core/services/productos.service';

@Component({
  selector: 'app-nuevo-producto',
  templateUrl: './nuevo-producto.component.html',
  styleUrls: ['./nuevo-producto.component.css']
})
export class NuevoProductoComponent implements OnInit {
  nuevoProductoForm = this.fb.group({
    codigo: [null, Validators.required],
    nombre: [null, Validators.required],
    clase: [null, Validators.required],
    peso: [null, Validators.required],
    pesoUnd: [null, Validators.required],
    unidad: [null, Validators.required],
    bultos: [null, Validators.required]
  });

  clases: Clase[];
  producto: Producto;

  constructor(
    private fb: FormBuilder,
    private productosService: ProductosService,
    public snackBar: MatSnackBar,
    private router: Router) { }



  ngOnInit(): void {
    this.fetchClases();

  }

  onSubmit(): void {
    this.producto = {
      codigoProvidencia: this.nuevoProductoForm.get('codigo').value,
      nombre: this.nuevoProductoForm.get('nombre').value,
      peso: this.nuevoProductoForm.get('peso').value,
      pesoUnd: this.nuevoProductoForm.get('pesoUnd').value,
      unidad: this.nuevoProductoForm.get('unidad').value,
      bultos: this.nuevoProductoForm.get('bultos').value,
      claseId: this.nuevoProductoForm.get('clase').value
    };

    this.productosService.postProducto(this.producto).subscribe(rs => {
      if (rs.id) {
        this.router.navigate(['./productos']);
      }
      else {
        this.snackBar.open(rs, 'Ok', { duration: 3000 });
      }

    });
  }

  fetchClases(): void {
    this.productosService.getAllProductos()
      .subscribe(clases => {
        this.clases = clases;
      });
  }
}
