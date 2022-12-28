create table Table1(
	id int,
	var1 char,
	date_from date,
	date_to date
);

create table Table2(
	id int,
	var2 char,
	date_from date,
	date_to date
);

insert into Table1 values(1, 'A', '2018-09-01', '2018-09-15');
insert into Table1 values(1, 'B', '2018-09-16', '5999-12-31');

insert into Table2 values(1, 'A', '2018-09-01', '2018-09-18');
insert into Table2 values(1, 'B', '2018-09-19', '5999-12-31');

select Table1.id, Table1.var1, Table2.var2, least(Table1.date_to, Table2.date_to), greatest(Table1.date_from, Table2.date_from)
from Table1
join Table2 on Table1.date_from < Table2.date_to and Table1.date_to > Table2.date_from;