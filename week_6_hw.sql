1. Show all customers whose last names start with T. Order them by first name from A-Z.

SELECT *
FROM customer
WHERE last_name LIKE 'T%'
ORDER BY first_name;

Successfully run. Total query runtime: 319 msec.
20 rows affected.

/* Specified customer table of dvdrental database; used % wildcard to instruct SQL to only return
records of customers whose last names begin with the letter "T"; then used ORDER BY to sort results
alphabetically by first_name field */

2. Show all rentals returned from 5/28/2005 to 6/1/2005

SELECT *
FROM rental
WHERE return_date BETWEEN '2005-05-28' AND '2006-06-01';

Successfully run. Total query runtime: 278 msec.
15796 rows affected.

/* Specified rental table of dvdrental database; used WHERE-BETWEEN-AND to ask for rentals
returned between May 28, 2005 and June 1, 2005 (inclusive) using ISO date format*/

3. How would you determine which movies are rented the most?

SELECT title, rental_rate
FROM film
ORDER BY rental_rate DESC;

Successfully run. Total query runtime: 127 msec.
1000 rows affected.

-- does "rental_rate" mean how often film is rented or cost of renting film??

4. Show how much each customer spent on movies (for all time) . Order them from least to most.

SELECT SUM(amount), customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount);

Successfully run. Total query runtime: 136 msec.
599 rows affected.

/* Specified payment table of dvdrental database; told SQL to retrieve customer_id column + sum of
amount column values; had SQL group results by customer_id, then sort the results by total amount
spent with values ascending*/

5. Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias the actor name and count as a more descriptive name. Order the results from most to least.

SELECT COUNT(last_name) as total_movies, last_name as actor_name,
release_year, title
FROM film
JOIN film_actor
ON film.film_id = film_actor.film_id
JOIN actor
ON film_actor.actor_id = actor.actor_id
WHERE release_year = 2006
GROUP BY actor.last_name, film.title, film.release_year
ORDER BY COUNT(last_name) DESC;

Successfully run. Total query runtime: 239 msec.
5381 rows affected.

/* Needed to join the actor, film, and film_actor tables to combine fields needed to answer this 
question.  Joined film and film_actor tables along film_id column; joined film_actor and actor tables
along actor_id column.  Requsted actors' last names and film titles; restricted results to films
released in 2006.  Asked SQL to count records by actor last name, group results by actor last name,
then order results by descending count (most to least).*/

-- max movie count for 2006 was 2; several actors were in two movies that year

6. Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. Use the following link to understand how this works http://postgresguide.com/performance/explain.html 


7. What is the average rental rate per genre?

SELECT name, AVG(rental_rate)
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film_category.film_id = film.film_id
GROUP BY category.name;

Successfully run. Total query runtime: 220 msec.
16 rows affected.

/* Needed to join category, film_category, and film tables to combine relevant fields necessary to 
answer this question.  Joined category and film_category tables along category_id column; joined
film_category and film tables along film_id column.  Asked SQL to return category name (aka genre),
the average rental rate, and to group results by category name (genre). */

8. How many films were returned late? Early? On time?

SELECT title, rental_date, return_date, rental_duration as theoretical_duration, 
(return_date-rental_date) as actual_duration
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
WHERE return_date IS NOT NULL
ORDER BY (return_date-rental_date) DESC;

Successfully run. Total query runtime: 183 msec.
15861 rows affected.

/* I got this far; stuck on whatever step is needed to ask SQL to retrieve late items (actual_duration >
theoretical_duration), on-time items (actual_duration = theoretical duration), and early items
(actual_duration < theoretical_duration) */


9. What categories are the most rented and what are their total sales?

SELECT amount, rental.rental_id, name
FROM payment
JOIN rental
ON payment.rental_id = rental.rental_id
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film_category
ON inventory.film_id = film_category.film_id
JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name, payment.amount, rental.rental_id
ORDER BY category.name, payment.amount DESC;


/* Action looks to be the most rented category, but how to get total sales?? */


Create a view for 8 and a view for 9. Be sure to name them appropriately. 
Bonus:
Write a query that shows how many films were rented each month. Group them by category and month. 
