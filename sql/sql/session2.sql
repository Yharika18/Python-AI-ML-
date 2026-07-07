#select 

 SELECT * FROM sakila.actor;
 
 SELECT DISTINCT first_name from sakila.actor;
 ----------
 select * from sakila.film where original_language_id is null;
 
 select count(*) from sakila.film ;
 
 select * from sakila.film;
 --------------
select distinct title from sakila.film where original_language_id is  null;

------------------------------------------------
select count(distinct(title)) from sakila.film;
-------------------------------
#count and distinct count 

select count(first_name) from sakila.actor;
select count(distinct(first_name)) from sakila.actor;
-------------------
#select specific columns 

SELECT first_name,last_name FROM sakila.actor;
-------------------------------
#Limit 

SELECT first_name, last_name FROM sakila.actor limit 100;
--------------------
#filtering with where 

SELECT distinct(rating) FROM sakila.film;

SELECT * FROM sakila.film;

SELECT * FROM sakila.film WHERE rating = 'R'  and length >= 92;

SELECT * FROM sakila.film WHERE length >= 92;
------------------
#sorting 
SELECT rental_rate from sakila.film;

SELECT  rental_rate FROM sakila.film ORDER BY rental_rate desc;
--------------------
#AND #OR operators 

SELECT * FROM sakila.film 
where rating = 'PG' and rental_duration = 5
ORDER BY rental_rate ASC;

SELECT * FROM sakila.film 
where rating = 'PG' or rental_duration = 5
ORDER BY rental_rate ASC;


--------------------------------------
#NOT 

SELECT * FROM sakila.film 
where rental_duration  not IN ( 6, 7,3)
ORDER BY rental_rate ASC;

SELECT * FROM sakila.film 
where  not rental_duration = 6 
ORDER BY rental_rate ASC;
-------------------------------------
SELECT * FROM sakila.film 
where rental_duration = 6 and (rating = 'G' OR rating = 'PG')
ORDER BY rental_rate ASC;


--------------------------------------------
#LIKE used with where clause 

-- There are two wildcards often used in conjunction with the LIKE operator:
-- 	The percent sign % represents zero, one, or multiple characters
-- 	The underscore sign _ represents one, single character

SELECT city FROM sakila.city where city like 'A%s';

SELECT city FROM sakila.city where city like '___a_s%';
-----------------------------------------------------------------------
#NULL Value

#Check Rentals That Were Never Returned 

select * from sakila.rental;

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date  IS NULL;

-----------------------------------------
#between 

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE  return_date between '2005-05-26' and '2005-05-30';

------------------
#group by and having 
#TO CHECK DUPLICATES 

select customer_id,COUNT(rental_id) as count_rentals
FROM sakila.rental
GROUP BY customer_id
HAVING count(rental_id) >= 30 
order by  count_rentals desc
limit 50;

-- select count(*) as count from sakila.rental;
-----------------------------------
#order of execution is SQL 

# from (table) ---> join ---> where --- group by --> having ---> select ---> order by  --> limit

----------------------
# DIFFERENCE BETWEEN where cluase and having 

-- order by count;PRIMARY

select * from sakila.rental where return_date is null;

select * from sakila.rental where customer_id = 33;
------------------------------
SELECT * FROM sakila.payment;

SELECT customer_id, sum(amount) as total_payment 
FROM sakila.payment
group by customer_id
having sum(amount) < 100 and customer_id between 1 and 100;
-----------------------------------------