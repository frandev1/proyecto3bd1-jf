---insetar un nuevo cliente
CREATE PROCEDURE insertCliente
    @inIdentificacion INT,
	@inNombre NVARCHAR(128),
	@inNamePostbyUser NVARCHAR(128),
	@inPostInIP NVARCHAR(128),
	@OutResult INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON;

BEGIN TRY

	DECLARE @Descripcion NVARCHAR(256);
	DECLARE @IdUser INT;

	SET @OutResult = 0;
	SELECT @IdUser = Id 
	FROM dbo.Usuario 
	WHERE UserName = @inNamePostbyUser;

	
	IF EXISTS (SELECT 1 FROM dbo.Cliente WHERE Identificacion = @inIdentificacion)
	BEGIN
		SET @OutResult = 50001;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inIdentificacion) + ', ' + 
							@inNombre;

		PRINT 'El valorDocumentoIdentidad ya existe en la base de datos.';
	END;

	ELSE IF EXISTS (SELECT 1 FROM Cliente WHERE Nombre = @inNombre)
	BEGIN
		SET @OutResult = 50002;

		SELECT @Descripcion = Descripcion 
		FROM Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion + ', ' + 
							CONVERT(NVARCHAR(50), @inIdentificacion) + ', ' + 
							@inNombre;

		PRINT 'El nombre del empleado ya existe en la base de datos.';
	END;

	ELSE
	BEGIN
		BEGIN TRANSACTION 
			--incersion
			INSERT 
			INTO 
				dbo.Cliente( Identificacion, Nombre) 
			VALUES 
				(@inIdentificacion, @inNombre); 

			SET @Descripcion = CONVERT(NVARCHAR(50), @inIdentificacion) + ', ' + 
							   @inNombre;
			
		COMMIT TRANSACTION 
	END;

	--trazabilidad
	INSERT INTO dbo.BitacoraEvento (idTipoEvento, 
		Descripcion, 
		IdPostByUser, 
		PostInIP, 
		PostTime)
	VALUES (1, 
		@Descripcion , 
		@IdUser, 
		@inPostInIP, 
		GETDATE());

END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0 
	BEGIN
		ROLLBACK TRANSACTION;
	END;
	
	SET @OutResult = 50100;   -- error en BD

END CATCH
SET NOCOUNT OFF;
END;


--EXECUTE [dbo].[insertCliente] 6231142,'Pedro Pascal2','admin','12.4343.2',0;

--select * from Cliente
--select * from BitacoraEvento



---insetar un nuevo contrato
CREATE PROCEDURE insertContrato
    @inNumero BIGINT,
	@inDocIdCliente INT,
	@inTipoTarifa INT,
	@fechaContrato DATE,
	@inNamePostbyUser NVARCHAR(128),
	@inPostInIP NVARCHAR(128),
	@OutResult INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON;

BEGIN TRY
	DECLARE @Descripcion NVARCHAR(256);
	DECLARE @IdUser INT;

	DECLARE @IdCliente INT;

	SET @OutResult = 0;

	SELECT @IdUser = Id 
	FROM dbo.Usuario 
	WHERE UserName = @inNamePostbyUser;

	IF NOT EXISTS (SELECT 1 FROM dbo.Cliente WHERE Identificacion = @inDocIdCliente)
	BEGIN
		SET @OutResult = 50003;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inNumero) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdCliente)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoTarifa);

		PRINT 'El valorDocumentoIdentidad no existe en la base de datos.';
	END;

	ELSE IF EXISTS (SELECT 1 FROM Contrato WHERE Numero = @inNumero)
	BEGIN
		SET @OutResult = 50004;

		SELECT @Descripcion = Descripcion 
		FROM Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inNumero) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdCliente)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoTarifa);

		PRINT 'El numero ya cuenta con un contrato.';
	END;

	ELSE
	BEGIN
		BEGIN TRANSACTION

			SELECT @IdCliente = ID 
			FROM Cliente 
			WHERE Identificacion = @inDocIdCliente;

			--incersion
			INSERT 
			INTO 
				dbo.Contrato(Numero, DocIdCliente, TipoTarifa, Fecha) 
			VALUES 
				(@inNumero, @IdCliente, @inTipoTarifa, @fechaContrato); 

			print('contrato guardado')

			SET @Descripcion = CONVERT(NVARCHAR(50), @inNumero) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdCliente)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoTarifa);
			
		COMMIT TRANSACTION 
	END;

	--trazabilidad
	INSERT INTO dbo.BitacoraEvento (idTipoEvento, Descripcion, IdPostByUser, PostInIP, PostTime)
	VALUES (2, @Descripcion , @IdUser, @inPostInIP, GETDATE());

END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0 
	BEGIN
		ROLLBACK TRANSACTION;
	END;
	
	SET @OutResult = 50100;   -- error en BD

END CATCH
SET NOCOUNT OFF;
END;


--EXECUTE [dbo].[insertContrato] 8988839,5673413,2,'2-5-2024','admin','12.3456.78',0;
--select * from Contrato
--select * from BitacoraEvento



---insetar un relacion familiar
CREATE PROCEDURE insertRelacionFamiliar
    @inDocIdDe INT,
	@inDocIdA INT,
	@inTipoRelacion INT,
	@inNamePostbyUser NVARCHAR(128),
	@inPostInIP NVARCHAR(128),
	@OutResult INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON;

BEGIN TRY
	DECLARE @Descripcion NVARCHAR(256);
	DECLARE @IdUser INT;

	SET @OutResult = 0;

	SELECT @IdUser = Id 
	FROM dbo.Usuario 
	WHERE UserName = @inNamePostbyUser;

	IF NOT EXISTS (SELECT 1 FROM dbo.Cliente WHERE Identificacion = @inDocIdDe)
	BEGIN
		SET @OutResult = 50005;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoRelacion);

		PRINT 'El DocIdDe no existe en la base de datos.';
	END;

	ELSE IF NOT EXISTS (SELECT 1 FROM dbo.Cliente WHERE Identificacion = @inDocIdA)
	BEGIN
		SET @OutResult = 50006;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoRelacion);

		PRINT 'El DocIdA no existe en la base de datos.';
	END;

	ELSE IF EXISTS (SELECT 1 FROM dbo.RelacionFamiliar WHERE DocIdDe = @inDocIdDe and DocIdA = @inDocIdA)
	BEGIN
		SET @OutResult = 50007;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoRelacion);

		PRINT 'El DocIdDe y DocIdA ya tienen una relacion.';
	END;

	ELSE
	BEGIN
		BEGIN TRANSACTION

			--incersion
			INSERT 
			INTO 
				dbo.RelacionFamiliar(DocIdDe, DocIdA, TipoRelacion) 
			VALUES 
				(@inDocIdDe, @inDocIdA, @inTipoRelacion); 

			print('relacion familiar guardada')

			SET @Descripcion = CONVERT(NVARCHAR(50), @inDocIdDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inDocIdA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inTipoRelacion);
			
		COMMIT TRANSACTION 
	END;

	--trazabilidad
	INSERT INTO dbo.BitacoraEvento (idTipoEvento, Descripcion, IdPostByUser, PostInIP, PostTime)
	VALUES (3, @Descripcion , @IdUser, @inPostInIP, GETDATE());

END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0 
	BEGIN
		ROLLBACK TRANSACTION;
	END;
	
	SET @OutResult = 50100;   -- error en BD

END CATCH
SET NOCOUNT OFF;
END;



--EXECUTE [dbo].[insertRelacionFamiliar] 5732025,5673413,2,'admin','12.3456.78',0;
--select * from RelacionFamiliar




---insetar una llamada telefonica
CREATE PROCEDURE insertLlamadaTelefonica
    @inNumeroDe BIGINT,
	@inNumeroA BIGINT,
	@inInicio DATETIME,
	@inFinal DATETIME,
	@inNamePostbyUser NVARCHAR(128),
	@inPostInIP NVARCHAR(128),
	@OutResult INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON;

BEGIN TRY
	DECLARE @Descripcion NVARCHAR(256);
	DECLARE @IdUser INT;

	SET @OutResult = 0;

	SELECT @IdUser = Id 
	FROM dbo.Usuario 
	WHERE UserName = @inNamePostbyUser;

	--verifica si es una llamda entre alguna de las empresa X o Y
	IF ((@inNumeroDe >= 70000000 and @inNumeroDe < 80000000) and NOT EXISTS(SELECT 1 FROM dbo.NumerosEmpresaExtranjera WHERE Numero = @inNumeroDe))
	BEGIN
		INSERT INTO dbo.NumerosEmpresaExtranjera(Numero,Empresa)
		VALUES(@inNumeroDe,'X')
	END;

	IF ((@inNumeroA >= 70000000 and @inNumeroA < 80000000) and NOT EXISTS(SELECT 1 FROM dbo.NumerosEmpresaExtranjera WHERE Numero = @inNumeroA))
	BEGIN
		INSERT INTO dbo.NumerosEmpresaExtranjera(Numero,Empresa)
		VALUES(@inNumeroA,'X')
	END;

	IF ((@inNumeroDe >= 60000000 and @inNumeroDe < 70000000) and NOT EXISTS(SELECT 1 FROM dbo.NumerosEmpresaExtranjera WHERE Numero = @inNumeroDe))
	BEGIN
		INSERT INTO dbo.NumerosEmpresaExtranjera(Numero,Empresa)
		VALUES(@inNumeroDe,'Y')
	END;

	IF ((@inNumeroA >= 60000000 and @inNumeroA < 70000000) and NOT EXISTS(SELECT 1 FROM dbo.NumerosEmpresaExtranjera WHERE Numero = @inNumeroA))
	BEGIN
		INSERT INTO dbo.NumerosEmpresaExtranjera(Numero,Empresa)
		VALUES(@inNumeroA,'Y')
	END;

	--verifica si el numeroDe esta en la base
	IF (NOT EXISTS (SELECT 1 FROM dbo.Contrato WHERE Numero = @inNumeroDe) 
		AND NOT EXISTS (SELECT 1 FROM dbo.NumerosEmpresaExtranjera WHERE Numero = @inNumeroDe) 
		AND NOT(@inNumeroDe = 911) 
		AND NOT(@inNumeroDe = 110)
		)
	BEGIN
		SET @OutResult = 50008;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inNumeroDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inNumeroA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inInicio)+ ', ' + 
							CONVERT(NVARCHAR(50), @inFinal);

		PRINT 'El numeroDe no existe en la base de datos.';
	END;

	--verifica si el numeroA esta en la base
	ELSE IF (NOT EXISTS (SELECT 1 FROM dbo.Contrato WHERE Numero = @inNumeroA) 
		AND NOT EXISTS (SELECT 1 FROM dbo.NumerosEmpresaExtranjera WHERE Numero = @inNumeroA)
		AND NOT(@inNumeroA = 911)
		AND NOT(@inNumeroA = 110)
		)
	BEGIN
		SET @OutResult = 50009;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inNumeroDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inNumeroA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inInicio)+ ', ' + 
							CONVERT(NVARCHAR(50), @inFinal);

		PRINT 'El numeroA no existe en la base de datos.';
	END;

	ELSE
	BEGIN
		BEGIN TRANSACTION

			--incersion
			INSERT 
			INTO 
				dbo.LlamadaTelefonica(NumeroDe, NumeroA, Inicio, Final) 
			VALUES 
				(@inNumeroDe, @inNumeroA, @inInicio, @inFinal); 

			print('llamada telefonica guardada')

			SET @Descripcion = CONVERT(NVARCHAR(50), @inNumeroDe) + ', ' + 
							CONVERT(NVARCHAR(50), @inNumeroA)+ ', ' + 
							CONVERT(NVARCHAR(50), @inInicio)+ ', ' + 
							CONVERT(NVARCHAR(50), @inFinal);
			
		COMMIT TRANSACTION 
	END;

	--trazabilidad
	INSERT INTO dbo.BitacoraEvento (idTipoEvento, Descripcion, IdPostByUser, PostInIP, PostTime)
	VALUES (4, @Descripcion , @IdUser, @inPostInIP, GETDATE());

END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0 
	BEGIN
		ROLLBACK TRANSACTION;
	END;
	
	SET @OutResult = 50100;   -- error en BD

END CATCH
SET NOCOUNT OFF;
END;


--EXECUTE [dbo].[insertLlamadaTelefonica] 78988839,69888335,'5-5-2024','6-5-2024','admin','12.3456.78',0;
--select * from LlamadaTelefonica
--select * from NumerosEmpresaExtranjera





---insetar uso de datos
CREATE PROCEDURE insertUsoDatos
    @inNumero BIGINT,
	@inQGigas FLOAT,
	@inDiaConsumo DATETIME,
	@inNamePostbyUser NVARCHAR(128),
	@inPostInIP NVARCHAR(128),
	@OutResult INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON;

BEGIN TRY
	DECLARE @Descripcion NVARCHAR(256);
	DECLARE @IdUser INT;

	SET @OutResult = 0;

	SELECT @IdUser = Id 
	FROM dbo.Usuario 
	WHERE UserName = @inNamePostbyUser;

	IF NOT EXISTS (SELECT 1 FROM dbo.Contrato WHERE Numero = @inNumero)
	BEGIN
		SET @OutResult = 50010;

		SELECT @Descripcion = Descripcion 
		FROM dbo.Error 
		WHERE Codigo = @OutResult;

		SET @Descripcion = @Descripcion +  ', ' + 
							CONVERT(NVARCHAR(50), @inNumero) + ', ' + 
							CONVERT(NVARCHAR(50), @inQGigas)+ ', ' + 
							CONVERT(NVARCHAR(50), @inDiaConsumo);

		PRINT 'El numero no cuenta con ningun contrato.';
	END;

	ELSE
	BEGIN
		BEGIN TRANSACTION

			--incersion
			INSERT 
			INTO 
				dbo.UsoDatos(Numero, QGigas, DiaConsumo) 
			VALUES 
				(@inNumero, @inQGigas, @inDiaConsumo); 

			print('uso de datos guardado')

			SET @Descripcion = CONVERT(NVARCHAR(50), @inNumero) + ', ' + 
							CONVERT(NVARCHAR(50), @inQGigas)+ ', ' + 
							CONVERT(NVARCHAR(50), @inDiaConsumo);
			
		COMMIT TRANSACTION 
	END;

	--trazabilidad
	INSERT INTO dbo.BitacoraEvento (idTipoEvento, Descripcion, IdPostByUser, PostInIP, PostTime)
	VALUES (5, @Descripcion , @IdUser, @inPostInIP, GETDATE());

END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0 
	BEGIN
		ROLLBACK TRANSACTION;
	END;
	
	SET @OutResult = 50100;   -- error en BD

END CATCH
SET NOCOUNT OFF;
END;


--EXECUTE [dbo].[insertUsoDatos] 8988833, 10.5, '10-3-2024','admin','12.3456.78',0;
--select * from UsoDatos
--select * from Contrato

/*
print(convert(time,'1:00:1.1090'))


SELECT 0.5*(DATEDIFF(SECOND, '1-1-1 1:00:1.1090', '1-1-1 1:01:2.1090')) AS TotalMinutes

SELECT (DATEDIFF(MINUTE, '1-30-1 1:00:1.1090', '2-10-1 1:01:2.1090')) AS TotalMinutes


declare @ds date;
set @ds = '1-30-0001 1:00:1.1090'

print(@ds)
*/