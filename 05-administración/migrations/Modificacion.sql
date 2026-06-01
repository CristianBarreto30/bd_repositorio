/*
MIGRACIÓN: 001_CREATE_USUARIOS
 Base de datos: PostgreSQL

 ¿Qué es una migración?
Una migración es un archivo SQL versionado que contiene cambios en la
estructura de la base de datos. Permite crear, modificar o eliminar
objetos de forma controlada y reproducible.

 ¿Para qué sirve?
Mantener un historial de cambios.
Sincronizar entornos de desarrollo, pruebas y producción.
Facilitar despliegues y actualizaciones.
Garantizar que todos los miembros del equipo trabajen con el mismo esquema.

¿Cómo se utiliza?
 1. Crear un archivo SQL con una versión y nombre descriptivo.
 2. Agregar las instrucciones necesarias para modificar la base de datos.
 3. Ejecutar el archivo sobre la base de datos objetivo.

Ejecución:
 psql -U postgres -d nombre_base_datos -f 001_create_usuarios.sql

 Buenas prácticas:
Realizar una única tarea por migración.
Utilizar nombres descriptivos.
Ejecutar las migraciones en orden.
Realizar un backup antes de aplicarlas en producción.

 Objetivo de esta migración:
 Crear la tabla "usuarios" para almacenar información básica de usuarios.
*/

CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Verificación opcional
SELECT 'Migración 001_create_usuarios ejecutada correctamente.' AS resultado;