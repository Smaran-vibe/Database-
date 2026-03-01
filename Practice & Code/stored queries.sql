Use startersql;

DELIMITER $$
-- CREATE PROCEDURE select_users()

	CREATE procedure ADDUSER(
	IN p_name varchar(20),
	IN p_email varchar(30),
	In p_gender enum ('Male','Female','Other'),
	IN p_dob date,
	IN p_salary INT
	)
	BEGIN
	INSERT INTO users (name,email,gender,date_of_birth,salary)
	VALUES (p_name, p_email, p_gender, p_dob, p_salary);
	SELECT * FROM users;

	-- SELECT * FROM users;
	End $$
	DELIMITER ;

	-- CALL select_users();
	-- CALL ADDUSER ('Samar Kun','madamji60@gmail.com','male','2007-12-09','69000');
    CALL ADDUSER ('Bipin Danga','Embassy@gmai.com','other','2006-10-21','96000');

