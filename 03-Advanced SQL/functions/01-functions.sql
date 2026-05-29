/*
========================================================
 FUNCIONES EN POSTGRESQL
========================================================

Las funciones permiten reutilizar lógica SQL,
automatizar procesos y encapsular operaciones.

Pueden:
✔ recibir parámetros
✔ retornar valores
✔ retornar tablas
✔ ejecutar lógica compleja

========================================================
 FUNCIÓN BÁSICA
========================================================
Retorna un valor simple
*/

CREATE OR REPLACE FUNCTION saludar(nombre TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN 'Hola, ' || nombre;
END;
$$;

-- Uso
SELECT saludar('Juan');

/*
========================================================
 FUNCIÓN CON PARÁMETROS
========================================================
*/

CREATE OR REPLACE FUNCTION sumar(
    a INTEGER,
    b INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN a + b;
END;
$$;

-- Uso
SELECT sumar(10, 5);

/*
========================================================
 FUNCIÓN CON VALIDACIÓN
========================================================
*/

CREATE OR REPLACE FUNCTION es_mayor_edad(
    edad INTEGER
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN edad >= 18;
END;
$$;

-- Uso
SELECT es_mayor_edad(20);

/*
========================================================
 FUNCIÓN QUE RETORNA TABLAS
========================================================
Muy utilizada en consultas complejas
*/

CREATE OR REPLACE FUNCTION obtener_clientes()
RETURNS TABLE (
    id BIGINT,
    nombre VARCHAR(100)
)
LANGUAGE sql
AS $$
    SELECT id, nombre
    FROM shared.clientes;
$$;

-- Uso
SELECT * FROM obtener_clientes();

/*
========================================================
 FUNCIONES AGREGADAS
========================================================
Operan sobre múltiples filas
*/

-- COUNT
SELECT COUNT(*) FROM shared.clientes;

-- SUM
SELECT SUM(total) FROM shared.ordenes;

-- AVG
SELECT AVG(total) FROM shared.ordenes;

-- MAX
SELECT MAX(total) FROM shared.ordenes;

-- MIN
SELECT MIN(total) FROM shared.ordenes;

/*
========================================================
 FUNCIONES DE TEXTO
========================================================
*/

SELECT UPPER('postgresql');      -- MAYÚSCULAS
SELECT LOWER('POSTGRESQL');      -- minúsculas
SELECT LENGTH('database');       -- longitud
SELECT CONCAT('Hola ', 'Mundo'); -- concatenar

/*
========================================================
 FUNCIONES DE FECHA
========================================================
*/

SELECT NOW();                    -- fecha actual
SELECT CURRENT_DATE;             -- fecha actual
SELECT CURRENT_TIME;             -- hora actual

/*
========================================================
 FUNCIONES MATEMÁTICAS
========================================================
*/

SELECT ROUND(10.75);             -- redondear
SELECT ABS(-50);                 -- absoluto
SELECT POWER(2, 3);              -- potencia
SELECT SQRT(64);                 -- raíz cuadrada

/*
========================================================
 FUNCIONES WINDOW
========================================================
Análisis avanzado por filas
*/

SELECT
    nombre,
    salario,
    RANK() OVER (ORDER BY salario DESC)
FROM empleados;

/*
========================================================
 FUNCIONES TRIGGER
========================================================
Automatizan eventos en tablas
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
 BUENAS PRÁCTICAS
========================================================

✔ reutilizar lógica frecuente
✔ validar reglas críticas
✔ evitar duplicar código
✔ usar nombres descriptivos
✔ preferir SQL functions cuando sea posible

========================================================
 TIPOS MÁS IMPORTANTES
========================================================

✔ funciones escalares
✔ funciones agregadas
✔ funciones window
✔ funciones trigger
✔ funciones tabulares

========================================================
*/