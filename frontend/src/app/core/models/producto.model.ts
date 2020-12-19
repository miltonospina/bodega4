import { Clase } from './clase.model';

export interface Producto {
    id: number;
    nombre: string;
    pesoUnd: number;
    peso: number;
    unidad: string;
    clase: Clase;
}
