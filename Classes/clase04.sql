-- Active: 1654168274613@@127.0.0.1@3306
use sakila;

SELECT title, special_features from film where rating = "PG-13";

select title, length from film;

select title, rental_rate, replacement_cost from film where replacement_cost between 20 and 24;

select title, c.name, rating, special_features from film inner join category c on category_id where special_features="Behind the scenes";

select first_name, last_name, f.title from actor as a inner join film f where title="ZOOLANDER FICTION";

select a.address, c.city, cc.country, s.store_id from address as a 
    inner join city c 
    inner join country as cc
    inner join store as s
where store_id=1;

select  f1.title  , f2.title  ,f1.rating FROM film f1 , film f2
WHERE f1.rating  =  f2.rating AND f1.film_id <>  f2.film_id;
