-- EXPLAIN ANALYZE: Plan de ejecución
SET search_path TO shared;

-- EXPLAIN: muestra el plan estimado sin ejecutar
EXPLAIN SELECT * FROM shared.clientes;

-- EXPLAIN ANALYZE: ejecuta y muestra plan + tiempos reales
EXPLAIN ANALYZE
SELECT * FROM shared.productos WHERE precio > 500;

-- EXPLAIN (ANALYZE, BUFFERS): incluye estadísticas de caché
EXPLAIN (ANALYZE, BUFFERS)
SELECT c.nombre, SUM(o.total) AS gasto
FROM shared.clientes c
JOIN shared.ordenes o ON o.cliente_id = c.id
GROUP BY c.id, c.nombre;

-- EXPLAIN (FORMAT JSON): plan estructurado para análisis programático
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT * FROM shared.ordenes WHERE estatus = 'pagado';

-- Tipos de nodos en el plan:
--   Seq Scan     → escanea toda la tabla (lento en tablas grandes)
--   Index Scan   → busca por índice y accede a la fila
--   Index Only   → índice suficiente, no toca la tabla
--   Bitmap Scan  → combina varios índices
--   Nested Loop  → join anidado (ideal con índice)
--   Hash Join    → join con tabla hash
--   Merge Join   → join sobre datos ordenados
