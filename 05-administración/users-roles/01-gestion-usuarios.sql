-- GESTIÓN DE USUARIOS Y ROLES EN PostgreSQL

-- Crear roles (equivalente a grupos)
CREATE ROLE lectores;
CREATE ROLE editores;
CREATE ROLE administradores;

-- Crear usuarios
CREATE USER analista WITH PASSWORD 'password_seguro';
CREATE USER desarrollador WITH PASSWORD 'password_seguro';
CREATE USER dba WITH PASSWORD 'password_seguro' SUPERUSER;

-- Asignar roles a usuarios
GRANT lectores TO analista;
GRANT editores TO desarrollador;
GRANT administradores TO dba;

-- Privilegios a nivel de esquema
GRANT USAGE ON SCHEMA shared TO lectores;
GRANT SELECT ON ALL TABLES IN SCHEMA shared TO lectores;

GRANT USAGE ON SCHEMA shared TO editores;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA shared TO editores;

-- Privilegios por defecto (para tablas futuras)
ALTER DEFAULT PRIVILEGES IN SCHEMA shared
    GRANT SELECT ON TABLES TO lectores;

ALTER DEFAULT PRIVILEGES IN SCHEMA shared
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO editores;

-- Revocar permisos
REVOKE DELETE ON shared.ordenes FROM editores;

-- Ver permisos actuales
SELECT * FROM information_schema.table_privileges WHERE table_schema = 'shared';
