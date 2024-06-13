-- Crear la base de datos


CREATE DATABASE Nuevo_Horizonte;
GO

-- Usar la base de datos recién creada
USE Nuevo_Horizonte;
GO


-- Insertar datos en la tabla Ciclos
INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (1, 'Grado Superior');

INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (2, 'Grado Superior');



-- Insertar datos en la tabla Asignatura_Ciclo
INSERT INTO CICLO_ASIGNATURA(Id_CicloAsignatura, CodigoAsignatura, CodigoCiclo)
VALUES (1, 'B1', 1);  -- Esto funcionará



USE Nuevo_Horizonte
-- Crear procedimiento almacenado para insertar datos en Asignatura_Ciclo
CREATE PROCEDURE InsertarAsignaturaCiclo
    @codigo_asignatura_ciclo INT,
    @codigo_interno_asignatura Varchar(50),
    @codigo_interno_central_ciclo INT
AS
BEGIN
    -- Verificar si la asignatura existe
    IF EXISTS (SELECT 1 FROM Asignatura WHERE Codigo_Interno_Central = @codigo_interno_asignatura)
    BEGIN
        -- Verificar si el ciclo existe
        IF EXISTS (SELECT 1 FROM CICLO WHERE CodigoInterno_Central = @codigo_interno_central_ciclo)
        BEGIN
            -- Insertar en Asignatura_Ciclo si no existe la combinación única
            IF NOT EXISTS (SELECT 1 FROM CICLO_ASIGNATURA WHERE CodigoAsignatura = @codigo_interno_asignatura AND CodigoCiclo = @codigo_interno_central_ciclo)
            BEGIN
                INSERT INTO CICLO_ASIGNATURA(Id_CicloAsignatura, CodigoAsignatura, CodigoCiclo)
                VALUES (@codigo_asignatura_ciclo, @codigo_interno_asignatura, @codigo_interno_central_ciclo);
            END
            ELSE
            BEGIN
                PRINT 'La combinación de asignatura y ciclo ya existe.';
            END
        END
        ELSE
        BEGIN
            PRINT 'El ciclo no existe.';
        END
    END
    ELSE
    BEGIN
        PRINT 'La asignatura no existe.';
    END
END;
GO

SELECT * FROM ASIGNATURA
SELECT * FROM CICLO_ASIGNATURA

-- Ejemplo de uso del procedimiento almacenado
EXEC InsertarAsignaturaCiclo @codigo_asignatura_ciclo = 12, @codigo_interno_asignatura = 'MAT101', @codigo_interno_central_ciclo = 2;

EXEC InsertarAsignaturaCiclo @codigo_asignatura_ciclo = 10, @codigo_interno_asignatura = 'B2' , @codigo_interno_central_ciclo = 2;

EXEC InsertarAsignaturaCiclo @codigo_asignatura_ciclo = 12, @codigo_interno_asignatura = 'B2', @codigo_interno_central_ciclo = 3;

