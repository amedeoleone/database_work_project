SELECT settore, ROUND(AVG(stipendio_max)) AS stipendio_settore
FROM recensioni_aziende_grandi
GROUP BY settore
HAVING AVG (stipendio_max)=(
	SELECT MAX (stipendio_settore)
FROM(
	SELECT settore, AVG(stipendio_max) AS stipendio_settore
	FROM recensioni_aziende_grandi
	GROUP BY settore
	)AS massimo	
);