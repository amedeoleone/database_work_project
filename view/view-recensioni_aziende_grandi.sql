CREATE VIEW recensioni_aziende_grandi AS

SELECT DISTINCT ON (azienda.nome)

azienda. nome AS nome_azienda, azienda.settore, azienda. valutazione_globale,

stipendio.stipendio_totale_medio AS stipendio_max

FROM azienda

JOIN sede ON azienda.partita_iva = sede.partita_iva

JOIN stipendio ON sede.codice_s = stipendio.codice_s

WHERE azienda.num_dipendenti >= 10000

ORDER BY azienda. nome, stipendio.stipendio_totale_medio DESC;

