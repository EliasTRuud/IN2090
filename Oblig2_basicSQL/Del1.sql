--Oblig 2 - Enkel SQL

--Del : Setup & Queries
/*
 1. SSH til uio
 2. psql -h dbpg-ifi-kurs03 -U arneet -d arneet
 
 (Her er planeter.sql dataen puttet inn. \d display tables. Lastet inn i pc/downloads)
 masse: relativt til solen, 1 = solmasse
 stjerne.avstand: avstand fra solen til stjernen i parsecs
 planet.oppdaget: årstall oppdaget, int
 
 Stjerne(navn, [avstand], [masse]) #avstand - avstand fra solen
 KN/PN: {navn}
 
 Planet(navn, [masse], [oppdaget], [stjerne])
 PN: {navn}
 FN: (stjerne) -> Stjerne(navn)
 
 Materie(planet, molekyl)
 PN: {planet, molekyl}
 FN: (planet) -> Planet(navn)
 */
;
--Opg 2
--a)  Navn på alle planeter som går i bane rundt stjernen med navn Proxima Centauri.
SELECT navn
FROM planet
WHERE stjerne = 'Proxima Centauri';

--b) Hvilke årstall (uten duplikater) det ble oppdaget planeter i bane 
--   rundt stjernene med navn TRAPPIST-1 og Kepler-154.
SELECT DISTINCT oppdaget
FROM planet
WHERE stjerne = 'TRAPPIST-1'
    OR stjerne = 'Kepler-154';

--c)  Antall planeter det er som ikke har oppgitt en masse (altså hvor masse er NULL).
SELECT COUNT(*)
FROM planet
WHERE masse IS NULL;

--d)  Navn og masse på alle planeter oppdaget i 2020 med masse høyere enn 
--    gjennomsnittet av massen til alle planeter.
SELECT navn,
    masse
FROM planet
WHERE oppdaget = 2020
    AND masse > (
        SELECT avg(masse) --avg masse = 6.483 
        FROM planet
    ); 

--e) Antall år mellom første og siste oppdagede planet i planet-tabellen.
SELECT max(oppdaget) - min(oppdaget)
FROM planet;


--Opg 3
/*
De har ulike modeller som baserer seg på ulik informasjon, og din jobb blir å finne 
lister med planeter som passer hver modell. 
Resultatene fra spørringene du skriver trenger ikke ha overlappende svar.

*/;

--a) masse mellom 3 og 10. 
--   Må ha molekyl = vann/H2O.
--   Skriv derfor en spørring som finner navn på alle planeter som passer denne informasjonen.
SELECT navn
FROM materie m
    INNER JOIN planet p ON m.planet = p.navn
WHERE m.molekyl = 'H2O' AND p.masse BETWEEN 3 AND 10;

--b) stjerne.avstand < stjerne.masse * 12
--   inneholder materie.molekyl = 'H'
SELECT p.navn AS planet_navn
FROM materie m
    INNER JOIN planet p ON m.planet = p.navn
    INNER JOIN stjerne s ON p.stjerne = s.navn
WHERE s.avstand < s.masse * 12 AND m.molekyl = 'H';

--c) Isteden for stjerne, kan vi bruke to massive planeter for akselerasjon
--   kan ha reist fra en av to planeter fra samme solsystem, begge med masse større 
--   enn 10, gitt at avstanden til deres solsystem er mindre enn 50
--   stjerne.avstand < 50
--   TWO planets med planet.masse > 10

/*
--En måte å liste opp alle stjerner med minst 1 planet
SELECT s.navn AS stjerne_navn, p.navn AS planet_navn, p.masse
FROM planet p
    INNER JOIN stjerne s ON p.stjerne = s.navn
WHERE s.avstand < 50 AND p.masse > 10
ORDER BY s.navn, p.masse DESC;
*/;

--For å kreve mer enn 1, bruker GROUP BY sammen med count for å gruppere 
-- entries med samme stjernenavn. Deretter krever at telte duplikater av s.navn > 1.
SELECT s.navn --, count(s.navn)
FROM planet p
    INNER JOIN stjerne s ON p.stjerne = s.navn
WHERE s.avstand < 50 AND p.masse > 10
GROUP BY s.navn 
HAVING count(s.navn) > 1; --count(s.navn), teller ant samme stjerne_navn opptrer i tabellen


--Opg 4
-- Siden vi har joinet planet og stjerne, vil avstand være fra stjernetabellen.
-- stjerne.avstand referer til avstanden fra stjernen til vår sol, ikke avstand mellom planeten og stjernen
SELECT oppdaget
FROM planet
    NATURAL JOIN stjerne
WHERE avstand > 8000;



--DEL 2: Lage og INSERT i tables 

--Opg 5
/*
Legg til jorda(planet) og sola(stjerne) inn i de relevante tabellene
Bruker: INSERT INTO table VALUES ('value1', 'value2', ...)

 Stjerne(navn, [avstand], [masse])
 Planet(navn, [masse], [oppdaget], [stjerne])

a) Setter inn Sola i stjerne-tabellen, med navn lik Sola, avstand lik 0og masse lik 1.
b) ) Setter inn Jorda i planet-tabellen, med navn lik Jorda, masse lik 0.003146, oppdaget lik NULL, og stjerne lik Sola.
*/;

--Insert sola inn i stjernetabellen
INSERT INTO stjerne VALUES ('Sola', '0', '1');

--Insert jorda inn i planet, referer til Sola ved å skrive dets navn verdi: 'Sola'
INSERT INTO planet VALUES ('Jorda', 0.003146, NULL, 'Sola');


--Opg 6
/*
Ny tabell: observasjon
- observasjons_id(int) , NOT NULL, 
- tidspunkt(TIMESTAMP), NOT NULL, 
- (planet) -> Planet(navn), FOREIGN KEY
- kommentar(str), no constraint

observasjons_id brukes som Primary Key

https://www.sqlines.com/postgresql/datatypes/serial 
SERIAL - SERIAL data type allows you to automatically generate unique integer numbers 
         (IDs, identity, auto-increment, sequence) for a column.
*/;

CREATE TABLE observasjon (
    observasjons_id SERIAL PRIMARY KEY, --if not SERIAL, specify type(int)
    tidspunkt TIMESTAMP NOT NULL,
    planet VARCHAR(255) NOT NULL REFERENCES planet(navn),
    kommentar text 
);
/*
id=DEFAULT gir automatisk id. 
INSERT INTO observasjon 
VALUES(DEFAULT, '2017-07-23', 'Jorda', 'veldig kult!'); 

eller så kan vi skrive:
INSERT INTO observasjon (tidspunkt, planet, kommentar)
VALUES('2017-07-23', 'Jorda', 'veldig kult!'); 

*/
