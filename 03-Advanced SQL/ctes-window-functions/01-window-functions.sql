-- WINDOW FUNCTIONS (funciones de ventana) - PostgreSQL

-- ROW_NUMBER: numerar filas
SELECT
    p.nombre,
    p.categoria,
    p.precio,
    ROW_NUMBER() OVER (PARTITION BY p.categoria ORDER BY p.precio DESC) AS ranking
FROM shared.productos p;

-- RANK y DENSE_RANK
SELECT
    p.nombre,
    p.categoria,
    p.precio,
    RANK()        OVER (ORDER BY p.precio DESC) AS rank,
    DENSE_RANK()  OVER (ORDER BY p.precio DESC) AS dense_rank
FROM shared.productos p;

-- LAG y LEAD (comparar con fila anterior/siguiente)
SELECT
    o.created_at::DATE AS fecha,
    COUNT(*) AS ordenes,
    LAG(COUNT(*), 1, 0)  OVER (ORDER BY o.created_at::DATE) AS dia_anterior,
    LEAD(COUNT(*), 1, 0) OVER (ORDER BY o.created_at::DATE) AS dia_siguiente
FROM shared.ordenes o
GROUP BY o.created_at::DATE;

-- SUM acumulativo (running total)
SELECT
    o.created_at::DATE AS fecha,
    o.total,
    SUM(o.total) OVER (ORDER BY o.created_at::DATE) AS acumulado
FROM shared.ordenes o;

-- CTE + Window Function: top 3 por categoría
WITH ranked AS (
    SELECT
        p.nombre,
        p.categoria,
        p.precio,
        ROW_NUMBER() OVER (PARTITION BY p.categoria ORDER BY p.precio DESC) AS rn
    FROM shared.productos p
)
SELECT * FROM ranked WHERE rn <= 3;
