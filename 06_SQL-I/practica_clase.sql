use data_engineer_m3;

-- Veriable de usuario
SET @anio = 2019;
SELECT @anio;

SELECT @numero := IdVenta FROM venta WHERE IdVenta = 25;
SELECT @numero;

SELECT *
FROM venta
WHERE YEAR(Fecha) = @anio;

SHOW DATABASES;
SHOW TABLES;
SHOW VARIABLES;

-- Query por si da error y no pueden crear las funciones
SET GLOBAL log_bin_trust_function_creators = 1;

use henry;

DELIMITER $$
CREATE FUNCTION antMeses(fechaIngreso DATE) RETURNS INT
BEGIN
	DECLARE meses INT;
    SET meses = timestampdiff(MONTH, fechaIngreso, curdate());
    RETURN meses;
END$$
DELIMITER ;

SET @meses =  antMeses('2020-01-21');
SELECT @meses as cantidad_meses;

-- Creamos un proceso
DROP PROCEDURE detTotalAlumnos;
DELIMITER $$
CREATE PROCEDURE getTotalAlumnos()
BEGIN
	DECLARE total_alumnos INT DEFAULT 0;
    SELECT COUNT(*)
    INTO total_alumnos
    FROM alumno;
    SELECT total_alumnos;
END$$
DELIMITER ;

CALL getTotalAlumnos;