DECLARE @XMLData XML;

SELECT @XMLData = BulkColumn
FROM OPENROWSET(BULK 'C:\TEC\BasesDatos1\proyecto3bd1-jf\scriptsCreacion\operacionesMasivasCorregido.xml', SINGLE_BLOB) AS x;

--insertar todas las fechas en una tabla
DECLARE @fechaOperacion TABLE (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	fecha DATETIME
);

INSERT INTO @fechaOperacion(fecha)
SELECT 
    FechaOperacion.value('@fecha', 'DATETIME')
FROM 
    @XMLData.nodes('/Operaciones/FechaOperacion') AS T(FechaOperacion);

DECLARE @lo INT = 1,@hi INT;
SELECT @hi = COUNT(ID) 
FROM dbo.Cliente

DECLARE @tempFecha DATE
DECLARE @xpath NVARCHAR(100)

--variables para clientes nuevos
DECLARE @ClientesNuevos TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			Identificacion INT,
			Nombre NVARCHAR(128)
		);
DECLARE @loInsCLi INT = 1,@hiInsCLi INT = 0
DECLARE @tempIdentificacion INT, @tempNombre NVARCHAR(128)

--variables para contratos nuevos
DECLARE @ContratosNuevos TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			Numero BIGINT,
			DocIdCliente INT,
			TipoTarifa INT
		);
DECLARE @loInsCont INT = 1,@hiInsCont INT = 0
DECLARE @tempNumero BIGINT, @tempDocIdCliente INT, @tempTipoTarifa INT


--variables para relaciones nuevas
DECLARE @RelacionFamiliar TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			DocIdDe INT,
			DocIdA INT,
			TipoRelacion INT
		);
DECLARE @loInsRelFam INT = 1,@hiInsRelFam INT = 0
DECLARE @tempDocIdDe INT, @tempDocIdA INT, @tempTipoRelacion INT


--variables para llamadas telefonica
DECLARE @LlamadaTelefonica TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			NumeroDe BIGINT,
			NumeroA BIGINT,
			Inicio DATETIME,
			Final DATETIME
		);
DECLARE @loInsLlamTel INT = 1,@hiInsLlamTel INT = 0
DECLARE @tempNumeroDe BIGINT, @tempNumeroA BIGINT, @tempInicio DATETIME, @tempFinal DATETIME
 

--variables para pagos de facturas
DECLARE @PagoFactura TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			Numero BIGINT
		);
DECLARE @loInsPagoFact INT = 1,@hiInsPagoFact INT = 0
DECLARE @tempNumeroPF BIGINT


--variables para uso de datos
DECLARE @UsoDatos TABLE (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			Numero BIGINT,
			QGigas FLOAT
		);
DECLARE @loInsUsoDatos INT = 1,@hiInsUsoDatos INT = 0
DECLARE @tempNumeroUD BIGINT, @tempQGigas FLOAT


 

WHILE (@lo<=@hi)
	BEGIN
		SELECT @tempFecha = fecha FROM @fechaOperacion WHERE ID = @lo
		
		
		--guarda los nuevos clientes
		INSERT INTO @ClientesNuevos(
			Identificacion,
			Nombre
			)
		SELECT 
			clientesNuevos.value('@Identificacion', 'INT'),
			clientesNuevos.value('@Nombre', 'NVARCHAR(128)')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/ClienteNuevo') AS T(clientesNuevos);
		
		--select * from @ClientesNuevos

		SELECT @hiInsCLi = COUNT(Nombre) FROM @ClientesNuevos

		WHILE (@loInsCLi<=@hiInsCLi)
		BEGIN
			SELECT @tempIdentificacion = Identificacion, @tempNombre = Nombre FROM @ClientesNuevos WHERE  ID = @loInsCLi
			EXECUTE [dbo].[insertCliente] @tempIdentificacion,@tempNombre,'admin','12.3456.78',0;

			SET @loInsCLi = @loInsCLi+1
		END


		--guarda los nuevos contratos
		INSERT INTO @ContratosNuevos(
			Numero,
			DocIdCliente,
			TipoTarifa
			)
		SELECT 
			contratoNuevo.value('@Numero', 'BIGINT'),
			contratoNuevo.value('@DocIdCliente', 'INT'),
			contratoNuevo.value('@TipoTarifa', 'INT')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/NuevoContrato') AS T(contratoNuevo);
		
		--select * from @ContratosNuevos

		SELECT @hiInsCont = COUNT(Numero) FROM @ContratosNuevos

		WHILE (@loInsCont<=@hiInsCont)
		BEGIN
			SELECT @tempNumero = Numero, @tempDocIdCliente = DocIdCliente, @tempTipoTarifa = TipoTarifa FROM @ContratosNuevos WHERE  ID = @loInsCont
			EXECUTE [dbo].[insertContrato] @tempNumero,@tempDocIdCliente,@tempTipoTarifa,@tempFecha,'admin','12.3456.78',0;

			SET @loInsCont = @loInsCont+1
		END
		

		--guarda las relaciones familiares nuevas
		INSERT INTO @RelacionFamiliar(
			DocIdDe,
			DocIdA,
			TipoRelacion
			)
		SELECT 
			RelacionNueva.value('@DocIdDe', 'INT'),
			RelacionNueva.value('@DocIdA', 'INT'),
			RelacionNueva.value('@TipoRelacion', 'INT')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/RelacionFamiliar') AS T(RelacionNueva);
		
		--select * from @RelacionFamiliar

		SELECT @hiInsRelFam = COUNT(DocIdDe) FROM @RelacionFamiliar

		WHILE (@loInsRelFam<=@hiInsRelFam)
		BEGIN
			SELECT @tempDocIdDe = DocIdDe, @tempDocIdA = DocIdA, @tempTipoRelacion = TipoRelacion FROM @RelacionFamiliar WHERE  ID = @loInsRelFam
			EXECUTE [dbo].[insertRelacionFamiliar] @tempDocIdDe,@tempDocIdA,@tempTipoRelacion,'admin','12.3456.78',0;

			SET @loInsRelFam = @loInsRelFam+1
		END
		

		--guarda las llamdas telefonicas
		INSERT INTO @LlamadaTelefonica(
			NumeroDe,
			NumeroA,
			Inicio,
			Final
			)
		SELECT 
			LlamadaNueva.value('@NumeroDe', 'BIGINT'),
			LlamadaNueva.value('@NumeroA', 'BIGINT'),
			LlamadaNueva.value('@Inicio', 'DATETIME'),
			LlamadaNueva.value('@Final', 'DATETIME')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/LlamadaTelefonica') AS T(LlamadaNueva);
		
		--select * from @LlamadaTelefonica

		SELECT @hiInsLlamTel = COUNT(NumeroDe) FROM @LlamadaTelefonica

		WHILE (@loInsLlamTel<=@hiInsLlamTel)
		BEGIN
			SELECT @tempNumeroDe = NumeroDe, @tempNumeroA = NumeroA, @tempInicio = Inicio, @tempFinal = Final FROM @LlamadaTelefonica WHERE  ID = @loInsLlamTel
			EXECUTE [dbo].[insertLlamadaTelefonica] @tempNumeroDe,@tempNumeroA,@tempInicio,@tempFinal,'admin','12.3456.78',0;

			SET @loInsLlamTel = @loInsLlamTel+1
		END
		


		--guarda los pagos de facturas
		INSERT INTO @PagoFactura(
			Numero
			)
		SELECT 
			PagoNuevo.value('@Numero', 'BIGINT')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/PagoFactura') AS T(PagoNuevo);
		
		--select * from @PagoFactura

		SELECT @hiInsPagoFact = COUNT(Numero) FROM @PagoFactura

		WHILE (@loInsPagoFact<=@hiInsPagoFact)
		BEGIN
			SELECT @tempNumeroPF = Numero FROM @PagoFactura WHERE  ID = @loInsPagoFact
			--EXECUTE [dbo].[insertPagoFactura] @tempNumeroPF,'admin','12.3456.78',0;

			SET @loInsPagoFact = @loInsPagoFact+1
		END
		


		--guarda el uso de datos
		INSERT INTO @UsoDatos(
			Numero,
			QGigas
			)
		SELECT 
			UsoDatosNuevo.value('@Numero', 'BIGINT'),
			UsoDatosNuevo.value('@QGigas', 'FLOAT')
		FROM 
			@XMLData.nodes('/Operaciones/FechaOperacion[@fecha=sql:variable("@tempFecha")]/UsoDatos') AS T(UsoDatosNuevo);
		
		--select * from @UsoDatos

		SELECT @hiInsUsoDatos = COUNT(Numero) FROM @UsoDatos

		WHILE (@loInsUsoDatos<=@hiInsUsoDatos)
		BEGIN
			SELECT @tempNumeroUD = Numero, @tempQGigas = QGigas FROM @UsoDatos WHERE  ID = @loInsUsoDatos
			EXECUTE [dbo].[insertUsoDatos] @tempNumeroUD, @tempQGigas, @tempFecha,'admin','12.3456.78',0;

			SET @loInsUsoDatos = @loInsUsoDatos+1
		END


		SET @lo=@lo+1;
			
	END;

--select * from Cliente 


--SELECT * FROM Cliente
--SELECT * FROM Contrato
--SELECT * FROM RelacionFamiliar
--SELECT * FROM LlamadaTelefonica
--SELECT * FROM PagoFacturas
--SELECT * FROM UsoDatos
