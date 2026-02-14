USE startersql;
SET autocommit = 0;
SELECT * FROM users;

-- DELETE FROM users where id = 3;
commit;
-- ROLLBACK;
-- DELETE FROM users where id = 3;

-- SELECT COUNT(*) FROM users WHERE gender = 'male';
-- SELECT * FROM users ORDER BY date_of_birth ASC;
-- SELECT * FROM users ORDER BY name DESC;
 
 -- ALTER TABLE
--  ALTER TABLE users add CONSTRAINT chk_dob CHECK(date_of_birth > 2026) ;
-- INSERT INTO users (name,email,gender,date_of_birth,salary) VALUES
-- ('Samrat','samrat96@gmail.com','Male','2027-09-12',100000);
 
 -- Insert table 
-- INSERT INTO users (name,email,gender,date_of_birth,salary) VALUES
-- ('Mohan','Mohan96@gmail.com','Male','2021-09-12',90000);

-- UPDATE users SET email ='Mohan09@gmail.com' WHERE id = 30;
-- SELECT * FROM users ORDER BY gender ASC;

-- DELETE FROM users WHERE email = 'Mohan09@gmail.com';

-- SELECT * FROM Clients;
-- INSERT INTO Clients (user_id, name, email, gender, date_of_birth)
-- VALUES
-- (1, 'Ram Shrestha', 'ram1@example.com', 'MALE', '1998-05-14'),
-- (1, 'Sita Karki', 'sita1@example.com', 'FEMALE', '2000-09-22'),
-- (2, 'Aarav Gurung', 'aarav1@example.com', 'MALE', '1995-12-03');




-- DROP TABLE Clients;
-- SHOW TABLES;

-- Join
-- SELECT users.name AS user_name,
-- Clients.name AS client_name
-- FROM users
-- JOIN Clients 
-- ON users.id = Clients.user_id;

-- SELECT users.id,
-- users.name AS user_name,
-- Clients.name AS client_name
-- FROM users
-- LEFT JOIN Clients
-- ON users.id = Clients.user_id;

-- SELECT users.name AS user_name,
-- Clients.name AS client_name
-- FROM users
-- RIGHT JOIN Clients
-- ON users.id = Clients.user_id;

-- SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM users;
-- SELECT SUM(salary) AS TOtal_salary FROM users;
-- SELECT AVG(salary) As Avg_Salary From users;
-- SELECT gender,AVG(salary) AS Avg_Salary FROM users GROUP BY gender;

-- SELECT id,gender, Lower(name) as lower,Concat(Lower(name),"4303") AS User_name, Year(date_of_birth) as YOB,length(name) as name_len FROM users;
-- SELECT salary,
--        ROUND(salary) AS rounded,
--        FLOOR(salary) AS floored,
--        CEIL(salary) AS ceiled
-- FROM users;
















 

    