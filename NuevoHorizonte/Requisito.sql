USE Nuevo_Horizonte;
GO

INSERT INTO ASIGNATURA (Codigo_Interno_Central, Codigo_europeo, Nombre, Dia, Hora) VALUES
('MAT01', 01, 'Matematicas I', 'Lunes', 'Primera'),
('MAT02', 02, 'Matematicas II', 'Martes', 'Segunda');
-- Insertar datos en la tabla Requisito
INSERT INTO Requisito (NOMBRE_REQUISITO) VALUES
('Matematicas I');

-- Insertar datos en la tabla Asignatura_Requisito
use Nuevo_Horizonte
go
INSERT INTO Asignatura_Requisito ( CODIGO_ASIGNATURA_REQUISITO, CODIGO_ASIGNATURA, CODIGO_REQUISITO) VALUES
(1, 'MAT02', 'MAT01'); --MATEMATICAS II REQUIERE MATEMATICAS I
go

CREATE PROCEDURE Sp_MatricularEstudiante
    @cedula INT,
    @codigo_asignatura VARCHAR(25)
AS
BEGIN
    DECLARE @count INT;
    DECLARE @total_requisitos INT;

    -- Comprobar si el estudiante cumple con los requisitos
    SELECT @count = COUNT(*)
    FROM Asignatura_Requisito ar
    JOIN Matricula m ON ar.CODIGO_REQUISITO = m.Codigo_Asignatura
    WHERE ar.CODIGO_ASIGNATURA = @codigo_asignatura
    AND m.Estudiante_Cedula = @cedula;

    -- Contar el número de requisitos para la asignatura
    SELECT @total_requisitos = COUNT(*)
    FROM Asignatura_Requisito
    WHERE CODIGO_ASIGNATURA = @codigo_asignatura;

    -- Si el estudiante ha cumplido todos los requisitos, permitir la matrícula
    IF @count = @total_requisitos
    BEGIN
        -- Verificar si la matrícula ya existe
        IF EXISTS (SELECT 1 FROM Matricula WHERE Estudiante_Cedula = @cedula AND Codigo_Asignatura = @codigo_asignatura)
        BEGIN
            PRINT 'El estudiante ya está matriculado en esta asignatura';
        END
        ELSE
        BEGIN
            INSERT INTO Matricula (Estudiante_Cedula, Codigo_Asignatura, Estado)
            VALUES (@cedula, @codigo_asignatura, 1);  
			 PRINT 'Matricula registrada exitosamente';
        END
    END
    ELSE
    BEGIN
        PRINT 'No cumple con los requisitos';
    END
END;


-- Trigger para eliminar matrícula
CREATE TRIGGER TRG_EliminarMatricula
ON MATRICULA
AFTER DELETE
AS
BEGIN
    PRINT 'Matrícula eliminada exitosamente';
END;
GO

-- Trigger para modificar matrícula
CREATE TRIGGER TRG_ModificarMatricula
ON MATRICULA
AFTER UPDATE
AS
BEGIN
    PRINT 'Matrícula modificada exitosamente';
END;
GO

--Insertar una matricula
use Nuevo_Horizonte
go
EXEC Sp_MatricularEstudiante @cedula = 1002, @codigo_asignatura = 'MAT02';
go

--Eliminar una matricula
DELETE FROM MATRICULA
WHERE Codigo_Matricula = 4;

-- Modificar la matrícula del estudiante con la cédula 1003 y la asignatura 'F01'
UPDATE MATRICULA
SET Codigo_Asignatura = 'MAT01'
WHERE Codigo_Matricula = 3;

use Nuevo_Horizonte
go
select * from MATRICULA

--Consulta para saber cuantos estudiantes se matricularon por asignatura--
SELECT COUNT(*) AS TotalEstudiantesMatriculados
FROM Matricula
WHERE Codigo_Asignatura = 'Q01';

--Reinicar el codigo de asignatura_Requisito
DBCC CHECKIDENT ('MATRICULA', RESEED, 0);