# Proyecto: Sistema de Gestión de Inventarios

Integrantes

OSCAR DANIEL ORTIZ VALENZUELA - 24000468

EDGAR ARTURO JIMÉNEZ CENTENO- 19001704

ANDRES OVANDO MORALES - 24000581
 
DINA MORALES RIVERA - 24000205

## Fase 1: Implementación de la Base de Datos

### **Objetivo del Proyecto**
Desarrollar un sistema robusto que integre bases de datos para gestionar inventarios de productos en diferentes almacenes, asegurando la eficiencia, la seguridad y la escalabilidad en entornos empresariales modernos.

### **Estructura de la Base de Datos**
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

### **Procedimientos Almacenados Implementados**
Se crearon procedimientos para gestionar eficientemente la base de datos:

- **Manejo de Productos:**
  - `agregar_producto`: Agrega un nuevo producto a la base de datos.
  - `actualizar_stock`: Permite actualizar la cantidad de stock de un producto.
  - `registrar_venta`: Registra una transacción de venta y ajusta el stock automáticamente.

- **Manejo de Usuarios y Roles:**
  - `agregar_usuario`: Permite agregar un nuevo usuario con su respectivo rol.
  - `actualizar_rol_usuario`: Modifica el rol asignado a un usuario.
  - `eliminar_usuario`: Elimina un usuario del sistema.
  - `listar_usuarios_roles`: Consulta de usuarios con sus respectivos roles.
  - `asignar_permiso`: Asigna un permiso a un rol determinado.

- **Reportes Básicos:**
  - `reporte_inventario_general`: Lista el inventario con su valor total.
  - `reporte_productos_por_ubicacion`: Muestra productos agrupados por almacenes y ubicaciones.
  - `reporte_ventas_simuladas`: Reporte de ventas registradas en el sistema.
  - `reporte_productos_bajo_stock`: Muestra productos con stock inferior a un nivel definido.
  - `reporte_usuarios_roles`: Lista los usuarios y sus roles asignados.

### **Triggers Implementados**
- `before_venta_insert`: Previene ventas si el stock disponible es insuficiente.
- `after_producto_update`: Registra cambios en los productos en el historial.
- `after_producto_delete`: Guarda en el historial cuando un producto es eliminado.

---

## Faltante para Completar el Proyecto

1. **Interfaz de Usuario:**
   - Desarrollo de una aplicación web para la gestión del inventario.
   - Formularios para ingresar productos, usuarios y transacciones.

2. **Integración de MongoDB:**
   - Almacenamiento de registros históricos de ventas y modificaciones de productos.

3. **Seguridad Avanzada:**
   - Encriptación de contraseñas y manejo de sesiones seguras.
   - Autenticación y autorización con JWT o similar.

4. **Optimización de Consultas:**
   - Indexación y mejora de rendimiento en consultas frecuentes.

5. **Pruebas y Despliegue:**
   - Pruebas unitarias y de integración.
   - Implementación en un entorno de producción.

