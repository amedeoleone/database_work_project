DROP TABLE IF EXISTS utente CASCADE;
DROP TABLE IF EXISTS recensione_colloquio CASCADE;
DROP TABLE IF EXISTS lettore_c CASCADE;
DROP TABLE IF EXISTS recensione_esperienza_lavorativa CASCADE;
DROP TABLE IF EXISTS lettore_l CASCADE;
DROP TABLE IF EXISTS recensione_stipendio CASCADE;
DROP TABLE IF EXISTS lettore_s CASCADE;
DROP TABLE IF EXISTS stipendio CASCADE;
DROP TABLE IF EXISTS salario CASCADE;
DROP TABLE IF EXISTS sede CASCADE;
DROP TABLE IF EXISTS citta CASCADE;
DROP TABLE IF EXISTS azienda CASCADE;
DROP TABLE IF EXISTS posizione_lavorativa CASCADE;
DROP TABLE IF EXISTS a_p CASCADE;
DROP TABLE IF EXISTS p_rc CASCADE;
DROP TABLE IF EXISTS p_rl CASCADE;
DROP TABLE IF EXISTS p_rs CASCADE;

CREATE TABLE utente (
    mail VARCHAR(50) PRIMARY KEY, 
    tipo CHAR NOT NULL CHECK (tipo IN ('E', 'U', 'S')),
    posizione_lavorativa VARCHAR(100) NOT NULL, 
    luogo_lavoro VARCHAR(100) NOT NULL, 
    corso_studi_frequentato VARCHAR(100)
);

CREATE TABLE azienda (
    partita_iva BIGINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sito_web VARCHAR(100) NOT NULL,
    num_dipendenti INT NOT NULL,
    tipo_societa VARCHAR(100) NOT NULL,
    entrate BIGINT NOT NULL,
    sede_centrale VARCHAR(100) NOT NULL,
    anno_fondazione INT NOT NULL,
    settore VARCHAR(100) NOT NULL,
    num_recensioni INT NOT NULL,
    valutazione_globale INT NOT NULL
);

CREATE TABLE posizione_lavorativa (
    ruolo_ricoperto VARCHAR(100) PRIMARY KEY
);

CREATE TABLE sede ( 
    codice_s INT PRIMARY KEY,
    valutazione_globale_sede INT NOT NULL,
	via VARCHAR(50) NOT NULL,
	numero_civico INT NOT NULL,
	interno VARCHAR(5) NOT NULL,
	cap INT NOT NULL,
	nazione VARCHAR(50) NOT NULL,
    partita_iva BIGINT NOT NULL,
    FOREIGN KEY (partita_iva) REFERENCES AZIENDA (partita_iva) 
);

CREATE TABLE citta (
	codice_s INT PRIMARY KEY,
	comune VARCHAR(50) NOT NULL
);

CREATE TABLE stipendio (
    posizione_lavorativa VARCHAR(100) NOT NULL,
    anni_esperienza INT NOT NULL,
    data_ultimo_aggiornamento DATE NOT NULL,
    stipendio_totale_medio INT NOT NULL,
    num_utenti_che_hanno_pubblicato_stipendio INT NOT NULL,
    livello_affidabilita VARCHAR(11) NOT NULL CHECK (livello_affidabilita IN ('Molto alta', 'Alta', 'Bassa', 'Molto bassa')),
    codice_s INT NOT NULL REFERENCES SEDE (codice_s),
    PRIMARY KEY (posizione_lavorativa, anni_esperienza, codice_s)
);

CREATE TABLE recensione_colloquio ( 
    codice_rc INT PRIMARY KEY, 
    titolo VARCHAR(100) NOT NULL, 
    data DATE NOT NULL, 
    valutazione_complessiva_colloquio VARCHAR(8) NOT NULL CHECK (valutazione_complessiva_colloquio IN ('Positiva', 'Neutra', 'Negativa')), 
    descrizione_processo_colloquio VARCHAR(1000) NOT NULL, 
    difficolta VARCHAR(15) NOT NULL CHECK (difficolta IN ('Molto facile', 'Facile', 'Media', 'Difficile', 'Molto difficile')),
    offerta_lavoro_ricevuta VARCHAR(20) NOT NULL CHECK (offerta_lavoro_ricevuta IN ('No', 'Sì, ma ho rifiutato', 'Sì, e ho accettato')), 
    domande_ricevute VARCHAR(250) NOT NULL, 
    risposte VARCHAR(500), 
    mail VARCHAR(50) NOT NULL, 
	ruolo_ricoperto VARCHAR(100) NOT NULL,
    FOREIGN KEY (mail) REFERENCES utente (mail),
	FOREIGN KEY (ruolo_ricoperto) REFERENCES posizione_lavorativa (ruolo_ricoperto)
); 

CREATE TABLE lettore_c (
    mail VARCHAR(50) NOT NULL REFERENCES UTENTE (mail), 
    codice_rc INT NOT NULL REFERENCES RECENSIONE_COLLOQUIO (codice_rc),
    PRIMARY KEY (mail, codice_rc)
);

CREATE TABLE recensione_esperienza_lavorativa ( 
    codice_rl INT PRIMARY KEY,
    titolo VARCHAR(50) NOT NULL, 
    data DATE NOT NULL,
    dipendente_attuale BOOLEAN NOT NULL,
    ultimo_anno_di_lavoro INT,
    valutazione_CEO VARCHAR(15) CHECK (valutazione_CEO IN ('Approvo', 'Neutro', 'Disapprovo')),
    consiglio_ad_un_amico VARCHAR(15) CHECK (consiglio_ad_un_amico IN ('Positivo', 'Negativo')),
    pronostico_commerciale_a_6_mesi VARCHAR(15) CHECK (pronostico_commerciale_a_6_mesi IN ('Positivo', 'Neutro', 'Negativo')),
    valutazione_globale INT,
    opportunita_di_carriera INT,
    compensi_e_benefit INT,
    cultura_e_valori INT,
    diversita_e_inclusione INT,
    dirigenti_senior INT,
    equilibrio_lavoro_vita_privata INT,
    vantaggi VARCHAR (1000) NOT NULL,
    svantaggi VARCHAR(1000) NOT NULL,
    consigli_per_i_dirigenti VARCHAR(500),
    durata_impiego INT NOT NULL,
    mail VARCHAR(50) NOT NULL REFERENCES UTENTE (mail),
	ruolo_ricoperto VARCHAR(100) NOT NULL REFERENCES posizione_lavorativa (ruolo_ricoperto)
); 

CREATE TABLE lettore_l (
    mail VARCHAR(50) NOT NULL REFERENCES UTENTE (mail),
    codice_rl INT NOT NULL REFERENCES RECENSIONE_ESPERIENZA_LAVORATIVA (codice_rl),
    PRIMARY KEY (mail, codice_rl)	
);

CREATE TABLE recensione_stipendio (
    codice_rs INT PRIMARY KEY,
    titolo VARCHAR(50) NOT NULL,
    data DATE NOT NULL,
    giudizio VARCHAR(6) NOT NULL CHECK (giudizio IN ('Giusto', 'Alto', 'Basso')),
    feedback VARCHAR(500),
    importo_stipendio INT NOT NULL,
    Paga_bonus INT,
    mail VARCHAR(50) NOT NULL REFERENCES UTENTE (mail),
    posizione_lavorativa VARCHAR(100) NOT NULL,
    anni_esperienza INT NOT NULL,
    codice_s INT NOT NULL REFERENCES SEDE (codice_s),
	ruolo_ricoperto VARCHAR(100) NOT NULL REFERENCES posizione_lavorativa (ruolo_ricoperto),
    FOREIGN KEY (posizione_lavorativa, anni_esperienza, codice_s) REFERENCES stipendio (posizione_lavorativa, anni_esperienza, codice_s)
);

CREATE TABLE lettore_s ( 
    mail VARCHAR(255) NOT NULL REFERENCES UTENTE (mail),
    codice_rs INT NOT NULL REFERENCES RECENSIONE_STIPENDIO (codice_rs),
    PRIMARY KEY (mail, codice_rs)	
); 

CREATE TABLE salario ( 
    posizione_lavorativa VARCHAR(100) NOT NULL,
    anni_esperienza INT NOT NULL,
    paga_base INT NOT NULL,
    retribuzione_aggiuntiva INT NOT NULL,
    PRIMARY KEY (posizione_lavorativa, anni_esperienza)	
);

CREATE TABLE a_p (
    ruolo_ricoperto VARCHAR(100) NOT NULL,
	partita_iva BIGINT NOT NULL,
	PRIMARY KEY (ruolo_ricoperto, partita_iva)
);

CREATE TABLE p_rc (
    ruolo_ricoperto VARCHAR(100) NOT NULL,
	codice_rc INT NOT NULL,
	PRIMARY KEY (ruolo_ricoperto, codice_rc)
);

CREATE TABLE p_rl (
    ruolo_ricoperto VARCHAR(100) NOT NULL,
	codice_rl INT NOT NULL,
	PRIMARY KEY (ruolo_ricoperto, codice_rl)
);

CREATE TABLE p_rs (
    ruolo_ricoperto VARCHAR(100) NOT NULL,
	codice_rs INT NOT NULL,
	PRIMARY KEY (ruolo_ricoperto, codice_rs)
);

 -- Popolamento con dati di esempio

-- Utenti dipendenti (E) e disoccupati (U)
INSERT INTO utente (mail, tipo, posizione_lavorativa, luogo_lavoro) VALUES 
    ('michele.martino@gmail.com', 'U', 'Sviluppatore Software', 'Milano'), 
	('giulia.verdi@yahoo.com', 'U', 'Project Manager', 'Roma'), 
	('luca.concilio@hotmail.com', 'E', 'Analista Finanziario', 'Torino'), 
	('sara.ferrari@libero.it', 'E', 'Ingegnere Civile', 'Napoli'), 
	('andrea.romano@outlook.com', 'E', 'Architetto', 'Firenze'), 
	('francesca.gallo@tiscali.it', 'U', 'Avvocato', 'Bologna'), 
	('enzo.sessa@alice.it', 'E', 'Marketing Manager', 'Fisciano'), 
	('felicia.rizzo@virgilio.it', 'E', 'Graphic Designer', 'Palermo'), 
	('stefano.massera@fastwebnet.it', 'U', 'Infermiere', 'Genova'), 
	('simona.cucciolo@libero.it', 'U', 'Consulente Finanziario', 'Bari'), 
	('stefano.mari@gmail.com', 'E', 'Ingegnere Meccanico', 'Fisciano'), 
	('laura.rocco@yahoo.com', 'E', 'Docente Universitario', 'Roma'), 
	('paolo.conti@outlook.com', 'E', 'Architetto del Paesaggio', 'Torino'), 
	('chiara.bianco@libero.it', 'E', 'Consulente HR', 'Firenze'), 
	('davide.lupo@virgilio.it', 'U', 'Programmatore Web', 'Bologna'),
	('marco.rossi@gmail.com', 'E', 'Project Manager', 'Cupertino');

-- Utenti studenti (S)
INSERT INTO utente (mail, tipo, posizione_lavorativa, luogo_lavoro, corso_studi_frequentato) VALUES
    ('al.mangiola@gmail.com', 'S', 'Ethical Hacker', 'Milano', 'Ingegneria Informatica'),
    ('amedeoleone10@gmail.com', 'S', 'Docente Universitario', 'Potenza', 'Ingegneria Informatica'),
    ('paresci@hotmail.it', 'S', 'Maestro di Mandolino', 'Salerno', 'Ingegneria del Suono'),
    ('gaia.bianchi@hotmail.com', 'S', 'Analista Finanziario', 'Torino', NULL),
    ('alessandro.pec@gmail.com', 'S', 'Sviluppatore software', 'Salerno', 'Ingegneria Informatica'),
    ('alessia.romano@outlook.com', 'S', 'Architetto', 'Firenze', 'Architettura');
	
INSERT INTO azienda (partita_iva, nome, sito_web, num_dipendenti, tipo_societa, entrate, sede_centrale, anno_fondazione, settore, num_recensioni, valutazione_globale) VALUES
    (12345678901, 'Google', 'https://www.google.com', 150000, 'Società per Azioni', 15000000000, 'Mountain View, California', 1998, 'Tecnologia', 1000, 4.5),
    (98765432109, 'Apple', 'https://www.apple.com', 147000, 'Società per Azioni', 20000000000, 'Cupertino, California', 1976, 'Tecnologia', 1200, 4.8),
    (56789012345, 'Amazon', 'https://www.amazon.com', 1000000, 'Società per Azioni', 38600000000, 'Seattle, Washington', 1994, 'Commercio elettronico', 800, 4.3),
    (10987654321, 'Microsoft', 'https://www.microsoft.com', 175000, 'Società per Azioni', 15000000000, 'Redmond, Washington', 1975, 'Tecnologia', 900, 4.6),
    (24681357902, 'Facebook', 'https://www.facebook.com', 60000, 'Società per Azioni', 2100000000, 'Menlo Park, California', 2004, 'Tecnologia', 700, 4.4),
    (86420975318, 'Tesla', 'https://www.tesla.com', 48000, 'Società per Azioni', 1000000000, 'Palo Alto, California', 2003, 'Automotive', 500, 4.2),
    (13579246802, 'Netflix', 'https://www.netflix.com', 10000, 'Società per Azioni', 200000000, 'Los Gatos, California', 1997, 'Intrattenimento', 400, 4.1),
    (24680135792, 'Intel', 'https://www.intel.com', 110000, 'Società per Azioni', 720000000, 'Santa Clara, California', 1968, 'Tecnologia', 300, 4.0),
    (98765432108, 'IBM', 'https://www.ibm.com', 350000, 'Società per Azioni', 790000000, 'Armonk, New York', 1911, 'Tecnologia', 600, 4.3),
    (12345678900, 'Samsung', 'https://www.samsung.com', 320000, 'Società per Azioni', 2100000000, 'Seoul, Corea del Sud', 1938, 'Tecnologia', 800, 4.5),
	(98765432100, 'Leonardo', 'https://www.leonardocompany.com', 48000, 'Società per Azioni', 2000000000, 'Roma, Italia', 1948, 'Aerospazio e Difesa', 200, 4.2),
    (24681357903, 'General Electric', 'https://www.ge.com', 174000, 'Corporazione', 21000000000, 'Boston, Massachusetts', 1892, 'Energia e Utility', 600, 4.6),
    (13579246803, 'Airbnb', 'https://www.airbnb.com', 3000, 'Società a Responsabilità Limitata', 400000000, 'San Francisco, California', 2008, 'Turismo e Ospitalità', 400, 4.3),
    (86420975319, 'Ferrari', 'https://www.ferrari.com', 4000, 'Società per Azioni', 4000000000, 'Maranello, Italia', 1939, 'Automotive', 300, 4.5),
    (12345678902, 'Siemens', 'https://www.siemens.com', 300000, 'Società Europea', 8600000000, 'Monaco di Baviera, Germania', 1847, 'Tecnologia', 700, 4.4);

INSERT INTO sede (codice_s, valutazione_globale_sede, via, numero_civico, interno, cap, nazione, partita_iva) VALUES
	-- Sedi di Google
	(1, 4.6, 'Amphitheatre Parkway', 1600, '', 94043, 'Stati Uniti', 12345678901),
	(2, 4.4, 'Spear Street', 345, '', 94105, 'Stati Uniti', 12345678901),
	(3, 4.3, '6th Street South', 747, '', 94040, 'Stati Uniti', 12345678901),
	(4, 4.5, 'Main Street', 345, '', 94304, 'Stati Uniti', 12345678901),
	-- Sedi di Apple
	(5, 4.7, 'Apple Park Way', 1, '', 95014, 'Stati Uniti', 98765432109),
	(6, 4.5, 'Tantau Avenue', 10600, 'N', 95014, 'Stati Uniti', 98765432109),
	(7, 4.6, 'Infinite Loop', 1, '', 95014, 'Stati Uniti', 98765432109),
	(8, 4.4, 'Pruneridge Avenue', 19111 , '2B', 95014, 'Stati Uniti', 98765432109),
	-- Sedi di Amazon
	(9, 4.5, 'Terry Avenue North', 1, '410', 98109, 'Stati Uniti', 56789012345),
	(10, 4.3, 'Westlake Avenue', 2201, '', 98121, 'Stati Uniti', 56789012345),
	(11, 4.4, '8th Avenue', 1918, '', 98101, 'Stati Uniti', 56789012345),
	(12, 4.6, '1st Avenue South', 4100, '', 98134, 'Stati Uniti', 56789012345),
	-- Sedi di Microsoft
	(13, 4.7, '1 Microsoft Way', 1, '2C', 98052, 'Stati Uniti', 10987654321),
	(14, 4.5, '15010 NE 36th Street', 2, '4F', 98007, 'Stati Uniti', 10987654321),
	(15, 4.6, '925 NE 67th Street', 3, '4B', 98052, 'Stati Uniti', 10987654321),
	(16, 4.4, '15563 NE 31st Street', 4, '4A', 98052, 'Stati Uniti', 10987654321),
	-- Sedi di Facebook
	(17, 4.4, 'Hacker Way', 1, '', 94025, 'Stati Uniti', 24681357902),
	(18, 4.3, 'Middlefield Road', 10, '', 94025, 'Stati Uniti', 24681357902),
	(19, 4.5, 'Jefferson Drive', 101, '', 94025, 'Stati Uniti', 24681357902),
	(20, 4.2, 'Jefferson Drive', 200, '', 94025, 'Stati Uniti', 24681357902),
	-- Sedi di Tesla
	(21, 4.1, 'Deer Creek Road', 3500, '', 94304, 'Stati Uniti', 86420975318),
	(22, 4.3, 'Fremont Boulevard', 45500, '', 94538, 'Stati Uniti', 86420975318),
	(23, 4.2, 'Hillview Avenue', 3400, '', 94304, 'Stati Uniti', 86420975318),
	(24, 4.4, 'Eureka Drive', 39700, '', 94539, 'Stati Uniti', 86420975318),
	-- Sedi di Netflix
	(25, 4.1, 'Winchester Circle', 100, '7B', 95032, 'Stati Uniti', 13579246802),
	(26, 4.0, 'Albright Way', 121, '3C', 95032, 'Stati Uniti', 13579246802),
	(27, 4.3, 'Cobalt Way', 333, '9D', 95032, 'Stati Uniti', 13579246802),
	(28, 4.2, 'Sand Hill Road', 2888, '1F', 94025, 'Stati Uniti', 13579246802),
	-- Sedi di Intel
	(29, 4.2, 'Mission College Boulevard', 2200, '2D', 95054, 'Stati Uniti', 24680135792),
	(30, 4.0, 'S Dobson Road', 4500, '3D', 85282, 'Stati Uniti', 24680135792),
	(31, 4.3, 'NW 229th Avenue', 2500, '1C', 97124, 'Stati Uniti', 24680135792),
	(32, 4.1, 'NW 229th Avenue', 2200, '12M', 97124, 'Stati Uniti', 24680135792),
	-- Sedi di IBM
	(33, 4.3, 'New Orchard Road', 1, '6E', 10504, 'Stati Uniti', 98765432108),
	(34, 4.5, 'Old Columbia Road', 10100, '8Q', 21046, 'Stati Uniti', 98765432108),
	(35, 4.4, 'Riverwalk Boulevard', 10 , '3D', 10595, 'Stati Uniti', 98765432108),
	(36, 4.6, 'Schlumberger Drive', 6, '2A', 10956, 'Stati Uniti', 98765432108),
	-- Sedi di Samsung
	(37, 4.5, 'Samsung-ro', 129 , '', 06541, 'Corea del Sud', 12345678900),
	(38, 4.4, 'Hwangojang-dong', 205, '', 07268, 'Corea del Sud', 12345678900),
	(39, 4.6, 'Galwol-dong', 130, '', 08294, 'Corea del Sud', 12345678900),
	(40, 4.3, 'Seocho-daero 74-gil', 14 , '', 06620, 'Corea del Sud', 12345678900),
	-- Sedi di Leonardo
	(41, 4.2, 'Piazzale dell''Industria', 40, '', 00144, 'Italia', 98765432100),
	(42, 4.3, 'Viale del Parco Mellini', 44, '', 00136, 'Italia', 98765432100),
	(43, 4.1, 'Via Pietro Agostino Rivarola', 10, '', 00159, 'Italia', 98765432100),
	(44, 4.5, 'Via Labicana', 72, '', 00184, 'Italia', 98765432100),
	-- Sedi di General Electric
	(45, 4.6, 'Farnsworth Street', 41, '1A', 02210, 'Stati Uniti', 24681357903),
	(46, 4.4, 'East Galbraith Road', 5901, '4D', 45236, 'Stati Uniti', 24681357903),
	(47, 4.5, 'Woodford Road', 41, '3B', 01730, 'Stati Uniti', 24681357903),
	(48, 4.3, 'Boylston Street', 800, '2C', 02199, 'Stati Uniti', 24681357903),
	-- Sedi di Airbnb
	(49, 4.3, 'Brannan Street', 888, '3A', 94103, 'Stati Uniti', 13579246803),
	(50, 4.4, 'Eighth Avenue', 888, '7A', 10019, 'Stati Uniti', 13579246803),
	(51, 4.5, 'Tennesse Street', 888, '12A', 94107, 'Stati Uniti', 13579246803),
	(52, 4.2, 'Seventh Avenue', 888, '17A', 10019, 'Stati Uniti', 13579246803),
	-- Sedi di Ferrari
	(53, 4.5, 'Via Abetone Inferiore', 4, '', 41053, 'Italia', 86420975319),
	(54, 4.6, 'Via Emilia Est', 1163, '', 41121, 'Italia', 86420975319),
	(55, 4.4, 'Via Alfredo Dino Ferrari', 43, '', 41053, 'Italia', 86420975319),
	(56, 4.3, 'Via Gilles Villeneuve', 1, '', 41053, 'Italia', 86420975319),
	-- Sedi di Siemens
	(57, 4.4, 'Werner-von-Siemens-Strasse', 1, '8B', 80333, 'Germania', 12345678902),
	(58, 4.6, 'Hofmannstrasse', 51, '', 81379, 'Germania', 12345678902),
	(59, 4.3, 'Otto-Hahn-Ring', 6, '5D', 81739, 'Germania', 12345678902),
	(60, 4.5, 'Balcke-Duerr-Allee', 3, '', 40882, 'Germania', 12345678902);

INSERT INTO posizione_lavorativa (ruolo_ricoperto) VALUES
	('Sviluppatore Software'),
	('Project Manager'),
	('Analista Finanziario'),
	('Ingegnere Civile'),
	('Architetto'),
	('Avvocato'),
	('Marketing Manager'),
	('Graphic Designer'),
	('Infermiere'),
	('Consulente Finanziario'),
	('Ingegnere Meccanico'),
	('Docente Universitario'),
	('Architetto del Paesaggio'),
	('Consulente HR'),
	('Programmatore Web'),
	('Ethical Hacker'),
	('Maestro di Mandolino'),
	('Ingegnere del Suono'),
	('Maestro di Ballo'),
	('Data Scientist'),
	('Amministratore di sistema'),
    ('Analista finanziario'),
    ('Architetto del software'),
    ('Consulente di marketing'),
    ('Data analyst'),
    ('Designer UX/UI'),
    ('Direttore delle risorse umane'),
    ('Esperto di cybersecurity'),
    ('Ingegnere del software'),
    ('Responsabile del servizio clienti'),
	('Amministratore di Sistema'),
	('Web Developer'),
	('Network Engineer'),
	('Software Engineer'),
	('Cybersecurity Analyst');

INSERT INTO stipendio (posizione_lavorativa, anni_esperienza, data_ultimo_aggiornamento, stipendio_totale_medio, num_utenti_che_hanno_pubblicato_stipendio, livello_affidabilita, codice_s) VALUES
	('Sviluppatore Software', 2, '2023-05-01', 40000, 10, 'Alta', 1),
	('Sviluppatore Software', 5, '2023-05-10', 60000, 12, 'Molto alta', 1),
	('Sviluppatore Software', 5, '2023-05-10', 60000, 12, 'Molto alta', 6),
	('Sviluppatore Software', 10, '2023-06-01', 80000, 8, 'Molto alta', 10),
	('Project Manager', 2, '2023-05-01', 50000, 6, 'Bassa', 4),
	('Project Manager', 5, '2023-05-01', 70000, 4, 'Molto alta', 8),
	('Project Manager', 5, '2023-05-01', 70000, 4, 'Molto alta', 2),
	('Project Manager', 8, '2023-05-01', 90000, 2, 'Molto alta', 12),
	('Analista Finanziario', 2, '2023-05-01', 45000, 5, 'Alta', 1),
	('Analista Finanziario', 2, '2023-05-01', 45000, 5, 'Alta', 3),
	('Analista Finanziario', 4, '2023-05-01', 65000, 3, 'Molto alta', 13),
	('Analista Finanziario', 8, '2023-05-01', 85000, 1, 'Alta', 17),
	('Ingegnere Civile', 2, '2023-05-01', 42000, 8, 'Bassa', 50),
	('Ingegnere Civile', 5, '2023-05-01', 62000, 6, 'Molto alta', 50),
	('Ingegnere Civile', 10, '2023-05-01', 82000, 4, 'Alta', 51),
	('Architetto', 2, '2023-05-01', 38000, 7, 'Alta', 5),
	('Architetto', 5, '2023-05-01', 58000, 9, 'Molto alta', 22),
	('Architetto', 5, '2023-05-01', 58000, 9, 'Molto alta', 5),
	('Architetto', 10, '2023-05-01', 78000, 11, 'Alta', 46),
	('Architetto', 10, '2023-05-01', 78000, 11, 'Alta', 22),
	('Marketing Manager', 2, '2023-05-01', 47000, 3, 'Bassa', 55),
	('Marketing Manager', 2, '2023-05-01', 47000, 3, 'Bassa', 60),
	('Marketing Manager', 5, '2023-05-01', 67000, 5, 'Bassa', 55),
	('Marketing Manager', 10, '2023-05-01', 87000, 7, 'Molto alta', 42),
	('Graphic Designer', 2, '2023-05-01', 35000, 9, 'Alta', 31),
	('Graphic Designer', 5, '2023-05-01', 55000, 11, 'Alta', 20),
	('Graphic Designer', 5, '2023-05-01', 55000, 11, 'Alta', 12),
	('Graphic Designer', 7, '2023-05-01', 75000, 13, 'Molto alta', 12),
	('Infermiere', 2, '2023-05-01', 32000, 15, 'Molto alta', 4),
	('Infermiere', 2, '2023-05-01', 32000, 15, 'Molto alta', 21),
	('Infermiere', 5, '2023-05-01', 52000, 17, 'Molto alta', 18),
	('Infermiere', 10, '2023-05-01', 72000, 19, 'Molto alta', 21),
	('Sales Specialist', 2, '2023-05-01', 32000, 15, 'Molto alta', 24),
	('Sales Specialist', 7, '2023-05-01', 52000, 17, 'Molto alta', 38),
	('Sales Specialist', 9, '2023-05-01', 72000, 19, 'Molto alta', 56),
	('Sviluppatore Software', 3, '2023-05-25', 42000, 19, 'Molto alta', 1),
	('Sviluppatore Software', 3, '2023-05-25', 42000, 19, 'Molto alta', 56);

INSERT INTO salario (posizione_lavorativa, anni_esperienza, paga_base, retribuzione_aggiuntiva) VALUES  

	('Sviluppatore Software', 2, 40000, 0),
    ('Sviluppatore Software', 5, 60000, 0),
    ('Sviluppatore Software', 10, 80000, 0),
    ('Project Manager', 2, 50000, 0),
    ('Project Manager', 5, 70000, 0),
    ('Project Manager', 8, 80000, 10000),
    ('Analista Finanziario', 2, 45000, 0),
    ('Analista Finanziario', 4, 65000, 0),
    ('Analista Finanziario', 8, 85000, 0),
    ('Ingegnere Civile', 2, 40000, 2000),
    ('Ingegnere Civile', 5, 60000, 2000),
    ('Ingegnere Civile', 10, 75000, 7000),
    ('Architetto', 2, 38000, 0),
    ('Architetto', 5, 58000, 0),
    ('Architetto', 10, 78000, 0),
    ('Marketing Manager', 2, 47000, 0),
    ('Marketing Manager', 5, 67000, 0),
    ('Marketing Manager', 10, 87000, 0),
    ('Graphic Designer', 2, 35000, 0),
    ('Graphic Designer', 5, 55000, 0),
    ('Graphic Designer', 7, 70000, 5000),
    ('Infermiere', 2, 28000, 2000),
    ('Infermiere', 5, 50000, 2000),
    ('Infermiere', 10, 70000, 2000);
	
INSERT INTO recensione_colloquio (codice_rc, titolo, data, valutazione_complessiva_colloquio, descrizione_processo_colloquio, difficolta, offerta_lavoro_ricevuta, domande_ricevute, risposte, mail, ruolo_ricoperto) VALUES
    (1, 'Colloquio stimolante e ben strutturato', '2023-05-01', 'Positiva', 'Il colloquio è stato ben organizzato e l''azienda si è dimostrata molto interessata alle mie competenze.', 'Media', 'Sì, e ho accettato', 'Le domande erano incentrate sulle mie esperienze passate e le competenze richieste per il ruolo, ad esempio: "Descrivi un progetto in cui hai utilizzato il linguaggio di programmazione C e quali sfide hai affrontato?"', 'Ho risposto in modo dettagliato alle domande sulle mie esperienze e ho fornito esempi concreti.', 'michele.martino@gmail.com', 'Sviluppatore Software'),
    (2, 'Esperienza di colloquio nella media', '2020-05-03', 'Neutra', 'Il colloquio è stato abbastanza standard e non particolarmente memorabile.', 'Facile', 'No', 'Le domande erano abbastanza generiche e non approfondivano le mie competenze specifiche.', NULL, 'giulia.verdi@yahoo.com', 'Amministratore di Sistema'),
    (3, 'Colloquio ben condotto e impressionante', '2023-05-07', 'Positiva', 'Il colloquio è stato ben strutturato e l''azienda ha mostrato grande professionalità.', 'Facile', 'Sì, ma ho rifiutato', 'Le domande erano mirate a valutare le mie capacità di problem-solving e adattabilità. Mi hanno chiesto di descrivere una situazione in cui ho affrontato un bug critico e come ho risolto il problema.', 'Ho fornito risposte approfondite e ho sottolineato i miei punti di forza.', 'francesca.gallo@tiscali.it', 'Analista Finanziario'),
	(4, 'Colloquio standard senza sorprese', '2020-05-09', 'Positiva', 'Il colloquio è stato molto cordiale e l''azienda si è dimostrata molto interessata al mio background.', 'Molto facile', 'Sì, e ho accettato', 'Le domande erano incentrate sulle mie competenze specifiche richieste per il ruolo, ad esempio: "Descrivi una situazione in cui hai ottimizzato le prestazioni di un''applicazione web."', 'Ho fornito esempi concreti di come ho migliorato le prestazioni di un''applicazione web e ho spiegato le tecniche utilizzate.', 'simona.cucciolo@libero.it', 'Web Developer'),
    (5, 'Colloquio cordiale e interessante', '2023-05-11', 'Positiva', 'Il colloquio è stato ben strutturato e ho avuto modo di mostrare appieno le mie competenze.', 'Difficile', 'Sì, e ho accettato', 'Le domande erano molto tecniche e richiedevano una profonda conoscenza delle tecnologie utilizzate, ad esempio: "Spiega come funziona il protocollo TCP/IP."', 'Ho dato risposte dettagliate alle domande tecniche e ho dimostrato la mia conoscenza approfondita del protocollo TCP/IP.', 'davide.lupo@virgilio.it', 'Network Engineer'),
    (6, 'Colloquio impegnativo ma soddisfacente', '2023-05-15', 'Positiva', 'Il colloquio è stato molto ben organizzato e ho avuto modo di presentare appieno le mie competenze.', 'Facile', 'Sì, ma ho rifiutato', 'Le domande erano mirate a valutare le mie competenze tecniche, ad esempio: "Descrivi un problema complesso che hai risolto utilizzando algoritmi di machine learning."', 'Ho fornito dettagli sulla soluzione del problema complesso utilizzando algoritmi di machine learning e ho illustrato i risultati ottenuti.', 'felicia.rizzo@virgilio.it', 'Data Scientist'),
	(7, 'Esperienza positiva', '2022-05-19', 'Positiva', 'Il colloquio è stato molto ben organizzato e ho avuto modo di presentare appieno le mie competenze.', 'Facile', 'Sì, ma ho rifiutato', 'Le domande erano mirate a valutare le mie competenze tecniche, ad esempio: "Descrivi un problema complesso che hai risolto utilizzando algoritmi di machine learning."', 'Ho fornito dettagli sulla soluzione del problema complesso utilizzando algoritmi di machine learning e ho illustrato i risultati ottenuti.', 'felicia.rizzo@virgilio.it', 'Data Scientist'),
	(8, 'Buona impressione', '2022-05-05', 'Positiva', 'Il colloquio è stato interessante e ho avuto modo di discutere dettagliatamente dei miei progetti.', 'Media', 'Sì, ma ho rifiutato', 'Le domande erano incentrate sulle mie competenze tecniche e sui progetti a cui avevo lavorato, ad esempio: "Descrivi un progetto in cui hai utilizzato una tecnologia di sicurezza informatica e quali sono state le sfide affrontate."', 'Ho fornito una descrizione dettagliata del progetto di sicurezza informatica e ho spiegato come ho affrontato le sfide incontrate.', 'al.mangiola@gmail.com', 'Software Engineer'),
    (9, 'Colloquio ben organizzato e approfondito', '2023-05-13', 'Neutra', 'Il colloquio è stato abbastanza standard e non particolarmente memorabile.', 'Facile', 'No', 'Le domande riguardavano principalmente il mio background accademico e le mie aspirazioni future. Avrei preferito domande più tecniche sulle mie competenze informatiche.', NULL, 'amedeoleone10@gmail.com', 'Project Manager'),
    (10, 'Colloquio standard senza particolari emozioni', '2023-05-17', 'Neutra', 'Il colloquio è stato abbastanza standard senza particolari sorprese.', 'Molto facile', 'No', 'Le domande riguardavano principalmente le mie competenze tecniche e i progetti di ricerca a cui avevo partecipato. Avrei preferito domande più specifiche sui miei progetti di ricerca.', NULL, 'paresci@hotmail.it', 'Cybersecurity Analyst'),
    (11, 'Esperienza positiva', '2023-05-21', 'Positiva', 'Primo colloquio: il solito "raccontaci il tuo percorso" con domande tecniche all''interno per mettere in difficoltà. Suggerisco in caso di riprendersi un manuale di ragioneria e rimettersi a studiare...doveva (almeno pensavo) essere un colloquio conoscitivo invece si è rivelato un colloquio molto tecnico, decisamente inaspettato e ovviamente non ero preparato a sufficienza.', 'Media', 'Sì, e ho accettato', 'Che cos''è un rateo quando si manifesta, esempio in partita doppia', '', 'alessia.romano@outlook.com', 'Web Developer'),
	(12, 'Esperienza positiva come Project Manager', '2018-06-09', 'Positiva', 'Un colloquio ben organizzato che mette in risalto le competenze richieste per il ruolo di Project Manager.', 'Media', 'Sì, e ho accettato', 'Le domande erano incentrate sulle mie esperienze passate nella gestione di progetti complessi e sulle strategie adottate per affrontare sfide specifiche.', 'Ho fornito esempi concreti delle mie esperienze nella gestione di progetti e ho illustrato come ho superato le sfide incontrate.', 'marco.rossi@gmail.com', 'Project Manager');
	
INSERT INTO recensione_esperienza_lavorativa (codice_rl, titolo, data, dipendente_attuale, ultimo_anno_di_lavoro, valutazione_CEO, consiglio_ad_un_amico, pronostico_commerciale_a_6_mesi, valutazione_globale, opportunita_di_carriera, compensi_e_benefit, cultura_e_valori, diversita_e_inclusione, dirigenti_senior, equilibrio_lavoro_vita_privata, vantaggi, svantaggi, consigli_per_i_dirigenti, durata_impiego, mail, ruolo_ricoperto) VALUES
    (1, 'Esperienza positiva', '2022-05-10', true, NULL, 'Approvo', 'Positivo', 'Positivo', 4, 4, 4, 4, 4, 3, 4, 'Ottimo ambiente di lavoro, possibilità di crescita professionale', 'Carichi di lavoro pesanti', 'Continuare a investire nello sviluppo dei dipendenti', 3, 'luca.concilio@hotmail.com', 'Sviluppatore Software'),
    (2, 'Inclusività a scapito dei meriti', '2023-05-03', true, NULL, 'Disapprovo', 'Negativo', 'Neutro', 3, 3, 3, 3, 3, 3, 3, 'Azioni se lavori bene, stipendi decenti, colleghi con molti interessi', 'Vogliono spingere l''inclusività delle donne a tutti i costi per poter dire "abbiamo aumentato il numero di donne in ruoli importanti del 20%". Questo anche se la persona non ha le competenze o non si era nemmeno candidata al ruolo. Si è sentito proprio dire dai manager "avete avvisato lei che la mettiamo in quel ruolo perché vogliono una donna?" Mentre c''erano i colloqui di selezione aperti con nessuna donna che si era candidata compresa quella che è stata messa nel ruolo. C''è poca possibilità di crescita. Non vengono mai dati aumenti ore ai part time ma piuttosto preferiscono assumere nuove persone. E da un anno hanno bloccato anche le assunzioni così tante persone se ne sono andate e siamo rimasti in pochi a dover correre continuamente.', 'Cercate di premiare di più il merito e i risultati che ottiene una persona piuttosto di guardare solo alle donne e ai vostri interessi', 2, 'michele.martino@gmail.com', 'Project Manager'),
    (3, 'Esperienza positiva', '2023-01-15', true, NULL, 'Approvo', 'Positivo', 'Neutro', 4, 4, 3, 4, 4, 4, 3, 'Ottimo team di lavoro, eccellenti opportunità di crescita', 'Nessuno in particolare', 'Migliorare la comunicazione interna', 5, 'sara.ferrari@libero.it', 'Ingegnere Meccanico'),
    (4, 'Perfetta', '2023-06-07', true, NULL, 'Approvo', 'Positivo', 'Positivo', 5, 5, 5, 5, 5, 5, 5, 'Azienda strutturata, ambiente stimolante, orari di lavoro accettabile', 'Per ora nessuno, l’azienda è perfetta cosi', NULL, 1, 'giulia.verdi@yahoo.com', 'Consulente HR'),
    (5, 'Esperienza positiva', '2023-04-02', true, NULL, 'Approvo', 'Positivo', 'Positivo', 4, 4, 4, 4, 4, 4, 4, 'Ambiente di lavoro stimolante, eccellenti opportunità di formazione', 'Pressioni sui tempi di consegna', NULL, 2, 'francesca.gallo@tiscali.it', 'Programmatore Web'),
    (6, 'Esperienza neutra', '2021-12-18', false, 2020, 'Neutro', 'Negativo', 'Neutro', 3, 3, 3, 3, 3, 3, 3, 'Buon equilibrio lavoro-vita privata', 'Mancanza di riconoscimento per il lavoro svolto', NULL, 4, 'felicia.rizzo@virgilio.it', 'Ingegnere del Suono'),
    (7, 'Esperienza positiva', '2022-09-08', true, NULL, 'Approvo', 'Positivo', 'Neutro', 4, 4, 3, 4, 4, 3, 4, 'Ottimi benefit aziendali, possibilità di lavoro da remoto', 'Pochi progressi nella carriera', 'Aumentare le opportunità di crescita interna', 3, 'stefano.mari@gmail.com', 'Analista finanziario'),
    (8, 'Tanta stabilità, poca crescita', '2023-04-27', true, NULL, 'Neutro', 'Negativo', 'Neutro', 3, 2, 3, 4, 2, 2, 2, 'Il vantaggio principale è la stabilità del posto, oltre allo smartworking (finché decidono di mantenerlo) e alla possibilità di accumulare minuti per i permessi', 'Purtroppo si vede poca possibilità di crescita e in alcuni uffici il management lascia un po'' a desiderare, in generale c''è poca organizzazione e comunicazione tra i vari gruppi (il che può essere frustrante). Lo stipendo, rispetto alla difficoltà del lavoro, non è molto adeguato', 'Andrebbe migliorata la comunicazione e l''organizzazionr tra i gruppi. All''ingresso in azienda è difficilissimo trovare una persona disposta ad insegnare il lavoro e a condividere le proprie conoscenze: sarebbe da ottimizzare l''ingresso in azienda, perché imparare il lavoro per tentativi porta via più tempo rispetto che a investire di più nella formazione all''inizio. Infine dovrebbe essere concessa più libertà di iniziativa.', 1, 'paolo.conti@outlook.com', 'Consulente di marketing'),
    (9, 'Esperienza positiva', '2022-07-12', true, NULL, 'Approvo', 'Positivo', 'Positivo', 4, 4, 4, 4, 4, 4, 4, 'Clima aziendale positivo, possibilità di lavorare su progetti interessanti', 'Alta pressione in periodi di picco', NULL, 2, 'chiara.bianco@libero.it', 'Esperto di cybersecurity'),
    (10, 'Esperienza neutra', '2023-05-05', false, 2018, 'Neutro', 'Negativo', 'Neutro', 3, 2, 2, 3, 4, 3, 4, 'Buon ambiente di lavoro, possibilità di flessibilità negli orari', 'Poca chiarezza nell''assegnazione dei compiti', NULL, 1, 'sara.ferrari@libero.it', 'Network Engineer'),
	(11, 'Esperienza lavorativa come Project Manager', '2023-04-09', true, NULL, 'Approvo', 'Positivo', 'Positivo', 3, 4, 5, 4, 3, 5, 5, 'Ambiente di lavoro stimolante e dinamico, possibilità di crescita professionale, ottimi colleghi', 'Carico di lavoro intenso, scarsa comunicazione interna', 'Suggerirei una maggiore trasparenza nella comunicazione da parte dei dirigenti', 5, 'marco.rossi@gmail.com', 'Project Manager');

INSERT INTO recensione_stipendio (codice_rs, titolo, data, giudizio, feedback, importo_stipendio, Paga_bonus, mail, posizione_lavorativa, anni_esperienza, codice_s, ruolo_ricoperto) VALUES
	(1, 'Ottima esperienza stipendiale', '2023-06-01', 'Alto', 'Mi sento soddisfatto del mio stipendio. La remunerazione è davvero competitiva.', 60000, 1000, 'michele.martino@gmail.com', 'Sviluppatore Software', 5, 1, 'Sviluppatore Software'),
	(2, 'Stipendio adeguato', '2023-06-02', 'Giusto', 'Penso che il mio stipendio sia adeguato rispetto alle mie responsabilità.', 48000, 0, 'giulia.verdi@yahoo.com', 'Project Manager', 5, 8, 'Project Manager'),
	(3, 'Buone prospettive economiche', '2023-06-03', 'Giusto', 'Ho ricevuto un aumento di stipendio dopo alcuni anni di lavoro. La mia posizione offre buone prospettive economiche.', 42000, 3000, 'luca.concilio@hotmail.com', 'Analista Finanziario', 4, 13, 'Analista Finanziario'),
	(4, 'Stipendio al di sotto delle aspettative', '2023-06-04', 'Basso', 'Mi aspettavo un salario più alto per il mio ruolo. Non sono soddisfatto del mio stipendio attuale.', 30000, 0, 'sara.ferrari@libero.it', 'Ingegnere Civile', 2, 50, 'Ingegnere Civile'),
	(5, 'Buon stipendio con possibilità di bonus', '2023-06-05', 'Alto', 'Mi piace il mio stipendio e ho la possibilità di ricevere bonus in base alle prestazioni.', 54000, 10000, 'andrea.romano@outlook.com', 'Architetto', 5, 5, 'Architetto'),
	(6, 'Stipendio adeguato al mercato', '2023-06-06', 'Giusto', 'Il mio stipendio è allineato con le medie del settore. Sono soddisfatto delle condizioni economiche.', 45600, 0, 'francesca.gallo@tiscali.it', 'Architetto', 10, 22, 'Architetto'),
	(7, 'Buoni incentivi economici', '2023-06-07', 'Alto', 'Sono molto soddisfatto degli incentivi economici che ricevo nel mio ruolo di Marketing Manager.', 50400, 3000, 'enzo.sessa@alice.it', 'Marketing Manager', 2, 55, 'Marketing Manager'),
	(8, 'Stipendio sufficiente ma potenziale di crescita', '2023-06-08', 'Giusto', 'Il mio stipendio è sufficiente per ora, ma mi aspetto un aumento in futuro dato il mio ruolo di Graphic Designer.', 36000, 0, 'felicia.rizzo@virgilio.it', 'Graphic Designer', 5, 12, 'Graphic Designer'),
	(9, 'Stipendio congruo e buone opportunità', '2023-06-09', 'Giusto', 'Il mio stipendio è congruo rispetto alle mie responsabilità. Ho anche buone opportunità di crescita.', 42000, 500, 'stefano.massera@fastwebnet.it', 'Infermiere', 2, 21, 'Infermiere'),
	(10, 'Stipendio adeguato al ruolo', '2023-06-10', 'Giusto', 'Sono soddisfatto del mio stipendio come Consulente Finanziario. È adeguato al ruolo che svolgo.', 45000, 600, 'simona.cucciolo@libero.it', 'Infermiere', 10, 21, 'Infermiere'),
	(11, 'Eccellente politica salariale', '2023-01-01', 'Alto', 'Sono molto soddisfatto dello stipendio offerto. L''azienda premia il mio impegno.', 26000, 4000, 'michele.martino@gmail.com', 'Sviluppatore Software', 3, 1, 'Sviluppatore Software'),
	(12, 'Corretto rapporto stipendio-responsabilità', '2023-02-01', 'Giusto', 'Lo stipendio è adeguato alle competenze richieste per il mio ruolo. Non ho alcuna lamentela in merito.', 30000, 1000, 'giulia.verdi@yahoo.com', 'Project Manager', 5, 2, 'Project Manager'),
	(13, 'Opportunità di miglioramento per la retribuzione', '2023-03-01', 'Basso', 'Lo stipendio potrebbe essere rivisto per renderlo più competitivo rispetto al mercato. Le responsabilità del mio ruolo meritano una maggiore compensazione.', 28000, 3000, 'luca.concilio@hotmail.com', 'Analista Finanziario', 2, 3, 'Analista Finanziario'),
	(14, 'Ottima retribuzione per il carico di lavoro', '2023-06-01', 'Alto', 'Mi sento soddisfatto del mio stipendio. La remunerazione è davvero competitiva.', 60000, 1000, 'michele.martino@gmail.com', 'Sviluppatore Software', 5, 1, 'Sviluppatore Software'),
    (15, 'Stipendio adeguato', '2023-06-02', 'Giusto', 'Penso che il mio stipendio sia adeguato rispetto alle mie responsabilità.', 48000, 0, 'marco.rossi@gmail.com', 'Project Manager', 5, 8, 'Project Manager');
	
INSERT INTO citta (codice_s, comune) VALUES
	(1, 'Cupertino'),
	(2, 'Seattle'),
	(3, 'Redmond'),
	(4, 'Menlo Park'),
	(5, 'Palo Alto'),
	(6, 'Milano'),
	(7, 'Torino'),
	(8, 'Napoli'),
	(9, 'Maranello'),
	(10, 'Boston'),
	(11, 'Seoul'),
	(12, 'Roma'),
	(13, 'San Francisco'),
	(14, 'Monaco di Baviera'),
	(15, 'Firenze');
	
INSERT INTO a_p (ruolo_ricoperto, partita_iva) VALUES
	('Sviluppatore Software', 12345678901),
	('Sviluppatore Software', 98765432109),
	('Sviluppatore Software', 56789012345),
	('Sviluppatore Software', 10987654321),
	('Sviluppatore Software', 98765432108),
	('Project Manager', 12345678901),
	('Project Manager', 98765432109),
	('Project Manager', 56789012345),
	('Project Manager', 98765432100),
	('Project Manager', 86420975319),
	('Analista Finanziario', 12345678901),
	('Analista Finanziario', 98765432109),
	('Analista Finanziario', 56789012345),
	('Analista Finanziario', 10987654321),
	('Analista Finanziario', 12345678902),
	('Ingegnere Civile', 98765432109),
	('Ingegnere Civile', 13579246803),
	('Ingegnere Civile', 98765432108),
	('Architetto', 10987654321),
	('Architetto', 13579246803),
	('Architetto', 12345678902),
	('Avvocato', 98765432109),
	('Avvocato', 56789012345),
	('Avvocato', 86420975319),
	('Marketing Manager', 12345678901),
	('Marketing Manager', 98765432109),
	('Marketing Manager', 12345678902),
	('Graphic Designer', 56789012345),
	('Graphic Designer', 10987654321),
	('Graphic Designer', 98765432108),
	('Infermiere', 12345678901),
	('Infermiere', 10987654321),
	('Infermiere', 86420975318),
	('Consulente Finanziario', 12345678901),
	('Consulente Finanziario', 98765432109),
	('Consulente Finanziario', 98765432108),
	('Ingegnere Meccanico', 98765432100),
	('Consulente HR', 12345678901),
	('Consulente HR', 98765432109),
	('Consulente HR', 86420975318),
	('Programmatore Web', 12345678901),
	('Programmatore Web', 98765432109),
	('Programmatore Web', 56789012345),
	('Programmatore Web', 10987654321),
	('Programmatore Web', 98765432108),
	('Ethical Hacker', 12345678901),
	('Ethical Hacker', 98765432109),
	('Ethical Hacker', 24680135792),
	('Data Scientist', 56789012345),
	('Data Scientist', 12345678902),
	('Data Scientist', 24680135792),
	('Amministratore di sistema', 12345678901),
	('Amministratore di sistema', 56789012345),
	('Amministratore di sistema', 4681357902),
	('Amministratore di sistema', 12345678902),
	('Amministratore di sistema', 24680135792),
    ('Architetto del software', 12345678901),
	('Architetto del software', 4681357902),
	('Architetto del software', 24681357903),
    ('Consulente di marketing', 98765432109),
	('Consulente di marketing', 56789012345),
	('Consulente di marketing', 24680135792),
    ('Data analyst', 12345678901),
	('Data analyst', 4681357902),
	('Data analyst', 24680135792),
    ('Designer UX/UI', 12345678901),
	('Designer UX/UI', 13579246802),
	('Designer UX/UI', 24680135792),
    ('Direttore delle risorse umane', 12345678901),
	('Direttore delle risorse umane', 98765432109),
	('Direttore delle risorse umane', 4681357902),
	('Direttore delle risorse umane', 12345678902),
	('Direttore delle risorse umane', 24680135792),
    ('Esperto di cybersecurity', 12345678901),
	('Esperto di cybersecurity', 98765432109),
	('Esperto di cybersecurity', 56789012345),
	('Esperto di cybersecurity', 24680135792),
	('Esperto di cybersecurity', 98765432108),
    ('Ingegnere del software', 12345678901),
	('Ingegnere del software', 98765432109),
	('Ingegnere del software', 56789012345),
	('Ingegnere del software', 4681357902),
	('Ingegnere del software', 24680135792),
    ('Responsabile del servizio clienti', 12345678901),
	('Responsabile del servizio clienti', 12345678902),
	('Responsabile del servizio clienti', 98765432109),
	('Web Developer', 12345678901),
	('Web Developer', 98765432109),
	('Web Developer', 24680135792),
	('Network Engineer', 12345678901),
	('Network Engineer', 98765432109),
	('Network Engineer', 24681357902),
	('Software Engineer', 12345678901),
	('Software Engineer', 98765432109),
	('Software Engineer', 24681357902),
	('Cybersecurity Analyst', 12345678901),
	('Cybersecurity Analyst', 98765432109),
	('Cybersecurity Analyst', 56789012345);

	