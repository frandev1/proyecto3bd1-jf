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
	SELECT @IdUser = Id FROM dbo.Usuario WHERE UserName = @inNamePostbyUser;

	
	IF EXISTS (SELECT 1 FROM dbo.Cliente WHERE Identificacion = @inIdentificacion)
	BEGIN
		SET @OutResult = 50001;
		SELECT @Descripcion = Descripcion FROM dbo.Error WHERE Codigo = @OutResult;
		SET @Descripcion = @Descripcion +  ', ' + CONVERT(NVARCHAR(50), @inIdentificacion) + ', ' + @inNombre;

		PRINT 'El valorDocumentoIdentidad ya existe en la base de datos.';
	END;

	ELSE IF EXISTS (SELECT 1 FROM Cliente WHERE Nombre = @inNombre)
	BEGIN
		SET @OutResult = 50002;
		SELECT @Descripcion = Descripcion FROM Error WHERE Codigo = @OutResult;
		SET @Descripcion = @Descripcion + ', ' + CONVERT(NVARCHAR(50), @inIdentificacion) + ', ' + @inNombre;

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

			SET @Descripcion = CONVERT(NVARCHAR(50), @inIdentificacion) + ', ' + @inNombre;
			
		COMMIT TRANSACTION 
	END;

	--trazabilidad
	INSERT INTO dbo.BitacoraEvento (idTipoEvento, Descripcion, IdPostByUser, PostInIP, PostTime)
	VALUES (1, CONVERT(NVARCHAR(250),@Descripcion) , @IdUser, @inPostInIP, GETDATE());

END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0 
	BEGIN
		ROLLBACK TRANSACTION;
	END;
	
	SET @OutResult = 500010;   -- error en BD

END CATCH
SET NOCOUNT OFF;
END;


EXECUTE [dbo].[insertCliente] 623114,'Pedro Pascal','admin','12.4343.2',0;

select * from Cliente