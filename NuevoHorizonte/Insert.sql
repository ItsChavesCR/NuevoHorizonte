--------------------------------------Insert-------------------------------------------------------------------------

-- Insertar  Profesores
INSERT INTO PROFESORES(Codigo_interno, Nombre, Dirección, Telefono, Email, DNI, Num_Seguridad_Social)
VALUES (1, 'Martha Lopez', 'Nicoya, Guanacaste', 70078912, 'Martha@gmail.com', 12345678, 987654321),
       (2, 'Pedro Perez', 'Cabo blanco, Puntarenas', 65673030, 'Pedro@gmail.com', 87654321, 123456789),
	   (3, 'Rosa Aguilar', 'Upala, Alajuela', 89807007, 'Rosa@gmail,com', 2341334, 4456788);
GO

----Modificar Profesor 
use Nuevo_Horizonte
go
UPDATE PROFESORES
SET Nombre = 'Juan Gomez', Email= 'Juan@gmail.com'
WHERE Codigo_interno = 3;
go

-----Eliminar Profesor 
use Nuevo_Horizonte
go
Delete PROFESORES
Where Codigo_interno = 1;
go


--Insertar datos en la tabla Estudiante--
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1001, 'Oscar', 'Zuñiga', 'Sanchez', 'oscar@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1002, 'Juan', 'Perez', 'Gomez', 'juan@gmail.com');
INSERT INTO Estudiante (CEDULA, NOMBRE, APE1, APE2, EMAIL) VALUES
(1003, 'Maria', 'Juarez', 'Lopez', 'maria@gmail.com');

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


	--Insert tabla ASIGNATURA
INSERT INTO ASIGNATURA (Codigo_Interno_Central, Nombre, Codigo_europeo)
VALUES 
    ('MAT101', 'Matemáticas I', 101),
    ('MAT102', 'Matemáticas II', 102 ),
	    ('FIS101', 'Fisica', 103 ),
		    ('QUI101', 'Quimica', 104 ),


-- Insertar datos en la tabla Ciclos
INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (1, 'Grado Iniciación');

INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (2, 'Grado Medio');

INSERT INTO CICLO(CodigoInterno_Central, Nombre)
VALUES (3, 'Grado Superior');


-- Insertar datos en la tabla Asignatura_Ciclo
INSERT INTO CICLO_ASIGNATURA (Id_CicloAsignatura, CodigoAsignatura, CodigoCiclo)
VALUES (1, 'B1', 1);  


-----Insertar datos en la tabla Aula
USE Nuevo_Horizonte;
GO
INSERT INTO AULA (Codigo_aula, Nombre, Num_aula, Metros_aula)
VALUES (1, 'Aula 101', 101, 30.5);

INSERT INTO AULA (Codigo_aula, Nombre, Num_aula, Metros_aula)
VALUES (2, 'Aula 102', 102, 40.0);


--Insertar Requisito
INSERT INTO Requisito (NOMBRE_REQUISITO) VALUES
('Matematicas II');


-- Insertar datos en la tabla Asignatura_Requisito
use Nuevo_Horizonte
go
INSERT INTO Asignatura_Requisito (CODIGO_ASIGNATURA, CODIGO_REQUISITO) VALUES
('F02', 'F01'),  -- Fisica requiere Fisica Basica
('Q02', 'Q01');  -- Quimica requiere Quimica Basica
go

INSERT INTO Asignatura_Requisito (CODIGO_ASIGNATURA, CODIGO_REQUISITO) VALUES
('MAT102', 'MAT101');



-------------------------------------Verificar Procedimiento Almacenado-------------------------------------------------

----------------------Asinatura_Ciclo--------------
-- Ejemplo de uso del procedimiento almacenado
EXEC InsertarAsignaturaCiclo 
@codigo_asignatura_ciclo = 12, 
@codigo_interno_asignatura = 'MAT101', 
@codigo_interno_central_ciclo = 2;

EXEC InsertarAsignaturaCiclo 
@codigo_asignatura_ciclo = 10,
@codigo_interno_asignatura = 'B2' , 
@codigo_interno_central_ciclo = 2;

EXEC InsertarAsignaturaCiclo 
@codigo_asignatura_ciclo = 12, 
@codigo_interno_asignatura = 'B2',
@codigo_interno_central_ciclo = 3;

--------------Ver Asignatura_Profesor-------------------

EXEC SP_AsignarProfesorAsignatura 
@CodigoInternoProfesor = 1,
@CodigoInternoCentral = 'MAT101';

EXEC SP_AsignarProfesorAsignatura 
@CodigoInternoProfesor = 2, 
@CodigoInternoCentral = 'MAT101';

-----------Insertar nombramientos---------------------
EXEC SP_InsertarNombramientoProfesor 
@CodigoNombramiento = 1, 
@FechaInicio = '2020-01-01',
@FechaFin = '2021-01-01',
@CodigoProfesor = 1,
@CodigoInternoCentral = 1;

EXEC SP_InsertarNombramientoProfesor
@CodigoNombramiento = 2,
@FechaInicio = '2021-01-02', 
@FechaFin = '2022-01-01',
@CodigoProfesor = 1, 
@CodigoInternoCentral = 2;
GO
---------Intentar insertar un nombramiento ya activo
EXEC SP_InsertarNombramientoProfesor 
@CodigoNombramiento = 4, 
@FechaInicio = '2020-06-01', 
@FechaFin = '2020-12-31', 
@CodigoProfesor = 1, 
@CodigoInternoCentral = 1;

-- Calcular años impartidos
EXEC SP_CalcularAniosImpartidos 
@CodigoProfesor = 1, 
@CodigoNombramiento = 1,
@CodigoInternoCentral = 1;

EXEC SP_CalcularAniosImpartidos 
@CodigoProfesor = 2, 
@CodigoNombramiento = 3,
@CodigoInternoCentral = 1;

--------------Insertar una nueva carrera--------
EXEC SP_InsertarCarrera 
@CodigoCarrera = 1, 
@Nombre = 'Ingeniería Informática';

EXEC SP_InsertarCarrera 
@CodigoCarrera = 2, 
@Nombre = 'Medicina';

-------------InsertarAsignacionAula--------------------
-- Insertar un registro válido
EXEC SP_InsertarAsignacionAula
    @CodigoInternoCentral = 'A123',
    @NombreAsignatura = 'Matemáticas',
    @CodigoEuropeo = 101,
    @Dia = 'Lunes',
    @Hora = 'Primera Hora',
    @CodigoAula = 1,
    @NombreAula = 'Aula 101',
    @NumAula = 101,
    @MetrosAula = 30.5;

EXEC SP_InsertarAsignacionAula
    @CodigoInternoCentral = 'B2',
    @NombreAsignatura = 'Biología',
    @CodigoEuropeo = 105,
    @Dia = 'Lunes',
    @Hora = 'Primera Hora',
    @CodigoAula = 2,
    @NombreAula = 'Aula 101',
    @NumAula = 101,
    @MetrosAula = 30.5;

EXEC SP_InsertarAsignacionAula
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
EXEC SP_InsertarAsignacionAula
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
EXEC SP_InsertarAsignacionAula
    @CodigoInternoCentral = 'A125',
    @NombreAsignatura = 'Ciencias',
    @CodigoEuropeo = 103,
    @Dia = 'Martes',
    @Hora = 'Séptima Hora',
    @CodigoAula = 2,
    @NombreAula = 'Aula 102',
    @NumAula = 102,
    @MetrosAula = 40.0;



---------------------------AULA-----------------
-- Asignar la asignatura 'Matemáticas' al 'Aula 101' el 'Lunes' en la 'Primera' hora
USE Nuevo_Horizonte2;
GO
EXEC sp_GestionarOcupacionAula 
@Codigo_aula = 1, 
@Codigo_interno_asignatura = 1, 
@Dia = 'Lunes', @Hora = 'Primera';

-- Intentar asignar otra asignatura al mismo aula en el mismo horario para verificar la restricción
EXEC sp_GestionarOcupacionAula 
@Codigo_aula = 1, 
@Codigo_interno_asignatura = 2, 
@Dia = 'Lunes', 
@Hora = 'Primera';

-- Asignar la asignatura 'Historia' al 'Aula 102' el 'Martes' en la 'Segunda' hora
EXEC sp_GestionarOcupacionAula 
@Codigo_aula = 2, 
@Codigo_interno_asignatura = 2, 
@Dia = 'Martes',
@Hora = 'Segunda';

-- Verificar los datos actualizados en la tabla AULA
USE Nuevo_Horizonte2;
GO
SELECT * FROM AULA;


----------------------MATRICULA------------------------
--Insertar una matricula
use Nuevo_Horizonte
go
EXEC Sp_MatricularEstudiante 
@cedula = 1001, 
@codigo_asignatura = 'F02';
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
