-- ============================================================
-- PROYECTO: E-Commerce (Migrado de MySQL a PostgreSQL)
-- ============================================================

-- Crear base de datos (ejecutar como superusuario)
-- CREATE DATABASE ecommerce WITH ENCODING 'UTF8';
-- \c ecommerce;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CATEGORÍAS
CREATE TABLE categorias (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. PRODUCTOS
CREATE TABLE productos (
    id            SERIAL PRIMARY KEY,
    nombre        VARCHAR(200) NOT NULL,
    descripcion   TEXT,
    precio        NUMERIC(10,2) NOT NULL CHECK (precio > 0),
    stock         INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria_id  INTEGER REFERENCES categorias(id) ON DELETE SET NULL,
    imagen        VARCHAR(500),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_productos_updated_at
    BEFORE UPDATE ON productos
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_updated_at();

-- 3. CLIENTES (nueva tabla agregada)
CREATE TABLE clientes (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    email       VARCHAR(200) UNIQUE NOT NULL,
    telefono    VARCHAR(20),
    direccion   TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. ÓRDENES
CREATE TABLE ordenes (
    id            SERIAL PRIMARY KEY,
    cliente_id    INTEGER NOT NULL REFERENCES clientes(id),
    total         NUMERIC(12,2) NOT NULL DEFAULT 0,
    estatus       VARCHAR(20) DEFAULT 'pendiente'
                    CHECK (estatus IN ('pendiente','pagado','enviado','entregado','cancelado')),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. DETALLE DE ÓRDENES
CREATE TABLE orden_detalles (
    id              SERIAL PRIMARY KEY,
    orden_id        INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    producto_id     INTEGER NOT NULL REFERENCES productos(id),
    cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL
);

-- Índices para rendimiento
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_ordenes_cliente ON ordenes(cliente_id);
CREATE INDEX idx_orden_detalles_orden ON orden_detalles(orden_id);
