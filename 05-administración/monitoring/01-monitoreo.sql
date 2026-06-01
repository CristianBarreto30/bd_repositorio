/*
MONITOREO DE BASE DE DATOS POSTGRESQL

¿Qué es el monitoreo?
El monitoreo consiste en supervisar el estado y rendimiento de la base de datos
para identificar problemas, analizar el uso de recursos y garantizar la
disponibilidad del servicio.

¿Para qué sirve?
- Detectar consultas lentas.
- Supervisar conexiones activas.
- Identificar bloqueos entre transacciones.
- Analizar el crecimiento de la base de datos.
- Prevenir problemas de rendimiento.

¿Cuándo se utiliza?
- Durante el desarrollo para optimizar consultas.
- En pruebas para validar el comportamiento del sistema.
- En producción para garantizar estabilidad y disponibilidad.

Buenas prácticas:
- Revisar periódicamente las consultas activas.
- Monitorear el número de conexiones concurrentes.
- Analizar consultas con tiempos de ejecución elevados.
- Implementar alertas para eventos críticos.

Objetivo de este archivo:
Mostrar consultas básicas de monitoreo para evaluar el estado y rendimiento
de una base de datos PostgreSQL.
*/

SELECT
    pid,
    usename,
    application_name,
    state
FROM pg_stat_activity;

SELECT
    pid,
    usename,
    query,
    state
FROM pg_stat_activity
WHERE state = 'active';

SELECT
    state,
    COUNT(*) AS total_conexiones
FROM pg_stat_activity
GROUP BY state;

SELECT
    pg_size_pretty(pg_database_size(current_database())) AS database_size;

SELECT
    relname AS tabla,
    n_live_tup AS registros
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;