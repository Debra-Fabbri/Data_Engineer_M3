use henry;
SELECT *
FROM instructor i
-- INNER JOIN cohorte c ON(c.idInstructor = i.idInstructor);
-- LEFT JOIN cohorte c ON(c.idInstructor = i.idInstructor);
RIGHT JOIN cohorte c ON(c.idInstructor = i.idInstructor);

SELECT *
FROM cohorte c
-- INNER JOIN instructor i ON(c.idInstructor = i.idInstructor);
LEFT JOIN instructor i ON(c.idInstructor = i.idInstructor)
UNION
SELECT *
FROM cohorte c
RIGHT JOIN instructor i ON(c.idInstructor = i.idInstructor);
-- CROSS JOIN instructor i ON(c.idInstructor = i.idInstructor);

use henry_m3;
SELECT v.Fecha, c.Nombre_y_Apellido, (v.Precio * v.Cantidad) as venta
FROM venta v
-- JOIN cliente c ON(c.IdCliente = v.IdCliente);
-- LEFT JOIN cliente c ON(c.IdCliente = v.IdCliente);
RIGHT JOIN cliente c ON(c.IdCliente = v.IdCliente);


SELECT v.Fecha, c.Nombre_y_Apellido, (v.Precio * v.Cantidad) as venta
FROM cliente c
LEFT JOIN venta v ON(c.IdCliente = v.IdCliente)
WHERE v.IdVenta IS NULL;






