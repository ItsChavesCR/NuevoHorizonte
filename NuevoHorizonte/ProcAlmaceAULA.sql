





drop database Nuevo_Horizonte
drop table AULA
drop table ASIGNATURA
drop procedure InsertarAsignacionAula


CREATE TABLE AULA
(
Codigo_aula  INT NOT NULL,
Nombre VARCHAR (50) NOT NULL,
Num_aula  INT NOT NULL, 
Metros_aula FLOAT NOT NULL,
Dia varchar(50) NULL,
Hora varchar(50) NOT NULL,
Codigo_interno_asignatura  varchar(50) NOT NULL, 
CONSTRAINT PK_Codigo_aula
PRIMARY KEY (Codigo_aula) ,
FOREIGN KEY (Codigo_interno_asignatura) REFERENCES  ASIGNATURA (Codigo_Interno_Central) 
)
GO


CREATE TABLE ASIGNATURA (
    Codigo_Interno_Central VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Codigo_europeo INT NOT NULL,
    CONSTRAINT PK_ASIGNATURA PRIMARY KEY (Codigo_Interno_Central)
);
GO


CREATE PROCEDURE InsertarAsignacionAula
    @CodigoInternoCentral VARCHAR(50),
    @NombreAsignatura VARCHAR(50),
    @CodigoEuropeo INT,
    @Dia VARCHAR(50),
    @Hora VARCHAR(50),
    @CodigoAula INT,
    @NombreAula VARCHAR(50),
    @NumAula INT,
    @MetrosAula FLOAT
AS
BEGIN
    -- Verificar si la hora es válida
    IF @Hora NOT IN ('Primera Hora', 'Segunda Hora', 'Tercera Hora', 'Cuarta Hora', 'Quinta Hora', 'Sexta Hora')
    BEGIN
        RAISERROR ('La etiqueta de la hora es inválida. Use "Primera Hora", "Segunda Hora". Solo se permiten seis horas por día', 16, 1);
        RETURN;
    END

    -- Verificar si el aula ya está ocupada en el mismo día y hora
    IF EXISTS (
        SELECT 1
        FROM AULA
        WHERE Dia = @Dia AND Hora = @Hora AND @NumAula = @NumAula
    )
    BEGIN
        RAISERROR ('Error: El aula ya está reservada para ese día y esa hora.', 16, 1);
        RETURN;
    END

    -- Insertar en la tabla ASIGNATURA si no existe
    IF NOT EXISTS (
        SELECT 1
        FROM ASIGNATURA
        WHERE Codigo_Interno_Central = @CodigoInternoCentral
    )
    BEGIN
        INSERT INTO ASIGNATURA (Codigo_Interno_Central, Nombre, Codigo_europeo)
        VALUES (@CodigoInternoCentral, @NombreAsignatura, @CodigoEuropeo);
    END

    -- Insertar en la tabla AULA
    INSERT INTO AULA (Codigo_aula, Nombre, Num_aula, Metros_aula, Dia, Hora, Codigo_interno_asignatura)
    VALUES (@CodigoAula, @NombreAula, @NumAula, @MetrosAula, @Dia, @Hora, @CodigoInternoCentral);

    RAISERROR ('Registrado con éxito.', 16, 1);
END
GO 



SELECT A.Codigo_Interno_Central, A.Nombre AS NombreAsignatura, A.Codigo_europeo, 
       AU.Dia, AU.Hora, AU.Codigo_aula, AU.Nombre AS NombreAula, AU.Num_aula, AU.Metros_aula
FROM ASIGNATURA A
JOIN AULA AU ON A.Codigo_Interno_Central = AU.Codigo_interno_asignatura;



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
