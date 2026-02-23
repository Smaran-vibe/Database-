use student;
set autocommit = 0;

Create table if not exists dept
 (
    DEPTNO INT AUTO_INCREMENT PRIMARY KEY,
    DNAME VARCHAR(100),
    LOC Varchar(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from department;
rename table dept to department;

ALTER TABLE department
ADD column PINCODE INT NOT NULL default 0;

ALTER TABLE department 
change DNAME DEPT_NAME varchar(20);
D:D:
alter table department 
modify LOC char(20);

drop table DEPARTMENT;
-- ROLLBACK;
