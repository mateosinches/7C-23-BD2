-- Active: 1654168274613@@127.0.0.1@3306
use sakila;
--Ej1
create a view list_of_customer as
select c.customer_id, CONCAT(c.first_name,' ', c.last_name) as full_name, a.`address`, a.postal_code as zip_code,
a.phone, ci.city, co.country, if(c.active, 'active', '') as `status`, c.store_id
from customer c
join `address` a using(address_id)
join city ci using(city_id)
join country co using(country_id);
select * from list_of_customer;

--Ej2
create a view film_details as
SELECT f.film_id, f.title,f.description,c.name as category,f.rental_rate as price,f.length,f.rating,
group_concat(concat(a.first_name,' ',a.last_name)order by a.first_name SEPARATOR ', ') as actors
from film f
join film_category fc using(film_id)
join category c using(category_id)
join film_actor fa using(film_id)
join actor a using(actor_id)
group by f.film_id, c.name;
select * from film_details;

--Ej3
create a view sales_by_film_category as
select c.name as category, sum(p.amount) as total_sales
from payment p
join rental using(rental_id)
join inventory using(inventory_id)
join film using(film_id)
join film_category using(film_id)
join category c using(category_id)
group by c.name
order by total_sales;
select * from sales_by_film_category;

--Ej4
create a view actor_information as
select a.actor_id as actor_id, a.first_name as first_name, a.last_name as last_name, COUNT(film_id) as films
from actor a
join film_actor using(actor_id)
group BY a.actor_id, a.first_name, a.last_name;
select * from actor_information;

---Ej5
/*
 La query que esta dentro de la view "actor_info" devuelve como resultado:
 a- El id de cada uno de los actores
 b- El nombre de cada uno de los actores
 c- El apellido de cada uno de los actores
 d- Una lista con todas las películas en las que este actua donde las mismas estan ordenadas alfabeticamente por categoria,
 ordenando alfabeticamente las categorías y dentro de cada una, organizando alfabeticamente las películas
 */

---Ej6
/*
 Las materialized views son tablas que se crean mediante una consulta con los datos de otras tablas.  Esto proporciona un acceso mucho más eficiente, a costa de un incremento en el tamaño de la base de datos y a una posible falta de sincronía, 
 se emplean cuando se va a trabajar con uno grupo reducido de datos de manera reiterada y se requiere su almacenamiento para agilizar las consultas y facilitar el trabajo a la hora de consultar los datos almacenados.
 Por ello, las views son utilizadas frecuentemente en todas las bases de datos que poseen grandes cantidades de datos o, en su defecto, emplean un grupo de datos de manera reiterada en sus consultas y demás.
Una de sus alternativas es una simple view, la cual no se almacena en la memoria y siempre se actualiza cuando modificamos los datos de una tabla.
Las materialized views solo existen en los siguientes DBMS: PostgreSQL, MySQL, Microsoft SQL Server, Oravle, Snowflake, Redshift, MongoDB, entre otros
 */