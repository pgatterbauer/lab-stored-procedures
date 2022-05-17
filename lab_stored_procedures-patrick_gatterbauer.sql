/** 

Lab | Stored procedures

- Now keep working on the previous stored procedure to make it more dynamic. 
Update the stored procedure in a such manner that it can take a string argument 
for the category name and return the results for all customers that rented movie 
of that category/genre. For eg., it could be action, animation, children, classics, etc.

- Write a query to check the number of movies released in each movie category. 
- Convert the query in to a stored procedure to filter only those categories that have movies released greater than 
a certain number. 
- Pass that number as an argument in the stored procedure.

**/

USE sakila;


# In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
SELECT 
    first_name, last_name, email
FROM
    customer
JOIN
    rental
ON 
	customer.customer_id = rental.customer_id
JOIN
    inventory
ON 
	rental.inventory_id = inventory.inventory_id
JOIN
    film 
ON 
	film.film_id = inventory.film_id
JOIN
    film_category
ON 
	film_category.film_id = film.film_id
JOIN
    category
ON 
	category.category_id = film_category.category_id
WHERE
    category.name = 'Action'
GROUP BY 
	first_name , last_name , email;


#Convert the query above into a simple stored procedure. Use the following query:

DELIMITER //
CREATE PROCEDURE user_action_cat ()
BEGIN
	SELECT 
		first_name, last_name, email
	FROM
		customer
	JOIN
		rental
	ON 
		customer.customer_id = rental.customer_id
	JOIN
		inventory
	ON 
		rental.inventory_id = inventory.inventory_id
	JOIN
		film
	ON 
		film.film_id = inventory.film_id
	JOIN
		film_category
	ON
		film_category.film_id = film.film_id
	JOIN
		category
	ON 
		category.category_id = film_category.category_id
	WHERE
		category.name = 'Action'
	GROUP BY 
		first_name , last_name , email;  
END;
//
DELIMITER ;

CALL user_action_cat;


# Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the 
# category name and return the results for all customers that rented movie of that category/genre. 
# For eg., it could be action, animation, children, classics, etc.
DELIMITER //
CREATE PROCEDURE name_list (IN param1 VARCHAR(30))
BEGIN
	SELECT 
		first_name, last_name, email
	FROM
		customer
	JOIN
		rental
	ON
		customer.customer_id = rental.customer_id
	JOIN
		inventory
	ON 
		rental.inventory_id = inventory.inventory_id
	JOIN
		film
	ON 
		film.film_id = inventory.film_id
	JOIN
		film_category
	ON
		film_category.film_id = film.film_id
	JOIN
		category
	ON 
		category.category_id = film_category.category_id
	WHERE
		category.name = param1 COLLATE utf8mb4_general_ci
	GROUP BY
		first_name , last_name , email;  
END;
//
DELIMITER ;

CALL name_list("Children");

DROP PROCEDURE name_list;

# Write a query to check the number of movies released in each movie category. 
SELECT 
    fc.category_id, c.name, COUNT(*) AS num_films
FROM
    film_category fc
JOIN
	category c
USING 
	(category_id)
GROUP BY
	category_id, c.name
ORDER BY
	c.name ASC;

# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number.

DELIMITER //
CREATE PROCEDURE category_filter ()
BEGIN
	SELECT 
		fc.category_id, c.name, COUNT(*) AS num_films
	FROM
		film_category fc
	JOIN
		category c 
	USING
		(category_id)
	GROUP BY
		category_id, c.name
	HAVING
		num_films > 20
	ORDER BY
		num_films ASC;
END;
//
DELIMITER ;

CALL category_filter;

DROP PROCEDURE category_filter;


# Pass that number as an argument in the stored procedure.
DELIMITER //
CREATE PROCEDURE category_count (IN param1 INT)
BEGIN
	SELECT 
		fc.category_id, c.name, COUNT(*) AS num_films
	FROM
		film_category fc
	JOIN
		category c 
	USING
		(category_id)
	GROUP BY
		category_id, c.name
	HAVING
		num_films > param1
	ORDER BY
		num_films ASC;
END;
//
DELIMITER ;

CALL category_count(20);