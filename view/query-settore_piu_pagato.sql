DROP VIEW IF EXISTS RecensioniRecenti;
CREATE VIEW RecensioniRecenti AS 

	SELECT titolo, data, ruolo_ricoperto,mail
	FROM recensione_esperienza_lavorativa
	UNION ALL
	SELECT titolo, data, ruolo_ricoperto,mail
	FROM recensione_colloquio
	UNION ALL
	SELECT titolo, data, ruolo_ricoperto,mail
	FROM recensione_stipendio
ORDER BY  data DESC
LIMIT 20;
select * from  RecensioniRecenti