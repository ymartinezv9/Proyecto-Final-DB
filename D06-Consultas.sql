USE TallerAutomotrizDB;


-- 5.1. Resumen de órdenes de reparación

WITH TotalServicios AS (
    SELECT
        idOrden,
        SUM(cantidad * precio_aplicado) AS total_servicios
    FROM DetalleServicioOrden
    GROUP BY idOrden
),
TotalRepuestos AS (
    SELECT
        idOrden,
        SUM(cantidad * precio_aplicado) AS total_repuestos
    FROM DetalleRepuestoOrden
    GROUP BY idOrden
)
SELECT
    o.idOrden AS CodigoOrden,
    o.fecha_recepcion AS FechaRecepcion,
    c.nombre AS Cliente,
    v.placa AS PlacaVehiculo,
    m.nombre AS MecanicoResponsable,
    COALESCE(ts.total_servicios, 0) AS TotalServicios,
    COALESCE(tr.total_repuestos, 0) AS TotalRepuestos,
    COALESCE(ts.total_servicios, 0) +
    COALESCE(tr.total_repuestos, 0) AS CostoTotal
FROM OrdenReparacion o
INNER JOIN Vehiculo v
    ON o.idVehiculo = v.idVehiculo
INNER JOIN Cliente c
    ON v.idCliente = c.idCliente
INNER JOIN Mecanico m
    ON o.idMecanico = m.idMecanico
LEFT JOIN TotalServicios ts
    ON o.idOrden = ts.idOrden
LEFT JOIN TotalRepuestos tr
    ON o.idOrden = tr.idOrden
ORDER BY o.fecha_recepcion DESC, o.idOrden;


-- 5.2. Historial de reparaciones por vehículo

WITH TotalServicios AS (
    SELECT
        idOrden,
        SUM(cantidad * precio_aplicado) AS total_servicios
    FROM DetalleServicioOrden
    GROUP BY idOrden
),
TotalRepuestos AS (
    SELECT
        idOrden,
        SUM(cantidad * precio_aplicado) AS total_repuestos
    FROM DetalleRepuestoOrden
    GROUP BY idOrden
),
TotalOrdenes AS (
    SELECT
        o.idOrden,
        o.idVehiculo,
        COALESCE(ts.total_servicios, 0) +
        COALESCE(tr.total_repuestos, 0) AS costo_total
    FROM OrdenReparacion o
    LEFT JOIN TotalServicios ts
        ON o.idOrden = ts.idOrden
    LEFT JOIN TotalRepuestos tr
        ON o.idOrden = tr.idOrden
)
SELECT
    v.placa AS PlacaVehiculo,
    v.marca AS Marca,
    v.modelo AS Modelo,
    c.nombre AS Propietario,
    COUNT(t.idOrden) AS CantidadOrdenes,
    COALESCE(SUM(t.costo_total), 0) AS CostoAcumulado
FROM Vehiculo v
INNER JOIN Cliente c
    ON v.idCliente = c.idCliente
LEFT JOIN TotalOrdenes t
    ON v.idVehiculo = t.idVehiculo
GROUP BY
    v.idVehiculo,
    v.placa,
    v.marca,
    v.modelo,
    c.nombre
ORDER BY CostoAcumulado DESC;


-- 5.3. Mecánicos con mayor participación

SELECT
    m.idMecanico,
    m.nombre AS Mecanico,
    COUNT(DISTINCT pm.idOrden) AS CantidadOrdenes,
    SUM(pm.horas_trabajadas) AS TotalHorasTrabajadas
FROM Mecanico m
INNER JOIN ParticipacionMecanico pm
    ON m.idMecanico = pm.idMecanico
GROUP BY
    m.idMecanico,
    m.nombre
HAVING COUNT(DISTINCT pm.idOrden) > 5
ORDER BY CantidadOrdenes DESC, TotalHorasTrabajadas DESC;


-- 5.4. Servicios más solicitados

SELECT
    s.idServicio,
    s.nombre AS Servicio,
    COUNT(DISTINCT dso.idOrden) AS CantidadOrdenes,
    SUM(dso.cantidad * dso.precio_aplicado) AS ImporteTotal
FROM Servicio s
INNER JOIN DetalleServicioOrden dso
    ON s.idServicio = dso.idServicio
GROUP BY
    s.idServicio,
    s.nombre
HAVING COUNT(DISTINCT dso.idOrden) > 5
ORDER BY CantidadOrdenes DESC, ImporteTotal DESC;


-- 5.5. Consumo de repuestos

SELECT
    r.idRepuesto,
    r.nombre AS Repuesto,
    SUM(dro.cantidad) AS CantidadTotalUtilizada,
    SUM(dro.cantidad * dro.precio_aplicado) AS ImporteTotal
FROM Repuesto r
INNER JOIN DetalleRepuestoOrden dro
    ON r.idRepuesto = dro.idRepuesto
GROUP BY
    r.idRepuesto,
    r.nombre
HAVING SUM(dro.cantidad) > 10
ORDER BY CantidadTotalUtilizada DESC;


-- 5.6. Ingresos por cliente y tipo de servicio

SELECT
    c.idCliente,
    c.nombre AS Cliente,
    s.nombre AS TipoServicio,
    COUNT(DISTINCT dso.idOrden) AS CantidadOrdenes,
    SUM(dso.cantidad * dso.precio_aplicado) AS ImporteTotal
FROM Cliente c
INNER JOIN Vehiculo v
    ON c.idCliente = v.idCliente
INNER JOIN OrdenReparacion o
    ON v.idVehiculo = o.idVehiculo
INNER JOIN DetalleServicioOrden dso
    ON o.idOrden = dso.idOrden
INNER JOIN Servicio s
    ON dso.idServicio = s.idServicio
GROUP BY
    c.idCliente,
    c.nombre,
    s.idServicio,
    s.nombre
HAVING SUM(dso.cantidad * dso.precio_aplicado) > 2000
ORDER BY ImporteTotal DESC;


-- 5.7. Clientes con gastos superiores al promedio

WITH TotalServicios AS (
    SELECT
        idOrden,
        SUM(cantidad * precio_aplicado) AS total_servicios
    FROM DetalleServicioOrden
    GROUP BY idOrden
),
TotalRepuestos AS (
    SELECT
        idOrden,
        SUM(cantidad * precio_aplicado) AS total_repuestos
    FROM DetalleRepuestoOrden
    GROUP BY idOrden
),
TotalOrdenes AS (
    SELECT
        o.idOrden,
        o.idVehiculo,
        COALESCE(ts.total_servicios, 0) +
        COALESCE(tr.total_repuestos, 0) AS costo_total
    FROM OrdenReparacion o
    LEFT JOIN TotalServicios ts
        ON o.idOrden = ts.idOrden
    LEFT JOIN TotalRepuestos tr
        ON o.idOrden = tr.idOrden
),
GastoPorCliente AS (
    SELECT
        c.idCliente,
        c.nombre,
        COALESCE(SUM(t.costo_total), 0) AS gasto_acumulado
    FROM Cliente c
    LEFT JOIN Vehiculo v
        ON c.idCliente = v.idCliente
    LEFT JOIN TotalOrdenes t
        ON v.idVehiculo = t.idVehiculo
    GROUP BY
        c.idCliente,
        c.nombre
)
SELECT
    idCliente,
    nombre AS Cliente,
    gasto_acumulado AS GastoAcumulado
FROM GastoPorCliente
WHERE gasto_acumulado > (
    SELECT AVG(gasto_acumulado)
    FROM GastoPorCliente
)
ORDER BY gasto_acumulado DESC;