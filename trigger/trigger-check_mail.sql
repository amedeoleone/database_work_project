CREATE OR REPLACE FUNCTION check_mail()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.mail != '^[*]+@[*]+\.[*]$' THEN
        RAISE EXCEPTION 'Email non valida';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

 

CREATE TRIGGER check_mail_trigger
BEFORE INSERT ON utente
FOR EACH ROW
EXECUTE PROCEDURE check_mail();