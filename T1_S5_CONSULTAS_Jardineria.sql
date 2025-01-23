-- UNIANDES; INGENIERÍA EN SOFTWARE; TERCER SEMESTRE; EDWIN BARRAZUETA
-- 1) Listar información básica de las oficinas: Recupera el código, ciudad, país y teléfono de todas las oficinas registradas.
SELECT codigo_oficina, ciudad, pais, telefono
FROM t1_s5_jardineria.oficina;

-- 2) Obtener los empleados por oficina: Muestra el nombre, apellidos y puesto de los empleados que trabajan en cada oficina, agrupados por código de oficina.
SELECT nombre, apellido1, apellido2, puesto 
FROM t1_s5_jardineria.empleado
ORDER BY codigo_oficina;

-- 3) Calcular el promedio de salario (límite de crédito) de los clientes por región: Determina el promedio del límite de crédito de los clientes agrupados por región.
SELECT region, AVG(limite_credito)
FROM t1_s5_jardineria.cliente
GROUP BY region;

-- 4) Listar clientes con sus representantes de ventas: Recupera el nombre completo del cliente junto con el nombre completo del representante de ventas asignado.
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2
FROM cliente
join empleado on cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado;

-- 5) Obtener productos disponibles y en stock: Lista el código, nombre y cantidad en stock de todos los productos que tienen al menos 1 unidad disponible.
SELECT codigo_producto, nombre, cantidad_en_stock
FROM t1_s5_jardineria.producto
WHERE cantidad_en_stock > 0

-- 6) Productos con precios por debajo del promedio: Muestra los productos cuyo precio de venta es menor que el precio promedio de todos los productos.
SELECT p.codigo_producto, p.nombre, p.precio_venta
FROM t1_s5_jardineria.producto p
JOIN (
    SELECT AVG(precio_venta) AS promedio_precio
    FROM t1_s5_jardineria.producto
) promedio ON p.precio_venta < promedio.promedio_precio;

-- 7) Pedidos pendientes por cliente: Lista el código y estado de todos los pedidos que no han sido entregados (estado diferente de "Entregado") junto con el nombre del cliente.
SELECT codigo_pedido, estado
FROM t1_s5_jardineria.pedido
WHERE estado not in ('Entregado')

-- 8) Total de productos por categoría (gama): Obtén la cantidad total de productos agrupados por categoría (gama).
SELECT gama, COUNT(*) 
FROM t1_s5_jardineria.producto
GROUP BY gama;

-- 9) Ingresos totales generados por cliente: Calcula el total de ingresos generados por cada cliente basado en los pagos realizados.
SELECT codigo_cliente, SUM(total) AS total
FROM pago
GROUP BY codigo_cliente;

-- 10) Pedidos realizados en un rango de fechas: Recupera los códigos de pedido y las fechas de los pedidos realizados entre dos fechas específicas.
SELECT codigo_pedido, fecha_pedido
FROM t1_s5_jardineria.pedido
WHERE fecha_pedido Between '2007-10-23' and '2009-01-06';

-- 11) Detalles de un pedido específico: Muestra el código de pedido, los productos involucrados, las cantidades y el precio total de cada línea de pedido.
SELECT codigo_pedido, codigo_producto, cantidad, precio_unidad
FROM t1_s5_jardineria.detalle_pedido;

-- 12) Productos más vendidos: Lista los productos con mayor cantidad vendida, ordenados de forma descendente por la cantidad total.
SELECT nombre, cantidad_en_stock
FROM t1_s5_jardineria.producto
Order by cantidad_en_stock DESC

-- 13) Pedidos con un valor total superior al promedio: Muestra los pedidos cuyo valor total (cantidad * precio_unidad) supera el promedio del valor total de todos los pedidos.
SELECT pedido.codigo_pedido, 
SUM(detalle_pedido.cantidad * detalle_pedido.precio_unidad) AS valor_total
FROM detalle_pedido
JOIN pedido ON detalle_pedido.codigo_pedido = pedido.codigo_pedido
GROUP BY pedido.codigo_pedido
HAVING valor_total > (SELECT AVG(detalle_pedido.cantidad * detalle_pedido.precio_unidad)
FROM detalle_pedido);

-- 14) Clientes sin representante de ventas asignado: Lista los clientes que no tienen un representante de ventas asociado.
SELECT codigo_cliente, nombre_cliente
FROM t1_s5_jardineria.cliente
WHERE codigo_empleado_rep_ventas IS NULL;

-- 15) Número total de empleados por oficina: Calcula la cantidad total de empleados asignados a cada oficina.
SELECT codigo_oficina, COUNT(*) 
FROM t1_s5_jardineria.empleado
GROUP BY codigo_oficina;

-- 16) Pagos realizados en una forma específica: Recupera los pagos realizados con una forma de pago específica, como "Tarjeta de Crédito".
SELECT codigo_cliente, forma_pago, fecha_pago
FROM t1_s5_jardineria.pago
WHERE forma_pago = 'Cheque'

-- 17) Ingresos mensuales: Calcula el total de ingresos generados por mes basado en las fechas de pago.
SELECT DATE_FORMAT(fecha_pago, '%Y-%m') AS mes, SUM(total) AS total_ingresos
FROM t1_s5_jardineria.pago
GROUP BY mes
ORDER BY mes;

-- 18) Clientes con múltiples pedidos: Muestra los nombres de los clientes que tienen más de un pedido registrado.
SELECT c.nombre_cliente, COUNT(p.codigo_pedido) AS total_pedidos 
FROM t1_s5_jardineria.cliente c
JOIN t1_s5_jardineria.pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre_cliente
HAVING total_pedidos > 1;

-- 19) Pedidos con productos agotados: Lista los pedidos que incluyen productos cuya cantidad en stock es cero.
USE t1_s5_jardineria;
SELECT p.codigo_producto, p.nombre, p.cantidad_en_stock, d.codigo_pedido
FROM jardineria p
JOIN detalle_pedido d ON p.codigo_producto = d.codigo_producto
WHERE p.cantidad_en_stock = 0;

-- 20) Promedio, máximo y mínimo del límite de crédito de los clientes por país: Obtén el promedio, el valor máximo y el mínimo del límite de crédito agrupados por país.
SELECT pais, AVG(limite_credito), MAX(limite_credito), MIN(limite_credito)
FROM cliente
GROUP BY pais;

-- 21) Historial de transacciones de un cliente: Recupera el historial de pagos realizados por un cliente específico, mostrando fecha, total y forma de pago.
SELECT forma_pago, fecha_pago, total
FROM t1_s5_jardineria.pago
WHERE codigo_cliente = 1

-- 22) Empleados sin jefe directo asignado: Muestra los empleados que no tienen asignado un código de jefe.
SELECT nombre, apellido1, apellido2
FROM t1_s5_jardineria.empleado
WHERE codigo_jefe IS NULL;

-- 23) Productos cuyo precio supera el promedio de su categoría (gama): Lista los productos cuyo precio de venta es mayor que el promedio de su gama.
SELECT *
FROM producto AS p
WHERE p.precio_venta > (
    SELECT AVG(sub_producto.precio_venta)
    FROM producto AS sub_producto
    WHERE sub_producto.gama = p.gama
);

-- 24) Promedio de días de entrega por estado: Calcula el promedio de días entre la fecha de pedido y la fecha de entrega agrupados por estado del pedido.
SELECT estado, AVG(DATEDIFF(fecha_entrega, fecha_pedido))
FROM pedido
GROUP BY estado;

-- 25) Clientes por país con más de un pedido: Lista los países con la cantidad de clientes que tienen más de un pedido registrado.
SELECT pais, COUNT(cliente.codigo_cliente)
FROM t1_s5_jardineria.cliente
JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
GROUP BY pais
HAVING COUNT(pedido.codigo_pedido) > 1;
