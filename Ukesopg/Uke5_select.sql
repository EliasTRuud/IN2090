-- Opg 3 , setninger med ulike type JOIN
;
-- 1. Alle sjangere (eng.: genres) til filmen ‘Pirates of the Caribbean: 
--                                             The Legend of Jack Sparrow’ (5)
SELECT f.title,
    fg.genre
FROM film AS f
    INNER JOIN filmgenre AS fg ON f.filmid = fg.filmid
WHERE f.title = 'Pirates of the Caribbean: The Legend of Jack Sparrow';

-- 2. Alle sjangere for filmen med filmid 985057 (9)
SELECT *
FROM film as f
    INNER JOIN filmgenre AS fg ON fg.filmid = f.filmid --kan bruke NATURAL JOIN eller USING(filmid) istedenfor ON siden likt navn
WHERE f.filmid = 985057;

-- 3. Tittel, produksjonsår og filmtype for alle filmer som ble produsert i 1894 (82)
SELECT f.title,
    f.prodyear,
    fi.filmtype
FROM film AS f,
    filmitem as fi
WHERE f.filmid = fi.filmid
    AND f.prodyear = 1894;

-- 4. Alle kvinnelige skuespillere(cast) i filmen med filmid 357076. 
--    Skriv ut navn og på skuespillerene og filmid (11)
SELECT p.lastname,
    fp.filmid
FROM person AS p,
    filmparticipation AS fp
WHERE fp.filmid = 357076
    AND p.gender = 'F'
    AND p.personid = fp.personid
    AND fp.parttype = 'cast';

-- 5. Finn fornavn og etternavn på alle personer som har deltatt i TV-serien South Park. 
--    Bruk tabellene Person, Filmparticipation og Series, og løs det med:
        -- INNER JOIN (21)
        -- Implisitt join (21)
        -- NATURAL JOIN
-- Hvorfor gir NATURAL JOIN ulikt resultat fra INNER JOIN og implisitt join? Forklar.
--a
SELECT p.firstname,
    p.lastname
FROM person AS p
    INNER JOIN filmparticipation AS fp ON p.personid = fp.personid
    INNER JOIN series AS s ON s.seriesid = fp.filmid
WHERE s.maintitle LIKE '%South Park%';

--b
SELECT p.firstname,
    p.lastname
FROM person AS p,
    filmparticipation AS fp,
    series AS s
WHERE s.seriesid = fp.filmid
    AND p.personid = fp.personid
    AND maintitle = 'South Park';

-- c.   NATURAL JOIN
SELECT DISTINCT p.personid, p.lastname, p.firstname, s.maintitle
FROM Person AS p
     NATURAL JOIN Filmparticipation AS fp
     NATURAL JOIN Series AS s
WHERE s.maintitle LIKE 'South Park';

/* d
NATURAL JOIN joiner “automatisk” på attributtene som har samme navn.
Dette fungerer i join-operasjonen mellom tabellen Person og Filmparticipation fordi 
begge har attributtet personid som det joines på. Men mellom Filmparticipation og Series 
er det ingen attributter med felles navn: vi må joine på filmparticipation.filmid 
og series.seriesid, og det går ikke med NATURAL JOIN. 
Vi må derfor bruke en annen join-metode (som i a eller b).
*/;


-- 6. Finn navn på alle skuespillere (cast) i filmen, deres rolle (parttype) i filmen 
--    «Harry Potter and the Goblet of Fire» (vær presis med staving), 
--    få med tittelen til filmen også (90).
SELECT DISTINCT p.firstname,
    p.lastname,
    f.title,
    fp.parttype
FROM person AS p
    INNER JOIN filmparticipation AS fp ON p.personid = fp.personid
    INNER JOIN film AS f ON f.filmid = fp.filmid
WHERE f.title = 'Harry Potter and the Goblet of Fire'
    AND fp.parttype = 'cast';


-- 7. Finn navn på alle skuespillere (cast) i filmen Baile Perfumado (14)

SELECT DISTINCT p.firstname || ' ' || p.lastname AS name
FROM person AS p
    INNER JOIN filmparticipation AS fp ON p.personid = fp.personid
    INNER JOIN film AS f ON f.filmid = fp.filmid
WHERE f.title = 'Baile Perfumado'
    AND fp.parttype = 'cast';


-- 8. Skriv ut tittel og regissør for norske filmer produsert før 1960 (269)
SELECT p.firstname || ' ' || p.lastname AS director ,
    f.title,
    f.prodyear
FROM film AS f
    INNER JOIN filmcountry AS fc ON f.filmid = fc.filmid
    INNER JOIN filmparticipation as fp ON f.filmid = fp.filmid
    INNER JOIN person AS p ON p.personid = fp.personid
WHERE fc.country = 'Norway'
    AND fp.parttype = 'director'
    AND f.prodyear < 1960;