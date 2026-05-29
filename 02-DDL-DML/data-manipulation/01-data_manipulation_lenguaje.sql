/*
========================================================
 DATA MANIPULATION LANGUAGE (DML) EN SQL
========================================================

DML (Data Manipulation Language) es el conjunto
de comandos utilizados para manipular datos
dentro de las tablas.

Permite:
✔ insertar datos
✔ consultar información
✔ actualizar registros
✔ eliminar registros

========================================================
 COMANDOS PRINCIPALES
========================================================

INSERT -> insertar registros
SELECT -> consultar datos
UPDATE -> actualizar información
DELETE -> eliminar registros

========================================================
 TABLA DE EJEMPLO
========================================================
*/

CREATE TABLE usuarios (

    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    activo BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

/*
========================================================
 INSERT
========================================================

Inserta nuevos registros.
*/

INSERT INTO usuarios (
    nombre,
    email
)
VALUES (
    'Juan Pérez',
    'juan@email.com'
);

/*
========================================================
 SELECT
========================================================

Consulta información almacenada.
*/

SELECT *
FROM usuarios;

/*
========================================================
 UPDATE
========================================================

Actualiza registros existentes.
*/

UPDATE usuarios
SET nombre = 'Juan David Pérez'
WHERE id = 1;

/*
========================================================
 DELETE
========================================================

Elimina registros.
*/

DELETE FROM usuarios
WHERE id = 1;

/*
========================================================
 DIFERENCIA ENTRE DDL Y DML
========================================================

DDL:
    Define estructuras

    Ejemplos:
    - CREATE
    - ALTER
    - DROP

DML:
    Manipula datos

    Ejemplos:
    - INSERT
    - SELECT
    - UPDATE
    - DELETE

========================================================
 OTRAS CATEGORÍAS SQL
========================================================

DCL:
    Control de permisos
    - GRANT
    - REVOKE

TCL:
    Control de transacciones
    - COMMIT
    - ROLLBACK

========================================================
 BUENAS PRÁCTICAS
========================================================

✔ usar WHERE en UPDATE y DELETE
✔ validar datos antes de modificar
✔ usar transacciones en operaciones críticas
✔ evitar DELETE sin condiciones
✔ mantener integridad de datos

========================================================
 IMPORTANCIA DEL DML
========================================================

El DML es fundamental porque permite
interactuar con la información almacenada
en la base de datos de forma segura y controlada.
*/