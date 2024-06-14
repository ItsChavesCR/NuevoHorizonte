--------------------------------------Insert-------------------------------------------------------------------------
-------------------------------------Verificar Procedimiento Almacenado-------------------------------------------------

--Ver asignatura

EXEC SP_AsignarProfesorAsignatura @CodigoInternoProfesor = 1, @CodigoInternoCentral = 'MAT101';
EXEC SP_AsignarProfesorAsignatura @CodigoInternoProfesor = 2, @CodigoInternoCentral = 'MAT101';


-- Insertar datos en la tabla Profesores
INSERT INTO Profesores(Codigo_interno, Nombre, Dirección, Telefono, Email, DNI, Num_Seguridad_Social)
VALUES (1, 'Martha Lopez', 'Nicoya, Guanacaste', 70078912, 'Martha@gmail.com', 12345678, 987654321),
       (2, 'Pedro Perez', 'Cabo blanco, Puntarenas', 65673030, 'Pedro@gmail.com', 87654321, 123456789),
	   (3, 'Rosa Aguilar', 'Upala, Alajuela', 89807007, 'Rosa@gmail,com', 2341334, 4456788);
GO

--Insert tabla ASIGNATURA
INSERT INTO ASIGNATURA (Codigo_Interno_Central, Nombre, Codigo_europeo, Dia, Hora)
VALUES 
    ('ASG1', 'Matemáticas', 101, '2024-06-10', '10:00:00'),
    ('ASG2', 'Ciencias', 102, '2024-06-11', '11:00:00');


-- Insertar nombramientos y relacionar profesor con asignatura
EXEC SP_InsertarNombramientoProfesor @CodigoNombramiento = 1, @FechaInicio = '2020-01-01', @FechaFin = '2021-01-01', @CodigoProfesor = 1, @CodigoInternoCentral = 1;
EXEC SP_InsertarNombramientoProfesor @CodigoNombramiento = 2, @FechaInicio = '2021-01-02', @FechaFin = '2022-01-01', @CodigoProfesor = 1, @CodigoInternoCentral = 2;
EXEC SP_InsertarNombramientoProfesor @CodigoNombramiento = 3, @FechaInicio = '2022-01-02', @FechaFin = '2023-01-01', @CodigoProfesor = 2, @CodigoInternoCentral = 1;
EXEC SP_InsertarNombramientoProfesor @CodigoNombramiento = 4, @FechaInicio = '2023-01-02', @FechaFin = '2024-01-01', @CodigoProfesor = 3, @CodigoInternoCentral = 3;
EXEC SP_InsertarNombramientoProfesor @CodigoNombramiento = 5, @FechaInicio = '2023-01-02', @FechaFin = '2024-01-01', @CodigoProfesor = 4, @CodigoInternoCentral = 4;

GO

-- Intentar insertar un nombramiento ya activo
EXEC SP_InsertarNombramientoProfesor @CodigoNombramiento = 4, @FechaInicio = '2020-06-01', @FechaFin = '2020-12-31', @CodigoProfesor = 1, @CodigoInternoCentral = 1;
GO

-- Calcular años impartidos
EXEC SP_CalcularAniosImpartiendo @CodigoProfesor = 1, @CodigoNombramiento = 1, @CodigoInternoCentral = 1;
EXEC SP_CalcularAniosImpartiendo @CodigoProfesor = 2, @CodigoNombramiento = 3, @CodigoInternoCentral = 1;
EXEC SP_CalcularAniosImpartiendo @CodigoProfesor = 3, @CodigoNombramiento = 4, @CodigoInternoCentral = 3;
EXEC SP_CalcularAniosImpartiendo @CodigoProfesor = 4, @CodigoNombramiento = 5, @CodigoInternoCentral = 4;
GO

-- Insertar una nueva carrera
EXEC SP_InsertarCarrera @CodigoCarrera = 1, @Nombre = 'Ingeniería Informática';
EXEC SP_InsertarCarrera @CodigoCarrera = 2, @Nombre = 'Medicina';
