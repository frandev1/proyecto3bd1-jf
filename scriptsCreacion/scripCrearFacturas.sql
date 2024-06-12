--SELECT * FROM Cliente
--SELECT * FROM Contrato 
--SELECT * FROM TiposTarifa
--SELECT * FROM LlamadaTelefonica

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

	print('encuentra el id del cliente')

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
	DECLARE @fechaConstrtato DATE;

	DECLARE @fechaInicioFact DATE;

	DECLARE @IdfacturaActual int;

	DECLARE @FechaUltimaFactura DATE = '0001-1-1';

	DECLARE @NumeroActual BIGINT;
	DECLARE @TipoTarifaBase INT = 0;
	DECLARE @TarifaBase INT = 0;
	DECLARE @MinutosBase INT = 0;
	DECLARE @MinutosExtra INT = 0;
	DECLARE @MinutosFamiliares INT = 0;
	DECLARE @GigasBase INT = 0;
	DECLARE @GigasExtra INT = 0;
	DECLARE @CobroPor911 INT = 0;
	DECLARE @CobroPor110 INT = 0;
	DECLARE @CobroPor900 INT = 0;
	DECLARE @CobroPor800 INT = 0;
	DECLARE @Minutos911 INT = 0;
	DECLARE @Minutos110 INT = 0;
	DECLARE @Minutos900 INT = 0;
	DECLARE @Minutos800 INT = 0;

	DECLARE @TotalMinutosExtra INT = 0;
	DECLARE @TotalGigasBase INT = 0;
	DECLARE @TotalGigasExtra INT = 0;
	DECLARE @TotalMinutos911 INT = 0;
	DECLARE @TotalMinutos110 INT = 0;
	DECLARE @TotalMinutos900 INT = 0;
	DECLARE @TotalMinutos800 INT = 0;
	DECLARE @TotalSinImp INT = 0;
	DECLARE @MultaPorAtraso INT = 0;

	WHILE (@lo<=@hi)
		BEGIN
			print('inicia de nuevo el ciclo para un nuevo contrato')
			SELECT @NumeroActual = Numero, @diaContrato = DAY(fecha), @TipoTarifaBase = TipoTarifa, @fechaConstrtato = Fecha
			FROM @NumerosDeContrato
			WHERE ID = @lo

			print(@NumeroActual)

			SELECT @FechaUltimaFactura  = Fecha
			FROM Factura
			WHERE IdCliente = @IdCliente AND Fecha = CONVERT(DATE,@inFechaActual)
			ORDER BY Fecha DESC


			--valida si el dia de hoy se factura el contrato
			IF((@diaActual = @diaContrato) AND NOT(@FechaUltimaFactura > '0001-1-1') AND @inFechaActual >= DATEADD(MONTH,1,@fechaConstrtato))
			BEGIN
				PRINT('realiza la factura')

				IF(@NumeroActual < 80000000000)
				BEGIN
					--PRINT('inserta el encabezado')
					print(@IdCliente)
					print(CONVERT(DATE,@inFechaActual))

					--inserta el encabezado de la factura
					INSERT INTO dbo.Factura(
						IdCliente,
						Fecha,
						SubtotalSinImpuestos,
						SubtotalConImpuestos,
						MultaPorFactPend,
						Total,
						FechaPagada,
						IdEstado
						)
					VALUES(
						@IdCliente,
						CONVERT(DATE,@inFechaActual),
						0,
						0,
						0,
						0,
						'1-1-0001',
						1
						)

					--select * from factura

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

					--PRINT('inserta el detalle de la factura')
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


					--print('inserta los detalles de las llamadas')
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
					
					--print('inserta detalle en uso de datos')
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
							AND DiaConsumo < @inFechaActual
							AND DiaConsumo >= DATEADD(MONTH,-1,@inFechaActual)


					SELECT @MinutosExtra = SUM(COALESCE(D.QMinutos,0)) - @MinutosBase
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


					SELECT @GigasExtra = SUM(COALESCE(D.QDatosConsmidos,0)) - @GigasBase
					FROM dbo.DetalleUsoDatos D
					WHERE D.IdFactura = @IdfacturaActual
					GROUP BY D.IdFactura

					SET @GigasExtra = CASE 
						WHEN @GigasExtra < 0 THEN 0 
						ELSE @GigasExtra 
					END;


					SELECT @MinutosFamiliares = SUM(COALESCE(D.QMinutos,0))
					FROM dbo.DetalleLlamadas D
					WHERE D.IdFactura = @IdfacturaActual
						AND D.EsUnaLlamadaEntreFamiliares > 0
					GROUP BY D.IdFactura

					SELECT @Minutos800 = SUM(COALESCE(D.QMinutos,0))
					FROM dbo.DetalleLlamadas D
					WHERE D.IdFactura = @IdfacturaActual
						AND D.NumeroDeLlamada >= 80000000000
						AND D.NumeroDeLlamada < 90000000000
					GROUP BY D.IdFactura

					SELECT @Minutos900 = SUM(COALESCE(D.QMinutos,0))
					FROM dbo.DetalleLlamadas D
					WHERE D.IdFactura = @IdfacturaActual
						AND D.NumeroDeLlamada >= 90000000000
					GROUP BY D.IdFactura

					SELECT @Minutos911 = SUM(COALESCE(D.QMinutos,0))
					FROM dbo.DetalleLlamadas D
					WHERE D.IdFactura = @IdfacturaActual
						AND D.NumeroDeLlamada = 911
					GROUP BY D.IdFactura

					SELECT @Minutos110 = SUM(COALESCE(D.QMinutos,0))
					FROM dbo.DetalleLlamadas D
					WHERE D.IdFactura = @IdfacturaActual
						AND D.NumeroDeLlamada = 110
					GROUP BY D.IdFactura

					--print('acualiza el detalle de la factura')
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

					SET @TotalSinImp = @TarifaBase+
										@TotalMinutosExtra+
										@TotalGigasExtra+
										@TotalMinutos911+
										@TotalGigasExtra+
										@TotalMinutos900+
										@TotalMinutos800;
					/*
					IF EXISTS(SELECT 1 FROM dbo.Factura WHERE IdCliente = @IdCliente AND IdEstado = 1)
					BEGIN
						SELECT @MultaPorAtraso = Valor
						FROM dbo.ElementoDeTipoTarifa
						WHERE(IdTipoTarifa = @TipoTarifaBase) AND (IdTipoElemento = 8)
					END
					ELSE
					BEGIN
						SET @MultaPorAtraso = 0;
					END
					*/


					--print('actualiza el encabezado')
					--actualizar el encabezado de la factura
					UPDATE [dbo].[Factura]
						SET [SubtotalSinImpuestos] = @TotalSinImp
							,[SubtotalConImpuestos] = @TotalSinImp * 1.13
							,[MultaPorFactPend] = 0
							,[Total] = @TotalSinImp * 1.13 + @MultaPorAtraso
						WHERE ID = @IdfacturaActual




						--para la fecha de vencimiento y el cobro extra, se saca de los tipo tarifa
				END;
				ELSE
				BEGIN
					PRINT('realiza factra para nuumero 800 0 900')
				END;
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



-- TODO: Set parameter values here.

EXECUTE [dbo].[facturarCliente] 4997881,'2024-4-1','dd','1',0;

select * from Cliente
select * from Factura
select * from DetalleDeFactura
select * from DetalleLlamadas
select * from DetalleUsoDatos