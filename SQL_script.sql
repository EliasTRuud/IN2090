--Eksempel, laste inn data fra CSV i psql:

1. Åpne et terminalvindu og skriv følgende kommando for å koble til PostgreSQL med psql:
psql -U brukernavn -d databasenavn

Bytt ut "brukernavn" med ditt PostgreSQL brukernavn.
Bytt ut "databasenavn" med navnet du vil gi til databasen.;

2. Når du er koblet til psql, kan du kjøre SQL-kommandoer for å opprette tabeller og laste inn data, for eksempel:

-- opprett tabell
CREATE TABLE customers (id SERIAL PRIMARY KEY, name TEXT, age INT);

-- last inn data fra en CSV-fil
COPY customers (name, age) FROM '/sti/til/filen.csv' DELIMITER ',' CSV HEADER;

Endre "customers" til ønsket tabellnavn.
Bytt ut "/sti/til/filen.csv" med banen til den faktiske CSV-filen du vil laste inn.


3.Når du er ferdig med å kjøre SQL-kommandoer, kan du avslutte psql ved å skrive:
\q
Dette vil avslutte psql-sesjonen og ta deg tilbake til terminalen.;


-- For å kjøre skript kan kjøre:
\i /sti/til/create_database.sql


-- Dumps, sikkerhetskopi
En database-sikkerhetskopi eller "dump" kan opprettes ved hjelp av pg_dump-verktøyet i psql. 
En dumpfil kan inneholde SQL-kommandoer som kan brukes til å gjenopprette en database til 
sitt nåværende tilstand, inkludert tabeller, data, visninger, indekser, funksjoner og mye mer.

For å opprette en dumpfil i psql, kan du bruke følgende kommando:
pg_dump -U brukernavn -d databasenavn -f dumpfil.sql
eller 
pg_dump [flag] db > filnavn

Når kommandoen er kjørt, vil psql opprette en dumpfil som inneholder SQL-kommandoer for å gjenopprette databasen og dens objekter.

Dumpfilen kan senere brukes til å gjenopprette databasen ved hjelp av psql ved hjelp av kommandoen:
psql -U brukernavn -d databasenavn -f dumpfil.sql