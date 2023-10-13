CREATE OR REPLACE FUNCTION update_valutazioni_globali ()
RETURNS TRIGGER AS $$
BEGIN
-- Aggiornamento valutazione globale della sede
UPDATE sede
SET valutazione_globale_sede = (
SELECT AVG (valutazione_globale)
FROM recensione_esperienza_lavorativa
WHERE codice_s = NEW.codice_s
)
WHERE codice_s = NEW.codice_s;
-- Aggiornamento valutazione globale dell'azienda
UPDATE azienda
SET valutazione_globale = (
SELECT AVG (valutazione_globale_sede)
FROM sede
WHERE partita_iva = NEW.partita_iva
)
WHERE partita_iva = NEW.partita_iva;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

 

-- Trigger dopo l'inserimento o la modifica di una recensione di esperienza lavorativa
CREATE TRIGGER update_valutazioni_globali
AFTER INSERT OR UPDATE ON recensione_esperienza_lavorativa
FOR EACH ROW
EXECUTE PROCEDURE update_valutazioni_globali ();