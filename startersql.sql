USE startersql;
SELECT * FROM users;
-- SELECT * FROM users ORDER BY date_of_birth ASC;
-- SELECT * FROM users ORDER BY name DESC;

 ALTER TABLE users add CONSTRAINT chk_dob CHECK(date_of_birth > 2026) ;
INSERT INTO users (name,email,gender,date_of_birth,salary) VALUES
('Samrat','samrat96@gmail.com','Male','2027-09-12',100000);


    