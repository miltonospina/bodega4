import { Producto } from './producto.model';

export interface Clase {
    nombre: string;
    id: number;
    nombrecss: string;
    productos: Producto[];
}
