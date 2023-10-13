CREATE OR REPLACE FUNCTION check_numero_parole()
RETURNS TRIGGER AS $$
DECLARE
    conteggio_vantaggi INTEGER;
    conteggio_svantaggi INTEGER;
BEGIN

    SELECT array_length(string_to_array(vantaggi, ' '), 1) INTO conteggio_vantaggi
    FROM recensione_esperienza_lavorativa
    WHERE codice_rl = NEW.codice_rl;
	
	SELECT array_length(string_to_array(svantaggi, ' '), 1) INTO conteggio_svantaggi
    FROM recensione_esperienza_lavorativa
    WHERE codice_rl = NEW.codice_rl;
	
    IF conteggio_vantaggi < 5 OR conteggio_svantaggi < 5 THEN
        RAISE EXCEPTION 'Il campo "vantaggi" e "svantaggi" deve contenere almeno 5 parole';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_numero_parole_trigger
BEFORE INSERT ON recensione_esperienza_lavorativa
FOR EACH ROW
EXECUTE FUNCTION check_numero_parole();