-- Active: 1654168274613@@127.0.0.1@3306@sakila
use sakila;

#1

DELIMITER //

CREATE FUNCTION GetFilmCopiesInStore(filmIdentifier INT, storeId INT) RETURNS INT
BEGIN
    DECLARE copies INT;

    IF filmIdentifier < 1000 THEN
        SELECT COUNT(*) INTO copies
        FROM inventory i
        WHERE i.store_id = storeId
        AND i.film_id = filmIdentifier;
    ELSE
        SELECT COUNT(*) INTO copies
        FROM inventory i
        JOIN film f ON i.film_id = f.film_id
        WHERE i.store_id = storeId
        AND f.title = filmIdentifier;
    END IF;

    RETURN copies;
END //

DELIMITER ;
SELECT GetFilmCopiesInStore('3', 2);

#2

DELIMITER //

CREATE PROCEDURE CountryCustomers(
    IN targetCountry VARCHAR(150),
     OUT customerss VARCHAR(230))

BEGIN
    DECLARE finish INT DEFAULT 0;
    DECLARE firstName VARCHAR(30);
    DECLARE lastName VARCHAR(50);
    DECLARE coun VARCHAR(100) ;

    DECLARE CursorC1 CURSOR FOR
        SELECT first_name, last_name
        FROM customer
        WHERE country = targetCountry;

    SET customerss = '';
    
    OPEN CursorC1;
    read_loop: LOOP
        FETCH CursorC1 INTO firstName, lastName;
        IF finish THEN
            LEAVE read_loop;

        END IF;
        
        IF LENGTH(customerss) > 0 THEN
            SET customerss = CONCAT(customerss, ';', firstName, ' ', lastName);
        ELSE
            SET customerss = CONCAT(firstName, ' ', lastName);

        END IF;
    END LOOP;
    CLOSE CursorC1;
END //

DELIMITER ;

CALL CountryCustomers('USA', @customerList);
SELECT @customerList;


DELIMITER //


CREATE PROCEDURE customerScountry(IN target_country VARCHAR(250), INOUT customer_list VARCHAR(500)) 
BEGIN 
	DECLARE finished INT DEFAULT 0;
	DECLARE first_name VARCHAR(250); 
	DECLARE last_name VARCHAR(250);
	DECLARE country VARCHAR(250);

	DECLARE cursor_list CURSOR FOR
	SELECT
	    co.country,c.first_name,c.last_name
	FROM customer c
	    INNER JOIN address USING(address_id)
	    INNER JOIN city USING(city_id)
	    INNER JOIN country co USING(country_id);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN cursor_list;

	loop_label: LOOP
		FETCH cursor_list INTO country, first_name, last_name;

		IF country = target_country THEN
			SET customer_list = CONCAT(first_name, ' ', last_name, ' ; ', customer_list);
		END IF;

        IF finished = 1 THEN
			LEAVE loop_label;
		END IF;

	END LOOP loop_label;
	CLOSE cursor_list;
	
END //
DELIMITER ;
SET @customer_list = '';
CALL customerScountry('Spain', @customer_list);
SELECT @customer_list;

#3

CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out INT;

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END

#Explicación:

    #La función verifica si existen alquileres (v_rentals) para el inventory_id especificado. Si no hay alquileres, devuelve VERDADERO (1), indicando que el artículo del inventario está en stock.
    #Si hay alquileres, verifica si hay alquileres con una return_date NULL (v_out). Si no hay alquileres de este tipo, devuelve VERDADERO; de lo contrario, devuelve FALSO.

#Ejemplos de Uso:
SELECT inventory_in_stock(1111); # Devuelve 1 (VERDADERO)
SELECT inventory_in_stock(4568); # Devuelve 0 (FALSO)

# film_in_stock
# está diseñado para encontrar elementos del inventario de una película específica en una tienda en particular y, opcionalmente devolver la cantidad de elementos disponibles.
# Toma p_film_id (ID de película), p_store_id (ID de tienda) y un parámetro de salida p_film_count para almacenar la cantidad de elementos disponibles.


CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
BEGIN
    SELECT inventory_id
    FROM inventory
    WHERE film_id = p_film_id
    AND store_id = p_store_id
    AND inventory_in_stock(inventory_id);

    SELECT COUNT(*)
    FROM inventory
    WHERE film_id = p_film_id
    AND store_id = p_store_id
    AND inventory_in_stock(inventory_id)
    INTO p_film_count;
END

#Explicación:

   # El procedimiento primero recupera el inventory_id de los elementos del inventario que coinciden con el film_id y el store_id especificados y que están en stock (usando la función inventory_in_stock).
   # Despues, cuenta el número total de elementos que cumplen los mismos criterios y almacena el recuento en el parámetro de salida p_film_count.

#Ejemplo de Uso:


# Llama al procedimiento para encontrar elementos del inventario de la película con ID 2 en la tienda con ID 2
CALL film_in_stock(1, 3, @total);

# Muestra la cantidad de elementos disponibles
SELECT @total;

