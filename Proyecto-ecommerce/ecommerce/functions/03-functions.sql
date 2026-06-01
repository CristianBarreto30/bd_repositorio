-- Funciones y procedimientos del e-commerce

-- Calcular total de una orden automáticamente
CREATE OR REPLACE FUNCTION calcular_total_orden(p_orden_id INTEGER)
RETURNS NUMERIC(12,2) AS $$
DECLARE
    v_total NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
    INTO v_total
    FROM orden_detalles
    WHERE orden_id = p_orden_id;

    UPDATE ordenes SET total = v_total WHERE id = p_orden_id;
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Obtener productos con stock bajo
CREATE OR REPLACE FUNCTION productos_stock_bajo(p_minimo INTEGER DEFAULT 10)
RETURNS TABLE(
    producto_id   INTEGER,
    nombre        VARCHAR(200),
    stock_actual  INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT id, nombre, stock
    FROM productos
    WHERE stock <= p_minimo
    ORDER BY stock ASC;
END;
$$ LANGUAGE plpgsql;
