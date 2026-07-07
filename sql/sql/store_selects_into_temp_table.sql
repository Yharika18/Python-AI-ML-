-- Stored Procedure
-- ##################################

-- Create a temp table to store SELECT statements
DROP TEMPORARY TABLE IF EXISTS sakila.select_statements;

CREATE TEMPORARY TABLE sakila.select_statements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    statement_text TEXT
);

-- drop PROCEDURE sakila.StoreSelectStatements;
-- Create the procedure
DELIMITER //

CREATE PROCEDURE sakila.StoreSelectStatements(IN db_name VARCHAR(64))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(64);
    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = db_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tbl_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @stmt = CONCAT('SELECT count(*) FROM ', db_name, '.', tbl_name, ';');
        SET @ins = CONCAT('INSERT INTO select_statements (statement_text) VALUES (?)');
        PREPARE stmt FROM @ins;
        EXECUTE stmt USING @stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END;
//

DELIMITER ;

-- Call the procedure
CALL sakila.StoreSelectStatements('joins');

-- See results
SELECT * FROM sakila.select_statements;






