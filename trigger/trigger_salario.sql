CREATE OR REPLACE FUNCTION inizializza_salario()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO salario (posizione_lavorativa, anni_esperienza, paga_base, retribuzione_aggiuntiva)
    VALUES (NEW.posizione_lavorativa, NEW.anni_esperienza, 0, 0)
    ON CONFLICT (posizione_lavorativa, anni_esperienza)
    DO NOTHING;
    
    INSERT INTO stipendio (posizione_lavorativa, anni_esperienza, data_ultimo_aggiornamento, 
						   stipendio_totale_medio, num_utenti_che_hanno_pubblicato_stipendio, livello_affidabilita, codice_s)
    SELECT s.posizione_lavorativa, s.anni_esperienza, current_date, 0, 0, 'Molto alta', sa.codice_s
    FROM salario sa
    JOIN stipendio s ON sa.posizione_lavorativa = s.posizione_lavorativa AND sa.anni_esperienza = s.anni_esperienza
    WHERE s.posizione_lavorativa = NEW.posizione_lavorativa AND s.anni_esperienza = NEW.anni_esperienza
    ON CONFLICT (posizione_lavorativa, anni_esperienza)
    DO NOTHING;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER inizializza_salario_trigger
AFTER INSERT ON stipendio
    FOR EACH ROW
    EXECUTE PROCEDURE inizializza_salario();