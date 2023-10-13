CREATE OR REPLACE FUNCTION check_posizione_lavorativa()
RETURNS TRIGGER AS $$

BEGIN

    IF (NEW.ruolo_ricoperto NOT IN (SELECT ruolo_ricoperto FROM a_p WHERE ruolo_ricoperto =recensione_colloquio.ruolo_ricoperto)) THEN

        RAISE EXCEPTION 'La posizione lavorativa inserita non è valida per l''azienda corrispondente';

    END IF;

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;

 

CREATE TRIGGER check_posizione_lavorativa_trigger

BEFORE INSERT ON recensione_esperienza_lavorativa

FOR EACH ROW

EXECUTE FUNCTION check_posizione_lavorativa();

 

CREATE TRIGGER check_posizione_lavorativa_trigger

BEFORE INSERT ON recensione_stipendio

FOR EACH ROW

EXECUTE FUNCTION check_posizione_lavorativa();

 

CREATE TRIGGER check_posizione_lavorativa_trigger

BEFORE INSERT ON recensione_colloquio

FOR EACH ROW

EXECUTE FUNCTION check_posizione_lavorativa();



