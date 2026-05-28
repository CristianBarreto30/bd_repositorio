-- =========================================================
-- CONSULTAS FUNDAMENTALES Y AVANZADAS EN PostgreSQL
-- =========================================================

-- =========================================================
-- 1. SELECCIÓN BÁSICA
-- Obtener todos los clientes registrados
-- =========================================================

SELECT *
FROM shared.clientes;

-- =========================================================
-- 2. PROYECCIÓN Y FILTROS
-- Seleccionar columnas específicas con filtro y ordenamiento
-- =========================================================

SELECT
    nombre,
    email
FROM shared.clientes
-- like es para buscar patrones en el email, en este caso todos los que terminan con @email.com
WHERE email LIKE '%@email.com'
ORDER BY nombre ASC;

-- =========================================================
-- 3. CONSULTAS DE AGREGACIÓN
-- Estadísticas de productos por categoría
-- =========================================================

SELECT
    categoria,
    --count es para contar el numero de productos en cada categoria,
    -- avg es para calcular el precio promedio, round es para redondear a 2 decimales,
    -- sum es para sumar el stock total
    COUNT(*) AS total_productos,
    ROUND(AVG(precio), 2) AS precio_promedio,
    SUM(stock) AS stock_total
FROM shared.productos
GROUP BY categoria
HAVING COUNT(*) > 1
ORDER BY total_productos DESC;

-- =========================================================
-- 4. PAGINACIÓN
-- Obtener productos paginados
-- =========================================================

SELECT *
-- shared.productos es la tabla de productos en el esquema compartido
FROM shared.productos
ORDER BY precio DESC
LIMIT 10 OFFSET 0;

-- =========================================================
-- 5. SUBCONSULTA
-- Productos con precio superior al promedio
-- =========================================================

SELECT
    nombre,
    precio
FROM shared.productos
WHERE precio > (
    SELECT AVG(precio)
    FROM shared.productos
);

-- =========================================================
-- 6. SUBCONSULTA CORRELACIONADA
-- Clientes que han realizado pedidos
-- =========================================================

SELECT
    c.nombre,
    c.email
FROM shared.clientes c
WHERE EXISTS (
    SELECT 1
    FROM shared.pedidos p
    WHERE p.cliente_id = c.cliente_id
);


-- =========================================================
-- 7. MÚLTIPLES JOINS
-- Información completa de pedidos
-- =========================================================

SELECT
    c.nombre,
    pr.nombre AS producto,
    dp.cantidad,
    dp.total_pedido
FROM shared.detalle_pedidos dp
INNER JOIN shared.pedidos p
    ON dp.pedido_id = p.pedido_id
INNER JOIN shared.clientes c
    ON p.cliente_id = c.cliente_id
INNER JOIN shared.productos pr
    ON dp.producto_id = pr.producto_id;

-- =========================================================
-- 8. CASE
-- Clasificación de productos según precio
-- =========================================================

SELECT
    nombre,
    precio,
-- case es para crear una nueva columna llamada categoria_precio,
-- que clasifica los productos en 3 categorias segun su precio,
    CASE
        WHEN precio < 50 THEN 'ECONÓMICO'
        WHEN precio BETWEEN 50 AND 200 THEN 'INTERMEDIO'
        ELSE 'PREMIUM'
    END AS categoria_precio

FROM shared.productos;

-- =========================================================
-- 9. CTE (COMMON TABLE EXPRESSION)
-- Productos con stock bajo
-- =========================================================
-- with es para crear una tabla temporal llamada stock_bajo,
-- que contiene los productos con stock menor a 5,
WITH stock_bajo AS (

    SELECT
        nombre,
        stock
    FROM shared.productos
    WHERE stock < 5
)

SELECT *
FROM stock_bajo
ORDER BY stock ASC;

-- =========================================================
-- 10. CONSULTA ANALÍTICA
-- Total gastado por cliente
-- =========================================================

SELECT
    c.nombre,
    SUM(dp.total_pedido) AS total_gastado
FROM shared.clientes c
INNER JOIN shared.pedidos p
    ON c.cliente_id = p.cliente_id
INNER JOIN shared.detalle_pedidos dp
    ON p.pedido_id = dp.pedido_id
GROUP BY c.nombre
ORDER BY total_gastado DESC;