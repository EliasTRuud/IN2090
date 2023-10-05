
--DEL 1


-- Opg 1

MAnsatte(navn, født, personnr, lønn, stilling, fareT, hemmeligT, skummeltT, alder)
De har forstått at de da trenger å vite hvilke funksjonelle avhengigheter som gjelder for sine data;


-- a)  Når en ansatt er født bestemmer naturligvis alderen til den ansatte.
født -> alder

-- b)  Kombinasjonen av født og personnr utgjør en persons fødselsnummer og er derfor unikt for alle ansatte.
født, personnr -> fødselsnummer ? kandidatnøkkel;

-- c) 
/*
lønn er bestemt av personnens stilling, samt en rekke mulige tillegg
avhengig av arbeidsoppgaver. Disse tilleggene er beskrevet i kolonnene
som slutter med T og er bare en boolsk verdi (sann/usann) avhengig
av om man får det tillegget eller ikke (f.eks. dersom arbeidsoppgavene
er farligere enn vanlig kontorarbeid vil man kunne få et faretillegg og
da vil fareT være sann; dersom man jobber med hemmelige ting vil
man få et tillegg for dette og da vil hemmeligT være sann; og om man
jobber med skumle ting (romvesner, spøkelser, el.) vil man få et tillegg
for dette og skummeltT vil være sann). */

stilling, fareT, hemmeligT, skummeltT -> lønn
;

-- d)
/*
Det er kun en gitt mengde stillinger som kan ende opp med å måtte
jobbe med skumle ting, og det er kun når disse stillingene også jobber
med farlige ting. Altså, hvis du gir meg en stilling og hvorvidt personen
jobber med noe farlig, så kan jeg si deg om personen jobber med noe skummelt.
*/
stilling, fareT -> skummeltT
;

Totalt:
født -> alder
født, personnr -> fødselsnummer 
stilling, fareT, hemmeligT, skummeltT -> lønn
stilling, fareT -> skummeltT
;

-- Opg 2
/*

Utstyr(navn, kategori, pris, farlighetsgrad, gradering, leverandør, adresseLeverandør, beholdning)

De har da altså funnet følgende funksjonelle avhengigheter:
1. navn, kategori → farlighetsgrad, gradering
2. navn, kategori, leverandør → pris, beholdning
3. adresseLeverandør → leverandør
4. farlighetsgrad, gradering, leverandør → kategori

Dersom vi bruker forbokstavene til attributtene over, kan relasjonen skrives:
Utstyr(N, K, P, F, G, L, A, B)
og de funksjonelle avhengighetene kan skrives litt kortere slik:
*/
1. N, K → F G
2. N, K, L → P B
3. A → L
4. F, G, L → K


-- a) tillukningen til A
Alt som vi kan utlede fra 
A+ = A, L

-- b) tillukningen til NKA
NKA+ = N, K, A, F, G, L, P, B  (altså alt sammen)

-- c) alle kandidatnøkler
N, K, A 
N, F, G, A
;



--Del 2

-- Oppgave 3 – Normalformer
AgenterPåOppdrag(agentId, navn, initialer, født, oppdragsNavn, varighet, lokasjon)

FD:
1. agentId → navn, født
2. navn, født → agentId
3. navn → initaler
4. oppdragNavn → varighet, lokasjon

Kandidatnøklene
• {agentId, oppdragsNavn}
• {navn, født, oppdragsNavn}

-- a) Forklar derfor, med et par setninger, hva normalformer er.
A -> B
De ulike normalformene beskriver hvordan de ulike attributtene relateres og
avhengig av hvilken form vil det være regler på hvilke attributter som har lov
til å være på venstre eller høyre side av de funksjonelle avhengighetene. 
Høyere grader av normalformer eliminerer anomolier, men øker kompleksitet/ant tabeller.

-- b) Vis dem hvordan du finner normalformen på relasjonen AgenterPåOppdrag.
bestem normalform




-- Oppgave 4 - Tapsfri dekomposisjon
R(A, B, C, D, E, F)

FDer:
1. A → BC
2. BC → A
3. D → E
4. AD → F
5. E → F

Kandidatnøkler: 
{A, D} 
{B, C, D}

-- Gjør om relasjonen (1NF) slik at det opfyller BCNF

FD 1: A -> BC (3NF)
Brudd på BCNF, siden A ikke er en nøkkel.
Ikke brudd på 3NF, siden BC er del av nøkkel. 
Beregner A+ = ABC -> S1(A,B, C), S2(A, D, E, F)

Bestem nøkler og sjekk igjen om BCNF for S1 og S2.

----------------------------------------
S1(A, B, C) , KN: {A}, {B,C}
FD 1 og 2: 
1. A -> BC
2. BC -> A

Begge oppfyller BCNF siden A og BC er supernøkler.

----------------------------------------
S2(A, D, E, F), KN: {A, D}
FD 3, 4, 5:
3. D → E
4. AD → F
5. E → F

FD 4 oppfyller BCNF.

FD 3 oppfyller ikke BCNF:
D+ = D, E -> S21(D, E), S22(D, A, F)

----------------------------------------
S21(D, E), KN: {D}
FD 3:
3. D -> E

Nå vil FD 3 oppfylle BCNF.

----------------------------------------
S22(D, A, F), KN: {A, D}
FD 4 og 5:
4. AD → F

FD 4 oppfyller BCNF.

----------------------------------------

For FD 5, blir det borte når vi kemponerer.

S1, S21, S22.









