/*
========================================================
 VISTAS (VIEWS) EN POSTGRESQL
========================================================

Las vistas son consultas almacenadas que se
comportan como tablas virtuales.

Permiten:
✔ simplificar consultas
✔ reutilizar lógica SQL
✔ ocultar complejidad
✔ mejorar seguridad
✔ centralizar información

========================================================
 TABLAS DE EJEMPLO
========================================================
*/

CREATE TABLE clientes (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE
);

CREATE TABLE ordenes (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    cliente_id BIGINT REFERENCES clientes(id),

    total NUMERIC(10,2),

    created_at TIMESTAMPTZ DEFAULT NOW()
);

/*
========================================================
 CREATE VIEW
========================================================

Vista con información de clientes y órdenes
*/

CREATE VIEW vw_clientes_ordenes AS

SELECT
    c.id,
    c.nombre,
    c.email,
    o.total,
    o.created_at

FROM clientes c

INNER JOIN ordenes o
ON o.cliente_id = c.id;

/*
========================================================
 USO DE LA VISTA
========================================================
*/

SELECT *
FROM vw_clientes_ordenes;

/*
========================================================
 VISTA PARA REPORTES
========================================================
*/

CREATE VIEW vw_total_ventas AS

SELECT
    cliente_id,
    COUNT(*) AS total_ordenes,
    SUM(total) AS total_ventas

FROM ordenes

GROUP BY cliente_id;

/*
========================================================
 VISTAS MATERIALIZADAS
========================================================

Almacenan físicamente los datos.
Mejoran rendimiento en consultas pesadas.
*/

CREATE MATERIALIZED VIEW mv_reporte_ventas AS

SELECT
    cliente_id,
    SUM(total) AS total_ventas
FROM ordenes
GROUP BY cliente_id;

/*
========================================================
 REFRESH MATERIALIZED VIEW
========================================================

Actualiza los datos almacenados
*/

REFRESH MATERIALIZED VIEW mv_reporte_ventas;

/*
========================================================
 CREATE OR REPLACE VIEW
========================================================

Permite modificar una vista existente
*/

CREATE OR REPLACE VIEW vw_clientes_ordenes AS

SELECT
    c.nombre,
    o.total
FROM clientes c
JOIN ordenes o
ON o.cliente_id = c.id;

/*
========================================================
 ELIMINAR VISTAS
========================================================
*/

DROP VIEW IF EXISTS vw_clientes_ordenes;

DROP MATERIALIZED VIEW IF EXISTS mv_reporte_ventas;

/*
========================================================
 TIPOS DE VISTAS
========================================================

✔ VIEW
✔ MATERIALIZED VIEW

========================================================
 DIFERENCIAS
========================================================

VIEW:
    consulta dinámica

MATERIALIZED VIEW:
    datos almacenados físicamente

========================================================
 BUENAS PRÁCTICAS
========================================================

✔ usar nombres descriptivos
✔ prefijo vw_ para vistas
✔ prefijo mv_ para materialized views
✔ evitar lógica excesiva
✔ usar materialized views en reportes pesados

========================================================
 IMPORTANCIA
========================================================

Las vistas ayudan a simplificar consultas,
mejorar organización y reutilizar lógica SQL.

========================================================
*/