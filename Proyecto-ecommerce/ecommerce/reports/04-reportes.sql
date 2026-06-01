-- Reportes de análisis del e-commerce

-- 1. Ventas por categoría
SELECT
    c.nombre AS categoria,
    COUNT(DISTINCT o.id) AS total_ordenes,
    SUM(od.cantidad) AS unidades_vendidas,
    SUM(od.cantidad * od.precio_unitario) AS ingresos_totales
FROM categorias c
JOIN productos p ON p.categoria_id = c.id
JOIN orden_detalles od ON od.producto_id = p.id
JOIN ordenes o ON o.id = od.orden_id
WHERE o.estatus IN ('pagado', 'enviado', 'entregado')
GROUP BY c.id, c.nombre
ORDER BY ingresos_totales DESC;

-- 2. Top 5 productos más vendidos
SELECT
    p.nombre,
    SUM(od.cantidad) AS total_vendido,
    SUM(od.cantidad * od.precio_unitario) AS ingreso
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY p.id, p.nombre
ORDER BY total_vendido DESC
LIMIT 5;

-- 3. Clientes con más compras
SELECT
    cl.nombre,
    COUNT(o.id) AS num_ordenes,
    SUM(o.total) AS gasto_total
FROM clientes cl
JOIN ordenes o ON o.cliente_id = cl.id
GROUP BY cl.id, cl.nombre
ORDER BY gasto_total DESC;
