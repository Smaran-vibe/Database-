CREATE DATABASE Student;
use Student;

CREATE TABLE Vidharthi (
    id INT PRIMARY KEY, 
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE
);

CREATE TABLE Std_Course (
    Course_code INT PRIMARY KEY, 
    std_id INT,
    subject VARCHAR(100) NOT NULL,
    FOREIGN KEY (std_id) REFERENCES Vidharthi(id) ON DELETE CASCADE
);

INSERT INTO Vidharthi (id, name, email, gender, date_of_birth) VALUES 
(101, 'Biraj', 'biraj@email.com', 'Male', '2002-05-15'),
(102, 'Sara', 'sara@email.com', 'Female', '2003-08-22'),
(103, 'Alex', 'alex@email.com', 'Other', '2001-12-10');


INSERT INTO Std_Course (Course_code, std_id, subject) VALUES 
(5001, 101, 'Java Programming'),
(5002, 101, 'Database Systems'),
(5003, 102, 'Web Development'),
(5004, 103, 'Machine Learning');

SELECT * FROM vidharthi;
SELECT * FROM Std_Course;