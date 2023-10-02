
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

1. NK → F G
2. NKL → P B
3. A → L
4. F GL → K
*/

-- a) tillukningen til A
Alt som vi kan utlede fra A: L

-- b) tillukningen til NKA
F, G, L, P, B, K  (altså alt sammen)

-- c) alle kandidatnøkler
N, K, A blir en kandidatnøkkel, sannsynligvis også primær.