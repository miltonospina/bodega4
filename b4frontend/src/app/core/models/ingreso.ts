import { Paquete } from './paquete';

export interface Ingreso {
    nivel: number;
    columna: number;
    usuarioId: number;
    paquetes: Paquete;
}
