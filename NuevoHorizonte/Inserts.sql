-- Insertar datos en la tabla Ciclos
INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (1, 'Grado Iniciación');

INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (2, 'Grado Medio');

INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (3, 'Grado Superior');


---Insertar datos del sp Ciclo-Asignatura
EXEC InsertarAsignaturaCiclo 
    @codigo_asignatura_ciclo = 1,  -- Reemplaza con el valor deseado
    @codigo_interno_asignatura = 'MAT102',  -- Código interno de la asignatura existente
    @codigo_interno_central_ciclo = 2;  -- Código interno central del ciclo existente


--Insertar datos en la tabla Estudiante--
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1001, 'Oscar', 'Zuñiga', 'Sanchez', 'oscar@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1002, 'Juan', 'Perez', 'Gomez', 'juan@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1003, 'Maria', 'Juarez', 'Lopez', 'maria@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1004, 'Pedro', 'Barraza', 'Carrera', 'pedro@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1005, 'Jersson', 'Villafuerte', 'Moraga', 'jersson@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1006, 'Fabiola', 'Vallejos', 'Aguilar', 'fabiola@gmail.com');

-- Insertar datos en la tabla Profesores
INSERT INTO Profesores(Codigo_interno, Nombre, Dirección, Telefono, Email, DNI, Num_Seguridad_Social)
VALUES (1, 'Martha', 'Nicoya, Guanacaste', 70078912, 'Martha@gmail.com', 12345678, 987654321),
       (2, 'Pedro', 'Cabo blanco, Puntarenas', 65673030, 'Pedro@gmail.com', 87654321, 123456789),
	   (3, 'Rosa', 'Upala, Alajuela', 89807007, 'Rosa@gmail,com', 2341334, 4456788);
GO

-- Insertar nombramientos--
-- Ejemplo de ejecución del procedimiento almacenado
EXEC SP_InsertarNombramientoProfesor 
    @CodigoNombramiento = 1, 
    @NombreNombramiento = 'Profesor', 
    @FechaInicio = '2020-01-01', 
    @FechaFin = '2021-01-01', 
    @CodigoProfesor = 1;

EXEC SP_InsertarNombramientoProfesor 
    @CodigoNombramiento = 2, 
    @NombreNombramiento = 'Tutor', 
    @FechaInicio = '2021-01-02', 
    @FechaFin = '2022-01-01', 
    @CodigoProfesor = 2;

EXEC SP_InsertarNombramientoProfesor 
    @CodigoNombramiento = 3, 
    @NombreNombramiento = 'Tutor', 
    @FechaInicio = '2022-01-02', 
    @FechaFin = '2023-01-01', 
    @CodigoProfesor = 3;

	---Calcular años impartiendo--
EXEC SP_CalcularAniosImpartiendos @CodigoProfesor = 1, @CodigoNombramiento = 1, @CodigoInternoCentral = 1;
EXEC SP_CalcularAniosImpartiendos @CodigoProfesor = 2, @CodigoNombramiento = 2, @CodigoInternoCentral = 1;
EXEC SP_CalcularAniosImpartiendos @CodigoProfesor = 3, @CodigoNombramiento = 3, @CodigoInternoCentral = 1;
EXEC SP_CalcularAniosImpartiendos @CodigoProfesor = 4, @CodigoNombramiento = 5, @CodigoInternoCentral = 4;
GO

--Insertar una carrera--
EXEC SP_InsertarCarrera @CodigoCarrera = 1, @Nombre = 'Ingeniería Informática';
EXEC SP_InsertarCarrera @CodigoCarrera = 2, @Nombre = 'Medicina';

--Insert tabla ASIGNATURA
INSERT INTO ASIGNATURA (Codigo_Interno_Central, Nombre, Codigo_europeo)
VALUES 
    ('MAT101', 'Matemáticas I', 101),
    ('MAT102', 'Matemáticas II', 102 ),
	    ('FIS101', 'Fisica', 103 ),
		    ('QUI101', 'Quimica', 104 );


INSERT INTO REQUISITO (NOMBRE_REQUISITO)
VALUES 
    ('Matemáticas I es requisito de Matemáticas II');

INSERT INTO ASIGNATURA_REQUISITO (CODIGO_ASIGNATURA, CODIGO_REQUISITO)
VALUES 
    ('MAT102', 'MAT101'); -- Matemáticas II requiere Matemáticas I

	--Insertar Matricula--
	EXEC Sp_MatricularEstudiante @cedula = 1005, @codigo_asignatura = 'MAT101';

	delete from MATRICULA
--Insertar una matricula--
use Nuevo_Horizonte
go
EXEC Sp_MatricularEstudiante @cedula = 1006, @codigo_asignatura = 'MAT101';
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
DBCC CHECKIDENT ('Requisito', RESEED, 0);
select * from MATRICULA

USE Nuevo_Horizonte;
GO
SELECT * FROM AULA;


-- Insertar un registro válido
EXEC InsertarAsignacionAula
    @CodigoInternoCentral = 'A123',
    @NombreAsignatura = 'Matemáticas',
    @CodigoEuropeo = 101,
    @Dia = 'Lunes',
    @Hora = 'Primera Hora',
    @CodigoAula = 1,
    @NombreAula = 'Aula 101',
    @NumAula = 101,
    @MetrosAula = 30.5;

EXEC InsertarAsignacionAula
    @CodigoInternoCentral = 'B2',
    @NombreAsignatura = 'Biología',
    @CodigoEuropeo = 105,
    @Dia = 'Lunes',
    @Hora = 'Primera Hora',
    @CodigoAula = 2,
    @NombreAula = 'Aula 101',
    @NumAula = 101,
    @MetrosAula = 30.5;

EXEC InsertarAsignacionAula
    @CodigoInternoCentral = 'Qui4',
    @NombreAsignatura = 'Química',
    @CodigoEuropeo = 105,
    @Dia = 'Lunes',
    @Hora = 'Sexta Hora',
    @CodigoAula = 3,
    @NombreAula = 'Aula 101',
    @NumAula = 101,
    @MetrosAula = 30.5;

-- Intentar insertar un registro con un aula ya reservada
EXEC InsertarAsignacionAula
    @CodigoInternoCentral = 'A124',
    @NombreAsignatura = 'Historia',
    @CodigoEuropeo = 102,
    @Dia = 'Lunes',
    @Hora = 'Primera Hora',
    @CodigoAula = 1,
    @NombreAula = 'Aula 101',
    @NumAula = 101,
    @MetrosAula = 30.5;

-- Intentar insertar un registro con una hora inválida
EXEC InsertarAsignacionAula
    @CodigoInternoCentral = 'A125',
    @NombreAsignatura = 'Ciencias',
    @CodigoEuropeo = 103,
    @Dia = 'Martes',
    @Hora = 'Séptima Hora',
    @CodigoAula = 2,
    @NombreAula = 'Aula 102',
    @NumAula = 102,
    @MetrosAula = 40.0;



-- Ejemplo de uso del procedimiento almacenado
EXEC InsertarAsignaturaCiclo @codigo_asignatura_ciclo = 12, @codigo_interno_asignatura = 'MAT101', @codigo_interno_central_ciclo = 2;

EXEC InsertarAsignaturaCiclo @codigo_asignatura_ciclo = 10, @codigo_interno_asignatura = 'B2' , @codigo_interno_central_ciclo = 2;

EXEC InsertarAsignaturaCiclo @codigo_asignatura_ciclo = 12, @codigo_interno_asignatura = 'B2', @codigo_interno_central_ciclo = 3;


select * from ESTUDIANTE
select * from PROFESORES
select * from ASIGNATURA
select * from AULA
select * from CICLO
select * from Carrera
select * from REQUISITO
select * from NOMBRAMIENTO
select * from MATRICULA

select * from NOMBRAMIENTO