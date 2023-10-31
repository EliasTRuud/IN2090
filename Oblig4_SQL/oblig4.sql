-- Eksempler: https://www.uio.no/studier/emner/matnat/ifi/IN2090/h23/ukesoppgaver/uke09_lf.html

-- Opg 1: 
-- Skriv derfor en spørring som finner navn på alle skuespillere og rollen de spiller 
-- i filmen med tittelen 'Star Wars'. (108rader)
SELECT DISTINCT p.firstname || ' ' || p.lastname AS name,
    fc.filmcharacter
FROM film as f
    JOIN filmparticipation fp USING (filmid)
    JOIN person p USING (personid)
    JOIN filmcharacter fc USING (partid)
WHERE f.title = 'Star Wars'
    AND fp.parttype = 'cast';


-- Opg 2:
-- Skriv derfor en spørring som finner antall filmer som er laget i hver land.
-- Sorter resultatet fra høyest til lavest antall. (190 rader)
SELECT fc.country, count(*) ant
FROM filmcountry AS fc
GROUP BY fc.country
ORDER BY ant DESC;


-- Opg 3:
-- Skriv en spørring som finner gjennomsnittlig kjøretid for filmer per land
-- (hvor country ikke er NULL), men hvor vi kun ønsker å ta med de landene
-- hvor vi har minst 200 kjøretider (i minutter som beskrevet over). (44 rader)
SELECT country,
    ROUND(AVG(CAST(r.time AS integer)), 3) AS average_time -- had to cast to integer or i would have error
FROM runningtime r
WHERE country IS NOT NULL
    AND time ~ '^\d+$'
GROUP BY r.country
HAVING count(r.time) > 200
ORDER BY average_time DESC;


-- Opg 4:country
-- Så skriv en SQL-spørring som finner de 10 kinofilmene med flest sjangre
-- (kinofilmer har 'C' i filmitem.filmtype-kolonnen). Dersom det er filmer
-- med like mange sjangre, velg dem som kommer alfabetisk først. (10 rader)
SELECT f.title,
    count(fg.genre) as antSjangre
FROM filmgenre fg
    JOIN filmitem fi USING (filmid)
    JOIN film f USING (filmid)
WHERE fi.filmtype = 'C'
GROUP BY f.filmid,
    f.title
ORDER BY antSjangre DESC,
    f.title
LIMIT 10;


-- Opg 5:
-- Skriv en spørring som for hvert land finner totalt antall filmer laget i det
-- landet, gjennomsnittlig rating for disse filmene, og sjangeren som er vanligst
-- for landets filmer. (170-190 rader, avhengig av antagelser)

--  (flere delspørringer, hvor hver delspørring finner hver sin ting om landene. Atså, skriv
-- en spørring som finner antall filmer, en som finner gjenomsnittlig rating, og
-- en som finner den mest populære sjangeren, og så forsøk å kombiner disse
-- resultatene til slutt.)
WITH filmsPerCountry AS (
    SELECT country,
        count(*) as filmsPerCountry
    FROM filmcountry fc
    GROUP BY fc.country
),
rating AS (
    SELECT fc.country,
        AVG(fr.rank) as avgRank
    FROM filmrating fr
        JOIN filmcountry fc USING (filmid)
    GROUP BY fc.country
),
popGenre AS (
    SELECT fc.country,
        max(fg.genre) as mostPopGenre
    FROM filmgenre fg
        JOIN filmcountry fc USING (filmid)
    GROUP BY fc.country
)
SELECT *
FROM filmsPerCountry
    JOIN rating USING (country)
    JOIN popGenre USING (country)
ORDER BY avgrank DESC;


-- Opg 6:
-- Skriv derfor en SQL-spørring som finner navnene på alle par av land som
-- har laget mer enn 150 filmer sammen (i henhold til filmcountry-tabellen).
-- Merk: Hvert par av land skal bare forekomme én gang i resultatet. (40 rader)
SELECT DISTINCT fc1.country,
    fc2.country,
    count(*) as films
FROM filmcountry fc1
    JOIN filmcountry fc2 USING (filmid)
WHERE fc1.country < fc2.country
GROUP BY fc1.country,
    fc2.country
HAVING count(*) > 150
ORDER BY films DESC;


-- Opg 7:
-- Skriv derfor en spørring som finner navn og produksjonsår på alle filmer
-- som har en tittel som inneholder minst ett av ordene 'Dark' og 'Night',
-- og som er grøsser (har sjanger horror) eller er fra Romaina (eller evt. begge).
-- Resultatet skal ikke inneholde duplikater. (457 rader)
-- Merk: Det kan finnes filmer fra 'Romania' som ikke har noen sjanger
-- (altså ikke forekommer i filmgenre-tabellen) og 'horror'-filmer som ikke
-- har noe land (altså ikke er oppført i filmcountry).
SELECT DISTINCT f.title,
    f.prodyear
FROM film f
    JOIN filmgenre fg USING (filmid)
    LEFT JOIN filmcountry fc USING (filmid)
WHERE (
        title LIKE '%Dark%'
        OR title LIKE '%Night%'
    )
    AND (
        fg.genre = 'Horror'
        OR fc.country = 'Romania'
    );


-- Opg 8:
-- Skriv derfor en spørring som finner tittel og antall deltakere til alle filmer
-- laget i 2010 eller senere, og som kun har 2 eller færre deltakere (i henhold
-- til filmparticipation-tabellen, uansett rolle). (28 rader).
SELECT f.title,
    count(parttype) AS deltakere
FROM film as f
    LEFT OUTER JOIN filmparticipation fp USING (filmid) --outer join, cause some might have 0 deltakere but parttype is not null in filparticip
WHERE f.prodyear > 2009
GROUP BY f.filmid,
    f.title
HAVING count(parttype) < 3
ORDER BY f.title;


-- Opg 9:
-- Skriv derfor en spørring som finner antall filmer som hverken har sjanger
-- 'Sci-Fi' eller 'Horror'. (1 rad)
SELECT count(*)
FROM filmgenre
WHERE genre != 'Sci-Fi' AND genre != 'Horror';


-- Opg 10:
-- utvalg av de mest interessante filmene, for å dekke bredden innen film.
-- De definerer en interessant film som en kinofilm som både har høyere rank enn 8 og har mer enn 1000 votes
-- • De 10 som har høyest rank og votes (altså om de har lik rank, så velg de som har høyest votes).
-- • De filmene som Harrison Ford er skuespiller i.
-- • De filmene som har sjanger 'Comedy' eller 'Romance'.
-- Du får derfor i oppgave å lage en spørring som finner tittel på de utvalgte
-- filmene beskrevet over. (170 rader)

--Her er det lurt å bryte spørringen opp i delspørringer i en WITHklausul. 
--Start med å først finne filmid til alle interessante filmer, og så skriv
--delspørringer som gjør uttrekk fra disse i henhold til listen over (altså skriv en
--delspørring som finner filmid til de 10 høyest rangerte interessante filmene,
--så en annen delspørring som finner filmid til de interessante filmene med
--Harrison Ford som skuespiller, og så en delspørring som finner filmid til
--de interessante filmene som har sjanger 'Comedy' eller 'Romance') og så
--kombiner alle disse filmid’ene med passende mengdeoperasjon, og til slutt
--hent ut tittel på filmene.

WITH interesting_films AS (
    SELECT filmid, rank, votes
    FROM filmrating JOIN filmitem USING (filmid)
    WHERE rank >= 8
        AND votes >= 1000
        AND filmtype = 'C'
),
top10 AS (
    SELECT filmid
    FROM interesting_films f 
    ORDER BY rank DESC,
        f.votes DESC
    LIMIT 10
),
ford_films AS (
    SELECT f.filmid
    FROM interesting_films f JOIN filmparticipation fp USING (filmid) JOIN person p USING (personid)
    WHERE p.firstname = 'Harrison' AND p.lastname = 'Ford'
),
romance_and_comedy AS (
    SELECT fg.filmid
    FROM filmgenre fg JOIN interesting_films USING (filmid)
    WHERE fg.genre = 'Comedy' OR fg.genre = 'Romance'
)
SELECT f.title
FROM (
    SELECT top10.filmid
    FROM top10
    UNION
    SELECT ford_films.filmid
    FROM ford_films
    UNION
    SELECT rac.filmid
    FROM romance_and_comedy rac
) AS films JOIN film f USING (filmid)
ORDER BY f.title;


