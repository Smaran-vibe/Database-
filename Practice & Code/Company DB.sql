USE companydb;

SELECT * FROM EMPLOYEE;
SELECT * FROM department;

#q1. 10% raise for Research Department

SELECT FNAME, LNAME, SALARY, DNAME
FROM EMPLOYEE
JOIN department ON EMPLOYEE.DNO = department.DNUMBER
WHERE DNAME = 'Research';

#2 Salary statistics of Account Department 
# sum. max. min, avg for department administration 
SELECT 
    SUM(salary) AS total_budget,
    MAX(salary) AS max_salary, 
    MIN(salary) AS min_salary, 
    AVG(salary) AS avg_salary 
FROM EMPLOYEE
JOIN department ON EMPLOYEE.DNO = department.DNUMBER
WHERE department.DNAME = 'Administration';

#q3 Employees controlled by department no 5 
select FNAME,LNAME FROM Employee E 
where exists (select * from Employee e 
where e.DNO = 5 and E.SSN = e.SSN);

#Q4 Departments Having AT Least 2 Employees 

SELECT D.DNAME, COUNT(E.SSN) AS NumberOfEmployees
FROM department D
JOIN EMPLOYEE E ON D.DNUMBER = E.DNO
GROUP BY D.DNAME
HAVING COUNT(E.SSN) >= 2;


SELECT * FROM EMPLOYEE WHERE BDATE < '1999-01-01';
SELECT * FROM EMPLOYEE WHERE BDATE > '1999-01-01';
SELECT * FROM EMPLOYEE;




