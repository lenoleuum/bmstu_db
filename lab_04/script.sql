-- Создать, развернуть и протестировать 6 объектов SQL CLR

-- Для тупых (aka для меня)
-- Скалярные функции возвращают одно скалярное значение для каждой строки в запросе. 
-- Агрегатные функции возвращают одно агрегированное значение для всех строк в запросе. 
-- Агрегирование в общем смысле — это объединение нескольких элементов в единое целое. 
-- Результат агрегирования называют агрегатом.

-- 1). Определяемую пользователем скалярную функцию CLR

-- По id пользователя получаем его никнейм

create or replace function get_nickname_by_id(uid int) returns varchar
as
$body$
res = plpy.execute(f"\
				   select nickname\
				   from users\
				   where id = {uid};")
if res:
	return res[0]['nickname']
$body$
language plpython3u;

select *
from get_nickname_by_id(15) as user_nickname;

-- 2). Пользовательскую агрегатную функцию CLR

-- Для пользователя по его id получаем/определяем количество плейтистов у него

create or replace function get_cnt_by_id(uid int) returns int
as
$body$
res = plpy.execute(f"\
				   select *\
				   from tag\
				   where author_id = {uid};")
if res:
	cnt = 0
	
	for elem in res:
		cnt += 1
		
	return cnt
$body$
language plpython3u;

select *
from get_cnt_by_id(15) as cnt_playlists; 

-- Для заданного жанра определяет его количество слушателей

create or replace function get_genre_listeners(gen varchar) returns int
as
$body$
res = plpy.execute(f"\
				 select genre, number_of_listeners\
				 from artists;")
				 
cnt = 0

for i in range(len(res)):
	if (res[i]['genre'] == gen):
		cnt += res[i]['number_of_listeners']
	
return cnt
$body$
language plpython3u;

select *
from get_genre_listeners('pop');

-- 3). Определяемую пользователем табличную функцию CLR

-- Выводит информацию об артистах, количество слушателей которых находится в заданном диапазоне

create or replace function get_artists(n_min int, n_max int) 
returns table (artist_name varchar(50),
			   genre varchar(20),
			   number_of_listeners int)
as
$body$
r = plpy.execute(f"\
				 select artist_name, genre, number_of_listeners\
				 from artists;")
res = []

for elem in r:
	if (n_min < elem['number_of_listeners'] < n_max):
		res.append(elem)

return res;
$body$
language plpython3u;

select *
from get_artists(4000000, 5000000);

-- Для заданного жанра выводит название жанра, имя исполнителя и количество его слушателей

create or replace function get_by_genre(gen varchar) 
returns table (genre varchar(20),
			   artist varchar(50),
			   cnt_listeners int)
as
$body$
r = plpy.execute(f"\
				   select genre, artist_name as artist, number_of_listeners as cnt_listeners\
				   from artists;")
res = []

for elem in r:
	if (elem['genre'] == gen):
		res.append(elem)
		
return res
$body$
language plpython3u;

select *
from get_by_genre('rock');

-- 4). Хранимую процедуру CLR

-- Процедура выполняет вставку нового пользователя в таблицу users

create or replace procedure insert_user(uid int,
									    nickname varchar,
									    mail varchar,
									    date_of_birth date,
									    sex varchar) 
as
$body$
dat = plpy.prepare("insert into users values($1, $2, $3, $4, $5)", ["int", "varchar", "varchar", "date", "varchar"])
res = plpy.execute(dat, [uid, nickname, mail, date_of_birth, sex])
$body$
language plpython3u;

call insert_user(1001, 'Rindo', 'rindo@mail.com', '2002-04-09', 'female');

select *
from users
where id = 1001;

-- Увеличивает количество слушателей у исполнителей заданного жанра в переданное число раз

create or replace procedure update_artists(gen varchar, coef real)
as
$body$
plan = plpy.prepare(f"update artists\
					  set number_of_listeners = number_of_listeners * $1\
					  where genre = $2", ["numeric", "varchar"])
rv = plpy.execute(plan, [coef, gen])
$body$
language plpython3u;

select *
from artists
where genre = 'pop';

call update_artists('pop', 1.5);

select *
from artists
where genre = 'pop';

-- Функция plpy.prepare подготавливает план выполнения для запроса. 
-- Она вызывается со строкой запроса и списком типов параметров (если в запросе есть параметры).
-- Чтобы запустить подготовленный оператор на выполнение, используйте вариацию функции plpy.execute:
-- Передайте план в первом аргументе (вместо строки запроса), а список значений, которые будут подставлены в запрос, — во втором. 
-- Второй аргумент можно опустить, если запрос не принимает никакие параметры. 

-- 5). Триггер CLR

create view songs_copy as
select *
from songs;

-- (Мягкое удаление) Вместо того, чтобы удалять песню из таблицы songs, удаляем ее из всех плейлистов, в которые она добавлена
-- (удаляем все строки с ней из tag)

create or replace function del_songs()
returns trigger
as $$
old_name = TD["old"]["song_name"]
old_artist = TD["old"]["artist"]

plan = plpy.prepare("delete from tag\
				     where tag.song_name = $1 and tag.artist_name = $2", ["varchar", "varchar"])

rv = plpy.execute(plan, [old_name, old_artist])
				  
return TD["new"]
$$ language plpython3u;

create trigger del_song_trigger instead of delete on songs_copy
for each row execute procedure del_songs();

-- Проверка

select *
from songs_copy
where song_name = 'Creep' and artist = 'H.I.M1';

select *
from tag
where song_name = 'Creep' and artist_name = 'H.I.M1';

delete from songs_copy
where song_name = 'Creep' and artist = 'H.I.M1';

select *
from tag
where song_name = 'Creep' and artist_name = 'H.I.M1';

-- 6). Определяемый пользователем тип данных CLR

-- Тип содержит информацию об исполнителе: имя, жанр и кол-вл слушателей

create type artist_info as
(
	name varchar,
	genre varchar,
	num_listeners int
);

-- Полцчает информацию обо всех исполнителях, у которых есть песни заданной категории

create or replace function get_artists_in_category(cat varchar) 
returns table (dat artist_info)
as
$body$
plan = plpy.prepare("\
					select artist as name, genre, number_of_listeners as num_listeners\
				    from songs join artists on songs.artist = artists.artist_name\
					where category = $1;", ["varchar"])
					
rv = plpy.execute(plan, [cat]) 
return rv
$body$
language plpython3u;

select *
from get_artists_in_category('for children');

-- Проверка

select artist as name, genre, number_of_listeners as num_listeners
from songs join artists on songs.artist = artists.artist_name
where category = 'for children';

-- Получает информацию об артисте с наибольшим количеством слушателей

create or replace function get_artists_max() 
returns artist_info
as
$body$
rv = plpy.execute(f"\
				  select artist_name as name, genre, number_of_listeners as num_listeners\
				  from artists;")
				  
val = plpy.execute(f"\
				   select max(number_of_listeners) as n_max\
				   from artists;")	   
for elem in rv:
	if (elem["num_listeners"] == val[0]["n_max"]):
		return (elem["name"], elem["genre"], elem["num_listeners"])
$body$
language plpython3u;

select *
from get_artists_max();

-- Проверка

select artist_name as name, genre, number_of_listeners as num_listeners
from artists
where number_of_listeners = (select max(number_of_listeners)
							 from artists);
							 