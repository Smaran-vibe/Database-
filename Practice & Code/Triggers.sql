USE startersql;

DELIMITER $$
-- CREATE PROCEDURE select_users()
    CREATE TRIGGER after_user_insert
    AFTER insert on users
    FOR EACH ROW
	
	BEGIN
	INSERT INTO user_log (user_id,name)
	VALUES (New.id,New.name);
	


	End $$
	DELIMITER ;
	INSERT INTO users (name,email,gender,date_of_birth,salary) values
     ('Samar Shakya','madam60@gmail.com','male','2005-12-09','96000');
  