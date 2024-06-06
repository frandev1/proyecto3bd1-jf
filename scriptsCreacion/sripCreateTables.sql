USE [servicioTelefonico]
GO

/****** Object:  Table [dbo].[Cliente]    Script Date: 22/5/2024 15:11:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cliente](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Identificacion] [int] NOT NULL,
	[Nombre] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[Contrato]    Script Date: 5/6/2024 08:03:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contrato](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [bigint] NOT NULL,
	[DocIdCliente] [int] NOT NULL,
	[TipoTarifa] [int] NOT NULL,
 CONSTRAINT [PK_Contrato] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Contrato]  WITH CHECK ADD  CONSTRAINT [FK_Contrato_Cliente1] FOREIGN KEY([DocIdCliente])
REFERENCES [dbo].[Cliente] ([ID])
GO

ALTER TABLE [dbo].[Contrato] CHECK CONSTRAINT [FK_Contrato_Cliente1]
GO

ALTER TABLE [dbo].[Contrato]  WITH CHECK ADD  CONSTRAINT [FK_Contrato_TiposTarifa] FOREIGN KEY([TipoTarifa])
REFERENCES [dbo].[TiposTarifa] ([ID])
GO

ALTER TABLE [dbo].[Contrato] CHECK CONSTRAINT [FK_Contrato_TiposTarifa]
GO




/****** Object:  Table [dbo].[ElementoDeTipoTarifa]    Script Date: 2/6/2024 02:52:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ElementoDeTipoTarifa](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoTarifa] [int] NOT NULL,
	[IdTipoElemento] [int] NOT NULL,
	[Valor] [int] NOT NULL,
	[IdTipoUnidad] [int] NOT NULL,
 CONSTRAINT [PK_ElementoDeTipoTarifa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ElementoDeTipoTarifa]  WITH CHECK ADD  CONSTRAINT [FK_ElementoDeTipoTarifa_TiposElemento] FOREIGN KEY([IdTipoElemento])
REFERENCES [dbo].[TiposElemento] ([ID])
GO

ALTER TABLE [dbo].[ElementoDeTipoTarifa] CHECK CONSTRAINT [FK_ElementoDeTipoTarifa_TiposElemento]
GO

ALTER TABLE [dbo].[ElementoDeTipoTarifa]  WITH CHECK ADD  CONSTRAINT [FK_ElementoDeTipoTarifa_TiposTarifa] FOREIGN KEY([IdTipoTarifa])
REFERENCES [dbo].[TiposTarifa] ([ID])
GO

ALTER TABLE [dbo].[ElementoDeTipoTarifa] CHECK CONSTRAINT [FK_ElementoDeTipoTarifa_TiposTarifa]
GO

ALTER TABLE [dbo].[ElementoDeTipoTarifa]  WITH CHECK ADD  CONSTRAINT [FK_ElementoDeTipoTarifa_TipoUnidad] FOREIGN KEY([IdTipoUnidad])
REFERENCES [dbo].[TipoUnidad] ([ID])
GO

ALTER TABLE [dbo].[ElementoDeTipoTarifa] CHECK CONSTRAINT [FK_ElementoDeTipoTarifa_TipoUnidad]
GO



/****** Object:  Table [dbo].[ElementoTipoTarifaFijo]    Script Date: 6/6/2024 06:04:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ElementoTipoTarifaFijo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoTarifa] [int] NOT NULL,
	[IdTipoElemento] [int] NOT NULL,
	[Valor] [int] NOT NULL,
	[IdTipoUnidad] [int] NOT NULL,
 CONSTRAINT [PK_ElementoTipoTarifaFijo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ElementoTipoTarifaFijo]  WITH CHECK ADD  CONSTRAINT [FK_ElementoTipoTarifaFijo_TiposElemento] FOREIGN KEY([IdTipoElemento])
REFERENCES [dbo].[TiposElemento] ([ID])
GO

ALTER TABLE [dbo].[ElementoTipoTarifaFijo] CHECK CONSTRAINT [FK_ElementoTipoTarifaFijo_TiposElemento]
GO

ALTER TABLE [dbo].[ElementoTipoTarifaFijo]  WITH CHECK ADD  CONSTRAINT [FK_ElementoTipoTarifaFijo_TiposTarifa] FOREIGN KEY([IdTipoTarifa])
REFERENCES [dbo].[TiposTarifa] ([ID])
GO

ALTER TABLE [dbo].[ElementoTipoTarifaFijo] CHECK CONSTRAINT [FK_ElementoTipoTarifaFijo_TiposTarifa]
GO

ALTER TABLE [dbo].[ElementoTipoTarifaFijo]  WITH CHECK ADD  CONSTRAINT [FK_ElementoTipoTarifaFijo_TipoUnidad] FOREIGN KEY([IdTipoUnidad])
REFERENCES [dbo].[TipoUnidad] ([ID])
GO

ALTER TABLE [dbo].[ElementoTipoTarifaFijo] CHECK CONSTRAINT [FK_ElementoTipoTarifaFijo_TipoUnidad]
GO





/****** Object:  Table [dbo].[ElementoTipoTarifaPorcentual]    Script Date: 6/6/2024 06:04:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ElementoTipoTarifaPorcentual](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoTarifa] [int] NOT NULL,
	[IdTipoElemento] [int] NOT NULL,
	[Valor] [real] NOT NULL,
	[IdTipoUnidad] [int] NOT NULL,
 CONSTRAINT [PK_ElementoTipoTarifaPorcentual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ElementoTipoTarifaPorcentual]  WITH CHECK ADD  CONSTRAINT [FK_ElementoTipoTarifaPorcentual_TiposElemento] FOREIGN KEY([IdTipoElemento])
REFERENCES [dbo].[TiposElemento] ([ID])
GO

ALTER TABLE [dbo].[ElementoTipoTarifaPorcentual] CHECK CONSTRAINT [FK_ElementoTipoTarifaPorcentual_TiposElemento]
GO

ALTER TABLE [dbo].[ElementoTipoTarifaPorcentual]  WITH CHECK ADD  CONSTRAINT [FK_ElementoTipoTarifaPorcentual_TiposTarifa] FOREIGN KEY([IdTipoTarifa])
REFERENCES [dbo].[TiposTarifa] ([ID])
GO

ALTER TABLE [dbo].[ElementoTipoTarifaPorcentual] CHECK CONSTRAINT [FK_ElementoTipoTarifaPorcentual_TiposTarifa]
GO

ALTER TABLE [dbo].[ElementoTipoTarifaPorcentual]  WITH CHECK ADD  CONSTRAINT [FK_ElementoTipoTarifaPorcentual_TipoUnidad] FOREIGN KEY([IdTipoUnidad])
REFERENCES [dbo].[TipoUnidad] ([ID])
GO

ALTER TABLE [dbo].[ElementoTipoTarifaPorcentual] CHECK CONSTRAINT [FK_ElementoTipoTarifaPorcentual_TipoUnidad]
GO





/****** Object:  Table [dbo].[LlamadaTelefonica]    Script Date: 22/5/2024 15:13:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LlamadaTelefonica](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NumeroDe] [bigint] NOT NULL,
	[NumeroA] [bigint] NOT NULL,
	[Inicio] [datetime] NOT NULL,
	[Final] [datetime] NOT NULL,
 CONSTRAINT [PK_LlamadaTelefonica] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  Table [dbo].[NumerosEmpresaExtranjera]    Script Date: 6/6/2024 06:04:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NumerosEmpresaExtranjera](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [int] NOT NULL,
	[Empresa] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_NumerosEmpresaExtranjera] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  Table [dbo].[RelacionFamiliar]    Script Date: 22/5/2024 15:13:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RelacionFamiliar](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DocIdDe] [int] NOT NULL,
	[DocIdA] [int] NOT NULL,
	[TipoRelacion] [int] NOT NULL,
 CONSTRAINT [PK_RelacionFamiliar] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_TipoRelacionFamiliar] FOREIGN KEY([TipoRelacion])
REFERENCES [dbo].[TipoRelacionFamiliar] ([ID])
GO

ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_TipoRelacionFamiliar]
GO



/****** Object:  Table [dbo].[TipoRelacionFamiliar]    Script Date: 22/5/2024 15:13:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoRelacionFamiliar](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TipoRelacionFamiliar] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  Table [dbo].[TiposElemento]    Script Date: 22/5/2024 15:13:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TiposElemento](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](128) NOT NULL,
	[IdTipoUnidad] [int] NOT NULL,
	[Valor] [int] NOT NULL,
	[EsFijo] [int] NOT NULL
 CONSTRAINT [PK_TiposElemento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  Table [dbo].[TiposTarifa]    Script Date: 22/5/2024 15:13:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TiposTarifa](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TiposTarifa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[TipoUnidad]    Script Date: 22/5/2024 15:14:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoUnidad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TipoUnidad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[UsoDatos]    Script Date: 22/5/2024 15:14:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UsoDatos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [bigint] NOT NULL,
	[QGigas] [float] NOT NULL,
	[DiaConsumo] [datetime] NOT NULL,
 CONSTRAINT [PK_UsoDatos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



--Bitacora de eventos

/****** Object:  Table [dbo].[Usuario]    Script Date: 14/4/2024 20:59:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[Usuario]
VALUES ('admin','1223')

/****** Object:  Table [dbo].[TipoEvento]    Script Date: 14/4/2024 20:59:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoEvento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TipoEvento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--evento 1
INSERT INTO [dbo].[TipoEvento](Nombre)
VALUES ('Insertar cliente')

--evento 2
INSERT INTO [dbo].[TipoEvento](Nombre)
VALUES ('Insertar contrato')

--evento 3
INSERT INTO [dbo].[TipoEvento](Nombre)
VALUES ('Insertar relacion familiar')

--evento 4
INSERT INTO [dbo].[TipoEvento](Nombre)
VALUES ('Insertar llamda telefonica')

--evento 5
INSERT INTO [dbo].[TipoEvento](Nombre)
VALUES ('Insertar uso de datos')



--drop table [DBError]
/****** Object:  Table [dbo].[DBError]    Script Date: 14/4/2024 20:56:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DBError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorUserName] [nvarchar](50) NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorState] [nvarchar](50) NOT NULL,
	[ErrorSeverity] [nvarchar](50) NOT NULL,
	[ErrorLine] [int] NOT NULL,
	[ErrorProcedure] [nvarchar](50) NOT NULL,
	[ErrorMessage] [nvarchar](2000) NOT NULL,
	[ErrorDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_DBError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Error]    Script Date: 14/4/2024 20:57:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Error](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--error 50001
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50001,'El numero de identificacion del cliente ya existe')

--error 50002
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50002,'El nombre del cliente ya existe')

--error 50003
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50003,'El documento de identidad no existe')

--error 50004
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50004,'El numero ya cuenta con un contrato.')

--error 50005
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50005,'El DocIdDe no existe en la base de datos.')

--error 50006
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50006,'El DocIdA no existe en la base de datos.')

--error 50007
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50007,'El DocIdDe y DocIdA ya tienen una relacion.')

--error 50008
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50008,'El numeroDe no existe en la base de datos.')

--error 50009
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50009,'El numeroA no existe en la base de datos.')

--error 50010
INSERT INTO [dbo].[Error](Codigo,Descripcion)
VALUES (50010,'El numero no cuenta con ningun contrato.')




/****** Object:  Table [dbo].[BitacoraEvento]    Script Date: 14/4/2024 20:54:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BitacoraEvento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoEvento] [int] NOT NULL,
	[Descripcion] [nvarchar](2000) NOT NULL,
	[IdPostByUser] [int] NOT NULL,
	[PostInIP] [nvarchar](50) NOT NULL,
	[PostTime] [DATETIME] NOT NULL,
 CONSTRAINT [PK_BitacoraEvento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BitacoraEvento]  WITH CHECK ADD  CONSTRAINT [FK_BitacoraEvento_TipoEvento] FOREIGN KEY([idTipoEvento])
REFERENCES [dbo].[TipoEvento] ([Id])
GO

ALTER TABLE [dbo].[BitacoraEvento] CHECK CONSTRAINT [FK_BitacoraEvento_TipoEvento]
GO

ALTER TABLE [dbo].[BitacoraEvento]  WITH CHECK ADD  CONSTRAINT [FK_BitacoraEvento_Usuario] FOREIGN KEY([IdPostByUser])
REFERENCES [dbo].[Usuario] ([Id])
GO

ALTER TABLE [dbo].[BitacoraEvento] CHECK CONSTRAINT [FK_BitacoraEvento_Usuario]
GO