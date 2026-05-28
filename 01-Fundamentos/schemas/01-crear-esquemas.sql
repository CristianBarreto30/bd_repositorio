/*
========================================================
 ORGANIZACIÓN CON SCHEMAS EN POSTGRESQL
========================================================

Un schema funciona como una carpeta lógica dentro
de una base de datos.

Permite:
- Organizar módulos
- Separar responsabilidades
- Mejorar seguridad
- Evitar conflictos de nombres
- Escalar aplicaciones grandes

Ejemplo:
    ventas.clientes
    inventario.productos

========================================================
 COMPATIBILIDAD CON OTROS GESTORES
========================================================

PostgreSQL:
    Soporte completo de schemas

SQL Server:
    Muy similar a PostgreSQL

Oracle:
    Maneja schemas por usuario

MySQL:
    ⚠ SCHEMA = DATABASE
    No soporta múltiples schemas internos reales

SQLite:
    No soporta schemas reales

========================================================
 CREACIÓN DE SCHEMAS
========================================================
*/

CREATE SCHEMA IF NOT EXISTS ventas;
CREATE SCHEMA IF NOT EXISTS inventario;
CREATE SCHEMA IF NOT EXISTS recursos_humanos;
CREATE SCHEMA IF NOT EXISTS auditoria;

/*
========================================================
 TABLA: ventas.clientes
========================================================

Buenas prácticas aplicadas:
- Uso de IDENTITY en vez de SERIAL
- Restricciones NOT NULL
- Auditoría básica
- Valores por defecto
*/

CREATE TABLE IF NOT EXISTS ventas.clientes (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
--esto sirve para marcar si el cliente esta activo o inactivo, en vez de eliminarlo
    activo BOOLEAN DEFAULT TRUE,
-- auditoría básica para saber cuándo se creó o actualizó el registro
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

/*
========================================================
 TABLA: inventario.productos
========================================================
*/

CREATE TABLE IF NOT EXISTS inventario.productos (
-- se utliza BIGINT para IDs en sistemas empresariales, permite más registros que INTEGER 
--y el generated always as identity es la forma moderna de autoincrementar en PostgreSQL,
-- evitando problemas de secuencias
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,

    stock INTEGER NOT NULL DEFAULT 0,
    precio NUMERIC(12,2) NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT chk_stock_positivo
        CHECK (stock >= 0),

    CONSTRAINT chk_precio_positivo
        CHECK (precio >= 0)
);

/*
========================================================
 RELACIONES ENTRE TABLAS
========================================================

Ejemplo:
ventas.ventas -> ventas.clientes
*/

CREATE TABLE IF NOT EXISTS ventas.ventas (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    cliente_id BIGINT NOT NULL,

    total NUMERIC(12,2) NOT NULL,

    fecha TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES ventas.clientes(id)
        ON DELETE RESTRICT
);

/*
========================================================
 INSERCIÓN DE DATOS
========================================================
*/

INSERT INTO ventas.clientes (
    nombre,
    email,
    telefono
)
VALUES (
    'Juan Pérez',
    'juan@email.com',
    '3001234567'
);

INSERT INTO inventario.productos (
    nombre,
    descripcion,
    stock,
    precio
)
VALUES (
    'Laptop Lenovo',
    'Equipo portátil empresarial',
    15,
    3500.00
);

/*
========================================================
 CONSULTAS BÁSICAS
========================================================
*/
-- Consultar clientes
SELECT *
FROM ventas.clientes;
/*
========================================================
 METADATOS
========================================================
*/

-- Ver schemas disponibles
SELECT schema_name
FROM information_schema.schemata;

-- Ver tablas por schema
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

/*
========================================================
 SEARCH_PATH
========================================================

Permite evitar escribir el schema constantemente.
*/

SET search_path = ventas, public;

-- PostgreSQL buscará automáticamente en ventas
SELECT * FROM clientes;

/*
========================================================
 SEGURIDAD Y ROLES
========================================================
*/

CREATE ROLE app_ventas
LOGIN
PASSWORD 'password_seguro';

GRANT USAGE ON SCHEMA ventas TO app_ventas;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA ventas
TO app_ventas;

/*
========================================================
 ÍNDICES
========================================================

Mejoran el rendimiento de búsqueda.
*/

CREATE INDEX idx_clientes_email
ON ventas.clientes(email);

CREATE INDEX idx_productos_nombre
ON inventario.productos(nombre);

/*
========================================================
 ARQUITECTURA RECOMENDADA
========================================================

public                  -> utilidades generales
ventas                  -> ventas y facturación
inventario              -> productos y stock
recursos_humanos        -> empleados y nómina
auditoria               -> logs y trazabilidad
seguridad               -> autenticación y permisos
integraciones           -> APIs externas

========================================================
 BUENAS PRÁCTICAS
========================================================

✔ Usar snake_case
✔ Separar módulos por schema
✔ Usar migraciones
✔ Agregar auditoría
✔ Crear índices estratégicos
✔ Evitar SERIAL en PostgreSQL moderno

========================================================
 CONCLUSIÓN
========================================================

Los schemas ayudan a:

✔ Organizar aplicaciones grandes
✔ Mejorar seguridad
✔ Separar responsabilidades
✔ Facilitar mantenimiento
✔ Escalar sistemas empresariales

========================================================
*/