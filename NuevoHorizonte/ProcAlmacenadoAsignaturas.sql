

use Nuevo_Horizonte
go 

CREATE PROCEDURE InsertarAsignaturaHORARIO
    @Nombre VARCHAR(25),
    @Codigo_Asignatura VARCHAR(25),
    @Dia NVARCHAR(25),
    @Hora VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
   
    DECLARE @Count INT

    -- Validar etiquetas de hora
    IF @Hora NOT IN ('Primera Hora', 'Segunda Hora', 'Tercera Hora', 'Cuarta Hora', 'Quinta Hora', 'Sexta Hora')
    BEGIN
        RAISERROR ('La etiqueta de la hora es inválida. Use "Primera Hora", "Segunda Hora". Solo se permiten seis horas por dia', 16, 1);
	
        RETURN;
    END

    -- Verificar si ya existe una asignatura para esa hora y día
    IF EXISTS (SELECT 1 FROM Asignaturas WHERE Dia = @Dia AND Hora = @Hora)
    BEGIN
        RAISERROR ('Ya existe una asignatura para esa hora y día.', 16, 1);
        RETURN;
    END

 

    -- Insertar la nueva asignatura
    BEGIN TRY
        INSERT INTO Asignaturas (CODIGO_ASIGNATURA, Nombre, Dia, Hora)
        VALUES (@Codigo_Asignatura, @Nombre, @Dia, @Hora);
       
    END TRY
    BEGIN CATCH
        RAISERROR ('Error al registrar la asignatura. Verifique los datos e intente nuevamente. ', 16, 1);
    END CATCH
END;
GO


drop procedure InsertarAsignaturaHORARIO

USE Nuevo_Horizonte
GO 
SELECT * from Asignaturas

-- Intentar insertar asignaturas con diferentes casos

-- Caso exitoso
EXEC InsertarAsignaturaHORARIO 
    @Nombre = 'Matematicas',
    @Codigo_Asignatura = 'MAT101',
    @Dia = 'Lunes',
    @Hora = 'Primera Hora';  -- Exitoso
	



-- Caso con etiqueta de hora inválida
EXEC InsertarAsignaturaHORARIO
    @Nombre = 'Ciencias',
    @Codigo_Asignatura = 'CI101',
    @Dia = 'Lunes',
    @Hora = '1';  -- Error: La etiqueta de la hora es inválida

-- Caso con asignatura ya existente para la misma hora y día
EXEC InsertarAsignaturaHORARIO 
    @Nombre = 'Quimica',
    @Codigo_Asignatura = 'QU101',
    @Dia = 'Lunes',
    @Hora = 'Primera Hora';  -- Error: Ya existe una asignatura para esa hora y día

-- Caso con más de seis asignaturas en el mismo día
EXEC InsertarAsignaturaHORARIO 
    @Nombre = 'Arte',
    @Codigo_Asignatura = 'ART101',
    @Dia = 'Lunes',
    @Hora = 'Segunda Hora';  -- Exitoso


EXEC InsertarAsignaturaHORARIO
    @Nombre = 'Historia',
    @Codigo_Asignatura = 'HIST101',
    @Dia = 'Lunes',
    @Hora = 'Tercera Hora';  -- Exitoso


EXEC InsertarAsignaturaHORARIO
    @Nombre = 'Biologia',
    @Codigo_Asignatura = 'Bio22',
    @Dia = 'Lunes',
    @Hora = 'Cuarta Hora';  -- Exitoso



EXEC InsertarAsignaturaHORARIO 
    @Nombre = 'Geografia',
    @Codigo_Asignatura = 'GEO101',
    @Dia = 'Lunes',
    @Hora = 'Quinta Hora';  -- Exitoso
EXEC InsertarAsignaturaHORARIO 
    @Nombre = 'Literatura',
    @Codigo_Asignatura = 'LIT101',
    @Dia = 'Lunes',
    @Hora = 'Sexta Hora';  -- Exitoso

	EXEC InsertarAsignaturaHORARIO 
    @Nombre = 'Literatura',
    @Codigo_Asignatura = 'LIT101',
    @Dia = 'Lunes',
    @Hora = 'Septima Hora'; -- Error: No se pueden asignar más de seis horas en el mismo día

