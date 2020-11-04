USE [bodega4]
GO
/****** Object:  Table [bodega4].[clases]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[clases](
	[Id] [int] IDENTITY(5,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[nombrecss] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_clases_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bodega4].[clientes]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[clientes](
	[Id] [int] IDENTITY(65,1) NOT NULL,
	[nombre] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_clientes_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bodega4].[movimientos]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[movimientos](
	[Id] [int] IDENTITY(1129571,1) NOT NULL,
	[fecha] [datetime2](3) NOT NULL,
	[sentido] [int] NOT NULL,
	[nivel] [int] NOT NULL,
	[columna] [int] NOT NULL,
	[posicion] [int] NOT NULL,
	[paquetesId] [int] NOT NULL,
	[usuariosId] [int] NULL,
 CONSTRAINT [PK_movimientos_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bodega4].[opciones]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[opciones](
	[Id] [int] IDENTITY(2,1) NOT NULL,
	[nombre] [varchar](20) NOT NULL,
	[valor] [varchar](191) NOT NULL,
 CONSTRAINT [PK_opciones_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bodega4].[paquetes]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[paquetes](
	[Id] [int] IDENTITY(336234,1) NOT NULL,
	[lote] [nvarchar](30) NOT NULL,
	[productoId] [int] NOT NULL,
	[clienteId] [int] NOT NULL,
	[bultos] [int] NULL,
 CONSTRAINT [PK_bodega_paquetes_codigo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bodega4].[productos]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[productos](
	[Id] [int] IDENTITY(33789,1) NOT NULL,
	[claseId] [int] NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[peso_und] [real] NULL,
	[peso] [real] NULL,
	[unidad] [nvarchar](10) NULL,
	[bultos] [int] NULL,
 CONSTRAINT [PK_productos_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bodega4].[usuarios]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bodega4].[usuarios](
	[Id] [int] IDENTITY(20,1) NOT NULL,
	[username] [varchar](20) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[rol] [varchar](30) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[fecharegistro] [date] NOT NULL,
	[identificacion] [varchar](30) NOT NULL,
	[correo] [varchar](50) NOT NULL,
	[telefono] [varchar](30) NOT NULL,
 CONSTRAINT [PK_usuarios_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [bodega4].[v_paquetes_actuales]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bodega4].[v_paquetes_actuales]
AS
SELECT        paquetesId, movimientosId
FROM            (SELECT        paquetesId, SUM(sentido) AS _sentido, MAX(Id) AS movimientosId
                          FROM            bodega4.movimientos
                          GROUP BY paquetesId) AS sq
WHERE        (_sentido > 0)
GO
/****** Object:  View [bodega4].[v_posiciones_actual]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bodega4].[v_posiciones_actual]
AS
SELECT        bodega4.movimientos.sentido, bodega4.movimientos.nivel, bodega4.movimientos.columna, bodega4.movimientos.posicion, bodega4.movimientos.paquetesId, bodega4.v_paquetes_actuales.movimientosId
FROM            bodega4.movimientos INNER JOIN
                         bodega4.v_paquetes_actuales ON bodega4.movimientos.Id = bodega4.v_paquetes_actuales.movimientosId
GO
/****** Object:  View [bodega4].[v_minimo_pos]    Script Date: 03/11/2020 19:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bodega4].[v_minimo_pos]
AS
SELECT        MIN(posicion) AS minimo, nivel, columna
FROM            dbo.v_posiciones_actual
GROUP BY nivel, columna
GO
SET IDENTITY_INSERT [bodega4].[clases] ON 
GO
INSERT [bodega4].[clases] ([Id], [nombre], [nombrecss]) VALUES (1, N'Azúcar Crudo', N'crudo')
GO
INSERT [bodega4].[clases] ([Id], [nombre], [nombrecss]) VALUES (2, N'Azúcar Blanco Especial', N'blancoespecial')
GO
INSERT [bodega4].[clases] ([Id], [nombre], [nombrecss]) VALUES (3, N'Azúcar Orgánica', N'organica')
GO
INSERT [bodega4].[clases] ([Id], [nombre], [nombrecss]) VALUES (4, N'Azúcar Blanco', N'blanco')
GO
INSERT [bodega4].[clases] ([Id], [nombre], [nombrecss]) VALUES (5, N'sample', N'samplecss')
GO
SET IDENTITY_INSERT [bodega4].[clases] OFF
GO
SET IDENTITY_INSERT [bodega4].[clientes] ON 
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (1, N'Postobon')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (2, N'Nal Chocolates Bogota')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (3, N'Nal Chocolates Rionegro')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (4, N'Nestlé')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (5, N'CocaCola')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (6, N'Aldor')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (7, N'JGB')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (8, N'Otras Industrias')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (9, N'Super de Alimentos')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (10, N'Dulces La Americana')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (11, N'Productos Ramo')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (12, N'Sucroal Blanco')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (13, N'Bavaria')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (14, N'Exportación')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (15, N'N/D')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (16, N'Casa Luker')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (17, N'Meals')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (18, N'Tradin')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (19, N'Atco HP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (20, N'Pronatec')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (21, N'B&M Rasanco')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (22, N'Cafetal')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (23, N'B&M Loiret')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (24, N'Filipinas')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (25, N'Man Sugar USA')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (26, N'Sucroal Conjuntas')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (27, N'Almacenes de Cadena')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (28, N'Atco LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (29, N'DML HP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (30, N'Casado')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (31, N'Argentimport')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (32, N'Multiple LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (33, N'Daltan LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (34, N'Ecuador LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (35, N'Pendiente HP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (36, N'Pendiente LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (37, N'Sucrocan')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (38, N'Interra')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (39, N'HP Mercado Nacional')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (40, N'Moist Interra')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (41, N'Pullman')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (42, N'Comercio')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (43, N'Nestlé La Rosa')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (44, N'Man Inc')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (45, N'DML LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (46, N'BYM Peach Tree')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (47, N'Aldor Conjuntas')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (48, N'IGS')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (49, N'Wholesome')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (50, N'B&M USA')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (51, N'Mercado Nacional')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (52, N'Parmalat')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (53, N'Libre LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (54, N'Kelloggs')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (55, N'Clientes HP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (56, N'Clientes LP')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (57, N'B&M Puerto Rico')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (58, N'Cuarentena')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (59, N'Ind Cacaotera')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (60, N'B&M Multiple')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (61, N'Sopex')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (62, N'Demerara')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (63, N'Tv Pan')
GO
INSERT [bodega4].[clientes] ([Id], [nombre]) VALUES (64, N'Man Canada')
GO
SET IDENTITY_INSERT [bodega4].[clientes] OFF
GO
SET IDENTITY_INSERT [bodega4].[movimientos] ON 
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129778, CAST(N'2020-10-31T11:38:36.8340000' AS DateTime2), 1, 1, 2, 47, 336362, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129779, CAST(N'2020-10-31T11:38:39.0090000' AS DateTime2), 1, 1, 2, 46, 336363, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129780, CAST(N'2020-10-31T11:38:40.9050000' AS DateTime2), 1, 1, 2, 45, 336364, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129781, CAST(N'2020-10-31T11:38:42.0750000' AS DateTime2), 1, 1, 2, 44, 336365, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129782, CAST(N'2020-10-31T11:38:43.4690000' AS DateTime2), 1, 1, 2, 43, 336366, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129783, CAST(N'2020-10-31T11:38:44.4600000' AS DateTime2), 1, 1, 2, 42, 336367, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129784, CAST(N'2020-10-31T11:38:45.3380000' AS DateTime2), 1, 1, 2, 41, 336368, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129785, CAST(N'2020-10-31T11:38:46.4830000' AS DateTime2), 1, 1, 2, 40, 336369, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129786, CAST(N'2020-10-31T11:38:47.3750000' AS DateTime2), 1, 1, 2, 39, 336370, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129787, CAST(N'2020-10-31T11:38:48.3710000' AS DateTime2), 1, 1, 2, 38, 336371, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129788, CAST(N'2020-10-31T11:38:49.3450000' AS DateTime2), 1, 1, 2, 37, 336372, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129789, CAST(N'2020-10-31T11:38:50.2670000' AS DateTime2), 1, 1, 2, 36, 336373, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129790, CAST(N'2020-10-31T11:38:51.7010000' AS DateTime2), 1, 1, 2, 35, 336374, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129791, CAST(N'2020-10-31T11:38:53.3300000' AS DateTime2), 1, 1, 2, 34, 336375, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129792, CAST(N'2020-10-31T11:38:55.0610000' AS DateTime2), 1, 1, 2, 33, 336376, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129793, CAST(N'2020-10-31T11:38:56.7050000' AS DateTime2), 1, 1, 2, 32, 336377, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129794, CAST(N'2020-10-31T11:38:57.7110000' AS DateTime2), 1, 1, 2, 31, 336378, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129795, CAST(N'2020-10-31T11:38:58.3840000' AS DateTime2), 1, 1, 2, 30, 336379, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129796, CAST(N'2020-10-31T11:38:58.9390000' AS DateTime2), 1, 1, 2, 29, 336380, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129797, CAST(N'2020-10-31T11:38:59.6320000' AS DateTime2), 1, 1, 2, 28, 336381, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129798, CAST(N'2020-10-31T11:39:00.2360000' AS DateTime2), 1, 1, 2, 27, 336382, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129799, CAST(N'2020-10-31T11:39:00.8230000' AS DateTime2), 1, 1, 2, 26, 336383, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129800, CAST(N'2020-10-31T11:39:01.5550000' AS DateTime2), 1, 1, 2, 25, 336384, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129801, CAST(N'2020-10-31T11:39:02.1020000' AS DateTime2), 1, 1, 2, 24, 336385, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129802, CAST(N'2020-10-31T11:39:02.7690000' AS DateTime2), 1, 1, 2, 23, 336386, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129803, CAST(N'2020-10-31T11:39:03.6440000' AS DateTime2), 1, 1, 2, 22, 336387, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129804, CAST(N'2020-10-31T11:39:03.9240000' AS DateTime2), 1, 1, 2, 21, 336388, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129805, CAST(N'2020-10-31T11:39:07.6860000' AS DateTime2), -1, 1, 2, 21, 336388, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129806, CAST(N'2020-10-31T11:39:08.8730000' AS DateTime2), -1, 1, 2, 22, 336387, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129807, CAST(N'2020-10-31T11:39:09.6110000' AS DateTime2), -1, 1, 2, 23, 336386, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129808, CAST(N'2020-10-31T11:39:10.3270000' AS DateTime2), -1, 1, 2, 24, 336385, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129809, CAST(N'2020-10-31T11:39:10.9790000' AS DateTime2), -1, 1, 2, 25, 336384, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129810, CAST(N'2020-10-31T11:39:11.8220000' AS DateTime2), -1, 1, 2, 26, 336383, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129811, CAST(N'2020-10-31T11:39:12.6600000' AS DateTime2), -1, 1, 2, 27, 336382, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129812, CAST(N'2020-10-31T11:39:13.3560000' AS DateTime2), -1, 1, 2, 28, 336381, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129813, CAST(N'2020-10-31T11:39:14.1070000' AS DateTime2), -1, 1, 2, 29, 336380, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129814, CAST(N'2020-10-31T11:39:14.9070000' AS DateTime2), -1, 1, 2, 30, 336379, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129815, CAST(N'2020-10-31T11:39:35.7520000' AS DateTime2), -1, 1, 2, 31, 336378, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129816, CAST(N'2020-10-31T11:39:36.8660000' AS DateTime2), -1, 1, 2, 32, 336377, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129817, CAST(N'2020-10-31T11:39:37.6150000' AS DateTime2), -1, 1, 2, 33, 336376, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129818, CAST(N'2020-10-31T11:39:38.3280000' AS DateTime2), -1, 1, 2, 34, 336375, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129819, CAST(N'2020-10-31T11:39:39.0550000' AS DateTime2), -1, 1, 2, 35, 336374, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129820, CAST(N'2020-10-31T11:39:39.7960000' AS DateTime2), -1, 1, 2, 36, 336373, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129821, CAST(N'2020-10-31T11:39:40.4390000' AS DateTime2), -1, 1, 2, 37, 336372, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129822, CAST(N'2020-10-31T11:39:41.2250000' AS DateTime2), -1, 1, 2, 38, 336371, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129823, CAST(N'2020-10-31T11:39:41.9130000' AS DateTime2), -1, 1, 2, 39, 336370, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129824, CAST(N'2020-10-31T11:39:42.6720000' AS DateTime2), -1, 1, 2, 40, 336369, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129825, CAST(N'2020-10-31T11:39:43.3230000' AS DateTime2), -1, 1, 2, 41, 336368, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129826, CAST(N'2020-10-31T11:39:43.9120000' AS DateTime2), -1, 1, 2, 42, 336367, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129827, CAST(N'2020-10-31T11:39:44.5570000' AS DateTime2), -1, 1, 2, 43, 336366, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129828, CAST(N'2020-10-31T11:39:45.2270000' AS DateTime2), -1, 1, 2, 44, 336365, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129829, CAST(N'2020-10-31T11:39:46.1770000' AS DateTime2), -1, 1, 2, 45, 336364, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129830, CAST(N'2020-10-31T11:39:47.2520000' AS DateTime2), -1, 1, 2, 46, 336363, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129831, CAST(N'2020-10-31T11:39:55.6380000' AS DateTime2), -1, 1, 2, 47, 336362, NULL)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129832, CAST(N'2020-10-31T11:40:12.3110000' AS DateTime2), 1, 1, 2, 47, 336389, 16)
GO
INSERT [bodega4].[movimientos] ([Id], [fecha], [sentido], [nivel], [columna], [posicion], [paquetesId], [usuariosId]) VALUES (1129833, CAST(N'2020-10-31T11:40:17.9660000' AS DateTime2), -1, 1, 2, 47, 336389, NULL)
GO
SET IDENTITY_INSERT [bodega4].[movimientos] OFF
GO
SET IDENTITY_INSERT [bodega4].[opciones] ON 
GO
INSERT [bodega4].[opciones] ([Id], [nombre], [valor]) VALUES (1, N'nombre_app', N'Energy+')
GO
INSERT [bodega4].[opciones] ([Id], [nombre], [valor]) VALUES (2, N'B4.max_posiciones', N'47')
GO
SET IDENTITY_INSERT [bodega4].[opciones] OFF
GO
SET IDENTITY_INSERT [bodega4].[paquetes] ON 
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336362, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336363, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336364, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336365, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336366, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336367, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336368, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336369, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336370, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336371, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336372, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336373, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336374, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336375, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336376, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336377, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336378, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336379, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336380, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336381, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336382, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336383, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336384, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336385, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336386, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336387, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336388, N'TEST3', 3378, 36, 30)
GO
INSERT [bodega4].[paquetes] ([Id], [lote], [productoId], [clienteId], [bultos]) VALUES (336389, N'TEST3', 3378, 36, 30)
GO
SET IDENTITY_INSERT [bodega4].[paquetes] OFF
GO
SET IDENTITY_INSERT [bodega4].[productos] ON 
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (225, 1, N'C incauca x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (227, 4, N'B papel x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (228, 4, N'B poly x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (231, 4, N'B BigBag conjuntas x 1000 kgs', 20, 20, N'qq', 1)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (233, 1, N'C 2.5 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (234, 1, N'C 1.0 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (297, 1, N'C ipsa x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (323, 4, N'B < 250 poly x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (551, 4, N'B BigBag x 1000 kgs', 20, 20, N'qq', 1)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (552, 3, N'O poly apto x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (611, 3, N'O papel x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (681, 3, N'O poly x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (768, 3, N'O BigBag x 1000 kgs', 20, 20, N'qq', 1)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (932, 3, N'O papel x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1176, 1, N'C 0.5 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1224, 4, N'B 0.5 kgs x arroba', 0.25, 21, N'qq', 84)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1225, 1, N'C 0.5 kgs x arroba', 0.25, 21, N'qq', 84)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1234, 2, N'BE < 180 poly x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1236, 2, N'BE < 150 poly x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1301, 2, N'BE tipo A calimeña x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1325, 4, N'B < 250 calimeña x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1471, 2, N'BE < 180 poly x 50 kgs calimeña', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1589, 1, N'C poly x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1630, 1, N'C 0.5 kgs incauca x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1631, 1, N'C 1.0 kgs incauca x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1632, 1, N'C 2.5 kgs incauca x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1822, 4, N'B 2.5 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1823, 4, N'B 1.0 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1824, 4, N'B 0.5 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1891, 3, N'O sobres 5 grs x 10 kgs', 0.2, 20, N'qq', 100)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (1892, 3, N'O carton 850 grs x 8.5 kgs', 0.17, 8.67, N'qq', 51)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (2521, 1, N'C calimeña x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3355, 4, N'B 5.0 kgs incauca x 25 kgs', 0.5, 24, N'qq', 48)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3356, 1, N'C 5.0 kgs incauca x 25 kgs', 0.5, 24, N'qq', 48)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3378, 3, N'O S22.68 kgs', 0.4536, 22.2264, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3390, 4, N'B pap tub incauca x 10 kgs', 0.2, 16, N'qq', 80)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3391, 4, N'B pap incauca ref x 10 kgs', 0.2, 16, N'qq', 80)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3429, 1, N'C incauca x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3434, 4, N'B 454 grs S11.35 kgs', 0.227, 21.792, N'qq', 96)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3447, 3, N'O carton 454 grs x 5.448 kgs', 0.10896, 7.19136, N'qq', 66)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3463, 2, N'BE BigBag < 150 x 1000 kgs', 20, 20, N'qq', 1)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3468, 4, N'B sobre tub x 10 kgs', 0.2, 20, N'qq', 100)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3471, 3, N'O sobre tub x 10 kgs', 0.2, 20, N'qq', 100)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3476, 2, N'BE < 150 x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3489, 1, N'C diamante x 25 kgs', 0.5, 24, N'qq', 48)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3490, 4, N'B poly x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3516, 3, N'O carton 850 grs x 10.2 kgs', 0.204, 7.956, N'qq', 39)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3518, 1, N'BROWN CANE #1 x 25 kgs', 0.5, 24, N'qq', 48)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3520, 4, N'B poly x 50 kgs RE', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3542, 4, N'B 454 grs S13.62 kgs', 0.2724, 21.2472, N'qq', 78)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3553, 4, N'B 5 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3554, 1, N'C 5 kgs x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3581, 1, N'C Tuman x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3582, 2, N'BE papel royal tipo C S22.68 kgs', 0.4536, 22.2264, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3590, 3, N'O cr carton 850 grs x 10.2 kgs', 0.204, 7.956, N'qq', 39)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (3648, 2, N'BE papel tipo A S22.68 kgs', 0.4536, 22.2264, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (5522, 3, N'O poly Averias x 50 kgs', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (6111, 3, N'O papel averias x 25 kgs', 0.5, 24.5, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (7688, 3, N'O BigBag averías x 1000 kgs', 20, 20, N'qq', 1)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (33788, 3, N'O S22.68 kgs x averias', 0.4536, 22.2264, N'qq', 49)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (33789, 5, N'sample', 1, 25, N'qq', 25)
GO
INSERT [bodega4].[productos] ([Id], [claseId], [nombre], [peso_und], [peso], [unidad], [bultos]) VALUES (33790, 5, N'sample2', 1, 25, N'qq', 25)
GO
SET IDENTITY_INSERT [bodega4].[productos] OFF
GO
SET IDENTITY_INSERT [bodega4].[usuarios] ON 
GO
INSERT [bodega4].[usuarios] ([Id], [username], [nombre], [rol], [password], [fecharegistro], [identificacion], [correo], [telefono]) VALUES (1, N'admin', N'Administrador', N'Administrador', N'e10adc3949ba59abbe56e057f20f883e', CAST(N'2014-01-22' AS Date), N'*123', N'admin@winpack.com.co', N'0')
GO
INSERT [bodega4].[usuarios] ([Id], [username], [nombre], [rol], [password], [fecharegistro], [identificacion], [correo], [telefono]) VALUES (16, N'walvarez', N'Administrador', N'Administrador', N'', CAST(N'2014-01-22' AS Date), N'*123', N'admin@winpack.com.co', N'0')
GO
INSERT [bodega4].[usuarios] ([Id], [username], [nombre], [rol], [password], [fecharegistro], [identificacion], [correo], [telefono]) VALUES (17, N'nparedes', N'Administrador', N'Administrador', N'e10adc3949ba59abbe56e057f20f883e', CAST(N'2014-01-22' AS Date), N'*123', N'admin@winpack.com.co', N'0')
GO
INSERT [bodega4].[usuarios] ([Id], [username], [nombre], [rol], [password], [fecharegistro], [identificacion], [correo], [telefono]) VALUES (18, N'mfospina', N'Administrador', N'Administrador', N'8aa1765c68f6938741a297cdd6f745bb', CAST(N'2014-01-22' AS Date), N'*123', N'', N'0')
GO
INSERT [bodega4].[usuarios] ([Id], [username], [nombre], [rol], [password], [fecharegistro], [identificacion], [correo], [telefono]) VALUES (19, N'aecheverri', N'Andres Echeverri Castro', N'Administrador', N'f5c6a7789de0f6efa0ac33ee12b25eb8', CAST(N'2020-09-03' AS Date), N'', N'aecheverri@ingprovidencia.com ', N'24755')
GO
SET IDENTITY_INSERT [bodega4].[usuarios] OFF
GO
ALTER TABLE [bodega4].[paquetes] ADD  DEFAULT (NULL) FOR [bultos]
GO
ALTER TABLE [bodega4].[productos] ADD  DEFAULT (NULL) FOR [peso_und]
GO
ALTER TABLE [bodega4].[productos] ADD  DEFAULT (NULL) FOR [peso]
GO
ALTER TABLE [bodega4].[productos] ADD  DEFAULT (NULL) FOR [unidad]
GO
ALTER TABLE [bodega4].[productos] ADD  DEFAULT (NULL) FOR [bultos]
GO
ALTER TABLE [bodega4].[movimientos]  WITH CHECK ADD  CONSTRAINT [FK_movimientos_paquetes] FOREIGN KEY([paquetesId])
REFERENCES [bodega4].[paquetes] ([Id])
GO
ALTER TABLE [bodega4].[movimientos] CHECK CONSTRAINT [FK_movimientos_paquetes]
GO
ALTER TABLE [bodega4].[movimientos]  WITH CHECK ADD  CONSTRAINT [FK_movimientos_usuarios] FOREIGN KEY([usuariosId])
REFERENCES [bodega4].[usuarios] ([Id])
GO
ALTER TABLE [bodega4].[movimientos] CHECK CONSTRAINT [FK_movimientos_usuarios]
GO
ALTER TABLE [bodega4].[paquetes]  WITH CHECK ADD  CONSTRAINT [FK_paquetes_clientes] FOREIGN KEY([clienteId])
REFERENCES [bodega4].[clientes] ([Id])
GO
ALTER TABLE [bodega4].[paquetes] CHECK CONSTRAINT [FK_paquetes_clientes]
GO
ALTER TABLE [bodega4].[paquetes]  WITH CHECK ADD  CONSTRAINT [FK_paquetes_productos] FOREIGN KEY([productoId])
REFERENCES [bodega4].[productos] ([Id])
GO
ALTER TABLE [bodega4].[paquetes] CHECK CONSTRAINT [FK_paquetes_productos]
GO
ALTER TABLE [bodega4].[productos]  WITH CHECK ADD  CONSTRAINT [FK_productos_clases] FOREIGN KEY([claseId])
REFERENCES [bodega4].[clases] ([Id])
GO
ALTER TABLE [bodega4].[productos] CHECK CONSTRAINT [FK_productos_clases]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.bodega_clases' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'clases'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.bodega_clientes' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'clientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.bodega_movimientos' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'movimientos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.opciones' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'opciones'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.bodega_paquetes' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'paquetes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.bodega_productos' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'productos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'bodega4.usuarios' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'TABLE',@level1name=N'usuarios'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "v_posiciones_actual"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'VIEW',@level1name=N'v_minimo_pos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'VIEW',@level1name=N'v_minimo_pos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sq"
            Begin Extent = 
               Top = 29
               Left = 410
               Bottom = 142
               Right = 580
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'VIEW',@level1name=N'v_paquetes_actuales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'VIEW',@level1name=N'v_paquetes_actuales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "movimientos (bodega4)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v_paquetes_actuales (bodega4)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'VIEW',@level1name=N'v_posiciones_actual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'bodega4', @level1type=N'VIEW',@level1name=N'v_posiciones_actual'
GO
