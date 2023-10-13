-- Trigger per aggiornare lo stipendio totale medio quando viene inserito un nuovo stipendio o modificato uno stipendio esistente
CREATE OR REPLACE FUNCTION aggiorna_stipendio_medio()
RETURNS TRIGGER AS $$
DECLARE
	total_stipendio DECIMAL (10, 2);
	num_utenti INT;
BEGIN
    -- Calcola la somma totale degli importi degli stipendi per la stessa posizione lavorativa, anni di esperienza e codice sede
    -- e il conteggio totale delle recensioni degli stipendi
    SELECT SUM(importo_stipendio), COUNT(*)
    INTO total_stipendio, num_utenti
    FROM recensione_stipendio
    WHERE posizione_lavorativa = NEW.posizione_lavorativa
        AND anni_esperienza = NEW.anni_esperienza
        AND codice_s = NEW.codice_s;

    -- Aggiorna il valore dello stipendio totale medio e il numero di utenti che hanno pubblicato uno stipendio nella tabella "stipendio"
    IF num_utenti > 0 THEN
        UPDATE stipendio
        SET stipendio_totale_medio = total_stipendio / num_utenti,
            num_utenti_che_hanno_pubblicato_stipendio = num_utenti
        WHERE posizione_lavorativa = NEW.posizione_lavorativa
            AND anni_esperienza = NEW.anni_esperienza
            AND codice_s = NEW.codice_s;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger per inizializzare lo stipendio totale medio quando viene inserita la prima recensione di stipendio per una posizione lavorativa
CREATE TRIGGER inizializza_stipendio_medio
AFTER INSERT ON recensione_stipendio
FOR EACH ROW
EXECUTE PROCEDURE aggiorna_stipendio_medio();

-- Trigger per aggiornare lo stipendio totale medio quando viene modificata una recensione di stipendio esistente
CREATE TRIGGER aggiorna_stipendio_medio
AFTER UPDATE ON recensione_stipendio
FOR EACH ROW
EXECUTE PROCEDURE aggiorna_stipendio_medio();