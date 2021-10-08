CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(10),
    birth_day DATE,
    salary INT,
    supervisor_ID INT,
    branch_ID INT
);

CREATE TABLE branch (
    branch_ID INT PRIMARY KEY,
    branch_name VARCHAR (20),
    mngr_ID INT,
    mngr_start_date DATE,
    FOREIGN KEY(mngr_ID) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(supervisor_ID) 
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client(
    client_ID INT PRIMARY KEY,
    client_name VARCHAR(30),
    branch_ID INT,
    FOREIGN KEY(branch_ID) REFERENCES branch(branch_ID) ON DELETE SET NULL
);

CREATE TABLE works_with(
    emp_id INT,
    client_ID INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_ID),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_ID) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
    branch_ID INT,
    supplier_name VARCHAR(30),
    supply_type VARCHAR(20),
    PRIMARY KEY(branch_ID, supplier_name),
    FOREIGN KEY(branch_ID) REFERENCES branch(branch_ID) ON DELETE CASCADE
);

DESCRIBE branch_supplier;

-- DATA INSERTION --
-- CORPORATE -- 

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1965-11-17', 1000, NULL, NULL);
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-12-14');
INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-01', 1002, 100, 1);

UPDATE employee
SET branch_ID = 1
WHERE emp_id = 100;

SELECT *
FROM employee;

-- SCRANTON DATA --
 
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1970-02-02', 1003, 100, NULL);
INSERT INTO branch VALUES(2, 'Scranton', 101, '2000-05-03');
INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1980-10-10', 1004, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-11-10', 1005, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1970-10-12', 1006, 102, 2);


SELECT *
FROM branch;

UPDATE employee
SET branch_ID = 2
WHERE salary = 1003;

-- Stamford --
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1966-10-13', 1007, 101, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1999-11-12');

UPDATE employee
SET branch_ID = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andrew', 'Bernard', '1970-12-12', 1008, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1972-10-30', 1009, 106, 3);

-- Branch Supplier --
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-Ball', 'Writing Equipment');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'JT Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uniball', 'Writing Equipment');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mills', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Labels', 'Custom Forms');

SELECT * 
FROM branch_supplier;

-- Client Data --
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

SELECT *
FROM client;

-- Works_with --
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

SELECT * 
FROM works_with;

-- CHECK ALL TABLES --

SELECT * 
FROM works_with;

-- Manipulating the TheOfficeDB --

SELECT * 
FROM employee
ORDER BY salary DESC;

SELECT *
FROM employee
ORDER BY first_name, last_name;

SELECT * 
FROM employee
LIMIT 5; -- First 5 employees --

SELECT first_name AS forename, last_name AS surname
FROM employee;

SELECT DISTINCT first_name AS forename
FROM employee;

SELECT DISTINCT branch_ID AS Branches 
FROM employee;

-- FUNCTIONS --

SELECT COUNT(supervisor_ID)
FROM employee;

SELECT COUNT(emp_id)
FROM employee
WHERE birth_day >'1970-01-01';

SELECT AVG(salary)
FROM employee;

SELECT SUM(salary)
FROM employee;

SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id; -- How much did each client spend --

-- Wildcards --
SELECT * FROM client
WHERE client_name LIKE '%EX'; -- % means anything else before --

SELECT * FROM client
WHERE client_name LIKE '%Country';

SELECT * FROM branch_supplier;

SELECT * FROM branch_supplier
WHERE supplier_name LIKE '%Labels';

SELECT * FROM employee
WHERE birth_day LIKE '____-10%'; -- Each hyphen is a character, (emp born in Oct) --

SELECT * FROM client
WHERE client_name LIKE '%school'; 

-- UNION --
--Find the list of employee and branch names--

SELECT first_name AS FirstName
FROM employee
UNION
SELECT branch_name 
UNION
SELECT client_name 
FROM client;

SELECT client_name
FROM client
UNION
SELECT supplier_name
FROM branch_supplier;

SELECT total_sales
FROM works_with
UNION
SELECT salary
FROM employee;

-- JOINS IN SQL --

INSERT INTO branch VALUES(4, 'BUFFALO', NULL, NULL);

-- INNER JOIN (Have a shared column) --
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mngr_ID; 

-- LEFT JOIN (Selects all the rows from the left table) -- 
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mngr_ID; 

-- RIGHT JOIN (Selects all the rows from the right table) --
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mngr_ID;

-- FULL OUTER JOIN (Selects all the rows from the right and left table) --
-- Check some tutorial --

-- NESTED QUERIES --
--Find the name of the employees who have sold over 30k of product to single client--

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE total_sales > 30000
);

--Find all the clients handled by the branch
--that michael scott manages
--Assume you know Michael's ID

SELECT client.client_name
FROM client 
WHERE client.branch_ID IN (
    SELECT branch.branch_ID
    FROM branch
    WHERE branch.mngr_ID = 102
);


-- ON DELETE --
-- Deleting rows based on the foreign keys
-- ON DELETE SET NULL
DELETE FROM employee
WHERE emp_id = 102;

SELECT * FROM
branch;

SELECT * FROM employee;
-- ON DELETE SET CASCADE

DELETE FROM branch
WHERE branch_ID = 2;

SELECT * FROM 
branch_supplier;

-- TRIGGERS --
-- Provide a message incase of any manipulation in a database

CREATE TABLE trigger_test (
    message VARCHAR(100)
);

-- TRIGGER

DELIMITER $$
CREATE
    TRIGGER new_trigger3 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(New.first_name);
    END $$
DELIMITER ;

INSERT INTO employee VALUES(109, 'Oscar', 'Martinez', '1972-12-10', 10010, 106, 3);
INSERT INTO employee VALUES(110, 'Dwight', 'Schrute', '1973-11-10', 10011, 106, 3);
INSERT INTO employee VALUES(112, 'Kevin', 'Malone', '1974-09-10', 10012, 106, 3);

SELECT * FROM trigger_test;

