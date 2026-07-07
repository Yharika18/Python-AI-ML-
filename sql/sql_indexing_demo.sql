
-- INDEXING DEMO
-- ##################################
--  What is a Clustered Index?
-- A clustered index determines the physical order of data rows in a table. In MySQL (InnoDB), the primary key is always the clustered index.
--  Characteristics:
-- There is only one clustered index per table.
-- All rows are physically ordered by the clustered index key.
-- Very fast for range queries and primary key lookups.

-- What is a Non-Clustered Index?
-- A non-clustered index is a separate structure from the actual table data. It stores pointers (row IDs or PK values) to the actual rows in the clustered index.
--  Characteristics:
-- You can have multiple non-clustered indexes per table.
-- Ideal for filtering, searching, sorting on non-PK columns.
-- Slower than clustered index for lookups, since it adds an extra lookup step (called bookmark lookup).

DROP TABLE IF EXISTS sakila.sales_data;

CREATE TABLE sakila.sales_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    product_name VARCHAR(100),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sakila.sales_data (customer_name, product_name, amount, sale_date)
VALUES 
('Alice', 'Laptop', 1200.00, '2024-12-01'),
('Bob', 'Keyboard', 150.00, '2025-01-10'),
('Charlie', 'Monitor', 300.00, '2025-02-05'),
('Alice', 'Mouse', 50.00, '2025-03-12'),
('David', 'Printer', 450.00, '2025-04-21'),
('Eve', 'Tablet', 700.00, '2025-05-03'),
('Frank', 'Laptop', 1300.00, '2025-06-15'),
('Grace', 'Keyboard', 120.00, '2025-06-18'),
('Heidi', 'Monitor', 310.00, '2025-06-19'),
('Ivan', 'Mouse', 55.00, '2025-06-20'),
('xhdckj', 'Laptop', 155.00, '2025-06-20'),
('joey', 'Laptop', 1555.00, '2025-06-21'),
('tribiani', 'Laptop', 1900.00, '2025-06-22'),
('phoebe', 'Laptop', 1300.00, '2025-06-27');


SELECT * FROM sakila.sales_data;

SELECT * FROM sakila.sales_data  where id = 2;
EXPLAIN SELECT * FROM sakila.sales_data where id = 2;

SELECT * FROM sakila.sales_data  where  product_name = 'Laptop' and amount = 1300;

EXPLAIN SELECT * FROM sakila.sales_data WHERE product_name = 'Laptop' and amount = 1300;

-- Step 4: Add an index on the 'product_name' column
CREATE INDEX idx_product_name ON sakila.sales_data(product_name);

CREATE INDEX idx_Amount ON sakila.sales_data(amount);

-- Step 5: Run the same SELECT again after indexing
EXPLAIN SELECT * FROM sakila.sales_data WHERE product_name = 'Laptop'  and amount = 1300;

DROP INDEX idx_product_name ON sakila.sales_data;
DROP INDEX idx_Amount ON sakila.sales_data;


-- DISCUSSION: natural Key & Surrogate Key
-- ##################################

drop table if exists sakila.employee_natural ;

CREATE TABLE sakila.employee_natural (
    ssn CHAR(11) PRIMARY KEY,  
    name VARCHAR(100),
    department VARCHAR(50)
);

INSERT INTO sakila.employee_natural (ssn, name, department) VALUES
('123-45-6789', 'Alice', 'Finance'),
('234-56-7890', 'Bob', 'IT'),
('345-67-8901', 'Carol', 'HR');

select * from sakila.employee_natural;

-- This will fail: duplicate primary key
INSERT INTO sakila.employee_natural (ssn, name, department) VALUES
('123-45-6789', 'Eve', 'Marketing');

drop table if exists sakila.employee_surrogate;

CREATE TABLE sakila.employee_surrogate (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,  -- surrogate key
    ssn CHAR(11),
    name VARCHAR(100),
    department VARCHAR(50)
);

INSERT INTO sakila.employee_surrogate (ssn, name, department) VALUES
('123-45-6789', 'Alice', 'Finance'),
('234-56-7890', 'Bob', 'IT'),
('345-67-8901', 'Carol', 'HR');

select * from sakila.employee_surrogate;

-- This will succeed: ssn is not primary key
INSERT INTO sakila.employee_surrogate (ssn, name, department) VALUES
('123-45-6789', 'ruchik', 'Data science');


SET SQL_SAFE_UPDATES = 0;
delete from sakila.employee_surrogate where name = 'carol';
---------------------------------------------------------------------------------------------



-----------------------------------------------------
