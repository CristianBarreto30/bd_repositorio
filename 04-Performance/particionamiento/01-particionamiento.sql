-- PARTICIONAMIENTO NATIVO (PostgreSQL 10+)
SET search_path TO rendimiento;

-- RANGE: ideal para datos ordenados (fechas, IDs secuenciales)
CREATE TABLE ordenes_part (
    id          BIGSERIAL,
    cliente_id  UUID NOT NULL,
    total       NUMERIC(12,2),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (created_at);

CREATE TABLE ordenes_2026_01 PARTITION OF ordenes_part
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE ordenes_2026_02 PARTITION OF ordenes_part
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
CREATE TABLE ordenes_2026_03 PARTITION OF ordenes_part
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE ordenes_future PARTITION OF ordenes_part
    FOR VALUES FROM ('2026-04-01') TO ('9999-12-31');

-- LIST: categorías, regiones, estados
CREATE TABLE ventas_region (
    id     BIGSERIAL,
    region VARCHAR(20) NOT NULL,
    monto  NUMERIC(10,2)
) PARTITION BY LIST (region);

CREATE TABLE ventas_norte PARTITION OF ventas_region FOR VALUES IN ('norte');
CREATE TABLE ventas_sur  PARTITION OF ventas_region FOR VALUES IN ('sur');
CREATE TABLE ventas_otras PARTITION OF ventas_region FOR VALUES IN ('este', 'oeste');

-- HASH: distribución uniforme cuando no hay clave natural
CREATE TABLE logs (
    id     BIGSERIAL,
    nivel  VARCHAR(10),
    msg    TEXT
) PARTITION BY HASH (id);

CREATE TABLE logs_0 PARTITION OF logs FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE logs_1 PARTITION OF logs FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE logs_2 PARTITION OF logs FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE logs_3 PARTITION OF logs FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Partition pruning: el plan solo escanea particiones relevantes
INSERT INTO ordenes_part (cliente_id, total, created_at) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 150, '2026-01-15'),
    ('550e8400-e29b-41d4-a716-446655440002', 250, '2026-02-10');

EXPLAIN ANALYZE
SELECT * FROM ordenes_part WHERE created_at >= '2026-01-01' AND created_at < '2026-02-01';

-- Mantenimiento: desprender/drop de particiones es O(1)
-- ALTER TABLE ordenes_part DETACH PARTITION ordenes_2026_01;
-- DROP TABLE ordenes_2026_01;
