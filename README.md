# Proyecto: Sistema de Gestión de Inventarios

## Integrantes

- OSCAR DANIEL ORTIZ VALENZUELA - 24000468
- EDGAR ARTURO JIMÉNEZ CENTENO - 19001704
- ANDRES OVANDO MORALES - 24000581
- DINA MORALES RIVERA - 24000205

---

## Fase 1: Implementación de la Base de Datos

### Objetivo del Proyecto
Desarrollar un sistema robusto que integre bases de datos para gestionar inventarios de productos en diferentes almacenes, asegurando la eficiencia, la seguridad y la escalabilidad en entornos empresariales modernos.

### Estructura de la Base de Datos
Se diseñó la base de datos en MySQL con las siguientes tablas:
- **almacenes**: Almacena información sobre los diferentes almacenes.
- **ubicaciones**: Define ubicaciones específicas dentro de los almacenes.
- **productos**: Contiene detalles de los productos gestionados.
- **transacciones**: Registra ventas y movimientos de stock.
- **usuarios**: Maneja información de los usuarios del sistema.
- **roles**: Define los diferentes niveles de acceso dentro del sistema.
- **permisos**: Relaciona roles con los permisos específicos del sistema.
- **historial_cambios**: Registra modificaciones en los productos.
- **comentarios_productos**: Permite que los operadores añadan comentarios sobre productos.

### Procedimientos Almacenados Implementados

#### Manejo de Productos:
- `agregar_producto`: Agrega un nuevo producto a la base de datos.
- `actualizar_stock`: Permite actualizar la cantidad de stock de un producto.
- `registrar_venta`: Registra una transacción de venta y ajusta el stock automáticamente.

#### Manejo de Usuarios y Roles:
- `agregar_usuario`: Permite agregar un nuevo usuario con su respectivo rol.
- `actualizar_rol_usuario`: Modifica el rol asignado a un usuario.
- `eliminar_usuario`: Elimina un usuario del sistema.
- `listar_usuarios_roles`: Consulta de usuarios con sus respectivos roles.
- `asignar_permiso`: Asigna un permiso a un rol determinado.

#### Reportes Básicos:
- `reporte_inventario_general`: Lista el inventario con su valor total.
- `reporte_productos_por_ubicacion`: Muestra productos agrupados por almacenes y ubicaciones.
- `reporte_ventas_simuladas`: Reporte de ventas registradas en el sistema.
- `reporte_productos_bajo_stock`: Muestra productos con stock inferior a un nivel definido.
- `reporte_usuarios_roles`: Lista los usuarios y sus roles asignados.

### Triggers Implementados
- `before_venta_insert`: Previene ventas si el stock disponible es insuficiente.
- `after_producto_delete`: Guarda en el historial cuando un producto es eliminado.

---

## Fase 2: Funcionalidades Avanzadas (Final del Proyecto)

### 1. Optimización y Replicación (25 puntos)

#### Partición Horizontal
Se crearon dos tablas independientes a partir de `productos`, simulando una partición por almacén:
```sql
CREATE TABLE productos_almacen1 LIKE productos;
CREATE TABLE productos_almacen2 LIKE productos;
```

#### Partición Vertical
Se dividió la información de la tabla `productos` en dos:
```sql
CREATE TABLE productos_detalle (
    id BIGINT PRIMARY KEY,
    descripcion TEXT,
    id_ubicacion BIGINT NOT NULL,
    FOREIGN KEY (id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id) ON DELETE CASCADE
);
```

#### Replicación MySQL (Docker)
Se implementó un clúster local en Docker:
- Contenedor **mysql-master** con binlogs activados y base `gestion_inventarios`.
- Contenedor **mysql-slave** conectado al master usando usuario `replica`.
- Se verificó la replicación con `SHOW SLAVE STATUS \G` (valores en YES) y se replicaron inserciones de prueba correctamente desde master a slave.

### 2. Consultas Avanzadas y Reportes (25 puntos)

#### Procedimientos con filtros:
- `reporte_productos_bajo_stock(nivel_minimo)`
- `reporte_ventas_simuladas()`
- `reporte_inventario_general()`
- `reporte_productos_por_ubicacion()`
- `reporte_usuarios_roles()`

#### Vistas creadas:
```sql
CREATE VIEW vista_productos_por_ubicacion AS
SELECT a.nombre AS nombre_almacen, u.nombre AS nombre_ubicacion, p.nombre AS nombre_producto, p.stock
FROM productos p
JOIN ubicaciones u ON p.id_ubicacion = u.id
JOIN almacenes a ON u.id_almacen = a.id;

CREATE VIEW vista_resumen_ventas AS
SELECT p.nombre AS producto, COUNT(t.id) AS total_transacciones, SUM(t.cantidad) AS total_vendido, SUM(t.total) AS ingresos_totales
FROM transacciones t
JOIN productos p ON t.id_producto = p.id
GROUP BY p.nombre;
```

### 3. Gestión de Usuarios y Seguridad (15 puntos)
Se crearon y probaron las siguientes funcionalidades:
- Tabla de usuarios, roles y permisos.
- Se insertaron usuarios y se asignaron permisos por rol.
- Se actualizó el rol de un usuario y se eliminó otro.

#### Pruebas realizadas:
```sql
CALL agregar_usuario(...);
CALL asignar_permiso(...);
CALL listar_usuarios_roles();
CALL actualizar_rol_usuario(...);
CALL eliminar_usuario(...);
```

### 4. Conexión a MongoDB Atlas y Endpoints para Datos Históricos

Se implementó una API REST con **Node.js y Express** conectada a **MongoDB Atlas**, utilizada para almacenar datos históricos relacionados con el sistema de inventarios. Esta parte representa la integración de una base de datos **NoSQL** en el proyecto.

#### Funcionalidades implementadas:
- `POST /api/transacciones` y `GET /api/transacciones`  
  → Registro y consulta de transacciones históricas.

- `POST /api/historial` y `GET /api/historial`  
  → Registro y recuperación de cambios realizados a productos.

- `POST /api/comentarios` y `GET /api/comentarios`  
  → Registro y consulta de observaciones hechas por operadores.

#### Tecnologías utilizadas:
- **MongoDB Atlas** (nube)  
- **Node.js + Express + Mongoose**  
- **Postman** para pruebas

Los datos enviados desde Postman se almacenan directamente en la base de datos **`inventario-db`** alojada en MongoDB Atlas, lo que demuestra el correcto funcionamiento de la API y la conexión en la nube.

---

✅ **Fase 2 completada exitosamente. Proyecto finalizado.**
