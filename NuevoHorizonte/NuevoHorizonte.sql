
USE MASTER
GO 
CREATE DATABASE Nuevo_Horizonte
ON PRIMARY
(NAME = 'Nuevo_Horizonte_data',
FILENAME = 'C:\SQLData\Nuevo_Horizonte_data.Mdf',
SIZE = 20MB,
MAXSIZE = 50MB,
FILEGROWTH= 2MB)

LOG ON
(NAME = 'Nuevo_Horizonte_Log',
FILENAME = 'C:\SQLLog\Nuevo_Horizonte_Log.Ldf',
SIZE = 5MB,
MAXSIZE = 10MB,
FILEGROWTH= 1MB)
GO

--Aaron y Gene

CREATE TABLE AULA
(
Codigo_aula  INT,
Nombre VARCHAR (50) NOT NULL,
Num_aula  INT, 
Metros_aula FLOAT,
Codigo_interno_asignatura  INT, 
)
GO

USE Nuevo_Horizonte
GO
ALTER TABLE AULA
ADD CONSTRAINT PK_Aula_Codigo_aula
 PRIMARY KEY (Codigo_aula) 
GO

USE Nuevo_Horizonte
GO
ALTER TABLE AULA
ADD CONSTRAINT FK_Aula_Asignatura
FOREIGN KEY (Codigo_interno_asignatura)
REFERENCES  Asignatura (Codigo_interno) 
Go





CREATE TABLE PROFESORES
(
Codigo_interno INT,
Nombre VARCHAR(50),
Dirección VARCHAR(50),
Telefono INT,
Email VARCHAR(50),
DNI INT,
Num_Seguridad_Social INT
)
GO


USE Nuevo_Horizonte
GO
ALTER TABLE PROFESORES
ADD CONSTRAINT PK_codigo_interno
PRIMARY KEY (codigo_interno)
GO

execute sp_help Profesores


CREATE TABLE NOMBRAMIENTO
(
Codigo_nombramieto  INT,
fecha_inicio DATETIME,
fecha_fin DATETIME,
)
GO

USE Nuevo_Horizonte
GO
ALTER TABLE NOMBRAMIENTO
ADD CONSTRAINT PK_codigo_nombramiento
PRIMARY KEY (codigo_nombramiento)
GO

execute sp_help NOMBRAMIENTO



USE Nuevo_Horizonte
GO
ALTER TABLE Profesor_nombramiento
ADD CONSTRAINT FK_Nombramiento_Profesor
FOREIGN KEY (Codigo_nombramiento)
REFERENCES  Nombramiento (Codigo_interno_profesor) 
Go

USE Nuevo_Horizonte
GO
ALTER TABLE Profesor_nombramiento
ADD CONSTRAINT FK_Profesor_nombramiento
FOREIGN KEY (Codigo_profesor)
REFERENCES Profesor (Codigo_nombramiento);
GO

CREATE TABLE PROFESORES_NOMBRAMIENTO
(
Codigo_PROFESORES_NOMBRAMIENTO INT,
Codigo_nombramieto  INT,
Codigo_interno INT
)
GO

USE Nuevo_Horizonte
GO
ALTER TABLE PROFESORES_NOMBRAMIENTO
ADD CONSTRAINT PK_codigo_PROFESORES_NOMBRAMIENTO
PRIMARY KEY (codigo_PROFESORES_NOMBRAMIENTO)
GO



------------------------------------------------------------------------------
--Roy y Gerald

--**********************************************************
USE Nuevo_Horizonte
CREATE TABLE ESTUDIANTE 
(Cedula  INT not null,
Nombre VARCHAR (50) not null,
Ape1  VARCHAR (50) not null, 
Ape2 VARCHAR (50) null,
Email VARCHAR (75) not null)
GO
--**********************************************************
USE Nuevo_Horizonte
CREATE TABLE ASIGNATURA 
(Codigo_Interno_Central  INT not null,
Nombre VARCHAR (50) not null,
Codigo_europeo int not null, 
Dia Date null,
Hora Time not null)
GO
--**********************************************************
USE Nuevo_Horizonte
CREATE TABLE MATRICULA
(Codigo_Matricula  INT not null,
Estado BIT not null)
GO
--**********************************************************
USE Nuevo_Horizonte
CREATE TABLE CICLO 
(CodigoInterno_Central  INT not null,
Nombre VARCHAR (50) not null)
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE ESTUDIANTE
ADD CONSTRAINT PK_Estudiante_Cedula
 PRIMARY KEY (Cedula) 
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE MATRICULA
ADD CONSTRAINT PK_Matricula_Codigo_Matricula
 PRIMARY KEY (Codigo_Matricula) 
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE CICLO
ADD CONSTRAINT PK_CICLO_
 PRIMARY KEY (CodigoInterno_Central) 
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE ASIGNATURA
ADD CONSTRAINT PK_ASIGNATURA_Codigo_Interno
 PRIMARY KEY (Codigo_Interno_Central) 
GO
--**********************************************************
ALTER TABLE Matricula
ADD Estudiante_Cedula INT NOT NULL;
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE MATRICULA
ADD CONSTRAINT FK_Matricula_Estudiante
FOREIGN KEY (Estudiante_Cedula)
REFERENCES ESTUDIANTE (Cedula);
GO
--**********************************************************
ALTER TABLE Matricula
ADD Codigo_Asignatura INT NOT NULL;
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE MATRICULA
ADD CONSTRAINT FK_Matricula_Asignatura
FOREIGN KEY (Codigo_Asignatura)
REFERENCES ASIGNATURA (Codigo_Interno_Central);
GO
--**********************************************************
USE Nuevo_Horizonte
CREATE TABLE CICLO_ASIGNATURA 
(Id_CicloAsignatura INT NOT NULL,
 CodigoAsignatura INT NOT NULL,
 CodigoCiclo INT NOT NULL)
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE CICLO_ASIGNATURA
ADD CONSTRAINT PK_Ciclo_Asignatura_Tabla
 PRIMARY KEY (Id_CicloAsignatura) 
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE CICLO_ASIGNATURA
ADD CONSTRAINT FK_Asignatura_Ciclo
FOREIGN KEY (CodigoAsignatura)
REFERENCES ASIGNATURA (Codigo_Interno_Central);
GO
--**********************************************************
USE Nuevo_Horizonte
GO
ALTER TABLE CICLO_ASIGNATURA
ADD CONSTRAINT FK_Ciclo_Asignatura
FOREIGN KEY (CodigoCiclo)
REFERENCES CICLO (CodigoInterno_Central);
GO
--**********************************************************



use Nuevo_Horizonte
go
CREATE TABLE Asignaturas (
 CODIGO_ASIGNATURA INT not null,
    NOMBRE VARCHAR(50) not null,
	DIA varchar(25) not null,
	HORA varchar(25) not null
);

CREATE TABLE REQUISITO
(
CODIGO_REQUISITO int NOT NULL,
NOMBRE_REQUISITO varchar(50) NOT NULL
)
GO

CREATE TABLE Carrera 
(
CODIGO_CARRERA int NOT NULL,
NOMBRE VARCHAR(50) NOT NULL
)
GO


ALTER TABLE Asignaturas
ADD CONSTRAINT PK_CODIGO_ASIGNATURAS
PRIMARY KEY (CODIGO_ASIGNATURA)
GO

ALTER TABLE Carrera
ADD CONSTRAINT PK_CODIGO_CARRERA
PRIMARY KEY (CODIGO_CARRERA)
GO

ALTER TABLE REQUISITO
ADD CONSTRAINT PK_CODIGO_REQUISITO
PRIMARY KEY (CODIGO_REQUISITO)
GO

CREATE TABLE Asignatura_Carrera (
CODIGO_ASIGNATURA_CARRERA INT NOT NULL,
    CODIGO_ASIGNATURA INT NOT NULL,
    CODIGO_CARRERA INT NOT NULL
);
GO

-- Agregar llave foránea a la tabla intermedia Asignatura_Carrera para CODIGO_ASIGNATURA
ALTER TABLE Asignatura_Carrera
ADD CONSTRAINT FK_Asignatura_Carrera_Asignatura
FOREIGN KEY (CODIGO_ASIGNATURA) REFERENCES Asignaturas(CODIGO_ASIGNATURA);
GO

-- Agregar llave foránea a la tabla intermedia Asignatura_Carrera para CODIGO_CARRERA
ALTER TABLE Asignatura_Carrera
ADD CONSTRAINT FK_Asignatura_Carrera_Carrera
FOREIGN KEY (CODIGO_CARRERA) REFERENCES Carrera(CODIGO_CARRERA);
GO

ALTER TABLE Asignatura_Carrera
ADD CONSTRAINT PK_Asignatura_Carrera
PRIMARY KEY (CODIGO_ASIGNATURA_CARRERA);
GO

CREATE TABLE Asignatura_Requisito (
CODIGO_ASIGNATURA_REQUISITO INT NOT NULL,
    CODIGO_ASIGNATURA INT NOT NULL,
    CODIGO_REQUISITO INT NOT NULL
);
GO

ALTER TABLE Asignatura_Requisito
ADD CONSTRAINT PK_Asignatura_Requisito
PRIMARY KEY (CODIGO_ASIGNATURA_REQUISITO);
GO

-- Agregar llave foránea a la tabla intermedia Asignatura_Requisito para CODIGO_ASIGNATURA
ALTER TABLE Asignatura_Requisito
ADD CONSTRAINT FK_Asignatura_Requisito_Asignatura
FOREIGN KEY (CODIGO_ASIGNATURA) REFERENCES Asignaturas(CODIGO_ASIGNATURA);
GO

-- Agregar llave foránea a la tabla intermedia Asignatura_Requisito para CODIGO_REQUISITO
ALTER TABLE Asignatura_Requisito
ADD CONSTRAINT FK_Asignatura_Requisito_Requisito
FOREIGN KEY (CODIGO_REQUISITO) REFERENCES REQUISITO(CODIGO_REQUISITO);
GO



SELECT * FROM Asignaturas
exec sp_help Asignaturas
exec sp_help Carrera
exec sp_help REQUISITO
exec sp_help Asignatura_Carrera
exec sp_help Asignatura_Requisito
exec sp_helpdb Nuevo_Horizonte




