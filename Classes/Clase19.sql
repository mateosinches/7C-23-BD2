-- Active: 1654168274613@@127.0.0.1@3306
#1
CREATE USER data_analyst IDENTIFIED BY 'password';
select User, Host, plugin from mysql.user;

#2
GRANT SELECT, UPDATE, DELETE ON sakila.* to 'data_analyst'@'%';
SHOW GRANTS FOR 'data_analyst'@'%';

#3
CREATE TABLE troll(
	id_troll int,
	title varchar(30)
);
#mysql -udata_analyst -p
#ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'filmFake'

#4
UPDATE film SET title = 'Bondiola' WHERE film_id = 1;

#5
# sudo mysql -u root
revoke update on sakila.* from data_analyst;
show grants for 'data_analyst'@'%';

#6
UPDATE film SET title = 'Bondiola' WHERE film_id = 3;
#ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'