-- Active: 1654168274613@@127.0.0.1@3306

use sakila;

select title, length
from film
where length = (select min(length) from film);


SELECT title, rating, length
FROM film AS f1
WHERE length <= (SELECT MIN(length) FROM film)
  AND NOT EXISTS(SELECT * FROM film AS f2 WHERE f2.film_id <> f1.film_id AND f2.length <= f1.length);

select c.first_name as nombre,c.last_name as apellido, a.address as direccion,
	(select min(amount) from payment p where c.customer_id = p.customer_id ) as min
from customer c JOIN address a on c.address_id = a.address_id order by c.first_name;


SELECT first_name, last_name, a.address, MIN(p.amount) AS lowest_payment, MAX(p.amount) AS highest_payment
from customer INNER JOIN payment p on customer.customer_id = p.customer_id INNER JOIN address a on customer.address_id = a.address_id
GROUP BY first_name, last_name, a.address;