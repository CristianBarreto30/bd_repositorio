/*
========================================================
 TRIGGERS EN POSTGRESQL
========================================================

Los triggers permiten ejecutar lógica automáticamente
cuando ocurre un evento en una tabla.

Eventos principales:
✔ INSERT
✔ UPDATE
✔ DELETE

Muy usados para:
✔ auditoría
✔ validaciones
✔ logs
✔ automatización
✔ sincronización de datos

========================================================
 TABLA DE EJEMPLO
========================================================
*/

CREATE TABLE usuarios (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()
);

/*
========================================================
 TRIGGER FUNCTION
========================================================

Función que actualiza automáticamente updated_at
*/

CREATE OR REPLACE FUNCTION actualizar_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    NEW.updated_at = NOW();

    RETURN NEW;

END;
$$;

/*
========================================================
 CREATE TRIGGER
========================================================

BEFORE UPDATE:
ejecuta antes de actualizar un registro
*/

CREATE TRIGGER trg_actualizar_updated_at

BEFORE UPDATE
ON usuarios

FOR EACH ROW

EXECUTE FUNCTION actualizar_updated_at();

/*
========================================================
 EJEMPLO UPDATE
========================================================
*/

UPDATE usuarios
SET nombre = 'Juan Pérez'
WHERE id = 1;

/*
========================================================
 TRIGGER PARA AUDITORÍA
========================================================
*/

CREATE TABLE logs_usuarios (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    usuario_id BIGINT,

    accion TEXT,

    fecha TIMESTAMPTZ DEFAULT NOW()
);

/*
========================================================
 FUNCIÓN DE AUDITORÍA
========================================================
*/

CREATE OR REPLACE FUNCTION log_delete_usuario()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO logs_usuarios (
        usuario_id,
        accion
    )
    VALUES (
        OLD.id,
        'DELETE'
    );

    RETURN OLD;

END;
$$;

/*
========================================================
 TRIGGER DELETE
========================================================
*/

CREATE TRIGGER trg_log_delete_usuario

BEFORE DELETE
ON usuarios

FOR EACH ROW

EXECUTE FUNCTION log_delete_usuario();

/*
========================================================
 TIPOS DE TRIGGERS
========================================================

BEFORE INSERT
BEFORE UPDATE
BEFORE DELETE

AFTER INSERT
AFTER UPDATE
AFTER DELETE

========================================================
 VARIABLES IMPORTANTES
========================================================

NEW -> nuevos valores
OLD -> valores anteriores

========================================================
 EJEMPLOS
========================================================

NEW.nombre
OLD.email

========================================================
 BUENAS PRÁCTICAS
========================================================

✔ usar triggers para auditoría
✔ automatizar timestamps
✔ evitar lógica excesiva
✔ documentar triggers críticos
✔ mantener funciones simples

========================================================
 IMPORTANCIA
========================================================

Los triggers permiten mantener integridad,
automatizar procesos y centralizar lógica
directamente en la base de datos.

========================================================
*/