USE master;

IF DB_ID('TallerAutomotrizDB') IS NULL
BEGIN
    CREATE DATABASE TallerAutomotrizDB;
END;

USE TallerAutomotrizDB;


CREATE TABLE Cliente (
    idCliente INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(150) NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (idCliente)
);


CREATE TABLE Vehiculo (
    idVehiculo INT IDENTITY(1,1) NOT NULL,
    idCliente INT NOT NULL,
    placa VARCHAR(15) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio SMALLINT NOT NULL,
    CONSTRAINT PK_Vehiculo PRIMARY KEY (idVehiculo),
    CONSTRAINT UQ_Vehiculo_Placa UNIQUE (placa),
    CONSTRAINT FK_Vehiculo_Cliente FOREIGN KEY (idCliente)
        REFERENCES Cliente(idCliente),
    CONSTRAINT CK_Vehiculo_Anio CHECK (anio BETWEEN 1900 AND 2100)
);


CREATE TABLE Mecanico (
    idMecanico INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NULL,
    especialidad VARCHAR(100) NULL,
    estado VARCHAR(20) NOT NULL
        CONSTRAINT DF_Mecanico_Estado DEFAULT 'Activo',
    CONSTRAINT PK_Mecanico PRIMARY KEY (idMecanico),
    CONSTRAINT CK_Mecanico_Estado
        CHECK (estado IN ('Activo', 'Inactivo'))
);


CREATE TABLE OrdenReparacion (
    idOrden INT IDENTITY(1,1) NOT NULL,
    idVehiculo INT NOT NULL,
    idMecanico INT NOT NULL,
    fecha_recepcion DATETIME2(0) NOT NULL
        CONSTRAINT DF_Orden_FechaRecepcion DEFAULT SYSDATETIME(),
    problema_reportado VARCHAR(500) NOT NULL,
    estado VARCHAR(20) NOT NULL
        CONSTRAINT DF_Orden_Estado DEFAULT 'Abierta',
    fecha_entrega DATETIME2(0) NULL,
    CONSTRAINT PK_OrdenReparacion PRIMARY KEY (idOrden),
    CONSTRAINT FK_OrdenReparacion_Vehiculo FOREIGN KEY (idVehiculo)
        REFERENCES Vehiculo(idVehiculo),
    CONSTRAINT FK_OrdenReparacion_Mecanico FOREIGN KEY (idMecanico)
        REFERENCES Mecanico(idMecanico),
    CONSTRAINT CK_OrdenReparacion_Estado
        CHECK (estado IN ('Abierta', 'En proceso', 'Finalizada', 'Entregada', 'Cancelada')),
    CONSTRAINT CK_OrdenReparacion_Fechas
        CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_recepcion)
);


CREATE TABLE Servicio (
    idServicio INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300) NULL,
    precio_actual DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Servicio PRIMARY KEY (idServicio),
    CONSTRAINT UQ_Servicio_Nombre UNIQUE (nombre),
    CONSTRAINT CK_Servicio_Precio CHECK (precio_actual >= 0)
);


CREATE TABLE Repuesto (
    idRepuesto INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300) NULL,
    precio_actual DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Repuesto PRIMARY KEY (idRepuesto),
    CONSTRAINT UQ_Repuesto_Nombre UNIQUE (nombre),
    CONSTRAINT CK_Repuesto_Precio CHECK (precio_actual >= 0)
);


CREATE TABLE DetalleServicioOrden (
    idDetalleServicio INT IDENTITY(1,1) NOT NULL,
    idOrden INT NOT NULL,
    idServicio INT NOT NULL,
    cantidad INT NOT NULL
        CONSTRAINT DF_DetalleServicio_Cantidad DEFAULT 1,
    precio_aplicado DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_DetalleServicioOrden PRIMARY KEY (idDetalleServicio),
    CONSTRAINT FK_DetalleServicioOrden_Orden FOREIGN KEY (idOrden)
        REFERENCES OrdenReparacion(idOrden),
    CONSTRAINT FK_DetalleServicioOrden_Servicio FOREIGN KEY (idServicio)
        REFERENCES Servicio(idServicio),
    CONSTRAINT UQ_DetalleServicio_Orden_Servicio UNIQUE (idOrden, idServicio),
    CONSTRAINT CK_DetalleServicio_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_DetalleServicio_Precio CHECK (precio_aplicado >= 0)
);


CREATE TABLE DetalleRepuestoOrden (
    idDetalleRepuesto INT IDENTITY(1,1) NOT NULL,
    idOrden INT NOT NULL,
    idRepuesto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_aplicado DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_DetalleRepuestoOrden PRIMARY KEY (idDetalleRepuesto),
    CONSTRAINT FK_DetalleRepuestoOrden_Orden FOREIGN KEY (idOrden)
        REFERENCES OrdenReparacion(idOrden),
    CONSTRAINT FK_DetalleRepuestoOrden_Repuesto FOREIGN KEY (idRepuesto)
        REFERENCES Repuesto(idRepuesto),
    CONSTRAINT UQ_DetalleRepuesto_Orden_Repuesto UNIQUE (idOrden, idRepuesto),
    CONSTRAINT CK_DetalleRepuesto_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_DetalleRepuesto_Precio CHECK (precio_aplicado >= 0)
);


CREATE TABLE ParticipacionMecanico (
    idParticipacion INT IDENTITY(1,1) NOT NULL,
    idOrden INT NOT NULL,
    idMecanico INT NOT NULL,
    trabajo_realizado VARCHAR(300) NULL,
    horas_trabajadas DECIMAL(6,2) NOT NULL
        CONSTRAINT DF_Participacion_Horas DEFAULT 0,
    CONSTRAINT PK_ParticipacionMecanico PRIMARY KEY (idParticipacion),
    CONSTRAINT FK_ParticipacionMecanico_Orden FOREIGN KEY (idOrden)
        REFERENCES OrdenReparacion(idOrden),
    CONSTRAINT FK_ParticipacionMecanico_Mecanico FOREIGN KEY (idMecanico)
        REFERENCES Mecanico(idMecanico),
    CONSTRAINT UQ_Participacion_Orden_Mecanico UNIQUE (idOrden, idMecanico),
    CONSTRAINT CK_Participacion_Horas CHECK (horas_trabajadas >= 0)
);


CREATE NONCLUSTERED INDEX IX_OrdenReparacion_FechaRecepcion
ON OrdenReparacion(fecha_recepcion);


CREATE NONCLUSTERED INDEX IX_OrdenReparacion_Vehiculo
ON OrdenReparacion(idVehiculo);


CREATE NONCLUSTERED INDEX IX_DetalleServicioOrden_Orden
ON DetalleServicioOrden(idOrden);


CREATE NONCLUSTERED INDEX IX_ParticipacionMecanico_Mecanico
ON ParticipacionMecanico(idMecanico);


SELECT TABLE_NAME AS NombreTabla
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;