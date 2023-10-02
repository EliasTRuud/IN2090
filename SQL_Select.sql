
VS Code: ssh extension
> ssh: new connection

psql -h dbpg-ifi-kurs03 -U arneet -d databaseNavn
(fdb : filmdatabase)
(Northwind)
skriv inn passord

Åpnes i VS code terminal:;


Edit expression: \e
Open VIM editor: 
Press the letter i on your keyboard to enter INSERT mode in vim
When finished editing the file, press the ESC key. This takes you out of INSERT mode and -- INSERT -- disappears from the bottom left of your terminal.
To save the file, type in a colon (:) followed by wq, :wq
Press the Enter key on your keyboard to proceed.

Clear screen: Ctrl + L

Kjører SELECT setninger her:

Basic psql commands:
List All Databases: “\l”.
Access or Switch a Database: “\c db_name”.
List All Tables: “\dt”.
Describe All Tables: “\d”.
Describe a Specific Table: “\d tab_name”.
List All Schemas: “\dn”.
List All Views: “\dv”.
Execute Previous Command: “\g”.
Quit psql: “\q”.
Save Querys Results to a Specific File: “\o file_name”.
Run psql Commands/queries From a Particular File: “\i file_name”.

https://www.commandprompt.com/education/postgresql-basic-psql-commands/ 
;

SQL commands:

Order in syntax:
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT

--------------------------------------------------
LIKE statement to find strings:

SELECT attributes
FROM table
WHERE condition
LIKE '%string_to_search%';

'%end_of_string'
'%anywhere%'
'start%'

------------------------------------
SELECT:

Kan lage nye kolonner eller manipulere: f.eks
Bruk AS for å gi nytt navn til kolonnen
SELECT unit_price * 8 AS unit_price_NOK
FROM products;

Samle to kolonner med et blank space mellom:
SELECT contact_title || " " || contact_name AS contact_person
FROM customers;

Fjerne duplikater ved å bruke DISTINCT:
SELECT DISTINCT contact_title
FROM customers
WHERE contact_title LIKE '%Manager%';

Aggregering: sum, avg, max, min, count. Kan seprare flere aggregeringer med komma
SELECT sum(units_in_stock) AS total_nr_products
FROM products;

f.eks finn ant produkter som koster mer enn 20 dollar: (duplikater blir telt)
SELECT count(*) AS nr_expensive_products
FROM products
WHERE unit_price > 20;

Flere INNER JOIN: Finn ut hvilke drikkevarer som er kjøpt og av hvem [404 rader]
SELECT p.product_name , u. company_name
FROM categories AS c
    INNER JOIN products AS p ON (c. category_id = p. category_id )
    INNER JOIN order_details AS d ON (p. product_id = d. product_id )
    INNER JOIN orders AS o ON (d.order_id = o.order_id)
    INNER JOIN customers AS u ON (u. customer_id = o. customer_id )
WHERE c. category_name = 'Beverages ';

Self-joins: Finn navn og pris på alle produkter som er dyrere enn produktet Laptop 2.5GHz?
SELECT P2.Name , P2.Price
FROM Product AS P1 , Product AS P2
WHERE P1.Name = 'Laptop 2.5 GHz ' AND P1.Price < P2.Price;
--------------------------------------------------------
https://www.uio.no/studier/emner/matnat/ifi/IN2090/h23/undervisningsmateriale/05-05.pdf

Nestede spørringer & delspørringer

SELECT <columns >
FROM (SELECT <columns >
    FROM <tables >
    WHERE <condition >
    ) AS subquery
WHERE <condition >;

Eksempel:
Følgende spørring finner antall solgte drikkevarer med delspørring
SELECT sum(d.quantity )
FROM (
        SELECT p.product_id
        FROM products AS p 
            INNER JOIN categories AS c
            ON (p.category_id = c.category_id )
        WHERE c.category_name = 'Beverages'
    ) AS beverages
    INNER JOIN
    order_details AS d
    ON ( beverages.product_id = d.product_id );


Delspørringer som verdier:
Så for å finne alle produkter som koster mer enn gjennomsnittet kan vi skrive:
SELECT product_name
FROM products
WHERE unit_price > (SELECT avg( unit_price )
                    FROM products);

Delspørringer som mengder:
Dersom vi ønsker å begrense én verdi (eller et tuppel av verdier) til svarene av en annen spørring i WHERE-klausulen, kan vi bruke nøkkelorder IN
F.eks. for å finne navnet på alle produkter med en “supplier” fra Tyskland:
SELECT product_name
FROM products
WHERE supplier_id IN (SELECT supplier_id
                    FROM suppliers
                    WHERE country = 'Germany ');

Eksempel: Finn navn og pris på alle produktet med lavest pris. Ved min-aggregering og delspørring som verdi
SELECT product_name , unit_price
FROM products
WHERE unit_price = (SELECT min( unit_price )
                    FROM products);

Dersom vi ønsker å bruke den samme delspørringen om igjen kan man navngi den først med WITH, f.eks.:
Eksempel: Hva er den største differansen mellom prisen på laptopper?
SELECT max(l1.Price - l2.Price) AS diff
FROM (SELECT Price FROM products WHERE Name LIKE '%Laptop%') AS l1 ,
     (SELECT Price FROM products WHERE Name LIKE '%Laptop%') AS l2;

Istedt kan vi skrive:
WITH
    laptops AS (SELECT Price FROM products WHERE Name LIKE '%Laptop%')
SELECT max(l1.Price - l2.Price) AS diff
FROM laptops AS l1 , laptops AS l2;

WITH query_name1 AS (
     SELECT ...
     )
   , query_name2 AS (
     SELECT ...
       FROM query_name1
        ...
     )
SELECT ...;

--------------------------------------
Limit keyword, begrenese resultatene
Alltid siste keyword
LIMIT rows_count OFFSET rows_to_skip;

f.eks: Plukk ut de 5 beste filmene
SELECT film_id, title, year, score
FROM film
ORDER BY score
LIMIT 5 DESC; --Descending order, highest scores on top
