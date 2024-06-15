
-------Procedimiento almacenado para insertar datos en Asignatura_Ciclo----------
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


-----------------------------------SP_InsertarAsignacionAula-------------

CREATE PROCEDURE SP_InsertarAsignacionAula
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

-------JOIN ----------
SELECT A.Codigo_Interno_Central, A.Nombre AS NombreAsignatura, A.Codigo_europeo, 
       AU.Dia, AU.Hora, AU.Codigo_aula, AU.Nombre AS NombreAula, AU.Num_aula, AU.Metros_aula
FROM ASIGNATURA A
JOIN AULA AU ON A.Codigo_Interno_Central = AU.Codigo_interno_asignatura;


----------------------------Procedimiento almacenado SP_InsertarNombramientoProfesor--------------------------------
CREATE PROCEDURE SP_InsertarNombramientoProfesor
    @CodigoNombramiento INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME,
    @CodigoProfesor INT,
    @CodigoInternoCentral VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

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

        -- Verificar si el Codigo_nombramiento ya existe
        IF EXISTS (SELECT 1 FROM NOMBRAMIENTO WHERE Codigo_nombramiento = @CodigoNombramiento)
        BEGIN
            PRINT 'El Código de Nombramiento ya existe. Por favor, use un código diferente.';
            RETURN;
        END

        -- Insertar el nuevo nombramiento
        INSERT INTO NOMBRAMIENTO (Codigo_nombramiento, fecha_inicio, fecha_fin)
        VALUES (@CodigoNombramiento, @FechaInicio, @FechaFin);

        -- Insertar el registro en la tabla Profesores_Nombramiento
        INSERT INTO Profesores_Nombramiento (Codigo_nombramiento, Codigo_interno)
        VALUES (@CodigoNombramiento, @CodigoProfesor);

        COMMIT TRANSACTION;
        PRINT '¡Nombramiento registrado correctamente!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END



-------------------------------------------------------------------------------------------------------------------
--------------------------Procedimiento almacenado SP_CalcularAniosImpartiendo-----------------------------------------
CREATE PROCEDURE SP_CalcularAniosImpartidos
    @CodigoProfesor INT,
    @CodigoNombramiento INT,
    @CodigoInternoCentral INT
AS
BEGIN
    DECLARE @FechaInicio DATETIME,
	@FechaFin DATETIME,
	@Anios INT, 
	@Meses INT,
	@TotalMeses INT;
    
    SELECT @FechaInicio = fecha_inicio, @FechaFin = fecha_fin
    FROM Nombramiento
    WHERE Codigo_nombramiento = @CodigoNombramiento;
    
    IF @FechaInicio IS NULL OR @FechaFin IS NULL
    BEGIN
        PRINT CONCAT('No se encontraron datos para el profesor con código interno ', @CodigoProfesor, ' y nombramiento ', @CodigoNombramiento);
        RETURN;
    END

    SET @TotalMeses = DATEDIFF(MONTH, @FechaInicio, @FechaFin);
    
    -- Si no se ha completado el último mes, restamos uno
    IF DAY(@FechaInicio) > DAY(@FechaFin)
    BEGIN
        SET @TotalMeses = @TotalMeses - 1;
    END

    SET @Anios = @TotalMeses / 12;
    SET @Meses = @TotalMeses % 12;

    UPDATE Profesores_Nombramiento
    SET AniosImpartiendo = @Anios
    WHERE Codigo_interno = @CodigoProfesor
        AND Codigo_nombramiento = @CodigoNombramiento;
    
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT CONCAT('No se encontró relación entre el profesor ', @CodigoProfesor, ' y el nombramiento ', @CodigoNombramiento, ' en Profesores_Nombramiento.');
    END
    ELSE
    BEGIN
        IF @Anios > 0 AND @Meses > 0
            PRINT CONCAT('El profesor con código interno ', @CodigoProfesor, ' ha impartido la asignatura durante ', @Anios, ' año(s) y ', @Meses, ' mes(es).');
        ELSE IF @Anios > 0
            PRINT CONCAT('El profesor con código interno ', @CodigoProfesor, ' ha impartido la asignatura durante ', @Anios, ' año(s).');
        ELSE IF @Meses > 0
            PRINT CONCAT('El profesor con código interno ', @CodigoProfesor, ' ha impartido la asignatura durante ', @Meses, ' mes(es).');
        ELSE
            PRINT CONCAT('El profesor con código interno ', @CodigoProfesor, ' ha impartido la asignatura por menos de un mes.');
    END
END

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

----------------------------------------------------------------------
-----------------------------Sp_MatricularEstudiante--------------
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
