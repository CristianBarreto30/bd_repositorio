/*
========================================================
 CREATE TABLE EN POSTGRESQL
========================================================


Estructura básica:
- se saca primero de su modelo entidad-relación (conceptual y físico).
 Con ello lo llevamos a lo logico primero creamos nuestra base de datos create database

Una tabla almacena información organizada
en columnas y filas.

*/


CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
--esto en algunos gestores de BD el utf8mb4 es para soportar emojis y caracteres especiales,
--y el InnoDB es un motor de almacenamiento que soporta transacciones y claves foráneas.

CREATE TABLE usuarios (

    -- Identificador único
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Información del usuario
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,

    -- Valor por defecto
    activo BOOLEAN DEFAULT TRUE,

    -- Fecha de creación automática
    created_at TIMESTAMPTZ DEFAULT NOW()
  
);

/*
========================================================
 TIPOS DE DATOS UTILIZADOS
========================================================

BIGINT         -> números enteros grandes
VARCHAR(n)     -> texto con longitud limitada
BOOLEAN        -> TRUE / FALSE
TIMESTAMPTZ    -> fecha y hora con zona horaria

========================================================
 RESTRICCIONES UTILIZADAS
========================================================

PRIMARY KEY -> identifica registros únicos
NOT NULL    -> campo obligatorio
UNIQUE      -> evita duplicados
DEFAULT     -> asigna valor automático
FOREIGN KEY -> relaciona tablas

*/