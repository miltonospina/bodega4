import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Ingreso } from 'src/app/core/models/ingreso';
import { Clase } from 'src/app/core/models/clase.model';
import { BodegaService } from 'src/app/core/services/bodega.service';
import { ProductosService } from 'src/app/core/services/productos.service';
import { Cliente } from '../../../core/models/cliente.model';
import { ClientesService } from '../../../core/services/clientes.service';

@Component({
  selector: 'app-ingreso',
  templateUrl: './ingreso.component.html',
  styleUrls: ['./ingreso.component.css']
})
export class IngresoComponent implements OnInit {

  clientes: Cliente[] = [];
  productos: Clase[] = [];
  clases: Clase[] = [];
  niveles: number[] = [];
  columnas: number[] = [];

  ingreso: Ingreso;
  ingresoForm: FormGroup;

  posibleMultiple: boolean;

  constructor(
    private fb: FormBuilder,
    private clientesService: ClientesService,
    private productosService: ProductosService,
    private bodegaService: BodegaService,
    public snackBar: MatSnackBar
  ) { }

  ngOnInit(): void {
    this.fetchClientes();
    this.fetchProductos();
    this.fetchLayout();
    this.ingresoForm = this.fb.group({
      nivel: [null, Validators.required],
      columna: [null, Validators.required],
      lote: [null, Validators.required],
      producto: [null, Validators.required],
      cliente: [null, Validators.required],
      bultos: [null, Validators.required],
      posicion: [null, [Validators.required, Validators.min(1)]],
      multiple: [false],
      cantidad: [1, [Validators.min(1)]],
    });
    this.onChanges();
  }

  onSubmit(): void {
    if (this.ingresoForm.get('multiple').value) {
      this.ingresoMultiple();
    }
    else {
      this.ingesoSencillo();
    }
  }

  fetchClientes(): void {
    this.clientesService.getAllClientes()
      .subscribe(clientes => {
        this.clientes = clientes;
      });
  }

  fetchProductos(): void {
    this.productosService.getAllProductos()
      .subscribe(productos => {
        this.productos = productos;
        this.clases = productos;
      });
  }

  fetchLayout(): void {
    this.bodegaService.getLayout()
      .subscribe(bodega => {
        this.niveles = bodega.niveles;
        this.columnas = bodega.columnas;
      });
  }

  onChanges(): void {
    this.ingresoForm.get('producto').valueChanges.subscribe(val => {
      this.ingresoForm.patchValue({ bultos: val.bultos });
    });

    this.ingresoForm.get('columna').valueChanges.subscribe(val => {
      this.fetchDisponibilidad(val, this.ingresoForm.get('nivel').value);
    });

    this.ingresoForm.get('nivel').valueChanges.subscribe(val => {
      this.fetchDisponibilidad(this.ingresoForm.get('columna').value, val);
    });

    this.ingresoForm.get('posicion').valueChanges.subscribe(val => {
      this.fetchDisponibilidad(this.ingresoForm.get('columna').value, this.ingresoForm.get('nivel').value);
      if (val === undefined || val <= 1) {
        this.ingresoForm.patchValue({ multiple: false });
        this.posibleMultiple = false;
      }
      else {
        this.posibleMultiple = true;
      }
    });

  }

  fetchDisponibilidad(col: number, niv: number): void {
    if (col != null && niv != null) {
      this.bodegaService.getDisponibilidad(col, niv)
        .subscribe(rs => {
          rs = rs.respuesta;
          if (typeof rs === 'string') {
            this.snackBar.open(
              rs,
              'Ok',
              { duration: 3000 }
            );
          }
          else {
            if (this.ingresoForm.get('posicion').value !== rs) {
              this.ingresoForm.patchValue({ posicion: rs });
            }
          }
        });
    }
  }

  ingesoSencillo(): void {
    this.bodegaService.ingresarEstibas({
      nivel: this.ingresoForm.get('nivel').value,
      columna: this.ingresoForm.get('columna').value,
      usuariosId: 16,
      paquetes: {
        lote: this.ingresoForm.get('lote').value,
        productoId: this.ingresoForm.get('producto').value.id,
        clienteId: this.ingresoForm.get('cliente').value.id,
        bultos: this.ingresoForm.get('bultos').value
      }
    })
      .subscribe(rs => {
        if (rs.id) {
          this.snackBar.open(
            `Se ingresó la estiba en la posición [${rs.columna}][${rs.nivel}][${rs.posicion}] fecha: ${rs.fecha}`,
            'Ok',
            { duration: 3000 }
          );
          this.ingresoForm.patchValue({ posicion: (rs.posicion - 1) });
        }
        else {
          this.snackBar.open(
            rs,
            'Ok',
            { duration: 3000 }
          );
        }
      });
  }


  ingresoMultiple(): void {
    this.bodegaService.ingresarEstibasMultiple({
      cantidad: this.ingresoForm.get('cantidad').value,
      ingreso: {
        nivel: this.ingresoForm.get('nivel').value,
        columna: this.ingresoForm.get('columna').value,
        usuariosId: 16,
        paquetes: {
          lote: this.ingresoForm.get('lote').value,
          productoId: this.ingresoForm.get('producto').value.id,
          clienteId: this.ingresoForm.get('cliente').value.id,
          bultos: this.ingresoForm.get('bultos').value
        }
      }
    })
      .subscribe(rs => {
        if (rs instanceof Array) {
          this.snackBar.open(
            `Se ingresaron ${rs.length} la estiba en la posición [${rs[0].columna}][${rs[0].nivel}][${rs[0].posicion}] fecha: ${rs[0].fecha}`,
            'Ok',
            { duration: 3000 }
          );
          this.ingresoForm.patchValue({ posicion: (rs[rs.length - 1].posicion - 1) });
          this.ingresoForm.patchValue({ cantidad: 1 });
        }
        else {
          this.snackBar.open(
            rs,
            'Ok',
            { duration: 3000 }
          );
        }
      });
  }

}
