USE data_engineer_m3;

-- Instrucción SQL N° 1

-- INSERT INTO fact_inicial (IdFecha, Fecha, IdSucursal, IdProducto, IdProductoFecha, IdSucursalFecha, IdProductoSucursalFecha)
SELECT	c.IdFecha, 
		g.Fecha,
		g.IdSucursal, 
        NULL AS IdProducto, 
        NULL AS IdProductoFecha, 
        g.IdSucursal * 100000000 + c.IdFecha IdSucursalFecha,
        NULL AS IdProductoSucursalFecha
FROM 	gasto g JOIN calendario c
	ON (g.Fecha = c.fecha)
WHERE g.IdSucursal * 100000000 + c.IdFecha NOT IN  (	SELECT	v.IdSucursal * 100000000 + c.IdFecha 
													FROM venta v JOIN calendario c ON (v.Fecha = c.fecha)
													WHERE v.Outlier = 1);
SELECT	v.IdSucursal * 100000000 + c.IdFecha 
FROM venta v JOIN calendario c ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1;


-- Instrucción SQL N° 2


-- INSERT INTO fact_inicial (IdFecha, Fecha, IdSucursal, IdProducto, IdProductoFecha, IdSucursalFecha, IdProductoSucursalFecha)
SELECT	c.IdFecha, 
		co.Fecha,
		NULL AS IdSucursal, 
        co.IdProducto, 
        co.IdProducto * 100000000 + c.IdFecha AS  IdProductoFecha, 
        NULL IdSucursalFecha,
        NULL AS IdProductoSucursalFecha
FROM 	compra co JOIN calendario c
	ON (co.Fecha = c.fecha)
WHERE co.IdProducto * 100000000 + c.IdFecha IN (SELECT	v.IdProducto * 100000000 + c.IdFecha 
													FROM venta v JOIN calendario c ON (v.Fecha = c.fecha)
													WHERE v.Outlier = 1);


-- Instrucción SQL N° 3
CREATE VIEW prom_ventas_outilers AS
SELECT 	co.TipoProducto,
		co.PromedioVentaConOutliers,
        so.PromedioVentaSinOutliers
FROM
	(	SELECT 	tp.TipoProducto, AVG(v.Precio * v.Cantidad) as PromedioVentaConOutliers
		FROM 	venta v 
		JOIN producto p
		ON (v.IdProducto = p.IdProducto)
		JOIN tipo_producto tp
		ON (p.IdTipoProducto = tp.IdTipoProducto)
		GROUP BY tp.TipoProducto
	) co
JOIN
	(	SELECT 	tp.TipoProducto, AVG(v.Precio * v.Cantidad) as PromedioVentaSinOutliers
		FROM 	venta v 
		JOIN producto p
		ON (v.IdProducto = p.IdProducto and v.Outlier = 1)
		JOIN tipo_producto tp
		ON (p.IdTipoProducto = tp.IdTipoProducto)
		GROUP BY tp.TipoProducto
	) so
ON co.TipoProducto = so.TipoProducto;


-- 4. Obtener el total de ventas del primer día y útlimo día sobre los cuales se tenga resgitros.
SELECT Fecha, SUM(Precio * Cantidad) AS Total_Ventas
FROM venta
WHERE Fecha = (SELECT MIN(Fecha)
				FROM venta)
GROUP by Fecha
UNION
SELECT Fecha, SUM(Precio * Cantidad) AS Total_Ventas
FROM venta
WHERE Fecha = (SELECT MAX(Fecha)
				FROM venta)
GROUP by Fecha;

-- 5. Obtenga un listado de los productos vendidos y del total de ventas de cada uno, según los requisitos del punto anterior.
SELECT v.Fecha, v.IdProducto, p.Producto, SUM(v.Precio*v.Cantidad) AS Total_Ventas
FROM venta v
LEFT JOIN producto p ON(v.IdProducto=p.IdProducto)
WHERE Fecha IN (SELECT MIN(Fecha) FROM venta
				UNION
                SELECT MAX(Fecha) FROM venta)
GROUP BY v.Fecha, v.IdProducto, p.Producto;

-- 6. Obtenga el importe total de ventas por fecha y a partir de este último listado, en que fecha se obtuvo el récord de ventas.
SELECT Fecha, SUM(Precio * Cantidad) AS Total_Ventas
FROM venta
GROUP BY Fecha
ORDER by Total_Ventas DESC
LIMIT 1;

