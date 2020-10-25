using AutoMapper;
using b4backend.Models;

namespace b4backend.DTOs
{
    public static class AutoMapperConfiguration
    {
        public static void Configure()
        {
            var config = new MapperConfiguration(
                cfg =>
                {
                    cfg.CreateMap<Clases, ClasesDTO>()
                        .ForMember(x => x.Productos, o => o.Ignore())
                        .ReverseMap();

                    cfg.CreateMap<Clientes, ClientesDTO>()
                       .ForMember(x => x.Paquetes, o => o.Ignore())
                        .ReverseMap();

                    cfg.CreateMap<Movimientos, MovimientosDTO>();
                    
                    cfg.CreateMap<Paquetes, PaquetesDTO>()
                        .ForMember(x => x.Movimientos, o => o.Ignore())
                        .ReverseMap();

                    cfg.CreateMap<Productos, ProductosDTO>()
                        .ForMember(x => x.Paquetes, o => o.Ignore())
                        .ReverseMap();
                    
                    cfg.CreateMap<Usuarios, UsuariosDTO>()
                        .ForMember(x => x.Movimientos, o => o.Ignore())
                        .ReverseMap();
                    
                    cfg.CreateMap<Opciones, OpcionesDTO>();
                }
                );
        }
    }
}

