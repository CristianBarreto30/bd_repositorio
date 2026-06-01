<#
-- BACKUP DE BASE DE DATOS POSTGRESQL
--
-- ¿Qué es un backup?
-- Un backup o copia de seguridad es una exportación de la base de datos
-- que permite recuperar la información ante errores, pérdida de datos,
-- fallos del sistema o migraciones a otros entornos.
--
-- Este archivo contiene:
-- - Estructura de la base de datos (tablas, índices, vistas, etc.).
-- - Datos almacenados en las tablas.
-- - Sentencias para recrear los objetos necesarios.
--
-- Fecha de generación: 2026-06-01
-- Base de datos: db_portfolio
#>
# Backup de base de datos PostgreSQL con PowerShell
# Requiere: pg_dump en el PATH o ruta completa

$DB_NAME     = "db_portfolio"
$DB_USER     = "postgres"
$BACKUP_DIR  = "$env:USERPROFILE\backups\postgresql"
$TIMESTAMP   = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_FILE = "$BACKUP_DIR\${DB_NAME}_$TIMESTAMP.sql"

# Crear directorio si no existe
New-Item -ItemType Directory -Path $BACKUP_DIR -Force

# Backup completo (esquema + datos)
& "pg_dump" -U $DB_USER -d $DB_NAME --clean --if-exists -f $BACKUP_FILE

Write-Host "Backup creado: $BACKUP_FILE"

# Restaurar (comentado por seguridad):
# & "psql" -U $DB_USER -d $DB_NAME -f "ruta_del_backup.sql"
