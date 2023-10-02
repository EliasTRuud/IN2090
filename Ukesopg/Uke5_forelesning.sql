Skriv en spørring over Northwind - databasen som: 1.finner navn på alle kunder fra London
SELECT contact_name
FROM customers;

2.finner lasten (i tonn) for alle bestillinger som er sendt med skipene Around the Horn og Ernst Handel
SELECT freight
FROM orders
WHERE ship_name = 'Ernst Handel'
    OR ship_name = 'Around the Horn';

3.finner produktnavnet på alle produkter hvor totalverdien på lager er større enn 1000 og hvor produktets pakkemåte måles i kilogram eller gram
SELECT product_name
FROM products
WHERE units_in_stock * unit_price > 1000
    AND (
        quantity_per_unit LIKE '% g %'
        OR quantity_per_unit LIKE '% kg %'
    );

4.finner orderIDen til alle bestillinger som inneholder et discontinued produkt
SELECT DISTINCT order_id
FROM order_details
    INNER JOIN products ON order_details.product_id = products.product_id --product_id er det som linker dem sammen
WHERE discontinued = 1;

5.finner hvor mange dollar totalt kjøpt for og antall produkter totalt kjøpt fra kunder fra Tyskland
SELECT sum(od.unit_price * od.quantity) AS dollar_spent,
    sum(quantity) AS total_products
FROM order_details od
    INNER JOIN orders o ON od.order_id = o.order_id
    INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE country = 'Germany';

# Listet opp infoen uten summert
SELECT c.country,
    od.unit_price,
    od.quantity
FROM order_details od
    NATURAL JOIN orders o
    NATURAL JOIN customers c
WHERE country = 'Germany';

6.finner produktnavnet på det produktet som er solgt for en pris (som oppgitt i order_details) med størst differanse fra nåværende pris (som oppgitt iproducts).
Max verdien er:
SELECT max(abs(od.unit_price - p.unit_price)) AS price_diff
FROM order_details AS od INNER JOIN products AS p ON od.product_id = p.product_id;

Bruker SELECT table ovenifra i WHERE klausulen får å finne hvor absDiff = maxDiff:
SELECT DISTINCT p.product_name
FROM products p
    INNER JOIN order_details od ON p.product_id = od.product_id
WHERE abs(od.unit_price - p.unit_price) =
         (SELECT max(abs(od.unit_price - p.unit_price)) AS price_diff
         FROM order_details AS od INNER JOIN products AS p ON od.product_id = p.product_id);

Bonus: For å se prisforskjell i rekkefølge.
SELECT DISTINCT p.product_name, p.unit_price AS nowPrice, od.unit_price AS oldPrice, abs(od.unit_price - p.unit_price) AS priceDiff
FROM products p
    INNER JOIN order_details od ON p.product_id = od.product_id
ORDER BY priceDiff DESC;