-- SQL Query Fine-Tuning Techniques 
-- ##########################################################
use sakila;

-- 1. Use only necessary columns (Avoid SELECT *)
SELECT first_name, last_name FROM sakila.customer;

-- 2. Use WHERE before GROUP BY and HAVING
SELECT store_id, COUNT(*) AS total_customers
FROM sakila.customer
WHERE active = 1
GROUP BY store_id
HAVING COUNT(*) > 200;


-- 3. Use JOIN instead of subquery
-- Subquery (less efficient)

 SELECT first_name FROM customer WHERE store_id IN (SELECT store_id FROM store WHERE address_id = 1);

-- Equivalent JOIN (more efficient)
SELECT c.first_name
FROM customer c
JOIN store s ON c.store_id = s.store_id
WHERE s.address_id = 1;

-- 4. Avoid functions on indexed columns
-- Bad: cannot use index
explain SELECT * FROM sakila.rental WHERE YEAR(rental_date) = 2005;

-- Better: preserves index
explain SELECT * FROM sakila.rental WHERE rental_date BETWEEN '2005-01-01' AND '2005-12-31';

-- 5. Use LIMIT effectively
SELECT *  
FROM sakila.film
ORDER BY film_id
 LIMIT 100;

-- 7. Use CTE for readable query breakdown
WITH high_paying_customers AS (
  SELECT customer_id, SUM(amount) AS total_paid
  FROM sakila.payment
  GROUP BY customer_id
  HAVING SUM(amount) > 100
)
SELECT c.first_name, c.last_name, h.total_paid
FROM sakila.customer c
JOIN high_paying_customers h ON c.customer_id = h.customer_id;

-- 8. Use EXPLAIN to understand query execution plan
EXPLAIN SELECT * FROM sakila.customer WHERE store_id = 1;

-- 9. Maintenance commands (run periodically)
ANALYZE TABLE sakila.customer;
OPTIMIZE TABLE sakila.customer;

-- 10. Avoid large OFFSETs in pagination
-- Inefficient:
SELECT * FROM sakila.payment LIMIT 1000, 10;
-- Efficient:
SELECT * FROM sakila.payment WHERE payment_id > 1000 LIMIT 10;





