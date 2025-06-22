-- Script SQL para crear la tabla notas_nota en MySQL
-- Base de datos: holamundo

USE holamundo;

-- Crear la tabla notas_nota si no existe
CREATE TABLE IF NOT EXISTS notas_nota (
    id BIGINT(20) NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    contenido LONGTEXT NOT NULL,
    fecha_creacion DATETIME(6) NOT NULL,
    fecha_actualizacion DATETIME(6) NOT NULL,
    PRIMARY KEY (id)
);

-- Insertar algunas notas de ejemplo (opcional)
INSERT INTO notas_nota (titulo, contenido, fecha_creacion, fecha_actualizacion) VALUES
('Mi primera nota', 'Este es el contenido de mi primera nota. Aquí puedo escribir todo lo que quiera recordar.', NOW(6), NOW(6)),
('Lista de compras', 'Leche\nPan\nHuevos\nFrutas\nVerduras', NOW(6), NOW(6)),
('Ideas para el proyecto', 'Implementar CRUD completo\nAgregar validaciones\nMejorar la interfaz de usuario\nAgregar búsqueda por fechas', NOW(6), NOW(6));

-- Verificar que la tabla se creó correctamente
DESCRIBE notas_nota;

-- Mostrar todas las notas
SELECT * FROM notas_nota ORDER BY fecha_creacion DESC;
