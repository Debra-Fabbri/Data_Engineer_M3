use data_engineer_m3;

SELECT *
FROM cliente
WHERE IdCliente NOT IN
	(SELECT DISTINCT idCliente
	FROM venta);
    
 SELECT *
 FROM cliente
 WHERE Edad >= 
	(SELECT round(avg(Edad))
	FROM cliente);
    
-- CREATE VIEW clientes_alto_gasto AS  
ALTER VIEW clientes_alto_gasto AS
SELECT c.IdCliente, c.Nombre_y_Apellido, (v.Precio * v.Cantidad) AS ventas
FROM venta v
JOIN cliente c using(IdCliente)
WHERE (v.Precio * v.Cantidad) >
	(SELECT avg((v.Precio * v.Cantidad)) from venta v)
GROUP BY c.IdCliente, c.Nombre_y_Apellido
ORDER BY ventas DESC;


use henry;

SELECT idAlumno, nombre, apellido, fechaIngreso
FROM alumno
WHERE fechaIngreso = (
	SELECT MIN(fehaIngreso)
    FROM alumno);