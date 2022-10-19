USE data_engineer_m3;

/* #1 Crear un procedimiento que recibe como parametro 
una fecha y devuelva el listado de productos que se vendieron en esa fecha.
*/
DROP PROCEDURE listaProductos;
DELIMITER $$
CREATE PROCEDURE listaProductos (fechaVenta DATE)
BEGIN
	SELECT DISTINCT p.Producto
    FROM venta v
    JOIN producto p ON (p.IdProducto = v.IdProducto AND v.Fecha = fechaVenta);
END $$
DELIMITER ;

CALL listaProductos('2018-01-24');


/* #2 Crear una función que calcule el valor nominal de un margen bruto 
determinado por el usuario a partir del precio de lista de los productos.
*/
DROP FUNCTION margenBruto;
DELIMITER $$
CREATE FUNCTION margenBruto(precio DECIMAL(15,2), margen DECIMAL(8,2)) RETURNS DECIMAL (15,2)
BEGIN
	DECLARE margenBruto DECIMAL(15,2);
    SET margenBruto = precio * margen;
    RETURN margenBruto;
END $$
DELIMITER ;
SELECT margenBruto(100, 1.2);


-- en este caso lo hice con la lista de compra y no de productos

SELECT c.Fecha, pr.nombre as Proveedor, p.Producto, c.Precio as Precio_Compra -- , margenBruto(c.Precio, 1.2) as Precio_con_margen
FROM compra c
JOIN producto p ON(p.IdProducto = c.IdProducto)
JOIN proveedor pr ON(pr.IdProveedor = c.IdProveedor);


/* #3 Obtner un listado de productos de IMPRESION y utilizarlo para cálcular 
el valor nominal de un margen bruto del 20% de cada uno de los productos.
*/
SELECT p.IdProducto, p.Producto, p.Precio -- , margenBruto(p.Precio, 1.2) as precio_con_margen
FROM producto p
JOIN tipo_producto tp ON (p.IdTipoProducto = tp.IdTipoProducto AND TipoProducto = 'Impresión');


/* #4 Crear un procedimiento que permita listar los productos vendidos 
desde fact_venta a partir de un "Tipo" que determine el usuario.

Resuelto con tabla de venta NO fac_venta
*/
DROP PROCEDURE listaProductosCategoria;
DELIMITER $$
CREATE PROCEDURE listaProductosCategoria (categoria VARCHAR(30))
BEGIN
	SELECT v.*, p.Producto
    FROM venta v
    JOIN producto p ON (p.IdProducto = v.IdProducto)
    JOIN tipo_producto tp ON(tp.IdTipoProducto = p.IdTipoProducto AND TipoProducto collate utf8mb4_spanish_ci= categoria);
END $$
DELIMITER ;

-- CALL listaProductosCategoria('Audio');
CALL listaProductosCategoria('Limpieza');

/* #5 Crear un procedimiento que permita realizar la insercción de datos en la tabla fact_inicial.
*/
truncate table fact_venta;

DROP PROCEDURE cargarFact_venta;
DELIMITER $$
CREATE PROCEDURE cargarFact_venta ()
BEGIN
	INSERT INTO fact_venta
    SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
    FROM venta
    WHERE Outlier = 1
    LIMIT 10;
END $$
DELIMITER ;

CALL cargarFact_venta ();


/* #6 Crear un procedimiento almacenado que reciba un grupo etario 
y devuelta el total de ventas para ese grupo.
*/
DROP PROCEDURE ventasGrupoEtario;
DELIMITER $$
CREATE PROCEDURE ventasGrupoEtario(Rango_Etario VARCHAR(30))
BEGIN
	SELECT c.Rango_Etario, SUM(v.Precio * v.Cantidad) as total_venta
    FROM venta v
    JOIN cliente c ON (c.IdCliente = v.IdCliente AND c.Rango_Etario collate utf8mb4_spanish_ci LIKE concat('%', rango_etario, '%'))
    GROUP BY c.Rango_Etario;
END $$
DELIMITER ;

SELECT distinct Rango_Etario
FROM cliente;

CALL ventasGrupoEtario('41 a 50');


/* #7 Crear una variable que se pase como valor para realizar
una filtro sobre Rango_etario en una consulta génerica a dim_cliente.
*/
SET @grupo_etario = '4_De 51 a 60 años';
SELECT *
FROM dim_cliente
WHERE Rango_Etario collate utf8mb4_spanish_ci = @grupo_etario;
