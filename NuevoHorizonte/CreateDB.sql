USE MASTER
GO 
CREATE DATABASE Nuevo_Horizonte
ON PRIMARY
(NAME = 'Nuevo_Horizonte_data',
FILENAME = 'C:\SQL_DATA\Nuevo_Horizonte_data.Mdf',
SIZE = 100MB,
MAXSIZE = 2GB,
FILEGROWTH= 10MB)

LOG ON
(NAME = 'Nuevo_Horizonte_Log',
FILENAME = 'C:\SQL_LOG\Nuevo_Horizonte_Log.Ldf',
SIZE = 50MB,
MAXSIZE = 1GB,
FILEGROWTH= 5MB)
GO


----Creacion filegruop

Use MASTER
Go
Alter Database Nuevo_Horizonte
Add Filegroup Aulas
Go

Use MASTER
Go
Alter Database Nuevo_Horizonte
Add FIlegroup Personas
Go

Use MASTER
Go
Alter Database Nuevo_Horizonte
Add FIlegroup Academico
Go

----------Archivo de datos Aulas
Use Master
GO
Alter database Nuevo_Horizonte
Add file
(Name='Aulas_Data',
Filename='C:\SQLData\Aulas_Data.ndf',
Size=20Mb,
Maxsize=30Mb,
Filegrowth=4Mb
)
TO FILEGROUP Aulas
GO

--Archivo de datos para el Filegroup Personas
Use Master
GO
Alter database Nuevo_Horizonte
Add file
(Name='Personas_Data',
Filename='C:\SQLData\Personas_Data.ndf',
Size=20Mb,
Maxsize=30Mb,
Filegrowth=4Mb
)
TO FILEGROUP Personas
GO

-----Archivos de datos Filegruop Academico
Use Master
GO
Alter database Nuevo_Horizonte
Add file
(Name='Academico_Data',
Filename='C:\SQLData\Academico_Data.ndf',
Size=20Mb,
Maxsize=30Mb,
Filegrowth=4Mb
)
TO FILEGROUP Academico
GO