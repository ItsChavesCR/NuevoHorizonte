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

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Procedimieto Almacenados-------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- ----------------Procedimiento almacenado SP_InsertarNombramientoProfesor--------------------------------------
CREATE PROCEDURE SP_InsertarNombramientoProfesor
    @CodigoNombramiento INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME,
    @CodigoProfesor INT,
    @CodigoInternoCentral Varchar (50)
AS
BEGIN
    -- Verificar si el profesor ya tiene un nombramiento activo para la misma asignatura
    IF EXISTS (
        SELECT 1
        FROM Profesores_Nombramiento PN
        INNER JOIN Nombramiento N ON PN.Codigo_nombramiento = N.Codigo_nombramiento
        WHERE PN.Codigo_interno = @CodigoProfesor
            AND N.fecha_inicio <= @FechaFin
            AND N.fecha_fin >= @FechaInicio
    )
    BEGIN
        PRINT 'El profesor ya tiene un nombramiento activo para esta asignatura en el periodo especificado';
        RETURN;
    END

    -- Insertar el nuevo nombramiento
    INSERT INTO NOMBRAMIENTO (Codigo_nombramiento, fecha_inicio, fecha_fin)
    VALUES (@CodigoNombramiento, @FechaInicio, @FechaFin);

    -- Insertar el registro en la tabla Profesores_Nombramiento
    INSERT INTO Profesores_Nombramiento (Codigo_nombramiento, Codigo_interno)
    VALUES (@CodigoNombramiento, @CodigoProfesor);

    PRINT '¡Nombramiento registrado correctamente!';
END
GO

-------------------------------------------Sp_AniosImpartidos-----------------------------------------------------------
--Procedimiento almacenado SP_CalcularAniosImpartiendo
CREATE PROCEDURE SP_CalcularAniosImpartiendo
    @CodigoProfesor INT,
    @CodigoNombramiento INT,
    @CodigoInternoCentral INT
AS
BEGIN
    DECLARE @FechaInicio DATETIME, @AnioActual INT, @AniosImpartiendo INT;

    SELECT @FechaInicio = fecha_inicio
    FROM Nombramiento
    WHERE Codigo_nombramiento = @CodigoNombramiento;

    SET @AnioActual = YEAR(GETDATE());

    -- Calcular los años que el profesor ha impartido la asignatura
    SET @AniosImpartiendo = @AnioActual - YEAR(@FechaInicio);

    -- Actualizar la columna AniosImpartiendo en la tabla Profesores_Nombramiento
    UPDATE Profesores_Nombramiento
    SET AniosImpartiendo = @AniosImpartiendo
    WHERE Codigo_interno = @CodigoProfesor
        AND Codigo_nombramiento = @CodigoNombramiento;

    PRINT CONCAT('El profesor con código interno ', @CodigoProfesor, ' ha impartido la asignatura durante ', @AniosImpartiendo, ' años.');
END
GO

----------------------------------------------------Sp_ProfesorAsignatura-------------------------------------
-- Procedimiento almacenado SP_AsignarProfesorAsignatura
CREATE PROCEDURE SP_AsignarProfesorAsignatura
    @CodigoInternoProfesor INT,
    @CodigoInternoCentral VARCHAR(50)
AS
BEGIN
    DECLARE @NombreAsignatura VARCHAR(50);
    DECLARE @NombreProfesor VARCHAR(50);

    -- Verificar si el profesor ya está asignado a la asignatura
    IF EXISTS (
        SELECT 1
        FROM PROFESOR_ASIGNATURA
        WHERE Codigo_interno_profesor = @CodigoInternoProfesor
            AND Codigo_Interno_Central = @CodigoInternoCentral
    )
    BEGIN
        PRINT 'El profesor ya está asignado a esta asignatura.';
        RETURN;
    END

    -- Verificar si la asignatura ya está ocupada por otro profesor
    IF EXISTS (
        SELECT 1
        FROM PROFESOR_ASIGNATURA
        WHERE Codigo_Interno_Central = @CodigoInternoCentral
    )
    BEGIN
        -- Obtener el nombre de la asignatura
        SELECT @NombreAsignatura = Nombre
        FROM ASIGNATURA
        WHERE Codigo_Interno_Central = @CodigoInternoCentral;

        -- Obtener el nombre del profesor que ya está asignado
        SELECT @NombreProfesor = P.Nombre
        FROM PROFESOR_ASIGNATURA PA
        JOIN PROFESORES P ON PA.Codigo_interno_profesor = P.Codigo_interno
        WHERE PA.Codigo_Interno_Central = @CodigoInternoCentral;

        PRINT 'La asignatura ' + @NombreAsignatura + ' ya está ocupada por el profesor ' + @NombreProfesor + '.';
        RETURN;
    END

    -- Asignar la asignatura al profesor
    INSERT INTO PROFESOR_ASIGNATURA (Codigo_interno_profesor, Codigo_Interno_Central)
    VALUES (@CodigoInternoProfesor, @CodigoInternoCentral);

    PRINT 'Asignatura asignada correctamente al profesor.';
END
GO

---------------------------------------Sp_Carrera-----------------------------------------------------------
-- Procedimiento almacenado para insertar una nueva carrera
CREATE PROCEDURE SP_InsertarCarrera
    @CodigoCarrera INT,
    @Nombre VARCHAR(80)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Carrera WHERE Codigo_Carrera = @CodigoCarrera)
    BEGIN
        INSERT INTO Carrera (Codigo_Carrera, Nombre)
        VALUES (@CodigoCarrera, @Nombre);

        PRINT 'Carrera insertada correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'El código de carrera ya existe.';
    END
END
GO

------------------------------------Sp_OcupacionAula-----------------------------------------------------
CREATE PROCEDURE sp_GestionarOcupacionAula
    @Codigo_aula INT,
    @Codigo_interno_asignatura INT,
    @Dia VARCHAR(10),
    @Hora VARCHAR(20)
AS
BEGIN
    -- Verificar si el aula ya está ocupada en el mismo día y hora
    IF EXISTS (
        SELECT 1
        FROM AULA
        WHERE Codigo_aula = @Codigo_aula
        AND Dia = @Dia
        AND Hora = @Hora
    )
    BEGIN
        RAISERROR('El aula ya está ocupada en esta fecha y hora.', 16, 1);
        RETURN;
    END

    -- Actualizar o insertar la ocupación en la tabla AULA
    UPDATE AULA
    SET Codigo_interno_asignatura = @Codigo_interno_asignatura, Dia = @Dia, Hora = @Hora
    WHERE Codigo_aula = @Codigo_aula;

    -- Verificar si la actualización afectó alguna fila
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró el aula especificada.', 16, 1);
    END
END;
GO


-- Insertar datos en la tabla ASIGNATURA
USE Nuevo_Horizonte;
GO
INSERT INTO ASIGNATURA (Codigo_Interno_Central, Nombre, Codigo_europeo, Dia, Hora)
VALUES (1, 'Matemáticas', 1001, 'Lunes', 'Primera');

INSERT INTO ASIGNATURA (Codigo_Interno_Central, Nombre, Codigo_europeo, Dia, Hora)
VALUES (2, 'Historia', 1002, 'Martes', 'Segunda');


-- Insertar datos en la tabla AULA
USE Nuevo_Horizonte;
GO
INSERT INTO AULA (Codigo_aula, Nombre, Num_aula, Metros_aula)
VALUES (1, 'Aula 101', 101, 30.5);

INSERT INTO AULA (Codigo_aula, Nombre, Num_aula, Metros_aula)
VALUES (2, 'Aula 102', 102, 40.0);

-- Asignar la asignatura 'Matemáticas' al 'Aula 101' el 'Lunes' en la 'Primera' hora
USE Nuevo_Horizonte2;
GO
EXEC sp_GestionarOcupacionAula @Codigo_aula = 1, @Codigo_interno_asignatura = 1, @Dia = 'Lunes', @Hora = 'Primera';

-- Intentar asignar otra asignatura al mismo aula en el mismo horario para verificar la restricción
EXEC sp_GestionarOcupacionAula @Codigo_aula = 1, @Codigo_interno_asignatura = 2, @Dia = 'Lunes', @Hora = 'Primera';
-- Esto debería arrojar un error indicando que el aula ya está ocupada en esa fecha y hora

-- Asignar la asignatura 'Historia' al 'Aula 102' el 'Martes' en la 'Segunda' hora
EXEC sp_GestionarOcupacionAula @Codigo_aula = 2, @Codigo_interno_asignatura = 2, @Dia = 'Martes', @Hora = 'Segunda';

-- Verificar los datos actualizados en la tabla AULA
USE Nuevo_Horizonte2;
GO
SELECT * FROM AULA;
