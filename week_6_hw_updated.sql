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

SELECT film_id, COUNT (film_id), f.title
FROM rental AS r
JOIN inventory AS i
USING (inventory_id)
JOIN film AS f
USING (film_id)
GROUP BY film_id
ORDER BY COUNT(film_id) DESC;

Successfully run. Total query runtime: 128 msec.
958 rows affected.

Top 2 movies by # of rentals are Bucket Brotherhood (34) and Rocketeer Mother (33) (several movies tie for the #3 place with 32 rentals).

/*First determined how many times each film was rented by COUNTing the number of times each film_id showed up in the rental table.  Then needed to join inventory and finally film tables to obtain the titles of the movies.*/

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

Max movie count for 2006 was 2; several actors were in two movies that year

6. Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. Use the following link to understand how this works http://postgresguide.com/performance/explain.html 

-- Still don't completely understand what an explain plan is, so pasting the results of running EXPLAIN ANALYZE on 4 and 5

4.
"Sort  (cost=362.06..363.56 rows=599 width=34) (actual time=17.887..17.940 rows=599 loops=1)"
"  Sort Key: (sum(amount))"
"  Sort Method: quicksort  Memory: 53kB"
"  ->  HashAggregate  (cost=326.94..334.43 rows=599 width=34) (actual time=17.302..17.609 rows=599 loops=1)"
"        Group Key: customer_id"
"        Batches: 1  Memory Usage: 297kB"
"        ->  Seq Scan on payment  (cost=0.00..253.96 rows=14596 width=8) (actual time=0.010..10.954 rows=14596 loops=1)"
"Planning Time: 0.195 ms"
"Execution Time: 18.132 ms"

5.
"Sort  (cost=647.45..661.11 rows=5462 width=34) (actual time=25.110..25.563 rows=5381 loops=1)"
"  Sort Key: (count(actor.last_name)) DESC"
"  Sort Method: quicksort  Memory: 613kB"
"  ->  HashAggregate  (cost=253.77..308.39 rows=5462 width=34) (actual time=15.825..22.932 rows=5381 loops=1)"
"        Group Key: actor.last_name, film.title, film.release_year"
"        Batches: 1  Memory Usage: 977kB"
"        ->  Hash Join  (cost=85.50..199.15 rows=5462 width=26) (actual time=0.951..9.464 rows=5462 loops=1)"
"              Hash Cond: (film_actor.actor_id = actor.actor_id)"
"              ->  Hash Join  (cost=79.00..178.01 rows=5462 width=21) (actual time=0.839..7.507 rows=5462 loops=1)"
"                    Hash Cond: (film_actor.film_id = film.film_id)"
"                    ->  Seq Scan on film_actor  (cost=0.00..84.62 rows=5462 width=4) (actual time=0.005..0.996 rows=5462 loops=1)"
"                    ->  Hash  (cost=66.50..66.50 rows=1000 width=23) (actual time=0.732..0.733 rows=1000 loops=1)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 64kB"
"                          ->  Seq Scan on film  (cost=0.00..66.50 rows=1000 width=23) (actual time=0.013..0.428 rows=1000 loops=1)"
"                                Filter: ((release_year)::integer = 2006)"
"              ->  Hash  (cost=4.00..4.00 rows=200 width=11) (actual time=0.084..0.085 rows=200 loops=1)"
"                    Buckets: 1024  Batches: 1  Memory Usage: 17kB"
"                    ->  Seq Scan on actor  (cost=0.00..4.00 rows=200 width=11) (actual time=0.013..0.045 rows=200 loops=1)"
"Planning Time: 0.930 ms"
"Execution Time: 26.174 ms"


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

/* Needed to join category, film_category, and film tables to combine relevant fields necessary to answer this question.  Joined category and film_category tables along category_id column; joined film_category and film tables along film_id column.  Asked SQL to return category name (aka genre), the average rental rate, and to group results by category name (genre). */

8. How many films were returned late? Early? On time?

WITH t1 AS (SELECT *, DATE_PART('day', return_date-rental_date)
	AS date_differ
	FROM rental),
t2 AS (SELECT rental_duration, date_differ,
	  	CASE
	 	 WHEN rental_duration = date_differ THEN 'on time'
	  	WHEN rental_duration > date_differ THEN 'late'
	 	 ELSE 'early'
	 	END AS return_status
	FROM film AS f
	JOIN inventory AS i
	USING (film_id)
	JOIN t1
	USING (inventory_id))
SELECT return_status, count(*) AS total_film_num
FROM t2
GROUP BY 1
ORDER BY 2 DESC;

Successfully run. Total query runtime: 114 msec.
3 rows affected.

-- late = 7738
-- on time = 1720
-- early = 6586

/* I got this far; stuck on whatever step is needed to ask SQL to retrieve late items (actual_duration >
theoretical_duration), on-time items (actual_duration = theoretical duration), and early items
(actual_duration < theoretical_duration) */
/* Update: I'm still a little foggy on exactly how this works, so I wouldn't mind going over it in class sometime */


9. What categories are the most rented and what are their total sales?

SELECT
SUM(p.amount) AS TotalSales, c.name AS Category 
/*adding total sales and aliasing these 2 columns*/
FROM payment AS p
LEFT JOIN rental AS r
USING(customer_id)
LEFT JOIN inventory AS i
USING (inventory_id)
LEFT JOIN film_category AS fc
USING (film_id)
LEFT JOIN category AS c
USING (category_id)
/*Joining all needed tables; aliasing them just for fun */
GROUP BY Category /*grouping the total sales by the category*/
ORDER BY totalsales DESC; /*sort by sales, high to low */

Successfully run. Total query runtime: 294 msec.
16 rows affected.

/*Top 5 categories by total rental sales (is that an oxymoron?) are Sports ($125,547.36), Animation ($124,971.36), Action ($118,562.56), Family ($118,222.87), 
and Sci-Fi ($116,128.29).*/


Create a view for 8 and a view for 9. Be sure to name them appropriately. 

--Also not understanding how create views differ from the output of regular SQL queries?  Can this be explained in class/on slack?

8.
"late"	7738
"early"	6586
"on time"	1720

9.
125547.36	"Sports"
124971.95	"Animation"
118562.56	"Action"
118222.87	"Family"
116128.29	"Sci-Fi"
111073.76	"Drama"
111022.42	"Documentary"
110213.86	"Foreign"
104538.64	"Games"
100529.28	"New"
100146.68	"Comedy"
99714.60	"Classics"
99686.32	"Children"
89445.07	"Horror"
88557.80	"Travel"
87185.39	"Music"

Bonus:
Write a query that shows how many films were rented each month. Group them by category and month. 
