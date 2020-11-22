import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { BodegaService } from 'src/app/core/services/bodega.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-salida',
  templateUrl: './salida.component.html',
  styleUrls: ['./salida.component.css']
})
export class SalidaComponent implements OnInit {

  salidaForm: FormGroup;
  niveles: number[] = [];
  columnas: number[] = [];
  posicionPropuesta: object = {};
  oldvalue: number;

  constructor(
    private fb: FormBuilder,
    private bodegaService: BodegaService,
    public snackBar: MatSnackBar) { }

  ngOnInit(): void {

    this.fetchLayout();

    this.salidaForm = this.fb.group({
      nivel: [null, Validators.required],
      columna: [null, Validators.required],
      movimiento: [null, Validators.required],
      posicion: [null, Validators.required],
      producto: [null, Validators.required],
      cliente: [null, Validators.required],
      lote: [null, Validators.required],
      bultos: [null, Validators.min(1)],
      completa: [true]
    });
    this.onChanges();
  }

  fetchLayout(): void {
    this.bodegaService.getLayout()
      .subscribe(bodega => {
        this.niveles = bodega.niveles;
        this.columnas = bodega.columnas;
      });
  }

  onChanges(): void {

    this.salidaForm.get('columna').valueChanges.subscribe(val => {
      this.fetchPrimero(val, this.salidaForm.get('nivel').value);
    });

    this.salidaForm.get('nivel').valueChanges.subscribe(val => {
      this.fetchPrimero(this.salidaForm.get('columna').value, val);
    });

    this.salidaForm.get('completa').valueChanges.subscribe(val => {
      this.salidaForm.patchValue({
        bultos: this.oldvalue
      });
    });
  }

  fetchPrimero(col: number, niv: number): void {
    if (col != null && niv != null) {
      this.bodegaService.getPrimero(col, niv)
        .subscribe(rs => {
          rs = rs.respuesta;
          if (rs === null) {
            this.salidaForm.patchValue({ movimiento: null });
            this.snackBar.open(
              'No hay ningún contenido en la posición seleccionada',
              'Ok',
              { duration: 3000 }
            );
          }
          else {
            if (this.salidaForm.get('movimiento').value !== rs.paquete.id) {
              this.oldvalue = rs.paquete.bultos;
              this.salidaForm.patchValue({
                movimiento: rs.paquete.id,
                posicion: rs.posicion,
                producto: rs.paquete.producto.nombre,
                cliente: rs.paquete.cliente.nombre,
                lote: rs.paquete.lote,
                bultos: rs.paquete.bultos
              });
            }
          }
        });
    }
  }

  onSubmit(): void {
    if (this.salidaForm.get('completa').value) {
      this.salidaCompleta();
    }
    else {
      this.salidaParcial();
    }
  }


  salidaCompleta(): void {
    this.bodegaService.salidaEstibas(this.salidaForm.get('nivel').value, this.salidaForm.get('columna').value)
      .subscribe(rs => {
        if (rs.id) {
          this.snackBar.open(
            `Se registró la salida de la estiba en la posición [${rs.columna}][${rs.nivel}][${rs.posicion}] fecha: ${rs.fecha}`,
            'Ok',
            { duration: 3000 }
          );
          this.fetchPrimero(this.salidaForm.get('columna').value, this.salidaForm.get('nivel').value);
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


  salidaParcial(): void {
    this.bodegaService.salidaParcialEstibas(
      this.salidaForm.get('nivel').value,
      this.salidaForm.get('columna').value,
      {
        usuariosId: 16,
        paquetes: {
          bultos: this.salidaForm.get('bultos').value
        }
      })
      .subscribe(rs => {
        if (rs.id) {
          this.snackBar.open(
            `Se registró la salida parcial de la estiba en la posición [${rs.columna}][${rs.nivel}][${rs.posicion}] fecha: ${rs.fecha}`,
            'Ok',
            { duration: 3000 }
          );
          this.fetchPrimero(this.salidaForm.get('columna').value, this.salidaForm.get('nivel').value);
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


