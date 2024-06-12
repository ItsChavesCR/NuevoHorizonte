

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
