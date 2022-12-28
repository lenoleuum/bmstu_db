create table if not exists EmplVisits
(
	Department varchar,
	FIO varchar,
	D_date date,
	Status varchar
);

insert into EmplVisits(Department, FIO, D_date, Status) values('ИТ', 'Иванов Иван Иванович', '2020-01-15', 'Больничный');
insert into EmplVisits(Department, FIO, D_date, Status) values('ИТ', 'Иванов Иван Иванович', '2020-01-16', 'На работе');
insert into EmplVisits(Department, FIO, D_date, Status) values('ИТ', 'Иванов Иван Иванович', '2020-01-17', 'На работе');
insert into EmplVisits(Department, FIO, D_date, Status) values('ИТ', 'Иванов Иван Иванович', '2020-01-18', 'На работе');
insert into EmplVisits(Department, FIO, D_date, Status) values('ИТ', 'Иванов Иван Иванович', '2020-01-19', 'Оплачивемый отпуск');
insert into EmplVisits(Department, FIO, D_date, Status) values('ИТ', 'Иванов Иван Иванович', '2020-01-20', 'Оплачивемый отпуск');
insert into EmplVisits(Department, FIO, D_date, Status) values('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-15', 'Оплачивемый отпуск');
insert into EmplVisits(Department, FIO, D_date, Status) values('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-16', 'На работе');
insert into EmplVisits(Department, FIO, D_date, Status) values('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-17', 'На работе');
insert into EmplVisits(Department, FIO, D_date, Status) values('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-18', 'На работе');
insert into EmplVisits(Department, FIO, D_date, Status) values('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-19', 'Оплачивемый отпуск');
insert into EmplVisits(Department, FIO, D_date, Status) values('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-20', 'Оплачивемый отпуск');


create or replace function fn_get_time_intervals()
returns table
(
	Department varchar,
	FIO varchar,
	DateFrom date,
	DateTo date,
	Status varchar
)
as
$body$
sel = plpy.execute(f"\
				   select row_number() over(partition by FIO) as num, Department, FIO, D_date as DateFrom, D_date as DateTo, Status\
				   from EmplVisits;") # row_number, чтобы сначала шла вся инфа об одном сотруднике, потом о другом
				   
res = []
res.append(sel[0])
cur_status = sel[0]['status']
cur_fio = sel[0]['fio']

for i in range (len(sel)):
	if (sel[i]['status'] != cur_status or sel[i]['fio'] != cur_fio):
		res[-1]['dateto'] = sel[i - 1]['datefrom']
		res.append(sel[i])
		
		cur_status = sel[i]['status']
		cur_fio = sel[i]['fio']
		
res[-1]['dateto'] = res[-1]['datefrom']
		
return res
$body$
language plpython3u;

select *
from fn_get_time_intervals()