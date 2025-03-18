-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS gestion_inventarios;
USE gestion_inventarios;

-- Tabla de almacenes
CREATE TABLE almacenes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    direccion TEXT NOT NULL
);

-- Tabla de ubicaciones dentro de almacenes
CREATE TABLE ubicaciones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_almacen BIGINT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_almacen) REFERENCES almacenes(id) ON DELETE CASCADE
);

-- Tabla de productos
CREATE TABLE productos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_ubicacion BIGINT NOT NULL,
    FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id) ON DELETE CASCADE
);

-- Tabla de transacciones (ventas simuladas)
CREATE TABLE transacciones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT NOT NULL,
    cantidad INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de usuarios
CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    id_rol BIGINT NOT NULL
);

-- Tabla de roles
CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de permisos
CREATE TABLE permisos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_rol BIGINT NOT NULL,
    permiso VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES roles(id) ON DELETE CASCADE
);

-- Tabla de historial de cambios de productos
CREATE TABLE historial_cambios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT NOT NULL,
    cambio TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de comentarios sobre productos
CREATE TABLE comentarios_productos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    comentario TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Insertar roles por defecto
INSERT INTO roles (nombre) VALUES ('Administrador'), ('Operador');

-- Procedimiento para agregar productos
DELIMITER $$
CREATE PROCEDURE agregar_producto (
    IN p_codigo VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10,2),
    IN p_stock INT,
    IN p_id_ubicacion BIGINT
)
BEGIN
    INSERT INTO productos (codigo, nombre, descripcion, precio, stock, id_ubicacion)
    VALUES (p_codigo, p_nombre, p_descripcion, p_precio, p_stock, p_id_ubicacion);
END$$
DELIMITER ;

-- Procedimiento para actualizar el stock de un producto
DELIMITER $$
CREATE PROCEDURE actualizar_stock (
    IN p_id_producto BIGINT,
    IN p_nuevo_stock INT
)
BEGIN
    UPDATE productos SET stock = p_nuevo_stock WHERE id = p_id_producto;
END$$
DELIMITER ;

-- Procedimiento para registrar una venta
DELIMITER $$
CREATE PROCEDURE registrar_venta (
    IN p_id_producto BIGINT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    SELECT precio INTO v_precio FROM productos WHERE id = p_id_producto;
    INSERT INTO transacciones (id_producto, cantidad, total)
    VALUES (p_id_producto, p_cantidad, v_precio * p_cantidad);
    UPDATE productos SET stock = stock - p_cantidad WHERE id = p_id_producto;
END$$
DELIMITER ;

-- Trigger para evitar stock negativo
DELIMITER $$
CREATE TRIGGER before_venta_insert
BEFORE INSERT ON transacciones
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    SELECT stock INTO v_stock FROM productos WHERE id = NEW.id_producto;
    IF v_stock < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END$$
DELIMITER ;

-- Trigger para registrar eliminación de productos en historial
DELIMITER $$
CREATE TRIGGER after_producto_delete
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
    INSERT INTO historial_cambios (id_producto, cambio)
    VALUES (OLD.id, 'Producto eliminado');
END$$
DELIMITER ;

-- Función para calcular el valor total del inventario
DELIMITER $$
CREATE FUNCTION calcular_valor_total_inventario()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(precio * stock) INTO total FROM productos;
    RETURN total;
END$$
DELIMITER ;


-- Procedimiento para agregar usuarios
DELIMITER $$
CREATE PROCEDURE agregar_usuario (
    IN p_nombre VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_id_rol BIGINT
)
BEGIN
    INSERT INTO usuarios (nombre, email, password_hash, id_rol)
    VALUES (p_nombre, p_email, p_password_hash, p_id_rol);
END$$
DELIMITER ;

-- Procedimiento para actualizar el rol de un usuario
DELIMITER $$
CREATE PROCEDURE actualizar_rol_usuario (
    IN p_id_usuario BIGINT,
    IN p_nuevo_id_rol BIGINT
)
BEGIN
    UPDATE usuarios SET id_rol = p_nuevo_id_rol WHERE id = p_id_usuario;
END$$
DELIMITER ;

-- Procedimiento para eliminar un usuario
DELIMITER $$
CREATE PROCEDURE eliminar_usuario (
    IN p_id_usuario BIGINT
)
BEGIN
    DELETE FROM usuarios WHERE id = p_id_usuario;
END$$
DELIMITER ;

-- Procedimiento para listar usuarios y sus roles
DELIMITER $$
CREATE PROCEDURE listar_usuarios_roles()
BEGIN
    SELECT u.id, u.nombre, u.email, r.nombre AS rol FROM usuarios u
    JOIN roles r ON u.id_rol = r.id;
END$$
DELIMITER ;

-- Procedimiento para asignar un permiso a un rol
DELIMITER $$
CREATE PROCEDURE asignar_permiso (
    IN p_id_rol BIGINT,
    IN p_permiso VARCHAR(100)
)
BEGIN
    INSERT INTO permisos (id_rol, permiso) VALUES (p_id_rol, p_permiso);
END$$
DELIMITER ;

Reportes Generales
-- Reporte de inventario general
DELIMITER $$
CREATE PROCEDURE reporte_inventario_general()
BEGIN
    SELECT p.codigo, p.nombre, p.stock, p.precio, (p.stock * p.precio) AS valor_total
    FROM productos p;
END$$
DELIMITER ;

-- Reporte de productos por ubicación
DELIMITER $$
CREATE PROCEDURE reporte_productos_por_ubicacion()
BEGIN
    SELECT a.nombre AS almacen, u.nombre AS ubicacion, p.nombre AS producto, p.stock
    FROM productos p
    JOIN ubicaciones u ON p.id_ubicacion = u.id
    JOIN almacenes a ON u.id_almacen = a.id
    ORDER BY a.nombre, u.nombre;
END$$
DELIMITER ;


-- Reporte de ventas simuladas
DELIMITER $$
CREATE PROCEDURE reporte_ventas_simuladas()
BEGIN
    SELECT t.id, p.nombre AS producto, t.cantidad, t.fecha, t.total
    FROM transacciones t
    JOIN productos p ON t.id_producto = p.id
    ORDER BY t.fecha DESC;
END$$
DELIMITER ;

-- Reporte de productos con bajo stock
DELIMITER $$
CREATE PROCEDURE reporte_productos_bajo_stock(IN nivel_minimo INT)
BEGIN
    SELECT p.codigo, p.nombre, p.stock
    FROM productos p
    WHERE p.stock < nivel_minimo
    ORDER BY p.stock ASC;
END$$
DELIMITER ;

-- Reporte de usuarios y sus roles
DELIMITER $$
CREATE PROCEDURE reporte_usuarios_roles()
BEGIN
    SELECT u.id, u.nombre, u.email, r.nombre AS rol
    FROM usuarios u
    JOIN roles r ON u.id_rol = r.id;
END$$
DELIMITER ;

