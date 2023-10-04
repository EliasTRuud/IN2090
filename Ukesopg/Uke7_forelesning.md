# 07 – Eksempler: Databasedesign og normalformer

## Oppgave 1

Gitt følgende relasjon:

- Person(personnr, navn, initialer, fødselsdato, alder)

med FDene:
- personnr → navn, fødselsdato
- navn → initialer
- fødselsdato → alder

### Opg 
1. Finn tillukningene til: 
navn+ = navn, initialer
personnr+ = personnr, fødselsdato, navn, initialer, alder

2. Finn alle kandidatnøklene til Person 
KN: {personnr}


## Oppgave 2
Finn kandidatnøklene til relasjonen
- Produkt(produktID, navn, kategori, pris, butikkID, butikknavn, butikktype, adresse, postnr, poststed)

med FDene:
- produktID → navn, kategori, pris
- navn, kategori → produktID
- butikkID → butikknavn, butikktype, adresse, postnr
- postnr → poststed

Finn alle kandidatnøklene til Produkt:
Ikke på høyreside: butikkID
Kun på høyreside: poststed, butikknavn, butikktype, adresse
KN: {butikkID, produktID} ,{butikkID, navn, kategori}


## Oppgave 3
Gitt relasjonen R(A, B, C, D, E, F, G) 
med FDene 
AB → DE
C → A 
BD → E 
AE → BF

Finn alle nøkler.
Ikke på høyreside: C, G, 
Kun på høyreside: F
KN: {C, G, B}, {C, G, E}