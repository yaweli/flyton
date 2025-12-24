-- create first tables after docker created
create database fly;
use fly;
create table users 
 (
    id int AUTO_INCREMENT,
    username  varchar(255)  UNIQUE,
    LastName text,
    FirstName text,
    Roles json DEFAULT NULL,
    sis text,

    is_active bool DEFAULT 1, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data json DEFAULT NULL,
    PRIMARY KEY (id)
);


set @p='Zmx5MTIz'; # fly123

insert into users set id=1001,username="kic",LastName="kic",FirstName="admin",is_active=1,Roles='["admin","owner"]',sis=@p;



create table gen 
 (
    id int AUTO_INCREMENT,
    key1  varchar(255)  ,
    val1  varchar(255)  ,

    is_active bool DEFAULT 1, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data json DEFAULT NULL,
    PRIMARY KEY (id)
);



create table ses
 (
    id varchar(255) UNIQUE,
    user_id int,

    is_active bool DEFAULT 1, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data json DEFAULT NULL,
    PRIMARY KEY (id)
);


CREATE USER IF NOT EXISTS 'fly'@'%' IDENTIFIED BY '1964';
GRANT ALL PRIVILEGES ON *.* TO 'fly'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


