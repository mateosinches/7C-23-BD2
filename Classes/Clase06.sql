-- Active: 1654168274613@@127.0.0.1@3306
use sakila;


SELECT a.first_name, a.last_name
FROM actor a
WHERE EXISTS (
  SELECT *
  FROM actor b 
  WHERE a.last_name=b.last_name
    AND a.actor_id <> b.actor_id
)
ORDER BY a.last_name ;


SELECT  a.first_name, a.last_name
FROM actor as a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor
    WHERE a.actor_id = film_actor.actor_id
);



SELECT c1.first_name, c1.last_name FROM customer c1
WHERE (SELECT count(*) FROM rental r WHERE c1.customer_id = r.customer_id)=1;


SELECT c.first_name, c.last_name FROM customer c
WHERE (SELECT count(*) FROM rental r WHERE c.customer_id = r.customer_id)>1;


SELECT a.first_name, a.last_name
FROM actor as a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor as fa
    WHERE fa.film_id IN (
        SELECT f.film_id
        FROM film as f
        WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
    )
)
;


SELECT a.first_name, a.last_name 
FROM actor as a
WHERE EXISTS 
(SELECT * FROM film f JOIN film_actor fa on f.film_id = fa.film_id
WHERE f.film_id = fa.film_id AND a.actor_id = fa.actor_id AND 
(f.title = 'BETRAYED REAR' AND  f.title != 'CATCH AMISTAD'));


SELECT concat(a.first_name, ' ', a.last_name) as nombre_completo
FROM actor as a
WHERE EXISTS    (SELECT *
FROM film f JOIN film_actor fm on f.film_id = fm.film_id
WHERE f.film_id = fm.film_id
AND a.actor_id = fm.actor_id
AND (f.title = 'BETRAYED REAR' AND f.title = 'CATCH AMISTAD')
);

SELECT actor_id,first_name, last_name
FROM actor A WHERE NOT EXISTS(
        SELECT title
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND (F.title = 'BETRAYED REAR'OR F.title = 'CATCH AMISTAD')
    );
