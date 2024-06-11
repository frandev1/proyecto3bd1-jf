---crear la factura de un cliente
CREATE PROCEDURE facturarCliente
    @inIdentificacion INT,
	@inFechaActual DATETIME,
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

	DECLARE @IdCliente INT;

	SELECT @IdCliente = ID
	FROM dbo.Cliente
	WHERE Identificacion = @inIdentificacion

	--tabla de los numeros de contratos por cliente
	DECLARE @NumerosDeContrato TABLE (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	Numero BIGINT,
	Fecha DATE,
	TipoTarifa INT
	);

	INSERT INTO @NumerosDeContrato
	SELECT Numero, Fecha, TipoTarifa
	FROM dbo.Contrato
	WHERE DocIdCliente = @IdCliente

	--parametros para el while
	DECLARE @lo INT = 1,@hi INT;

	SELECT @hi  = COUNT(ID) 
	FROM @NumerosDeContrato;

	DECLARE @diaContrato INT;
	DECLARE @diaActual INT = DAY(@inFechaActual);

	DECLARE @fechaInicioFact DATE;

	DECLARE @IdfacturaActual int;

	DECLARE @FechaUltimaFactura DATE;

	DECLARE @NumeroActual BIGINT;
	DECLARE @TipoTarifaBase INT;
	DECLARE @TarifaBase INT;
	DECLARE @MinutosBase INT;
	DECLARE @MinutosExtra INT;
	DECLARE @MinutosFamiliares INT;
	DECLARE @GigasBase INT;
	DECLARE @GigasExtra INT;
	DECLARE @CobroPor911 INT;
	DECLARE @CobroPor110 INT;
	DECLARE @CobroPor900 INT;
	DECLARE @CobroPor800 INT;
	DECLARE @Minutos911 INT;
	DECLARE @Minutos110 INT;
	DECLARE @Minutos900 INT;
	DECLARE @Minutos800 INT;

	DECLARE @TotalMinutosExtra INT;
	DECLARE @TotalGigasExtra INT;
	DECLARE @TotalMinutos911 INT;
	DECLARE @TotalMinutos110 INT;
	DECLARE @TotalMinutos900 INT;
	DECLARE @TotalMinutos800 INT;
	DECLARE @TotalSinImp INT;
	DECLARE @MultaPorAtraso INT;

	WHILE (@lo<=@hi)
		BEGIN

			SELECT @NumeroActual = Numero, @diaContrato = DAY(fecha), @TipoTarifaBase = TipoTarifa
			FROM @NumerosDeContrato
			WHERE ID = @lo

			SELECT @FechaUltimaFactura  = Fecha
			FROM Factura
			WHERE IdCliente = @IdCliente
			ORDER BY Fecha DESC


			--valida si el dia de hoy se factura el contrato
			IF((@diaActual = @diaContrato) AND NOT(@FechaUltimaFactura = CONVERT(DATE,@inFechaActual)))
			BEGIN

				--inserta el encabezado de la factura
				INSERT INTO dbo.Factura(
					IdCliente,
					Fecha,
					SubtotalSinImpuestos,
					SubtotalSinImpuestos,
					MultaPorFactPend,
					Total,
					Fecha,
					IdEstado
					)
				VALUES(
					@IdCliente,
					@inFechaActual,
					0,
					0,
					0,
					0,
					'0-0-0000',
					1
					)

				SELECT @IdfacturaActual = ID 
				FROM Factura
				WHERE IdCliente = @IdCliente and Fecha = @inFechaActual

				SELECT @TarifaBase = Valor
				FROM dbo.ElementoDeTipoTarifa
				WHERE (IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 1)

				SELECT @MinutosBase = Valor
				FROM dbo.ElementoDeTipoTarifa
				WHERE (IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 2)

				SELECT @GigasBase = Valor
				FROM dbo.ElementoDeTipoTarifa
				WHERE (IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 5)

				--inserta los detalles de la factura
				INSERT INTO dbo.DetalleDeFactura(
					IdFactura,
					TarifaBasica,
					QMinutosExtra,
					QGigasExtra,
					QMintosAFamiliares,
					CobroPor911,
					CobroPor900,
					CobroPor800
					)
				VALUES(
					@IdfacturaActual,
					@TarifaBase,
					0,
					0,
					0,
					0,
					0,
					0
				)

				--insertar detalles de llamadas
				INSERT INTO dbo.DetalleLlamadas(
					IdFactura,
					Fecha,
					HoraInicio,
					HoraFin,
					NumeroDeLlamada,
					QMinutos,
					EsUnaLlamadaEntreFamiliares
				)
				SELECT
					@IdfacturaActual,
					CONVERT(DATE,Final),
					CONVERT(TIME,Inicio),
					CONVERT(TIME,Final),
					NumeroA,
					DATEDIFF(MINUTE,Inicio,Final),
					COALESCE(R.TipoRelacion,0) AS TipoRelacion
				FROM dbo.LlamadaTelefonica L
				inner join dbo.Contrato C ON L.NumeroDe = C.Numero
				inner join dbo.Contrato C2 ON L.NumeroA = C2.Numero
				inner join dbo.Cliente Cl ON C.DocIdCliente = Cl.ID
				inner join dbo.Cliente Cl2 ON C2.DocIdCliente = Cl2.ID
				left join dbo.RelacionFamiliar R ON (Cl.Identificacion = R.DocIdDe AND Cl2.Identificacion = R.DocIdA) 
													OR (Cl2.Identificacion = R.DocIdDe AND Cl.Identificacion = R.DocIdA)
				WHERE NumeroDe = @NumeroActual 
					AND L.Final < @inFechaActual
					AND L.Final >= DATEADD(MONTH,-1,@inFechaActual)

				--falta la validacion para cuando un mes termina en 31 y el otro en 30
					
				--insertar detalles uso de datos
				INSERT INTO dbo.DetalleUsoDatos(
					IdFactura,
					Fecha,
					QDatosConsmidos
				)	
				SELECT
					@IdfacturaActual,
					CONVERT(DATE,DiaConsumo),
					QGigas
				FROM dbo.UsoDatos
				WHERE Numero = @NumeroActual 


				SELECT @MinutosExtra = @MinutosBase - SUM(D.QMinutos)
				FROM dbo.DetalleLlamadas D
				WHERE D.IdFactura = @IdfacturaActual
					AND D.NumeroDeLlamada < 80000000000
					AND D.EsUnaLlamadaEntreFamiliares < 0
					AND NOT(D.NumeroDeLlamada = 911) 
					AND NOT(D.NumeroDeLlamada = 110)
				GROUP BY D.IdFactura

				SET @MinutosExtra = CASE 
				   WHEN @MinutosExtra < 0 THEN 0 
				   ELSE @MinutosExtra 
				END;


				SELECT @GigasExtra = @GigasBase - SUM(D.QDatosConsmidos)
				FROM dbo.DetalleUsoDatos D
				WHERE D.IdFactura = @IdfacturaActual
				GROUP BY D.IdFactura

				SET @GigasExtra = CASE 
				   WHEN @GigasExtra < 0 THEN 0 
				   ELSE @GigasExtra 
				END;


				SELECT @MinutosFamiliares = SUM(D.QMinutos)
				FROM dbo.DetalleLlamadas D
				WHERE D.IdFactura = @IdfacturaActual
					AND D.EsUnaLlamadaEntreFamiliares > 0
				GROUP BY D.IdFactura

				SELECT @Minutos800 = SUM(D.QMinutos)
				FROM dbo.DetalleLlamadas D
				WHERE D.IdFactura = @IdfacturaActual
					AND D.NumeroDeLlamada >= 80000000000
					AND D.NumeroDeLlamada < 90000000000
				GROUP BY D.IdFactura

				SELECT @Minutos900 = SUM(D.QMinutos)
				FROM dbo.DetalleLlamadas D
				WHERE D.IdFactura = @IdfacturaActual
					AND D.NumeroDeLlamada >= 90000000000
				GROUP BY D.IdFactura

				SELECT @Minutos911 = SUM(D.QMinutos)
				FROM dbo.DetalleLlamadas D
				WHERE D.IdFactura = @IdfacturaActual
					AND D.NumeroDeLlamada = 911
				GROUP BY D.IdFactura

				SELECT @Minutos110 = SUM(D.QMinutos)
				FROM dbo.DetalleLlamadas D
				WHERE D.IdFactura = @IdfacturaActual
					AND D.NumeroDeLlamada = 110
				GROUP BY D.IdFactura


				--actualizar el detalle de la factura
				UPDATE [dbo].[DetalleDeFactura]
				SET [TarifaBasica] = @TarifaBase
					  ,[QMinutosExtra] = @MinutosExtra
					  ,[QGigasExtra] = @GigasExtra
					  ,[QMintosAFamiliares] = @MinutosFamiliares
					  ,[CobroPor911] = 1300
					  ,[CobroPor900] = 100
					  ,[CobroPor800] = 50
				WHERE IdFactura = @IdfacturaActual


				SELECT @TotalMinutosExtra = @MinutosExtra * Valor
				FROM dbo.ElementoDeTipoTarifa
				WHERE(IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 3)


				SELECT @TotalGigasExtra = @GigasExtra * Valor
				FROM dbo.ElementoDeTipoTarifa
				WHERE(IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 6)


				SET @TotalMinutos911 = @TotalMinutos911 * 1300;

				SET @TotalMinutos110 = @TotalMinutos110 *20;

				SET @TotalMinutos900 = @Minutos900 * 100;
				SET @TotalMinutos800 = @Minutos800 * 50;

				SET @TotalSinImp = @TotalMinutosExtra+
									@TotalGigasExtra+
									@TotalMinutos911+
									@TotalGigasExtra+
									@TotalMinutos900+
									@TotalMinutos800;

				IF EXISTS(SELECT 1 FROM dbo.Factura WHERE IdCliente = @IdCliente AND IdEstado = 0)
				BEGIN
					SELECT @MultaPorAtraso = Valor
					FROM dbo.ElementoDeTipoTarifa
					WHERE(IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 8)
				END
				ELSE
				BEGIN
					SET @MultaPorAtraso = 0;
				END

				--actualizar el encabezado de la factura
				UPDATE [dbo].[Factura]
				   SET [SubtotalSinImpuestos] = @TotalSinImp
					  ,[SubtotalConImpuestos] = @TotalSinImp * 1.13
					  ,[MultaPorFactPend] = @MultaPorAtraso
					  ,[Total] = [SubtotalConImpuestos] + @MultaPorAtraso
				 WHERE ID = @IdfacturaActual




				 --para la fecha de vencimiento y el cobro extra, se saca de los tipo tarifa
			END;



			SET @lo=@lo+1;	
		END;


	--trazabilidad
	--INSERT INTO dbo.BitacoraEvento (idTipoEvento, Descripcion, IdPostByUser, PostInIP, PostTime)
	--VALUES (5, @Descripcion , @IdUser, @inPostInIP, GETDATE());

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