CHANGE MASTER TO
MASTER_HOST='192.168.1.103' ,
MASTER_USER='slave' ,
MASTER_PASSWORD='test1' ,
MASTER_LOG_FILE='mysql-bin.000092' ,
MASTER_LOG_POS=154;


CREATE USER 'slave'@'192.168.1.102' IDENTIFIED BY 'test1';

GRANT REPLICATION SLAVE ON *.*TO 'slave'@'192.168.1.102';

SELECT User, Host FROM mysql.user;

FLUSH PRIVILEGES;

create database demo2;


use demo3;
CREATE TABLE master_check1 (
 name varchar(50),
 age int,
 address varchar(50)
);

INSERT INTO master_check1 (Name,Age,Address) VALUES ('kendanic',26, 'chennai,tamilnadu');


describe master_check1;

INSERT INTO master_check1 VALUE('senthil', 30,'double room');

INSERT INTO master_check1 VALUE('kent', 15,'droom');

SELECT COUNT(*) FROM master_check1;