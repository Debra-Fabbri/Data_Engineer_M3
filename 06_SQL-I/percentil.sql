SELECT DISTINCT p.nro_percentil, MAX(precio) OVER w2 AS 'precio'
FROM ( 
	SELECT *, NTILE(100) OVER w1 AS 'nro_percentil'
	FROM productos 
	WINDOW w1 AS (ORDER BY precio)
	) AS p
WINDOW w2 AS (PARTITION BY nro_percentil);

SELECT DISTINCT p.nro_decil, MAX(precio) OVER w2 AS 'precio'
FROM ( 
	SELECT *, NTILE(10) OVER w1 AS 'nro_decil'
	FROM productos 
	WINDOW w1 AS (ORDER BY precio)
	) AS p
WINDOW w2 AS (PARTITION BY nro_decil);

SELECT DISTINCT p.nro_cuartil, MAX(precio) OVER w2 AS 'precio'
FROM ( 
	SELECT *, NTILE(4) OVER w1 AS 'nro_cuartil'
	FROM productos 
	WINDOW w1 AS (ORDER BY precio)
	) AS p
WINDOW w2 AS (PARTITION BY nro_cuartil);