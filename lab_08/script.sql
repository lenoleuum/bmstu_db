create table if not exists users 
(
	id int not null primary key,
	nickname varchar(30) not null,
	mail varchar(40) not null,
	date_of_birth date,
	sex varchar(10) not null
);