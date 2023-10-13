SELECT pl.*, COUNT(*) AS numero_conteggi
FROM posizione_lavorativa pl
JOIN recensione_esperienza_lavorativa rl ON pl.ruolo_ricoperto = rl.ruolo_ricoperto
JOIN recensione_colloquio rc ON pl.ruolo_ricoperto = rc.ruolo_ricoperto
JOIN recensione_stipendio rs ON pl.ruolo_ricoperto = rs.ruolo_ricoperto
WHERE rs.importo_stipendio > 3000
 AND rc.valutazione_complessiva_colloquio = 'Positiva'
 AND rl.valutazione_ceo = 'Approvo'
GROUP BY pl.ruolo_ricoperto;
