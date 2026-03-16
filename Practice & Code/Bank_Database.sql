CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;


CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00
);

insert into accounts values
(1,'Roronoa',50000),
(2,'Shyam',60000),
(3,'Luffy',70000);

start transaction;
update accounts 
set balance = balance - 5000 
where account_id = 1 ; 

update accounts 
set balance = balance + 5000 
where account_id = 2 ; 
commit;

select * from accounts;

-- rollback 
start transaction;
update accounts 
set balance = balance - 5000 
where account_id = 2 ; 

update accounts 
set balance = balance + 5000 
where account_id = 3 ; 
rollback;

select * from accounts;
# Savepoint while updating account balances.

start transaction;
update accounts 
set balance = balance - 2000
where account_id = 3; 
savepoint sp1;
update accounts set balance = balance + 2000
where account_id = 2; 
rollback to sp1; 
commit;

select * from accounts; 

create table if not exists employees (
emp_id int auto_increment primary key,
name varchar (100),
salary decimal(10,2));

# create a salary_log 
create table salary_log (
log_id int auto_increment primary key,
emp_id int,
old_salary decimal(10,2),
new_salary decimal(10,2),
update_at timestamp default current_timestamp
);

DELIMITER //
CREATE trigger check_salary
before insert on employees
for each row 
begin 
if new.salary < 10000 then 
signal sqlstate '45000'
set message_text = "salary must be atleast 10000";
end if; 
end //

DELIMITER ;

DELIMITER //
create trigger log_salary_update
after update on employees
for each row 
begin
insert into salary_log(emp_id,old_salary,new_salary)
values (old.emp_id,old.salary,new.salary);
end //
Delimiter ;

#Stored Procedure 
#Create a stored procedure that retrieves 
#all records from the employees table. 

DELIMITER // 
Create procedure getEmployees()
begin 
select * from employees;
end // 
DELIMITER ;
call getEmployees();

# Create a stored procedure that inserts 
# a new employee into the employees table 
# using parameters 

DELIMITER //
create procedure addEmployee(
IN p_id int,
IN p_name varchar(100),
IN p_salary decimal(10,2)
)
begin 
insert into employees values (p_id,p_name,p_salary);
end //
DELIMITER ;

call addEmployee (1,'Mohan',2000000);






 






















 
