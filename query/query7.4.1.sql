SELECT a.nome, a.partita_iva, COUNT(codice_rs) AS numero_recensioni_stipendio,
       ROUND(AVG(importo_stipendio), 3) AS media_stipendio
FROM azienda a
JOIN sede s ON a.partita_iva = s.partita_iva
JOIN stipendio st ON s.codice_s = st.codice_s
JOIN recensione_stipendio rs ON st.posizione_lavorativa = rs.posizione_lavorativa
       AND st.anni_esperienza = rs.anni_esperienza
GROUP BY a.nome, a.partita_iva;
