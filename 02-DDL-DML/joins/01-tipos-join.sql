/*
========================================================
 JOINS EN POSTGRESQL
========================================================

Los JOINS permiten combinar datos de múltiples tablas
basados en relaciones entre ellas.

========================================================
 INNER JOIN
========================================================
Solo registros que coinciden en ambas tablas
*/

SELECT c.nombre, o.id AS orden_id, o.total
FROM shared.clientes c
INNER JOIN shared.ordenes o
ON o.cliente_id = c.id;

/*
========================================================
 LEFT JOIN
========================================================
Todos los registros de la izquierda + coincidencias
*/

SELECT c.nombre, o.id AS orden_id, o.total
FROM shared.clientes c
LEFT JOIN shared.ordenes o
ON o.cliente_id = c.id;

/*
========================================================
 RIGHT JOIN
========================================================
Todos los registros de la derecha + coincidencias
*/

SELECT c.nombre, o.id AS orden_id, o.total
FROM shared.clientes c
RIGHT JOIN shared.ordenes o
ON o.cliente_id = c.id;

/*
========================================================
 FULL OUTER JOIN
========================================================
Todos los registros de ambas tablas
*/

SELECT c.nombre, o.id AS orden_id
FROM shared.clientes c
FULL OUTER JOIN shared.ordenes o
ON o.cliente_id = c.id;

/*
========================================================
 CROSS JOIN
========================================================
Producto cartesiano (todas las combinaciones)
*/

SELECT c.nombre, p.nombre AS producto
FROM shared.clientes c
CROSS JOIN shared.productos p;

/*
========================================================
 SELF JOIN
========================================================
Una tabla relacionada consigo misma
*/

SELECT a.nombre AS empleado, b.nombre AS supervisor
FROM empleados a
LEFT JOIN empleados b
ON a.supervisor_id = b.id;

/*
========================================================
 LATERAL JOIN
========================================================
Subconsulta dependiente de cada fila externa
*/

SELECT c.nombre, o.*
FROM shared.clientes c
LEFT JOIN LATERAL (
    SELECT *
    FROM shared.ordenes
    WHERE cliente_id = c.id
    ORDER BY total DESC
    LIMIT 1
) o ON true;

/*
========================================================
 RESUMEN RÁPIDO
========================================================

INNER  -> coincidencias en ambas
LEFT   -> todo izquierda + coincidencias
RIGHT  -> todo derecha + coincidencias
FULL   -> todo de ambas tablas
CROSS  -> combinaciones totales
SELF   -> misma tabla
LATERAL-> subconsulta por fila

========================================================
*/