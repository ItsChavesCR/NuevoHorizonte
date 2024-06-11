use Nuevo_Horizonte 
go
CREATE TRIGGER TRG_InsertarEstudiante
ON ESTUDIANTE
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar si el correo electrónico ya existe en la tabla ESTUDIANTE
    IF EXISTS (
        SELECT 1 
        FROM ESTUDIANTE e
        JOIN inserted i ON i.EMAIL = e.EMAIL
    )
    BEGIN
        RAISERROR ('Ya existe un estudiante con el mismo correo electrónico.', 16, 1);
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO ESTUDIANTE (Cedula, Nombre, Ape1, Ape2, EMAIL)
        SELECT Cedula, Nombre, Ape1, Ape2, EMAIL
        FROM inserted;
        PRINT 'Estudiante registrado exitosamente';
    END
END;
GO


-- Trigger para eliminar matrícula
use Nuevo_Horizonte
GO
CREATE TRIGGER TRG_EliminarEstudiante
ON ESTUDIANTE
AFTER DELETE
AS
BEGIN
    PRINT 'Estudiante eliminada exitosamente';
END;
GO

-- Trigger para modificar matrícula
use Nuevo_Horizonte
GO
CREATE TRIGGER TRG_ModificarEstudiante
ON ESTUDIANTE
AFTER UPDATE
AS
BEGIN
    PRINT 'Estudiante modificada exitosamente';
END;
GO

INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1002, 'Oscar', 'Zuñiga', 'Sanchez', 'o@gmail.com');

--Consultar todos los registros de los estudiantes--
use Nuevo_Horizonte
go
select * from ESTUDIANTE
go

--Modificar a un estudiante
use Nuevo_Horizonte
go
UPDATE ESTUDIANTE
SET Nombre = 'Juan', Ape1 = 'Peréz'
WHERE Cedula = 1002;
go

--Eliminar un Estudiante--
use Nuevo_Horizonte
go
Delete ESTUDIANTE
Where Cedula = 1002;
go
