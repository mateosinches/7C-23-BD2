-- Active: 1654168274613@@127.0.0.1@3306
use sakila;

--1

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('17886', '77459');
--7ms

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code NOT IN ('35355', '67976');
--12ms
CREATE INDEX idx_postal_code ON address (postal_code);
--despues de esto la primera query paso a 6ms y la segunda query paso a 10ms

--2
select first_name from actor;
--7ms
select last_name from actor;
--6ms
/*
en este cas la consulta de "first_name" toma 7ms mientras que la de "last_name" solo 6ms. La diferencia se debe a que la columna "last_name" tiene un índice, 
visible al ejecutar "SHOW INDEX in actor". Este índice permite a la base de datos encontrar los valores mucho más rápido. 
*/

--3


select description						
from film
where description like '%Emotional%';
--16ms

CREATE FULLTEXT INDEX film_description_idx ON film(description);
select description									
from film
where MATCH(description) AGAINST('%Emotional%');
--11ms
/*el índice fulltext es un tipo especial de índice creado para realizar búsquedas de texto completo de manera eficiente. Este tipo de índice está optimizado para buscar palabras o frases en textos extensos. 
Por lo tanto, en esta situación, nos ayudaría a mejorar la búsqueda de las características que estamos buscando en la descripción. 
el uso de FULLTEXT nos proporciona mayor rapidez al filtrar datos.*/