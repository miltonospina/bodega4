import { OnInit } from '@angular/core';
import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { Clase } from 'src/app/core/models/clase.model';
import { Producto } from 'src/app/core/models/producto.model';
import { ProductosService } from 'src/app/core/services/productos.service';

@Component({
  selector: 'app-editar-producto',
  templateUrl: './editar-producto.component.html',
  styleUrls: ['./editar-producto.component.css']
})
export class EditarProductoComponent implements OnInit {
  editarProductoForm = this.fb.group({
    codigoProvidencia: [null, Validators.required],
    nombre: [null, Validators.required],
    clase: [null, Validators.required],
    peso: [null, Validators.required],
    pesoUnd: [null, Validators.required],
    unidad: [null, Validators.required],
    bultos: [null, Validators.required]
  });

  clases: Clase[];
  id: number;
  producto: Producto;





  constructor(
    private fb: FormBuilder,
    private productosService: ProductosService,
    public snackBar: MatSnackBar,
    private router: Router,
    private activatedRoute: ActivatedRoute) { }



  ngOnInit(): void {
    this.fetchClases();
    this.activatedRoute.params.subscribe((params: Params) => {
      this.id = params.id;
      this.productosService.getProducto(this.id.toString()).subscribe(producto => {
        this.editarProductoForm.patchValue(producto);
        this.editarProductoForm.patchValue({clase: producto.claseId});
      });
    });

  }

  onSubmit(): void {
    this.producto = {
      codigoProvidencia: this.editarProductoForm.get('codigoProvidencia').value,
      nombre: this.editarProductoForm.get('nombre').value,
      peso: this.editarProductoForm.get('peso').value,
      pesoUnd: this.editarProductoForm.get('pesoUnd').value,
      unidad: this.editarProductoForm.get('unidad').value,
      bultos: this.editarProductoForm.get('bultos').value,
      claseId: this.editarProductoForm.get('clase').value,
      id: this.id
    };

    this.productosService.putProducto(this.producto).subscribe(rs => {
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
