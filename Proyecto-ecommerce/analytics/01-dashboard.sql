-- SISTEMA DE ANALYTICS (en progreso)
-- Proyecto para demostrar:
--   - Vistas materializadas
--   - Datos de series temporales
--   - Funciones analíticas avanzadas

CREATE SCHEMA IF NOT EXISTS analytics;
SET search_path TO analytics;

-- Vista materializada para dashboard de ventas
CREATE MATERIALIZED VIEW mv_ventas_diarias AS
SELECT
    o.created_at::DATE AS fecha,
    COUNT(DISTINCT o.id) AS ordenes,
    COUNT(DISTINCT o.cliente_id) AS clientes_unicos,
    SUM(o.total) AS ingresos,
    ROUND(AVG(o.total), 2) AS ticket_promedio
FROM shared.ordenes o
WHERE o.estatus NOT IN ('cancelado')
GROUP BY o.created_at::DATE
ORDER BY fecha DESC;

-- Refresh programado (ejecutar con cron o pg_tle)
-- REFRESH MATERIALIZED VIEW mv_ventas_diarias;
