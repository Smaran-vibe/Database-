 CREATE DATABASE  TechSolutionsDB;
 USE TechSolutionsDB;

	Create Table if not exists Department(
	DeptID INT primary key,
	DeptName varchar(30) NOT NULL,
	Location varchar(50)
	);

 CREATE TABLE Employee (
	empID INT PRIMARY KEY,
	firstname VARCHAR(50) NOT NULL,
	lastname VARCHAR(50) NOT NULL,
	gender VARCHAR(10),
	DeptID int(10),
	FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

 Create Table Project (
 ProjectID int primary key,
 ProjectName varchar(50),
 StartDate date,
 EndDate date,
 Budget Decimal(15,2),
 DeptID INT(10),        
 FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

 Create Table Works_on (
 EmpID int,
 ProjectID int,
 Primary key (EmpID, ProjectID),
 foreign key (EmpID) references Employee(empID),
 foreign key (ProjectID) references Project(ProjectID),
 HoursWorked Decimal(5,2)
 );

-- 1. Insert Departments first (Parent table)
INSERT INTO Department (DeptID, DeptName, Location) VALUES 
(101, 'IT Services', 'Lalitpur'),
(102, 'Digital Marketing', 'Kathmandu'),
(103, 'Human Resources', 'Pokhara');

-- 2. Insert Employee (References Department)
INSERT INTO Employee (empID, firstname, lastname, gender, DeptID) VALUES 
(1, 'Aayush', 'Sharma', 'Male', 101),
(2, 'Sita', 'Thapa', 'Female', 101),
(3, 'Binod', 'Chaudhary', 'Male', 102),
(4, 'Priya', 'Adhikari', 'Female', 103);

-- 3. Insert Projects (References Department)
INSERT INTO Project (ProjectID, ProjectName, StartDate, EndDate, Budget, DeptID) VALUES 
(501, 'Cloud Migration', '2024-01-01', '2024-06-30', 500000.00, 101),
(502, 'SEO Campaign', '2024-02-15', '2024-05-15', 120000.00, 102);

-- 4. Insert Works_on (References Employee AND Project)
INSERT INTO Works_on (EmpID, ProjectID, HoursWorked) VALUES 
(1, 501, 40.50),
(2, 501, 35.00),
(3, 502, 20.00);

ALTER TABLE Employee ADD COLUMN salary DECIMAL(10, 2);

UPDATE Employee SET salary = 65000.00 WHERE empID = 1;
UPDATE Employee SET salary = 72000.00 WHERE empID = 2;
UPDATE Employee SET salary = salary * 1.10 WHERE empID = 1;

SELECT * FROM Employee 
Where salary > 50000;

DELETE FROM Project 
where ProjectID = 2 ;


SELECT FirstName,LastName,Salary FROM Employee
 ORDER BY FirstName DESC;
 
SELECT E.firstname, E.lastname, D.DeptName
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
WHERE D.DeptName = 'IT Services';

SELECT D.DeptName, COUNT(E.empID) AS Total_Employees
FROM Department D
LEFT JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptName;

ALTER TABLE Employee ADD COLUMN HireDate DATE;
UPDATE Employee SET HireDate = '2023-05-10' WHERE empID = 1;
UPDATE Employee SET HireDate = '2021-11-20' WHERE empID = 2; 

SELECT firstname, HireDate FROM Employee;

UPDATE Employee SET HireDate = '2023-06-15' WHERE empID = 1;


UPDATE Employee SET HireDate = '2024-02-01' WHERE empID = 2;


UPDATE Employee SET HireDate = '2020-10-10' WHERE empID = 3;

UPDATE Employee SET HireDate = '2023-01-01' WHERE HireDate IS NULL;

SELECT firstname, lastname, HireDate 
FROM Employee 
WHERE HireDate > '2021-01-01';

SELECT E.firstname, E.lastname, D.DeptName
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID;

SELECT E.firstname, E.lastname, P.ProjectName
FROM Employee E
JOIN Works_on W ON E.empID = W.EmpID
JOIN Project P ON W.ProjectID = P.ProjectID;

SELECT P.ProjectName, SUM(W.HoursWorked) AS Total_Hours
FROM Project P
JOIN Works_on W ON P.ProjectID = W.ProjectID
GROUP BY P.ProjectName;

SELECT D.DeptName, AVG(E.salary) AS Average_Salary
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
GROUP BY D.DeptName;

SELECT D.DeptName, COUNT(E.empID) AS Employee_Count
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptName
ORDER BY Employee_Count DESC
LIMIT 1;

SELECT firstname, lastname, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);



SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE TABLE Employee;
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO Employee (empID, firstname, lastname, gender, DeptID, salary) VALUES 
(1, 'Aayush', 'Sharma', 'Male', 101, 95000.00),
(2, 'Sita', 'Thapa', 'Female', 101, 85000.00),
(3, 'Binod', 'Chaudhary', 'Male', 102, 75000.00),
(4, 'Priya', 'Adhikari', 'Female', 103, 65000.00);


SELECT * FROM Employee;



SELECT empID, firstname, salary FROM Employee;

SELECT firstname, lastname, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

SELECT * FROM Employee;
	 
	 






		




