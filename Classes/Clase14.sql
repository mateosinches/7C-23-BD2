-- Active: 1654168274613@@127.0.0.1@3306
use sakila;

#1-Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    a.address AS CustomerAddress,
    ct.city AS CustomerCity
FROM customer AS c
JOIN store AS s ON c.store_id = s.store_id
JOIN address AS a ON s.address_id = a.address_id
JOIN city AS ct ON a.city_id = ct.city_id
JOIN country AS co ON ct.country_id = co.country_id
WHERE co.country = 'Argentina';

#2-Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

SELECT
    f.title,
    l.name AS language,
    f.rating,
    CASE
        WHEN f.rating = 'G' THEN 'All ages admitted'
        WHEN f.rating = 'PG' THEN 'Some material may not be suitable for children'
        WHEN f.rating = 'PG-13' THEN 'Some material may be inappropriate for children under 13'
        WHEN f.rating = 'R' THEN 'Under 17 requires accompanying parent or adult guardian'
        WHEN f.rating = 'NC-17' THEN 'No one 17 and under admitted'
    END AS 'Rating Text'
FROM film AS f
INNER JOIN language AS l ON f.language_id = l.language_id;

#3- Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

SELECT
    CONCAT(ac.first_name, ' ', ac.last_name) AS actor,
    f.title AS film,
    f.release_year AS release_year
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor ac ON fa.actor_id = ac.actor_id
WHERE CONCAT(ac.first_name, ' ', ac.last_name) LIKE CONCAT('%', UPPER(TRIM('KIRSTEN AKROYD')), '%');

#4-Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.

SELECT
    f.title,
    r.rental_date,
    c.first_name AS customer_name,
    CASE
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS 'Returned'
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) = 5 OR MONTH(r.rental_date) = 6
ORDER BY r.rental_date;
