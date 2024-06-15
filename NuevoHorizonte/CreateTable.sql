Use Nuevo_Horizonte
GO
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
) ON Aulas
GO

Use Nuevo_Horizonte
GO
CREATE TABLE PROFESORES
(
    Codigo_interno INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Dirección VARCHAR(50) NULL,
    Telefono INT NULL,
    Email VARCHAR(50) NULL,
    DNI INT NULL,
    Num_Seguridad_Social INT NULL,
    CONSTRAINT PK_Codigo_interno 
	PRIMARY KEY (Codigo_interno)
) ON Personas
GO


Use Nuevo_Horizonte
GO
CREATE TABLE NOMBRAMIENTO
(
    Codigo_nombramiento  INT NOT NULL,
	Nombre_nombramiento VARCHAR (50) NOT NULL, 
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    CONSTRAINT PK_Codigo_nombramiento 
	PRIMARY KEY (Codigo_nombramiento)
) ON Personas
GO

Use Nuevo_Horizonte
GO
CREATE TABLE ASIGNATURA
(
    Codigo_Interno_Central VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Codigo_europeo INT NOT NULL,
    CONSTRAINT PK_ASIGNATURA PRIMARY KEY (Codigo_Interno_Central)
) ON Academico
GO

Use Nuevo_Horizonte
GO
CREATE TABLE Carrera
(
Codigo_Carrera INT,
Nombre VARCHAR (80)
CONSTRAINT Pk_Codigo_Carrera
PRIMARY KEY (Codigo_Carrera)
) ON Academico
GO

USE Nuevo_Horizonte
GO
CREATE TABLE Profesores_Nombramiento
(
    Codigo_PROFESORES_NOMBRAMIENTO INT IDENTITY(1,1) NOT NULL,
    Codigo_nombramiento INT NOT NULL,
    Codigo_interno INT NOT NULL,
    AniosImpartiendo INT DEFAULT 0,  --Lo agregue
    CONSTRAINT PK_PROFESORES_NOMBRAMIENTO 
	PRIMARY KEY (Codigo_PROFESORES_NOMBRAMIENTO),
    CONSTRAINT FK_PROFESORES_NOMBRAMIENTO_Nombramiento
	FOREIGN KEY (Codigo_nombramiento) REFERENCES Nombramiento(Codigo_nombramiento),
    CONSTRAINT FK_PROFESORES_NOMBRAMIENTO_Profesores 
	FOREIGN KEY (Codigo_interno) REFERENCES Profesores(Codigo_interno)
) ON Personas
GO

Use Nuevo_Horizonte
GO
CREATE TABLE PROFESOR_ASIGNATURA 
(
    Codigo_Profesor_Asignatura INT IDENTITY(1,1) NOT NULL,
    Codigo_interno_profesor INT NOT NULL,
    Codigo_Interno_Central VARCHAR(50) NOT NULL,
    CONSTRAINT PK_PROFESOR_ASIGNATURA 
	PRIMARY KEY (Codigo_Profesor_Asignatura),
    CONSTRAINT FK_PROFESOR_ASIGNATURA_Profesores 
	FOREIGN KEY (Codigo_interno_profesor) REFERENCES Profesores(Codigo_interno),
    CONSTRAINT FK_PROFESOR_ASIGNATURA_ASIGNATURA 
	FOREIGN KEY (Codigo_Interno_Central) REFERENCES ASIGNATURA(Codigo_Interno_Central)
) ON Personas
GO


Use Nuevo_Horizonte
GO
CREATE TABLE Carrera_Asignatura
(
Carrera_Asignatura INT Not null,
Codigo_Carrera INT NOT NULL , 
Codigo_Interno_Central varchar (50) NOT NULL
CONSTRAINT PK_Carrera_Asignatura 
PRIMARY KEY (Carrera_Asignatura ),
FOREIGN KEY (Codigo_Carrera) REFERENCES Carrera(Codigo_Carrera),
FOREIGN KEY (Codigo_Interno_Central) REFERENCES ASIGNATURA (Codigo_Interno_Central)
) ON Academico
GO

USE Nuevo_Horizonte
GO
CREATE TABLE ESTUDIANTE 
(
Cedula  INT not null,
Nombre VARCHAR (50) not null,
Ape1  VARCHAR (50) not null, 
Ape2 VARCHAR (50) null,
Email VARCHAR (75) not null,
CONSTRAINT PK_Estudiante_Cedula
PRIMARY KEY (Cedula) 
) ON Personas
GO

USE Nuevo_Horizonte
GO
CREATE TABLE MATRICULA
(
Codigo_Matricula  INT identity(1, 1)not null,
Estado BIT not null,
CONSTRAINT PK_Matricula_Codigo_Matricula
PRIMARY KEY (Codigo_Matricula) 
) ON Academico
GO


---Se agregan a Matricula
ALTER TABLE Matricula
ADD Estudiante_Cedula INT NOT NULL;

ALTER TABLE Matricula
ADD Codigo_Asignatura varchar(50) NOT NULL;

------------FK---------------
USE Nuevo_Horizonte
GO
ALTER TABLE MATRICULA
ADD CONSTRAINT FK_Matricula_Estudiante
FOREIGN KEY (Estudiante_Cedula)
REFERENCES ESTUDIANTE (Cedula);
GO

USE Nuevo_Horizonte
GO
ALTER TABLE MATRICULA
ADD CONSTRAINT FK_Matricula_Asignatura
FOREIGN KEY (Codigo_Asignatura)
REFERENCES ASIGNATURA (Codigo_Interno_Central);
GO

--------------------------------------------
USE Nuevo_Horizonte
GO
CREATE TABLE CICLO 
(
CodigoInterno_Central  INT not null,
Nombre VARCHAR (50) not null
CONSTRAINT PK_CICLO_CodigoInterno_Central
 PRIMARY KEY (CodigoInterno_Central)
) ON Academico
GO

USE Nuevo_Horizonte
GO
CREATE TABLE CICLO_ASIGNATURA 
(
Id_CicloAsignatura INT NOT NULL,
 CodigoAsignatura varchar(50) NOT NULL,
 CodigoCiclo INT NOT NULL,
 CONSTRAINT PK_Ciclo_Asignatura_Tabla
 PRIMARY KEY (Id_CicloAsignatura),
 FOREIGN KEY (CodigoAsignatura) REFERENCES ASIGNATURA (Codigo_Interno_Central),
 FOREIGN KEY (CodigoCiclo) REFERENCES CICLO (CodigoCiclo)
 ) ON Academico
GO

Use Nuevo_Horizonte
Go
CREATE TABLE REQUISITO
(
CODIGO_REQUISITO int identity(1, 1) NOT NULL, --PUSE IDENTITY ESTE CODIGO
NOMBRE_REQUISITO varchar(50) NOT NULL,
CONSTRAINT PK_CODIGO_REQUISITO
PRIMARY KEY (CODIGO_REQUISITO)
) ON Academico
GO

Use Nuevo_Horizonte
Go
CREATE TABLE Asignatura_Requisito (
CODIGO_ASIGNATURA_REQUISITO INT NOT NULL,
    CODIGO_ASIGNATURA VARCHAR(50) NOT NULL,
   CODIGO_REQUISITO int NOT NULL,
CONSTRAINT PK_Asignatura_Requisito
PRIMARY KEY (CODIGO_ASIGNATURA_REQUISITO),
CONSTRAINT FK_Asignatura_Requisito_Asignatura
FOREIGN KEY (CODIGO_ASIGNATURA) REFERENCES ASIGNATURA(Codigo_Interno_Central),
CONSTRAINT FK_Asignatura_Requisito_Requisito
FOREIGN KEY (CODIGO_REQUISITO) REFERENCES REQUISITO(CODIGO_REQUISITO)
) ON Academico
GO


---------------
SELECT * FROM Asignaturas
exec sp_help Asignaturas
exec sp_help Carrera
exec sp_help REQUISITO
exec sp_help Asignatura_Carrera
exec sp_help Asignatura_Requisito
exec sp_helpdb Nuevo_Horizonte