DECLARE @XMLData XML;

SELECT @XMLData = BulkColumn
FROM OPENROWSET(BULK 'C:\Users\Llermy\Desktop\proyecto2Bases\operacionesMasivasCorregido.xml', SINGLE_BLOB) AS x;

--insertar tipos de tarifa
DECLARE @fechaOperacion TABLE (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	fecha DATETIME
);

INSERT INTO @fechaOperacion(fecha)
SELECT 
    FechaOperacion.value('@fecha', 'DATETIME')
FROM 
    @XMLData.nodes('/Operaciones/FechaOperacion') AS T(FechaOperacion);

declare @lo int = 1,@hi int = 2
declare @tempFecha DATE
DECLARE @xpath NVARCHAR(100)

DECLARE @loInsCLi int = 1,@hiInsCLi int = 1
DECLARE @tempIdentificacion int, @tempNombre NVARCHAR(128)


WHILE (@lo<=@hi)
	BEGIN
		select @tempFecha = fecha from @fechaOperacion where ID = @lo

		SET @xpath = CONVERT(NVARCHAR(10),@tempFecha)

		DECLARE @ClientesNuevos TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			Identificacion int,
			Nombre NVARCHAR(128)
		);

		
		INSERT INTO @ClientesNuevos(
			Identificacion,
			Nombre
			)
		SELECT 
			clientesNuevos.value('@Identificacion', 'INT'),
			clientesNuevos.value('@Nombre', 'NVARCHAR(128)')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/ClienteNuevo') AS T(clientesNuevos);
		
		select * from @ClientesNuevos

		SELECT @hiInsCLi = COUNT(Nombre) FROM @ClientesNuevos

		WHILE (@loInsCLi<=@hiInsCLi)
		BEGIN
			SELECT @tempIdentificacion = Identificacion, @tempNombre = Nombre FROM @ClientesNuevos WHERE  ID = @loInsCLi
			EXECUTE [dbo].[insertCliente] @tempIdentificacion,@tempNombre,'admin','12.3456.78',0;

			SET @loInsCLi = @loInsCLi+1
		END

		SET @lo=@lo+1;
			
	END;

	select * from Cliente 