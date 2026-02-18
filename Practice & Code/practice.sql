USE startersql;

 SELECT * FROM Users;
 SELECT * FROM addresses;
 SELECT * FROM admin_users;
-- SELECT users.name, addresses.city,addresses.state,addresses.pincode
-- From users
-- -- inner join addresses on users.id = addresses.user_id;
-- -- Left join addresses on users.id = addresses.user_id;
-- Right join addresses on users.id = addresses.user_id;

-- SELECT name,salary,email FROM users
-- UNION 
-- SELECT name,salary,email FROM admin_users;

-- if there is duplication

SELECT name,salary,email,'USER' as role FROM users
UNION ALL
SELECT name,salary,email, 'Admin' as role FROM admin_users;





