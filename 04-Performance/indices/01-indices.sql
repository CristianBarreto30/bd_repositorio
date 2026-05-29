-- ÍNDICES: Tipos, uso y mantenimiento
SET search_path TO shared;

-- B-Tree (por defecto): =, <, >, BETWEEN, LIKE prefijo, ORDER BY
CREATE INDEX idx_productos_precio ON shared.productos USING btree (precio);
CREATE INDEX idx_productos_categoria ON shared.productos USING btree (categoria);

-- Compuesto: orden de columnas según selectividad
CREATE INDEX idx_productos_cat_precio
    ON shared.productos USING btree (categoria, precio);

-- Parcial: solo filas relevantes (menor tamaño)
CREATE INDEX idx_ordenes_activas
    ON shared.ordenes USING btree (created_at DESC)
    WHERE estatus NOT IN ('cancelado', 'entregado');

-- Funcional: índice sobre expresión
CREATE INDEX idx_clientes_dominio
    ON shared.clientes USING btree (split_part(email, '@', 2));

-- Hash: solo para comparación por igualdad (=)
CREATE INDEX idx_ordenes_estatus_hash
    ON shared.ordenes USING hash (estatus);

-- GIN: arrays, JSONB, full-text search
CREATE INDEX idx_metadata ON shared.productos USING gin (categoria);

-- BRIN: tablas con datos correlacionados físicamente (menor tamaño)
CREATE INDEX idx_ordenes_brin ON shared.ordenes USING brin (created_at);

-- Diagnóstico de índices
SELECT
    i.relname AS indice,
    pg_size_pretty(pg_relation_size(i.oid)) AS tamaño,
    COALESCE(s.idx_scan, 0) AS scans
FROM pg_index x
JOIN pg_class i ON i.oid = x.indexrelid
JOIN pg_class t ON t.oid = x.indrelid
LEFT JOIN pg_stat_user_indexes s ON s.indexrelid = x.indexrelid
WHERE t.relname NOT LIKE 'pg_%'
ORDER BY pg_relation_size(i.oid) DESC;

-- Reindexar (sin bloqueo en PG12+)
-- REINDEX INDEX CONCURRENTLY idx_productos_precio;
