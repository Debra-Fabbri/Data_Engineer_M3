USE data_engineer_m3;

/* #1 Obtener un listado del nombre y apellido de cada cliente que haya 
adquirido algun producto junto al id del producto y su respectivo precio.
*/
SELECT DISTINCT c.IdCliente, c.Nombre_y_Apellido, v.IdProducto, v.Precio
FROM venta v
-- JOIN cliente c ON(v.IdCliente = c.IdCliente);
JOIN cliente c using(IdCliente); -- 19071 registros


/* #2 Obteber un listado de clientes con la cantidad de productos 
adquiridos, incluyendo aquellos que nunca compraron algún producto.
*/
SELECT DISTINCT c.IdCliente, c.Nombre_y_Apellido, SUM(v.Cantidad) AS cantidad_productos_null, SUM(ifnull(v.Cantidad, 0)) AS cantidad_productos
FROM cliente c
-- LEFT JOIN venta v ON(v.IdCliente = c.IdCliente)
LEFT JOIN venta v using(IdCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido
ORDER BY cantidad_productos DESC; -- 3406


/* #3 Obtener un listado de cual fue el volumen de compra (cantidad)
por año de cada cliente.
*/
SELECT c.IdCliente, c.Nombre_y_Apellido, YEAR(v.Fecha) AS Anio, count(v.IdVenta) as total_compras
from venta v
-- JOIN cliente c ON (v.IdCliente = c.IdCliente)
JOIN cliente c using(IdCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido, YEAR(v.Fecha)
ORDER BY YEAR(v.Fecha) DESC;


/* #4 Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto 
junto al id del producto, la cantidad de productos adquiridos y el precio promedio.
*/
SELECT c.IdCliente, c.Nombre_y_Apellido, p.Producto, p.IdProducto, 
		SUM(v.Cantidad) as cantidad_productos,
        round(avg(v.Precio),2) as precio_promedio
FROM venta v
-- JOIN producto p ON(v.IdProducto = p.IdProducto)
-- JOIN cliente c ON (v.IdCliente = c.IdCliente)
JOIN producto p using(IdProducto)
JOIN cliente c using(IdCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido, p.Producto, p.IdProducto
ORDER BY c.IdCliente;


/* #5 Cacular la cantidad de productos vendidos y la suma total de ventas para cada localidad,
presentar el análisis en un listado con el nombre de cada localidad.
*/
-- Reviso primero si existen duplicados
SELECT localidad
FROM localidad
GROUP BY localidad
HAVING count(*) > 1; -- HAY 11 REPETIDOS 


SELECT p.Provincia, l.Localidad, 
		SUM(v.Cantidad) AS cantidad_productos,
		SUM(v.Precio * v.Cantidad) AS total_ventas,
        COUNT(v.IdVenta) AS volumen_de_ventas
FROM venta v
LEFT JOIN cliente c using(IdCliente)
LEFT JOIN localidad l ON (l.IdLocalidad = c.IdLocalidad)
LEFT JOIN provincia p using(IdProvincia)
WHERE v.Outlier = 1
GROUP BY p.Provincia, l.Localidad
ORDER BY p.Provincia, l.Localidad;



/* #6 Cacular la cantidad de productos vendidos y la suma total de ventas para cada provincia, 
presentar el análisis en un listado con el nombre de cada provincia, 
pero solo en aquellas donde la suma total de las ventas fue superior a $100.000.
*/
SELECT p.Provincia,
		SUM(v.Cantidad) AS cantidad_productos,
		SUM(v.Precio * v.Cantidad) AS total_ventas,
        COUNT(v.IdVenta) AS volumen_de_ventas
FROM venta v
LEFT JOIN cliente c using(IdCliente)
LEFT JOIN localidad l ON (l.IdLocalidad = c.IdLocalidad)
LEFT JOIN provincia p using(IdProvincia)
WHERE v.Outlier = 1
GROUP BY p.Provincia
HAVING total_ventas > 100000
-- ORDER BY p.Provincia;
ORDER BY total_ventas DESC;

/* #7 Obtener un listado de dos campos en donde por un lado se obtenga la cantidad de productos vendidos por 
rango etario y las ventas totales en base a esta misma dimensión. 
El resultado debe obtenerse en un solo listado.
*/
SELECT c.Rango_Etario, 
		SUM(v.Cantidad) AS cantidad_productos,
		SUM(v.Precio * v.Cantidad) AS total_ventas
FROM venta v
JOIN cliente c using(IdCliente)
WHERE v.Outlier = 1
GROUP BY c.Rango_Etario
ORDER BY total_ventas DESC;


/* #8 Obtener la cantidad de clientes por provincia. 
*/
SELECT p.IdProvincia, p.Provincia, count(c.IdCliente) as cantidad_clientes
FROM provincia p
LEFT JOIN localidad l ON(p.IdProvincia = l.IdProvincia)
LEFT JOIN cliente c ON(l.IdLocalidad = c.IdLocalidad)
GROUP BY p.IdProvincia, p.Provincia
ORDER BY p.Provincia;