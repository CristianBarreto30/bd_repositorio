-- SISTEMA DE INVENTARIO (en progreso)
-- Proyecto para demostrar:
--   - Triggers para auditoría de stock
--   - Vistas materializadas para reportes
--   - Particionamiento por fecha

CREATE SCHEMA IF NOT EXISTS inventario;
SET search_path TO inventario;

-- Tabla particionada por mes
CREATE TABLE movimientos_stock (
    id          BIGSERIAL,
    producto_id INTEGER NOT NULL,
    tipo        VARCHAR(10) CHECK (tipo IN ('entrada','salida')),
    cantidad    INTEGER NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (created_at);

-- Crear particiones mensuales (ejemplo)
CREATE TABLE movimientos_2026_01 PARTITION OF movimientos_stock
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE movimientos_2026_02 PARTITION OF movimientos_stock
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
