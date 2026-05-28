
/*
========================================================
 RESTRICCIONES (CONSTRAINTS) EN POSTGRESQL
========================================================

Las constraints permiten garantizar integridad,
consistencia y validación de datos directamente
desde la base de datos.

Tipos más utilizados:
✔ PRIMARY KEY
✔ NOT NULL
✔ UNIQUE
✔ CHECK
✔ DEFAULT
✔ FOREIGN KEY
✔ EXCLUDE (PostgreSQL avanzado)

========================================================
 TABLA: ejemplo_restricciones
========================================================
*/

CREATE TABLE ejemplo_restricciones (

    -- PRIMARY KEY:
    -- Identificador único por registro
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- NOT NULL:
    -- Campo obligatorio
    nombre VARCHAR(100) NOT NULL,

    -- UNIQUE:
    -- Evita valores duplicados
    email VARCHAR(200) UNIQUE NOT NULL,

    -- CHECK:
    -- Validación personalizada
    edad INTEGER CHECK (edad >= 18),

    salario NUMERIC(10,2)
        CHECK (salario > 0),

    -- DEFAULT:
    -- Valor automático por defecto
    activo BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- FOREIGN KEY:
    -- Relación con otra tabla
    departamento_id INTEGER
        REFERENCES departamentos(id)
        ON DELETE SET NULL
);

/*
========================================================
 CHECK CON MÚLTIPLES COLUMNAS
========================================================

Valida reglas de negocio complejas.
*/

CREATE TABLE reservaciones (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

    CHECK (fecha_fin > fecha_inicio)
);

/*

Muy útil para:
✔ reservas
✔ agendas
✔ calendarios
✔ salas de reuniones
✔ sistemas de turnos
*/

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE sala_reuniones (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    sala VARCHAR(50) NOT NULL,

    durante TSRANGE NOT NULL,

    EXCLUDE USING gist (
        sala WITH =,
        durante WITH &&
    )
);

/*
========================================================
 BUENAS PRÁCTICAS
========================================================

✔ Validar datos desde la base de datos
✔ Usar CHECK para reglas críticas
✔ Evitar lógica sensible solo en backend
✔ Definir claves foráneas correctamente
✔ Usar ON DELETE según necesidad del negocio
✔ Preferir IDENTITY sobre SERIAL

========================================================
 IMPORTANCIA DE LAS CONSTRAINTS
========================================================

Las restricciones ayudan a:

✔ mantener integridad de datos
✔ evitar inconsistencias
✔ mejorar seguridad
✔ reforzar reglas de negocio
✔ reducir errores en aplicaciones
*/

