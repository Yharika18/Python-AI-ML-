---------------------------------
#date diff 

SELECT rental_id, return_date,rental_date, DATEDIFF(return_date, rental_date) AS days_rented
FROM sakila.rental
WHERE return_date IS NOT NULL;

#date time 

select last_update,month(last_update),monthname(last_update) from sakila.film;

SELECT 
    rental_date, year(rental_date)
FROM
   sakila.rental;


SELECT payment_date FROM sakila.payment;

SELECT payment_date, date(payment_date) AS pay_date, SUM(amount) AS total_paid
FROM sakila.payment
GROUP BY DATE(payment_date),payment_date
ORDER BY pay_date DESC;

#Find Customers Who Paid in the Last 24 Hours

select * from sakila.payment;

SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= NOW() - INTERVAL 1 DAY;

select max(payment_date) FROM sakila.payment;

SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= (
    SELECT MAX(payment_date) - INTERVAL 2 day
    FROM sakila.payment
);

select now()  - INTERVAL 1 DAY as yesterday;


SELECT CONCAT('Today is: ', CURDATE()) AS message;
SELECT CONCAT('Today is: ', now()) AS message;

SELECT NOW(), CURDATE(), CURRENT_TIME;

--------------------------------------------------------
#sub queries 

SELECT first_name, last_name
FROM sakila.customer

WHERE address_id IN (
    SELECT address_id
    FROM sakila.customer
     WHERE customer_id = 4
);

-----------------------------------
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id in (
    SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) >= 10
) ;

-- select a.actor_id, a.first_name, a.last_name,count(fa.film_id), fa.last_update
-- from  sakila.actor as a 
-- join sakila.film_actor fa 
-- on a.actor_id = fa.actor_id 
-- group by a.actor_id, a.first_name, a.last_name, fa.last_update ;


SELECT actor_id,COUNT(film_id)
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10;
------------------
#sub query in  select 

SELECT actor_id,
       first_name,
       last_name,
       (
           SELECT COUNT(*)
           FROM sakila.film_actor
           WHERE film_actor.actor_id = actor.actor_id
           
       ) AS film_count
       
FROM sakila.actor;

------------------------
# Derived Tables

SELECT a.actor_id, a.first_name, a.last_name, fa.film_count
FROM sakila.actor a
JOIN (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM sakila.film_actor
    GROUP BY actor_id,last_update
    HAVING COUNT(film_id) > 10
) fa ON a.actor_id = fa.actor_id;


SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM sakila.payment
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 25
) AS top_customers;



SELECT customer_id, SUM(amount) AS total_spent
    FROM sakila.payment
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 15;

SELECT *
FROM (
    SELECT last_name,
           CASE 
               WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
               WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
               ELSE 'Other'
           END AS group_label
    FROM sakila.customer
    
) AS grouped_customers 
 WHERE group_label = 'Group A-M'
 limit 5 ;
 
 ---------------------------

 
---------------------------------
-- Use subqueries when:
-- You need temporary results to build your main query
-- You are comparing against aggregate values

SELECT customer_id, amount
FROM sakila.payment
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment
);

SELECT AVG(amount)
    FROM sakila.payment;
    
#when sub query fail 

SELECT first_name,
       (SELECT address_id FROM sakila.address WHERE district = 'California' limit 1) AS cali_address
FROM sakila.customer;

SELECT address_id FROM sakila.address WHERE district = 'California';
------------------------------------------------
#co related subqueries 
-- A correlated subquery is a subquery that:
-- Refers to a column from the outer (main) query
-- Is executed once for each row in the outer query
SELECT title,
  (SELECT COUNT(*)
   FROM sakila.film_actor fa
   WHERE fa.film_id = f.film_id) AS actor_count
FROM sakila.film f;

select * from sakila.film;
select * from sakila.film_actor;
select * from sakila.actor;


-------------------------------

SELECT payment_id, customer_id, amount, payment_date
FROM sakila.payment p1
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment p2
    WHERE p2.customer_id = p1.customer_id
);

----------------------------------------------