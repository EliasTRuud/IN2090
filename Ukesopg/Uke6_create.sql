-- https://www.uio.no/studier/emner/matnat/ifi/IN2090/h23/ukesoppgaver/uke06.html

/*
En ting vi gjerne ønsker å ha lagret i en database, er informasjon om et firmas kunder, prosjekter og ansatte. I denne oppgaven har vi et relasjonsdatabaseskjema for slike data, som ser slik ut:

Kunde(kundenummer, kundenavn, [kundeadresse], [postnr], [poststed])
Prosjekt(prosjektnummer, [prosjektleder], prosjektnavn, [kundenummer], [status])
Ansatt(ansattnr, navn, [fødselsdato], [ansattDato])
AnsattDeltarIProsjekt(ansattnr, prosjektnr)
I relasjonene er det som står før parentesen relasjonsnavnet, de kommaseparerte ordene er relasjonensattributter, mens primærnøklene er som følger:

Kunde(kundenummer)
Prosjekt(prosjektnummer)
Ansatt(ansattnr)
AnsattDeltarIProsjekt(ansattnr, prosjektnr)
Attributter som står i [klammeparentes], er attributter som kan inneholde NULL.


Relasjonene har følgende fremmednøkler:

Prosjekt(kundenummer) → Kunde(kundenummer)
AnsattDeltarIProsjekt(prosjektnr) → Prosjekt(prosjektnummer)
Prosjekt(prosjektleder) → Ansatt(ansattnr)
AnsattDeltarIProsjekt(ansattnr) → Ansatt(ansattnr)

*/;

BEGIN;
DROP SCHEMA IF EXISTS uke6 CASCADE;
CREATE SCHEMA uke6;

DROP TABLE IF EXISTS uke6.kunde CASCADE;
DROP TABLE IF EXISTS uke6.prosjekt CASCADE;
DROP TABLE IF EXISTS uke6.ansatt CASCADE;
DROP TABLE IF EXISTS uke6.ansattdeltariprosjekt CASCADE;

CREATE TABLE uke6.kunde (
  kundenummer INT PRIMARY KEY,
  kundenavn text NOT NULL,
  kundeadresse text,
  postnr VARCHAR(4),
  poststed text
);

CREATE TABLE uke6.ansatt (
  ansattnr INT PRIMARY KEY,
  navn text NOT NULL,
  fødselsdato DATE,
  ansattDato DATE
);

CREATE TABLE uke6.prosjekt (
  prosjektnummer INT PRIMARY KEY,
  prosjektleder INT,
  prosjektnavn text,
  kundenummer INT,
  status text,
  FOREIGN KEY (kundenummer) REFERENCES uke6.kunde(kundenummer) ON DELETE CASCADE,
  FOREIGN KEY (prosjektleder) REFERENCES uke6.ansatt(ansattnr) ON DELETE CASCADE
);

CREATE TABLE uke6.ansattdeltariprosjekt (
  ansattnr INT,
  prosjektnr INT,
  PRIMARY KEY (ansattnr, prosjektnr),
  FOREIGN KEY (ansattnr) REFERENCES uke6.ansatt(ansattnr) ON DELETE CASCADE,
  FOREIGN KEY (prosjektnr) REFERENCES uke6.prosjekt(prosjektnummer) ON DELETE CASCADE
);

INSERT INTO uke6.kunde (
    kundenummer,
    kundenavn,
    kundeadresse,
    postnr,
    poststed
  )
VALUES (
    1,
    'Acme Corporation',
    'Gatenavn 1',
    '1234',
    'Oslo'
  ),
  (2, 'Beta Business', 'Gatenavn 2', '5678', 'Bergen'),
  (3, 'Charlie Inc.', 'Gatenavn 3', '9012', 'Oslo');

INSERT INTO uke6.ansatt (ansattnr, navn, fødselsdato, ansattDato)
VALUES (1, 'Alice Andersson', '1990-01-01', '2020-01-01'),
  (2, 'Bob Berg', '1995-05-05', '1986-05-05'),
  (3, 'Carol Carlsson', '2000-10-10', '2022-10-10'),
  (4, 'Allan Atkins', '1992-06-16', '2017-11-18'),
  (5, 'Makayla Mccarthy', '1998-07-04', '2019-07-30'),
  (6, 'Ayana Atkinson', '1995-09-24', '2018-04-01'),
  (7, 'Julius Jonas', '1978-10-15', '2002-08-07'),
  (8, 'Anthony Alford', '1983-03-10', '2014-02-10'),
  (9, 'Isla Ireland', '1999-05-12', '2019-03-05'),
  (10, 'Curtis Crawford', '1991-11-03', '2017-02-15');

INSERT INTO uke6.prosjekt (
    prosjektnummer,
    prosjektleder,
    prosjektnavn,
    kundenummer,
    status
  )
VALUES (1, 1, 'Lag ny nettside', 1, 'I gang'),
  (2, 10, 'Bygg ny fabrikk', 1, 'Fullført'),
  (3, 3, 'Utvid butikklokaler', 2, 'Planlagt'),
  (4, 8, 'Lag ny nettside', 2, 'I gang'),
  (5, 4, 'Reparasjon av taklekkasje', 3, 'Fullført');

INSERT INTO uke6.ansattdeltariprosjekt(ansattnr, prosjektnr)
VALUES (2, 1),
  (7, 3),
  (9, 3);

COMMIT;


/*
-- Update a row
UPDATE ansatt
SET navn ='Bob Berger' 
WHERE ansattnr = 2;

-- Delete a row, since ON DELETE CASCADE, whatever referenced ansatt nr 1 will also be deleted.
DELETE FROM ansatt
WHERE ansattnr = 1;

*/