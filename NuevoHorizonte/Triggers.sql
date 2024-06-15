------------------------------------------------------Triggers------------------------------------------------------
--------------------------------------Trigger Profesores-----------
------------------------------- Trigger TR_InsertarProfesorAsignatura----------------------------------------
CREATE TRIGGER TR_InsertarProfesorAsignatura
ON Profesores
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CodigoProfesor INT;
    DECLARE @DniProfesor INT;

    SELECT @CodigoProfesor = Codigo_interno, @DniProfesor = DNI
    FROM inserted;

    INSERT INTO PROFESOR_ASIGNATURA (Codigo_interno_profesor, Codigo_Interno_Central)
    VALUES (@CodigoProfesor, 1); 

    PRINT 'Registro insertado en la tabla PROFESOR_ASIGNATURA';
END
GO

--------Eliminar Profesor---------
Use Nuevo_Horizonte
Go
CREATE TRIGGER TRG_EliminarProfesor
ON PROFESORES
AFTER DELETE
AS
BEGIN
    PRINT 'Profesor eliminado exitosamente';
END;
GO

--------Modificar Profesor----------
Use Nuevo_Horizonte
GO
CREATE TRIGGER TRG_ModificarProfesor
ON PROFESORES
AFTER UPDATE
AS
BEGIN
    PRINT 'Profesor modificado exitosamente';
END;
GO

-----------------------------Trigger Matricula------------------
-----Eliminar Matricula----
Use Nuevo_Horizonte
Go
CREATE TRIGGER TRG_EliminarMatricula
ON MATRICULA
AFTER DELETE
AS
BEGIN
    PRINT 'Matrícula eliminada exitosamente';
END;
GO

------Modificar matrícula------
Use Nuevo_Horizonte
GO
CREATE TRIGGER TRG_ModificarMatricula
ON MATRICULA
AFTER UPDATE
AS
BEGIN
    PRINT 'Matrícula modificada exitosamente';
END;
GO

-----------------------------Trigger Estudiante-------------------
----------Insertar Estudiante---------
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

----------Eliminar Estudiante-----------
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

------------Modificar Estudiante-------------
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



