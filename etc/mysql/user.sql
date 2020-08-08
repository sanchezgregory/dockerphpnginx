use mysql;
CREATE USER 'store'@'localhost' IDENTIFIED BY 'store';
GRANT ALL PRIVILEGES ON *.* TO 'store'@'localhost' WITH GRANT OPTION;
CREATE USER 'store'@'%' IDENTIFIED BY 'store';
GRANT ALL PRIVILEGES ON *.* TO 'store'@'%' WITH GRANT OPTION;