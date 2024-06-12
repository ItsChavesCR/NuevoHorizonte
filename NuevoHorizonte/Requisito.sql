USE Nuevo_Horizonte;
GO

-- Insertar datos en la tabla Requisito
INSERT INTO Requisito (NOMBRE_REQUISITO) VALUES
('Fisica Basica'),
('Quimica Basica');

-- Insertar datos en la tabla Asignatura_Requisito
use Nuevo_Horizonte
go
INSERT INTO Asignatura_Requisito (CODIGO_ASIGNATURA, CODIGO_REQUISITO) VALUES
('F02', 'F01'),  -- Fisica requiere Fisica Basica
('Q02', 'Q01');  -- Quimica requiere Quimica Basica
go

use Nuevo_Horizonte
go
INSERT INTO Asignatura_Requisito (CODIGO_ASIGNATURA, CODIGO_REQUISITO) VALUES
('F02', 'M01');
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
    AND m.Cedula_Estudiante = @cedula;

    -- Contar el número de requisitos para la asignatura
    SELECT @total_requisitos = COUNT(*)
    FROM Asignatura_Requisito
    WHERE CODIGO_ASIGNATURA = @codigo_asignatura;

    -- Si el estudiante ha cumplido todos los requisitos, permitir la matrícula
    IF @count = @total_requisitos
    BEGIN
        -- Verificar si la matrícula ya existe
        IF EXISTS (SELECT 1 FROM Matricula WHERE Cedula_Estudiante = @cedula AND Codigo_Asignatura = @codigo_asignatura)
        BEGIN
            PRINT 'El estudiante ya está matriculado en esta asignatura';
        END
        ELSE
        BEGIN
            INSERT INTO Matricula (Cedula_Estudiante, Codigo_Asignatura, Estado)
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
EXEC Sp_MatricularEstudiante @cedula = 1001, @codigo_asignatura = 'F02';
go

--Eliminar una matricula
DELETE FROM MATRICULA
WHERE Codigo_Matricula = 1;

-- Modificar la matrícula del estudiante con la cédula 1003 y la asignatura 'F01'
UPDATE MATRICULA
SET Codigo_Asignatura = 'M01'
WHERE Codigo_Matricula = 3;

use Nuevo_Horizonte
go
select * from MATRICULA

--Consulta para saber cuantos estudiantes se matricularon por asignatura--
SELECT COUNT(*) AS TotalEstudiantesMatriculados
FROM Matricula
WHERE Codigo_Asignatura = 'Q01';

--Reinicar el codigo de asignatura_Requisito
DBCC CHECKIDENT ('Asignatura_Requisito', RESEED, 0);

