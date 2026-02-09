-- 1. Create and Use
CREATE DATABASE IF NOT EXISTS dbemp1;
USE dbemp1;

-- 2. Create Table 
Drop table if exists employee;


CREATE TABLE employee (
    EmployeeID varchar(10) PRIMARY KEY, 
    FirstName varchar(20),
    LastName varchar(20),
    Gender char(1),
    DateofBirth date,
    Designation varchar(20),
    DepartmentName varchar(20),
    ManagerId varchar(10),
    JoinedDate date,
    Salary decimal(15,2) 
);
Drop table if exists customer;
CREATE TABLE customer (
customerId varchar(10) primary key,
firstName varchar(20),
lastName varchar(20),
gender char(1),
email varchar(20) unique,
city varchar (20)
);

INSERT INTO customer (customerID, firstName, lastName,gender, email, city) VALUES
('C001', 'Biraj', 'Shrestha', 'M', 'saimon@email.com', 'Lalitpur');

select orders.orderId,customer.customerId, orders.orderdate 
from orders, customer
where orders.customerId = customer.customerId;


INSERT INTO employee VALUES
('001','Season','Maharjan','M','1996-04-02','Engineer','Software engineering','002','2022-11-02', 5000000000),
('002','Srijana','Maharjan','F','2000-04-02','Manager','Software engineering','005','2025-11-02', 9000000),
('003','Smaran','Aryal','M','1996-04-02','CEO','Software engineering','001','2022-11-02', 9000000000);

-- 4. Update Gender
UPDATE employee SET Gender = 'M' WHERE EmployeeID = '003';

-- 5. Age Logic
SELECT FirstName, CURDATE(), DateofBirth, 
TIMESTAMPDIFF(YEAR, DateofBirth, CURDATE()) as age 
FROM employee 
WHERE TIMESTAMPDIFF(YEAR, DateofBirth, CURDATE()) >= 25;

-- 8 & 9. Dept-wise Salary
SELECT DepartmentName, MAX(Salary) as MaxSalary FROM employee GROUP BY DepartmentName;
SELECT DepartmentName, MIN(Salary) as MinSalary FROM employee GROUP BY DepartmentName;

 -- 10. List employees who act as managers
-- Logic: Find IDs that appear in the 'ManagerId' column

SELECT * FROM employee 
WHERE EmployeeID IN (SELECT DISTINCT ManagerId FROM employee);

Update employee set FirstName = 'Saimon Shrestha' where EmployeeID = "001"; 
 SELECT * FROM employee where employeeID = '001';
 
Update employee set FirstName = 'Mohan Dai' where EmployeeID = '002';
select * from employee where employeeID = '002';

select * from employee 
where FirstName Like 's%';

select * from employee 
where FirstName Like '%n';

 SELECT FirstName, LastName FROM employee 
 WHERE Salary > 1000 
 LIMIT 2;
 
 select orders.orderId,
 customers.customerId, order.orderdate,
 from orders, customer 
 where orders.customerId = customer.customerId;




