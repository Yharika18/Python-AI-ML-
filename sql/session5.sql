
-- TEMPORARY TABLES
-- ##################################
-- A table that exists only for the session or until explicitly dropped.
-- Useful for storing intermediate results or testing transformations without affecting actual data

-- Top 5 most rented categories
DROP TEMPORARY TABLE IF EXISTS sakila.top_categories;

CREATE TEMPORARY TABLE sakila.top_categories AS
SELECT c.name AS category_name, COUNT(*) AS rental_count
FROM sakila.rental r
JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN sakila.film f ON f.film_id = i.film_id
JOIN sakila.film_category fc ON f.film_id = fc.film_id
JOIN sakila.category c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 5;

SELECT * FROM sakila.top_categories;

-- VIEWS
-- ##################################
-- A virtual table created using a stored SQL query.
-- Helps with simplifying complex queries, data abstraction, and security (limit what users can see).
-- View for customer’s most recent rental

drop view sakila.recent_rentals;

CREATE OR REPLACE VIEW sakila.recent_rentals AS
SELECT r.customer_id, MAX(r.rental_date) AS ruchik
FROM sakila.rental r
GROUP BY r.customer_id;

select * from sakila.recent_rentals;

SELECT c.first_name, c.last_name, rr.ruchik
FROM sakila.customer c
JOIN sakila.recent_rentals rr ON c.customer_id = rr.customer_id;

-- Public view hiding sensitive columns
CREATE OR REPLACE VIEW sakila.customer_public_view AS
SELECT customer_id, first_name, last_name, email
FROM sakila.customer;

SELECT * FROM sakila.customer_public_view;

-- STORED PROCEDURES
-- ##################################

DROP PROCEDURE IF EXISTS sakila.GetCustomerPayments;
DELIMITER //

-- IN parameter only
CREATE PROCEDURE sakila.GetCustomerPayments(IN cid INT)
BEGIN
    SELECT customer_id,payment_id, amount, payment_date
    FROM sakila.payment
    WHERE customer_id = cid;
END;
//


DROP PROCEDURE IF EXISTS sakila.TotalPaid;

//
-- OUT parameter
CREATE PROCEDURE sakila.TotalPaid(IN cid INT, OUT total DECIMAL(10,2))
BEGIN
    SELECT SUM(amount) INTO total
    FROM sakila.payment
    WHERE customer_id = cid ;
END;
//

DROP PROCEDURE IF EXISTS sakila.DynamicQuery;
//
-- Dynamic SQL procedure
CREATE PROCEDURE sakila.DynamicQuery(IN tbl_name VARCHAR(64))
BEGIN
    SET @s = CONCAT('SELECT COUNT(*) AS total_rows FROM ', tbl_name);
    PREPARE stmt FROM @s;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//


DELIMITER ;

-- CALL examples:

CALL sakila.GetCustomerPayments(6);
-------------------------------------------
-- SET @rents = 0; CALL sakila.IncrementRentals(3, @rents); SELECT @rents;
------------------------------------------------------------------------------------------

CALL sakila.TotalPaid(5, @total); 
SELECT @total;

-------------------------------------------------------------


-----------------------------------------------------
CALL sakila.DynamicQuery('sakila.city');



    
