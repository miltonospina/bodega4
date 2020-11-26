import { Cliente } from './cliente.model';
import { Producto } from './producto.model';

export interface Paquete {
    lote: number;
    producto: Producto;
    cliente: Cliente;
    bultos: number;

    productosId: number;
    clienteId: number;
}
