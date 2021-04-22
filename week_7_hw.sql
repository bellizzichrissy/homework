1. Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time. 

SELECT rental_duration, return_date, rental_date,
CASE WHEN rental_duration > date_part('day', rental_date)
THEN 'late'
WHEN rental_duration = date_part('day', rental_date)
THEN 'on time'
ELSE 'early' END AS status
FROM rental AS r
JOIN inventory AS i
ON r.inventory_id = i.inventory_id
JOIN film AS f
ON f.film_id = i.film_id;

/* I'm not 100% sold that this is the "real" right answer, as it seems like the DVDs' rental status should relate to the difference between the rental_duration and the actual time rented (return_date - rental_date)... but I got myself way confused trying how to get that all in one query and make it work, so. */


2. Show the total payment amounts for people who live in Kansas City or Saint Louis.

SELECT city.city as cityname, sum(p.amount) AS total_payment
FROM payment AS p
LEFT JOIN customer AS c
ON p.customer_id = c.customer_id
LEFT JOIN address AS a
ON c.address_id = a.address_id
LEFT JOIN city
ON a.city_id = city.city_id
WHERE city.city = 'Saint Louis' OR city.city = 'Kansas City'
GROUP BY cityname
ORDER BY total_payment DESC;


"Kansas City"	81.81
"Saint Louis"	78.79


3. How many film categories are in each category? Why do you think there is a table for category and a table for film category?

SELECT COUNT(film_id), name
FROM film_category AS fcat
LEFT JOIN category AS ccat
ON fcat.category_id = ccat.category_id
GROUP BY name;

69	"Family"
61	"Games"
66	"Animation"
57	"Classics"
68	"Documentary"
63	"New"
74	"Sports"
60	"Children"
51	"Music"
57	"Travel"
73	"Foreign"
62	"Drama"
56	"Horror"
64	"Action"
61	"Sci-Fi"
58	"Comedy"

/*There are 16 different categories.  Since this database is a larger dataset with some more complex relationships between fields and tables, having two different category tables is a way to keep these relationships a little clearer and the data a little cleaner.  The film category table acts as a bridge between the category data and the film data. */


4. Show a roster for the staff that includes their email, address, city, and country (not ids)

SELECT staff.first_name, staff.last_name, staff.email, 
address.address, address.address2, city.city, country.country
FROM staff
LEFT JOIN address
ON staff.address_id = address.address_id
LEFT JOIN city
ON address.city_id = city.city_id
LEFT JOIN country
ON city.country_id = country.country_id;


5. Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005

SELECT film.film_id, rental_date, film.title, film.length
FROM film
LEFT JOIN inventory
ON film.film_id = inventory.film_id
LEFT JOIN rental
ON inventory.inventory_id = rental.inventory_id
WHERE return_date > '2005-05-14' 
AND rental_date < '2005-06-01';

Successfully run. Total query runtime: 115 msec.
1156 rows affected.


6. Write a subquery to show which movies are rented below the average price for all movies.


SELECT AVG(rental_rate) AS avg_cost
FROM film;

-- determined average rental rate for reference = $2.98

SELECT *
FROM film
WHERE rental_rate <
	(SELECT AVG(rental_rate) FROM film);

Successfully run. Total query runtime: 134 msec.
341 rows affected.

"Seq Scan on film  (cost=66.51..133.01 rows=333 width=384) (actual time=0.415..0.687 rows=341 loops=1)"
"  Filter: (rental_rate < $0)"
"  Rows Removed by Filter: 659"
"  InitPlan 1 (returns $0)"
"    ->  Aggregate  (cost=66.50..66.51 rows=1 width=32) (actual time=0.398..0.399 rows=1 loops=1)"
"          ->  Seq Scan on film film_1  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.002..0.170 rows=1000 loops=1)"
"Planning Time: 0.115 ms"
"Execution Time: 0.740 ms"


7. Write a join statement to show which movies are rented below the average price for all movies.
(use self join?)

SELECT f.title, film.rental_rate
FROM film AS f
JOIN film
ON f.title = film.title
WHERE f.rental_rate <
	(SELECT AVG(rental_rate) FROM film);

Successfully run. Total query runtime: 91 msec.
341 rows affected.

"Hash Join  (cost=137.18..208.25 rows=333 width=21) (actual time=3.006..3.344 rows=341 loops=1)"
"  Hash Cond: ((film.title)::text = (f.title)::text)"
"  InitPlan 1 (returns $0)"
"    ->  Aggregate  (cost=66.50..66.51 rows=1 width=32) (actual time=0.931..0.931 rows=1 loops=1)"
"          ->  Seq Scan on film film_1  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.004..0.303 rows=1000 loops=1)"
"  ->  Seq Scan on film  (cost=0.00..64.00 rows=1000 width=21) (actual time=0.009..0.122 rows=1000 loops=1)"
"  ->  Hash  (cost=66.50..66.50 rows=333 width=15) (actual time=1.267..1.268 rows=341 loops=1)"
"        Buckets: 1024  Batches: 1  Memory Usage: 24kB"
"        ->  Seq Scan on film f  (cost=0.00..66.50 rows=333 width=15) (actual time=0.967..1.200 rows=341 loops=1)"
"              Filter: (rental_rate < $0)"
"              Rows Removed by Filter: 659"
"Planning Time: 0.278 ms"
"Execution Time: 3.461 ms"


8. Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.

/*For this particular scenario, it looks like using a join is more efficient than using a subquery - the code for #7 took 91 msec to run, while the code for #6 took about 50% longer with a 134 msec runtime.*/


9. With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank 

SELECT title, length,
NTILE(4) OVER
(PARTITION BY length ORDER BY length)
AS quartile,
NTILE(5) OVER
(PARTITION BY length ORDER BY length)
AS quintile,
NTILE (100) OVER
(PARTITION BY length ORDER BY length)
AS percentile
FROM film
ORDER BY length DESC;

Successfully run. Total query runtime: 113 msec.
1000 rows affected.

10. In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are. 

/*Procedural programming occurs when we tell a system what we want it to do AND how we want it to be done.  Set-based approaches involve telling a system what we want it to do but NOT how we want it done.  I think Python is generally procedural and SQL is generally set-based, but based on my googling, it seems that's not always the case 100% of the time.*/

Bonus:
Find the relationship that is wrong in the data model. Explain why its wrong. 