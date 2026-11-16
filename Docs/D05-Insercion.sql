USE TallerAutomotrizDB;

SET XACT_ABORT ON;

BEGIN TRANSACTION;


INSERT INTO Cliente (nombre, telefono, correo)
VALUES
('Ana López', '5551-1001', 'ana.lopez@email.com'),
('Pedro Díaz', '5551-1002', 'pedro.diaz@email.com'),
('Carlos Méndez', '5551-1003', 'carlos.mendez@email.com'),
('María Torres', '5551-1004', 'maria.torres@email.com'),
('José Ramírez', '5551-1005', 'jose.ramirez@email.com');


INSERT INTO Vehiculo (idCliente, placa, marca, modelo, anio)
SELECT c.idCliente, v.placa, v.marca, v.modelo, v.anio
FROM (VALUES
    ('Ana López', 'P123ABC', 'Toyota', 'Corolla', 2018),
    ('Ana López', 'P124ABC', 'Honda', 'Civic', 2020),
    ('Pedro Díaz', 'P456DEF', 'Honda', 'CR-V', 2019),
    ('Carlos Méndez', 'P789GHI', 'Mazda', '3', 2017),
    ('María Torres', 'P321JKL', 'Hyundai', 'Tucson', 2021),
    ('José Ramírez', 'P654MNO', 'Nissan', 'Sentra', 2016),
    ('Pedro Díaz', 'P987PQR', 'Toyota', 'Hilux', 2022)
) AS v(nombreCliente, placa, marca, modelo, anio)
INNER JOIN Cliente c
    ON c.nombre = v.nombreCliente;


INSERT INTO Mecanico (nombre, telefono, especialidad, estado)
VALUES
('Luis Pérez', '5552-1001', 'Mecánica general', 'Activo'),
('María García', '5552-1002', 'Sistema eléctrico', 'Activo'),
('Carlos Ruiz', '5552-1003', 'Sistema de frenos', 'Activo'),
('José Morales', '5552-1004', 'Diagnóstico automotriz', 'Activo');


INSERT INTO Servicio (nombre, descripcion, precio_actual)
VALUES
('Cambio de aceite', 'Cambio de aceite y revisión básica del motor', 650.00),
('Revisión de frenos', 'Inspección del sistema de frenos', 450.00),
('Alineación y balanceo', 'Alineación de dirección y balanceo de ruedas', 300.00),
('Diagnóstico del motor', 'Evaluación del funcionamiento del motor', 500.00),
('Reparación eléctrica', 'Revisión y reparación del sistema eléctrico', 750.00);


INSERT INTO Repuesto (nombre, descripcion, precio_actual)
VALUES
('Filtro de aceite', 'Filtro para sistema de lubricación', 75.00),
('Aceite de motor', 'Aceite sintético para motor', 55.00),
('Pastillas de freno', 'Juego de pastillas de freno delanteras', 350.00),
('Filtro de aire', 'Filtro de aire para motor', 120.00),
('Bujías', 'Juego de bujías para motor', 85.00),
('Batería', 'Batería automotriz de 12 voltios', 850.00),
('Correa de distribución', 'Correa para sistema de distribución', 450.00),
('Amortiguador', 'Amortiguador de suspensión', 600.00),
('Lámpara halógena', 'Lámpara para sistema de iluminación', 65.00),
('Disco de freno', 'Disco de freno delantero', 500.00);


INSERT INTO OrdenReparacion (
    idVehiculo,
    idMecanico,
    fecha_recepcion,
    problema_reportado,
    estado,
    fecha_entrega
)
SELECT
    v.idVehiculo,
    m.idMecanico,
    o.fecha_recepcion,
    o.problema_reportado,
    o.estado,
    o.fecha_entrega
FROM (VALUES
    ('P123ABC', 'Luis Pérez', '2026-10-05T08:00:00', 'Mantenimiento preventivo y cambio de aceite', 'Entregada', '2026-10-05T15:00:00'),
    ('P456DEF', 'María García', '2026-10-06T09:00:00', 'Revisión del sistema de frenos', 'Entregada', '2026-10-06T16:00:00'),
    ('P123ABC', 'Luis Pérez', '2026-10-07T08:30:00', 'Diagnóstico y mantenimiento del motor', 'Entregada', '2026-10-07T17:00:00'),
    ('P789GHI', 'Carlos Ruiz', '2026-10-08T10:00:00', 'Cambio de aceite y revisión general', 'Entregada', '2026-10-08T16:00:00'),
    ('P321JKL', 'Luis Pérez', '2026-10-09T08:00:00', 'Mantenimiento preventivo', 'Entregada', '2026-10-09T14:00:00'),
    ('P654MNO', 'José Morales', '2026-10-10T09:00:00', 'Revisión de motor y sistema eléctrico', 'Entregada', '2026-10-10T17:00:00'),
    ('P124ABC', 'Luis Pérez', '2026-10-11T08:00:00', 'Servicio general y cambio de aceite', 'Entregada', '2026-10-11T15:00:00'),
    ('P987PQR', 'Luis Pérez', '2026-10-12T09:00:00', 'Mantenimiento y revisión de frenos', 'Entregada', '2026-10-12T16:00:00')
) AS o(placa, nombreMecanico, fecha_recepcion, problema_reportado, estado, fecha_entrega)
INNER JOIN Vehiculo v
    ON v.placa = o.placa
INNER JOIN Mecanico m
    ON m.nombre = o.nombreMecanico;


INSERT INTO DetalleServicioOrden (
    idOrden,
    idServicio,
    cantidad,
    precio_aplicado
)
SELECT
    o.idOrden,
    s.idServicio,
    d.cantidad,
    d.precio_aplicado
FROM (VALUES
    ('P123ABC', '2026-10-05T08:00:00', 'Cambio de aceite', 1, 650.00),
    ('P456DEF', '2026-10-06T09:00:00', 'Revisión de frenos', 1, 450.00),
    ('P123ABC', '2026-10-07T08:30:00', 'Cambio de aceite', 1, 650.00),
    ('P789GHI', '2026-10-08T10:00:00', 'Cambio de aceite', 1, 650.00),
    ('P321JKL', '2026-10-09T08:00:00', 'Cambio de aceite', 1, 650.00),
    ('P654MNO', '2026-10-10T09:00:00', 'Diagnóstico del motor', 1, 500.00),
    ('P124ABC', '2026-10-11T08:00:00', 'Cambio de aceite', 1, 650.00),
    ('P987PQR', '2026-10-12T09:00:00', 'Cambio de aceite', 1, 650.00)
) AS d(placa, fecha_recepcion, nombreServicio, cantidad, precio_aplicado)
INNER JOIN OrdenReparacion o
    ON o.fecha_recepcion = d.fecha_recepcion
INNER JOIN Vehiculo v
    ON v.idVehiculo = o.idVehiculo
    AND v.placa = d.placa
INNER JOIN Servicio s
    ON s.nombre = d.nombreServicio;


INSERT INTO DetalleRepuestoOrden (
    idOrden,
    idRepuesto,
    cantidad,
    precio_aplicado
)
SELECT
    o.idOrden,
    r.idRepuesto,
    d.cantidad,
    d.precio_aplicado
FROM (VALUES
    ('P123ABC', '2026-10-05T08:00:00', 'Filtro de aceite', 1, 75.00),
    ('P123ABC', '2026-10-05T08:00:00', 'Aceite de motor', 4, 55.00),
    ('P456DEF', '2026-10-06T09:00:00', 'Pastillas de freno', 1, 350.00),
    ('P123ABC', '2026-10-07T08:30:00', 'Filtro de aceite', 1, 75.00),
    ('P123ABC', '2026-10-07T08:30:00', 'Aceite de motor', 4, 55.00),
    ('P789GHI', '2026-10-08T10:00:00', 'Filtro de aceite', 1, 75.00),
    ('P789GHI', '2026-10-08T10:00:00', 'Aceite de motor', 4, 55.00),
    ('P321JKL', '2026-10-09T08:00:00', 'Filtro de aceite', 1, 75.00),
    ('P321JKL', '2026-10-09T08:00:00', 'Aceite de motor', 4, 55.00),
    ('P654MNO', '2026-10-10T09:00:00', 'Bujías', 4, 85.00),
    ('P654MNO', '2026-10-10T09:00:00', 'Lámpara halógena', 2, 65.00),
    ('P124ABC', '2026-10-11T08:00:00', 'Filtro de aceite', 1, 75.00),
    ('P124ABC', '2026-10-11T08:00:00', 'Aceite de motor', 4, 55.00),
    ('P987PQR', '2026-10-12T09:00:00', 'Pastillas de freno', 1, 350.00),
    ('P987PQR', '2026-10-12T09:00:00', 'Disco de freno', 2, 500.00)
) AS d(placa, fecha_recepcion, nombreRepuesto, cantidad, precio_aplicado)
INNER JOIN OrdenReparacion o
    ON o.fecha_recepcion = d.fecha_recepcion
INNER JOIN Vehiculo v
    ON v.idVehiculo = o.idVehiculo
    AND v.placa = d.placa
INNER JOIN Repuesto r
    ON r.nombre = d.nombreRepuesto;


INSERT INTO ParticipacionMecanico (
    idOrden,
    idMecanico,
    trabajo_realizado,
    horas_trabajadas
)
SELECT
    o.idOrden,
    m.idMecanico,
    p.trabajo_realizado,
    p.horas_trabajadas
FROM (VALUES
    ('P123ABC', '2026-10-05T08:00:00', 'Luis Pérez', 'Cambio de aceite y mantenimiento general', 3.00),
    ('P456DEF', '2026-10-06T09:00:00', 'María García', 'Inspección del sistema de frenos', 4.00),
    ('P123ABC', '2026-10-07T08:30:00', 'Luis Pérez', 'Diagnóstico y mantenimiento del motor', 5.00),
    ('P789GHI', '2026-10-08T10:00:00', 'Carlos Ruiz', 'Cambio de aceite y revisión general', 3.00),
    ('P321JKL', '2026-10-09T08:00:00', 'Luis Pérez', 'Mantenimiento preventivo', 3.00),
    ('P654MNO', '2026-10-10T09:00:00', 'José Morales', 'Diagnóstico del motor y revisión eléctrica', 5.00),
    ('P124ABC', '2026-10-11T08:00:00', 'Luis Pérez', 'Servicio general y cambio de aceite', 4.00),
    ('P987PQR', '2026-10-12T09:00:00', 'Luis Pérez', 'Mantenimiento y revisión de frenos', 4.00),
    ('P456DEF', '2026-10-06T09:00:00', 'Luis Pérez', 'Apoyo en reparación del sistema de frenos', 2.00),
    ('P654MNO', '2026-10-10T09:00:00', 'María García', 'Revisión del sistema eléctrico', 3.00)
) AS p(placa, fecha_recepcion, nombreMecanico, trabajo_realizado, horas_trabajadas)
INNER JOIN OrdenReparacion o
    ON o.fecha_recepcion = p.fecha_recepcion
INNER JOIN Vehiculo v
    ON v.idVehiculo = o.idVehiculo
    AND v.placa = p.placa
INNER JOIN Mecanico m
    ON m.nombre = p.nombreMecanico;


COMMIT TRANSACTION;


SELECT 'Cliente' AS Tabla, COUNT(*) AS Registros FROM Cliente
UNION ALL
SELECT 'Vehiculo', COUNT(*) FROM Vehiculo
UNION ALL
SELECT 'Mecanico', COUNT(*) FROM Mecanico
UNION ALL
SELECT 'OrdenReparacion', COUNT(*) FROM OrdenReparacion
UNION ALL
SELECT 'Servicio', COUNT(*) FROM Servicio
UNION ALL
SELECT 'Repuesto', COUNT(*) FROM Repuesto
UNION ALL
SELECT 'DetalleServicioOrden', COUNT(*) FROM DetalleServicioOrden
UNION ALL
SELECT 'DetalleRepuestoOrden', COUNT(*) FROM DetalleRepuestoOrden
UNION ALL
SELECT 'ParticipacionMecanico', COUNT(*) FROM ParticipacionMecanico;