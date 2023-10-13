CREATE OR REPLACE FUNCTION check_registrazione()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo = 'E' AND (EXISTS (SELECT 1 FROM utente WHERE mail = NEW.mail AND tipo IN ('U', 'S')) OR
                           NEW.posizione_lavorativa IS NULL) THEN
        RAISE EXCEPTION 'Impossibile registrarsi come dipendente con la stessa email già registrata come studente o
        disoccupato o mancando la posizione lavorativa';
    ELSIF NEW.tipo = 'U' AND (EXISTS (SELECT 1 FROM utente WHERE mail = NEW.mail AND tipo IN ('E', 'S')) OR 
                             NEW.corso_studi_frequentato IS NULL) THEN
        RAISE EXCEPTION 'Impossibile registrarsi come studente con la stessa email già registrata come dipendente o
        disoccupato o mancando il corso di studi frequentato';
    ELSIF NEW.tipo = 'S' AND (EXISTS (SELECT 1 FROM utente WHERE mail = NEW.mail AND tipo IN ('E', 'U')) OR 
                              NEW.corso_studi_frequentato IS NULL) THEN
        RAISE EXCEPTION 'Impossibile registrarsi come disoccupato con la stessa email già registrata come dipendente o
        studente o mancando il corso di studi frequentato';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

 

 

CREATE TRIGGER check_registratione_trigger
BEFORE INSERT ON utente
FOR EACH ROW
EXECUTE PROCEDURE check_registrazione(); 