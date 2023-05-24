-- Active: 1654168274613@@127.0.0.1@3306

use sakila;


SELECT country.country, country.country_id, COUNT(city.city_id) AS CIUDADES
from country
inner join city ON country.country_id = city.country_id
GROUP BY country.country, country.country_id
ORDER BY country.country, country.country_id;


select country.country, COUNT(city.city_id) AS contador_cities
from country
join city ON country.country_id = city.country_id
GROUP BY country.country
HAVING contador_cities > 10
ORDER BY contador_cities DESC;


select c.first_name, c.last_name, a.address,
COUNT(r.rental_id) AS peliculasrentadas,
SUM(p.amount) AS gasto_total
FROM customer AS c
inner join address AS a ON c.address_id = a.address_id
inner join rental AS r ON c.customer_id = r.customer_id
inner join payment AS p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY gasto_total DESC;


SELECT category.name, AVG(film.length) AS duracion_promedio
from category
join film_category ON category.category_id = film_category.category_id
join film ON film_category.film_id = film.film_id
GROUP BY category.category_id, category.name
ORDER BY duracion_promedio DESC;


select film.rating, COUNT(payment.payment_id) AS ventas
from film
join inventory ON film.film_id = inventory.film_id
join rental ON inventory.inventory_id = rental.inventory_id
join payment ON rental.rental_id = payment.rental_id
GROUP BY film.rating
ORDER BY sales DESC;