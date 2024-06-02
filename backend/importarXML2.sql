DECLARE @XMLData XML;

SELECT @XMLData = BulkColumn
FROM OPENROWSET(BULK 'C:\Users\Llermy\Desktop\proyecto2Bases\config.xml', SINGLE_BLOB) AS x;

--insertar tipos de tarifa
DECLARE @TempTiposTarifa TABLE (
  Nombre NVARCHAR(128)
);

INSERT INTO @TempTiposTarifa(Nombre)
SELECT 
    TiposTarifa.value('@Nombre', 'NVARCHAR(128)')
FROM 
    @XMLData.nodes('/Data/TiposTarifa/TipoTarifa') AS T(TiposTarifa);


--select * from @TempTiposTarifa

INSERT INTO dbo.TiposTarifa(
	Nombre
	)
SELECT T.Nombre
FROM @TempTiposTarifa T

--sekect * from TiposTarifa

--insertar tipos de unidad
DECLARE @TempTiposUnidad TABLE (
  Nombre NVARCHAR(128)
);

INSERT INTO @TempTiposUnidad(Nombre)
SELECT 
    TiposUnidad.value('@Tipo', 'NVARCHAR(128)')
FROM 
    @XMLData.nodes('/Data/TiposUnidades/TipoUnidad') AS T(TiposUnidad);


--select * from @TempTiposUnidad

INSERT INTO dbo.TipoUnidad(
	Tipo
	)
SELECT T.Nombre
FROM @TempTiposUnidad T

--select * from TipoUnidad


--insertar tipos de elemento
DECLARE @TempTiposElemento TABLE (
  Nombre NVARCHAR(128),
  IdTipoUnidad INT,
  Valor INT,
  EsFijo INT
);

INSERT INTO @TempTiposElemento(Nombre,IdTipoUnidad,Valor,esFijo)
SELECT 
    TiposElemento.value('@Nombre', 'NVARCHAR(128)'),
	TiposElemento.value('@IdTipoUnidad', 'INT'),
	COALESCE(TiposElemento.value('@Valor','INT'),0),
	TiposElemento.value('@EsFijo', 'INT')
FROM 
    @XMLData.nodes('/Data/TiposElemento/TipoElemento') AS T(TiposElemento);


--select * from @TempTiposElemento

INSERT INTO dbo.TiposElemento(
	Nombre,
	IdTipoUnidad,
	Valor,
	EsFijo
	)
SELECT T.Nombre,
	T.IdTipoUnidad,
	T.Valor,
	T.EsFijo
FROM @TempTiposElemento T

--select * from TiposElemento



--insertar elementos de tipo tarifa
DECLARE @TempElementoDeTipoTarifa TABLE (
  idTipoTarifa INT,
  IdTipoElemento INT,
  Valor INT
);

INSERT INTO @TempElementoDeTipoTarifa(idTipoTarifa,IdTipoElemento,Valor)
SELECT 
	ElementoDeTipoTarifa.value('@idTipoTarifa', 'INT'),
	ElementoDeTipoTarifa.value('@IdTipoElemento', 'INT'),
	ElementoDeTipoTarifa.value('@Valor','INT')
FROM 
    @XMLData.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS T(ElementoDeTipoTarifa);


--select * from @ElementoDeTipoTarifa

INSERT INTO dbo.ElementoDeTipoTarifa(
	idTipoTarifa,
	IdTipoElemento,
	Valor,
	IdTipoUnidad
	)
SELECT T.idTipoTarifa,
	T.IdTipoElemento,
	T.Valor,
	1
FROM @TempElementoDeTipoTarifa T

--select * from ElementoDeTipoTarifa



--insertar tipos de relaciones familiares
DECLARE @TempTipoRelacionFamiliar TABLE (
  Nombre NVARCHAR(128)
);

INSERT INTO @TempTipoRelacionFamiliar(Nombre)
SELECT 
    TipoRelacionesFamiliar.value('@Nombre', 'NVARCHAR(128)')
FROM 
    @XMLData.nodes('/Data/TipoRelacionesFamiliar/TipoRelacionFamiliar') AS T(TipoRelacionesFamiliar);


--select * from @TempTipoRelacionFamiliar

INSERT INTO dbo.TipoRelacionFamiliar(
	Nombre
	)
SELECT T.Nombre
FROM @TempTipoRelacionFamiliar T

--select * from TipoRelacionFamiliar
