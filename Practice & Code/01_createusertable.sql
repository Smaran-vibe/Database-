 CREATE DATABASE IF NOT EXISTS startersql;
USE startersql;

CREATE TABLE users (
     id INT AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
     gender ENUM('Male', 'Female', 'Other'),
     date_of_birth DATE,
    salary DECIMAL(10, 2),
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     );
     
CREATE TABLE IF NOT EXISTS Clients(
id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT,
name varchar(100) NOT NULL,
email Varchar(100) UNIQUE NOT NULL,
gender enum ('MALE','FEMALE','OTHER'),
date_of_birth DATE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE
ON UPDATE CASCADE
);
