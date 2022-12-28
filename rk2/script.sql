-- Задание №1

create database RK2;

create table if not exists driver
(
	id int primary key,
	FIO text,
	birth_year int,
	experience int, 
	phone varchar
);

create table if not exists car
(
	id int primary key,
	id_driver int,
	model varchar,
	num int,
	color varchar,
	foreign key(id_driver) references driver(id)
);

create table if not exists flight
(
	id int not null,
	driver_id int,
	flight_date date,
	adress_1 text,
	adress_2 text,
	weight int,
	foreign key(driver_id) references driver(id)
);

copy driver(id, FIO, birth_year, experience, phone) from 'C:\data\rk\driver.csv' delimiter ',' csv;
copy car(id, id_driver, model, num, color) from 'C:\data\rk\car.csv' delimiter ',' csv;
copy flight(id, driver_id, flight_date, adress_1, adress_2, weight) from 'C:\data\rk\flight.csv' delimiter ',' csv;

-- Задание №2

-- Инструкцию SELECT, использующую простое выражение CASE

-- В простом выражении case анализируется поле модель и в зависимости от его
-- значения полю coast присваивается соответствующее значение

select id as car_id, model, color, 
	case model
		when 'fill' then 'very expensive'
		when 'money' then 'expensive'
		when 'high' then 'cheap'
		when 'poor' then 'very cheap'
	else 'middle coast' 
	end as coast
from car

--  Инструкцию, использующую оконную функцию

-- Патриционирование происходит по полю driver_id;
-- Оконная функция считает средний вес, перевозимый соответствующим driver_id
-- Запрос выдает id рейса, id водителя и средний перевозимый данным водителем вес

select id, driver_id, avg(weight) over (partition by driver_id)
from flight

-- Инструкцию SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING

-- Запрос выводит id, год рождения и средний перевозимый этим водителем вес груза для всех водителей, 
-- год рождения которых позже 1990
-- Группировка производится по id водителя и году его рождения, с помощью having выбираем водителей, 
-- родившихся посже 1990 года

select driver_id, birth_year, avg(weight)
from flight join driver on driver.id = flight.driver_id
group by driver_id, birth_year
having birth_year > 1990

-- Задание №3

-- Создать хранимую процедуру с параметром, в которой для экземпляра SQL
-- Server создаются резервные копии всех пользовательских баз данных,
-- созданных или переименованных после даты, указанной в параметре
-- процедуры. Имя файла резервной копии должно состоять из имени базы
-- данных и даты создания резервной копии, разделенных символом нижнего
-- подчеркивания. Дата создания резервной копии должна быть представлена в
-- формате YYYYDDMM. Созданную хранимую процедуру протестировать.

-- Из системного каталога pg_database, где хранится информация о доступных базах данных, выбирются
-- имена всех баз данных (поле datname содержит имя базы данных)
-- В объявленную переменную f_name(имя файла резервной копии) записывается текущие год, месяц, 
-- день и имя базы данных (с помощью операции || - конкатенация)
-- С помощью команды raise выводится замечание о том, какая база копируется и в какой файл
-- С помомощью оператора execute (нельзя без execute, т.к. команад create - динамическая)
-- делаем резервную копию

-- Не смогла найти поля с последним изменением имени/датой создания в системных каталогах 
-- в pg_stat_database есть поле stats_reset, но это не то немного вроде..

create or replace procedure backup(dat date)
as
$body$
declare 
	elem pg_database;
	f_name varchar;
begin
	for elem in
		select *
		from pg_database
	loop
		select elem.datname || '_' || extract(year from current_date)::varchar ||
		extract(month from current_date)::varchar || extract(day from current_date)::varchar
		into f_name;
				
		raise notice 'Database % is copied into file %!', elem.datname, f_name;
		
		execute 'create database ' || f_name || ' with template ' || elem.datname;
	end loop;
end;
$body$
language plpgsql;

call backup('2000-01-01');