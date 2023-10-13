SELECT ruolo_ricoperto
FROM recensione_colloquio
WHERE valutazione_complessiva_colloquio = 'Positiva'

INTERSECT

SELECT ruolo_ricoperto
FROM recensione_esperienza_lavorativa
WHERE valutazione_ceo = 'Approvo'

EXCEPT

SELECT ruolo_ricoperto
FROM recensione_stipendio
WHERE importo_stipendio < 3000;
