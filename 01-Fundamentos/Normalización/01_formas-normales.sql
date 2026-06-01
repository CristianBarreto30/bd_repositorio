-- =========================================================
-- EJEMPLO DE NORMALIZACIÓN DE BASES DE DATOS
-- 1FN, 2FN y 3FN
-- Sistema de gestión de pedidos para e-commerce
-- =========================================================

-- =========================================================
-- 0. TABLA DESNORMALIZADA
-- Ejemplo de estructura con redundancia
-- =========================================================
-- En esta tabla, cada fila representa un pedido, pero se repite información del cliente y del producto es decir no hay normalización, 
--lo que genera redundancia y posibles inconsistencias.
CREATE TABLE pedidos_desnormalizado (
    pedido_id          INTEGER,
    cliente_nombre     VARCHAR(100),
    cliente_email      VARCHAR(200),
    producto_nombre    VARCHAR(200),
    producto_precio    NUMERIC(10,2),
    cantidad           INTEGER,
    fecha_pedido       DATE
);

-- Problemas detectados:
-- - Información duplicada de clientes
-- - Información duplicada de productos
-- - Riesgo de inconsistencias
-- - Dificultad de mantenimiento
-- - Baja escalabilidad

-- =========================================================
-- ESTRUCTURA NORMALIZADA
-- Aplicación de 1FN, 2FN y 3FN
-- =========================================================

CREATE TABLE clientes_normalizado (
    cliente_id     SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    apellido       VARCHAR(100) NOT NULL,
    telefono        VARCHAR(20),
    email          VARCHAR(200) UNIQUE NOT NULL,
    creado_en      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productos_normalizado (
    producto_id     SERIAL PRIMARY KEY,
    nombre          VARCHAR(200) NOT NULL,
    precio          NUMERIC(10,2) NOT NULL CHECK (precio > 0),
    -- integer es para cantidades enteras, como stock o cantidad en pedido--
    stock           INTEGER DEFAULT 0 CHECK (stock >= 0),
    creado_en       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos_normalizado (
    pedido_id       SERIAL PRIMARY KEY,
    cliente_id      INTEGER NOT NULL,
    --date not nyll es para que no se puedan insertar pedidos sin fecha,
    -- y default current_date es para que si no se especifica fecha, se asigne la fecha actual
    fecha_pedido    DATE NOT NULL DEFAULT CURRENT_DATE,
    estado          VARCHAR(30) DEFAULT 'PENDIENTE',

    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES clientes_normalizado(cliente_id)
        ON DELETE CASCADE
);

CREATE TABLE pedido_detalles_normalizado (
    --el interger references es para establecer la relación entre las tablas, 
    --indicando que pedido_id hace referencia a la columna id de la tabla pedidos_normalizado,
    -- y producto_id hace referencia a la columna id de la tabla productos_normalizado. 
    --Esto asegura la integridad referencial, es decir, que no se puedan insertar detalles de pedido para pedidos o productos que no existan.
    pedido_id   INTEGER REFERENCES pedidos_normalizado(id),
    producto_id INTEGER REFERENCES productos_normalizado(id),
    cantidad    INTEGER NOT NULL CHECK (cantidad > 0),
    total_pedido NUMERIC(10,2) NOT NULL CHECK (total_pedido > 0),
    PRIMARY KEY (pedido_id, producto_id)
);
