-- Datos iniciales del e-commerce
\c ecommerce;

INSERT INTO categorias (nombre) VALUES
    ('Electrónicos'),
    ('Ropa'),
    ('Hogar'),
    ('Deportes');

INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id) VALUES
    ('Smartphone X',    'Teléfono inteligente de última generación',   599.99,  50, 1),
    ('Laptop Pro',      'Laptop de alto rendimiento para trabajo y gaming', 1299.99, 30, 1),
    ('Camiseta Algodón','Camiseta de algodón 100% suave y cómoda',    19.99,  100, 2),
    ('Set de Sartenes', 'Set de 5 sartenes antiadherentes',           89.99,   20, 3),
    ('Pelota Fútbol',   'Pelota oficial tamaño 5',                     29.99,   60, 4);

INSERT INTO clientes (nombre, email, telefono, direccion) VALUES
    ('Juan Pérez',   'juan@email.com',  '555-0101', 'Calle Principal 123'),
    ('María López',  'maria@email.com', '555-0102', 'Av. Central 456'),
    ('Pedro Gómez',  'pedro@email.com', '555-0103', 'Boulevard Sur 789');
