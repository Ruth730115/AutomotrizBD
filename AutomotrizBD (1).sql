CREATE DATABASE AutomotrizDB;

USE AutomotrizDB;

CREATE TABLE [Cliente] (
  [id_cliente] int PRIMARY KEY,
  [nombre] varchar(50),
  [telefono] varchar(10),
  [correo] varchar(30)
)
GO

CREATE TABLE [Vehiculo] (
  [id_vehiculo] int PRIMARY KEY,
  [placa] varchar(10),
  [marca] varchar(25),
  [modelo]nvarchar(50),
  [año] datetime,
  [id_cliente] int
)
GO

CREATE TABLE [OrdenTrabajo] (
  [id_orden] int PRIMARY KEY,
  [fecha] datetime,
  [diagnostico] varchar(255),
  [estado] varchar(50),
  [id_vehiculo] int
)
GO

CREATE TABLE [Mecanico] (
  [id_mecanico] int PRIMARY KEY,
  [nombre] varchar(50),
  [especialidad] varchar(50),
  [id_orden] int
)
GO

CREATE TABLE [Pago] (
  [id_pago] int PRIMARY KEY,
  [fecha] datetime,
  [monto] decimal,
  [tipo_pago] varchar(25),
  [id_orden] int
)
GO

CREATE TABLE [Proveedor] (
  [id_proveedor] int PRIMARY KEY,
  [nombre] varchar(50)
)
GO

CREATE TABLE [Repuesto] (
  [id_repuesto] int PRIMARY KEY,
  [nombre] varchar(50),
  [stock] int,
  [precio] decimal,
  [id_proveedor] int
)
GO

CREATE TABLE [MovimientoInventario] (
  [id_movimiento] int PRIMARY KEY,
  [tipo] varchar(25),
  [cantidad] int,
  [fecha] date,
  [id_repuesto] int
)
GO

CREATE TABLE [Motor] (
  [id_motor] int PRIMARY KEY,
  [codigo] int,
  [marca] varchar(25),
  [modelo] varchar(50),
  [compatibilidad] varchar(25),
  [stock] int
)
GO

CREATE TABLE [CambioMotor] (
  [id_cambio] int PRIMARY KEY,
  [fecha] date,
  [nueva_serie] varchar(50),
  [motivo] varchar(255),
  [id_vehiculo] int,
  [id_motor] int
)
GO

ALTER TABLE [Vehiculo] ADD FOREIGN KEY ([id_cliente]) REFERENCES [Cliente] ([id_cliente])
GO

ALTER TABLE [OrdenTrabajo] ADD FOREIGN KEY ([id_vehiculo]) REFERENCES [Vehiculo] ([id_vehiculo])
GO

ALTER TABLE [Mecanico] ADD FOREIGN KEY ([id_orden]) REFERENCES [OrdenTrabajo] ([id_orden])
GO

ALTER TABLE [Pago] ADD FOREIGN KEY ([id_orden]) REFERENCES [OrdenTrabajo] ([id_orden])
GO

ALTER TABLE [Repuesto] ADD FOREIGN KEY ([id_proveedor]) REFERENCES [Proveedor] ([id_proveedor])
GO

ALTER TABLE [MovimientoInventario] ADD FOREIGN KEY ([id_repuesto]) REFERENCES [Repuesto] ([id_repuesto])
GO

ALTER TABLE [CambioMotor] ADD FOREIGN KEY ([id_vehiculo]) REFERENCES [Vehiculo] ([id_vehiculo])
GO

ALTER TABLE [CambioMotor] ADD FOREIGN KEY ([id_motor]) REFERENCES [Motor] ([id_motor])
GO


---
IF COL_LENGTH('Cliente', 'activo') IS NULL
    ALTER TABLE Cliente ADD activo BIT NOT NULL CONSTRAINT DF_Cliente_activo DEFAULT 1;
GO


ALTER TABLE Mecanico ALTER COLUMN id_orden INT NULL;
GO

IF OBJECT_ID('Servicio', 'U') IS NULL
BEGIN
    CREATE TABLE Servicio (
        id_servicio     INT PRIMARY KEY,
        codigo          VARCHAR(20)   NOT NULL UNIQUE,
        nombre          VARCHAR(100)  NOT NULL,
        descripcion     VARCHAR(200)  NOT NULL,
        nivel           INT           NOT NULL CHECK (nivel BETWEEN 1 AND 5),
        costo_mano_obra DECIMAL(10,2) NOT NULL CHECK (costo_mano_obra >= 0),
        tiempo_estimado DECIMAL(5,2)  NOT NULL CHECK (tiempo_estimado > 0)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM Servicio)
BEGIN
    INSERT INTO Servicio (id_servicio, codigo, nombre, descripcion, nivel, costo_mano_obra, tiempo_estimado)
    VALUES (1, 'SRV-001', 'Cambio de aceite', 'Cambio de aceite y filtro de aceite', 1, 350, 0.5),
           (2, 'SRV-002', 'Cambio de bujias', 'Reemplazo del juego de bujias', 1, 400, 1),
           (3, 'SRV-003', 'Afinamiento', 'Afinamiento general del motor', 2, 900, 2.5),
           (4, 'SRV-004', 'Cambio de frenos', 'Cambio de pastillas y revision de discos', 2, 1200, 3),
           (5, 'SRV-005', 'Cambio de radiador', 'Reemplazo del radiador y sistema de enfriamiento', 3, 1500, 4),
           (6, 'SRV-006', 'Reparacion de transmision', 'Reparacion de caja automatica', 4, 3500, 12),
           (7, 'SRV-007', 'Sustitucion de motor', 'Reconstruccion y sustitucion completa del motor', 5, 6000, 40);
END
GO

SELECT * FROM Servicio;
SELECT id_cliente, nombre, activo FROM Cliente;
GO

IF NOT EXISTS (SELECT 1 FROM Cliente)
BEGIN
    INSERT INTO Cliente (id_cliente, nombre, telefono, correo)
    VALUES (1, 'Juan Perez', '32568475', 'juanperez@gmail.com'),
           (2, 'Jose Cardona', '99858545', 'josecardona@hotmail.com'),
           (3, 'Carlos Balderrama', '39294839', 'carlosbalderrama@gmail.com'),
           (4, 'Mario Figueroa', '39289384', 'mariofigueroa@yahoo.com'),
           (5, 'Pedro Urbina', '98392839', 'pedrourbina@gmail.com'),
           (6, 'Carlos Gomez', '98765432', 'carlos@gmail.com'),
           (7, 'Ana Martinez', '97451263', 'anamartinez@gmail.com'),
           (8, 'Luis Hernandez', '88123456', 'luishernandez@yahoo.com');
END
GO

IF NOT EXISTS (SELECT 1 FROM Vehiculo)
BEGIN
    INSERT INTO Vehiculo (id_vehiculo, placa, marca, modelo, [año], id_cliente)
    VALUES (1, 'HN 2564', 'MAZDA', 'MAZDA 3', '20100101', 3),
           (2, 'PS 3829', 'HONDA', 'CIVIC', '20130101', 1),
           (3, 'RT 3687', 'TOYOTA', 'COROLLA', '20130101', 2),
           (4, 'HN 6580', 'HYUNDAI', 'ELANTRA', '20140101', 5),
           (5, 'PW 6842', 'FORD', 'ESCAPE', '20150101', 4),
           (6, 'HAA1234', 'TOYOTA', 'HILUX', '20150101', 1),
           (7, 'HBB1234', 'HONDA', 'CIVIC', '20200101', 6),
           (8, 'PD 4410', 'KIA', 'SPORTAGE', '20180101', 7),
           (9, 'HC 7721', 'NISSAN', 'VERSA', '20160101', 8),
           (10, 'PB 3098', 'MITSUBISHI', 'L200', '20120101', 3);
END
GO

IF NOT EXISTS (SELECT 1 FROM Mecanico)
BEGIN
    INSERT INTO Mecanico (id_mecanico, nombre, especialidad)
    VALUES (1, 'Tomas Morales', 'Motor Diesel'),
           (2, 'Rafael Rivera', 'Motor Gasolina'),
           (3, 'Juan Carlos Rendon', 'Sistema Electrico'),
           (4, 'Danilo Torres', 'Motor Gasolina'),
           (5, 'Roberto Mejia', 'Motor Gasolina'),
           (6, 'Marvin Castillo', 'Frenos y Suspension');
END
GO

IF NOT EXISTS (SELECT 1 FROM Servicio WHERE id_servicio = 8)
BEGIN
    INSERT INTO Servicio (id_servicio, codigo, nombre, descripcion, nivel, costo_mano_obra, tiempo_estimado)
    VALUES (8, 'SRV-008', 'Cambio de luces', 'Cambio de focos y revision del sistema de luces', 1, 150, 0.5),
           (9, 'SRV-009', 'Reparacion de alternador', 'Reparacion o cambio del alternador', 3, 1100, 3),
           (10, 'SRV-010', 'Reparacion de sistema electrico', 'Diagnostico y reparacion del sistema electrico', 4, 2000, 8);
END
GO

SELECT * FROM Cliente;
SELECT * FROM Vehiculo;
SELECT * FROM Mecanico;
SELECT * FROM Servicio;
GO
