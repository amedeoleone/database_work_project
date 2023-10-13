SELECT a.nome, a.partita_iva, ROUND(
    (SELECT AVG(rs.importo_stipendio)
     FROM recensione_stipendio rs
     WHERE rs.codice_s IN (
         SELECT s.codice_s
         FROM sede s
         WHERE s.partita_iva = a.partita_iva
	 )
    ), 0) AS media_stipendio
FROM azienda a
ORDER BY media_stipendio ASC;
