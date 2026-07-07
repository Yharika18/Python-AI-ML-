-- whats databse?
-- whats database management system?  DBMS
-- whats sql? Structured query languange 
-- what is schema?
-- sql commands - whats ddl,dml,dql, dcl, tcl

-- DDL - Data defination lang
-- DML -= data manipulative 
-- DQL - Data query lang
-- dcl - data control lang
-- tcl - transation control 

-----------------------
 #use company_db;
 
#create database 
CREATE DATABASE company_db;
-----------------------------------------
#Create Table 

CREATE TABLE company_db.test_table (
  id INT,
  name VARCHAR(100)
);

SELECT id FROM company_db.test_table;
 -------------------------------------------------------------
 #Insert Data into the Table
 
INSERT INTO company_db.test_table (id, name)
 VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO company_db.test_table (id, name)
 VALUES
(5, 5);
---------------------------------
#Select 

SELECT * FROM company_db.test_table;
------------------------------------
#Alter table 
ALTER TABLE company_db.test_table
ADD Email varchar(255);
---
ALTER TABLE company_db.test_table
RENAME COLUMN Email to email_id;
---------------------------------------------------------------
# SQL constraints are used to specify rules for data in a table.

#not null and  unique constraints 
drop table if exists company_db.Persons;

CREATE TABLE company_db.Persons (
    ID int NOT NULL unique,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

SELECT * FROM company_db.Persons;

INSERT INTO  company_db.Persons (ID, LastName, FirstName, Age)
VALUES (1, 'Smith', 'John', 30);

INSERT INTO  company_db.Persons (ID, LastName, FirstName, Age)
VALUES (2, 'Doe', NULL, NULL);  -- NULLs allowed for FirstName and Age


-- This will FAIL because ID = 1 already exists
INSERT INTO  company_db.Persons (ID, LastName, FirstName, Age)
VALUES (1, 'Brown', 'Charlie', 25);


-- This will FAIL because LastName is NOT NULL
INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
VALUES (3, null, 'Alice', 28);
--------------------------------------------------------

#PRIMARY KEY 

ALTER TABLE  company_db.Persons
ADD PRIMARY KEY (ID);
-----
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
AND TABLE_NAME = 'actor';
-- AND CONSTRAINT_TYPE = 'PRIMARY KEY';-- 
-------------------------------------

ALTER TABLE company_db.Persons
DROP  PRIMARY key ;
-------
ALTER TABLE company_db.Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID);

------------------------------------------------------------------------
#Foregin KEY
-- A FOREIGN KEY is a field (or collection of fields) in one table, that refers to the PRIMARY KEY in another table.
-- The table with the foreign key is called the child table, and the table with the primary key is called the referenced or parent table.

CREATE TABLE company_db.Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Persons(ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

INSERT INTO company_db.Orders (OrderID, OrderDate, PersonID)
VALUES (1001, '2024-06-10', 1);

SELECT * FROM company_db.Orders;
SeLECT * FROM company_db.persons;
INSERT INTO company_db.Orders (OrderID, OrderDate, PersonID)
VALUES (1002, '2024-06-11', 999);  -- PersonID 999 doesn't exist

DELETE FROM company_db.Persons WHERE ID = 1;

select * FROM company_db.persons; -- parent 
SELECT * FROM company_db.Orders; -- child 

UPDATE company_db.Persons SET ID = 4 WHERE ID = 1;
	
------------------------------------------------------------------------------------------------
#check and default 

CREATE TABLE company_db.employee (
    ID int NOT NULL ,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int  CHECK (Age>=18),
	city varchar(255) DEFAULT 'new york'
);

SELECT * FROM company_db.employee;
--------

INSERT INTO company_db.employee (ID, LastName, FirstName, Age,city)
VALUES (1, 'joey', 'tribiani', 17, 'texas');

--------------------------
# Difference between drop and delete 
select * FROM company_db.test_table;

select * FROM company_db.test_table where id = 1;

SET SQL_SAFE_UPDATES = 0;

DELETE from company_db.test_table where id = 1; 
--------------------------------------
#drop 

DROP TABLE company_db.test_table;
DROP TABLE  company_db.employee;

# Truncate
truncate TABLE company_db.test_table;
--------------------------

DROP TABLE company_db.persons;
DROP TABLE company_db.Orders;

drop database   company_db;

-------------------------------------------------------------------------------------------------------------------