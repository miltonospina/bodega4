import { Clase } from './clase.model';

export interface Producto {
    id?: number;
    codigoProvidencia?: string;
    nombre: string;
    pesoUnd: number;
    peso: number;
    unidad: string;
    clase?: Clase;
    bultos: number;
    claseId: number;
}
