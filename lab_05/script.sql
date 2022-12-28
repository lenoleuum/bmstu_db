-- 1). Из таблиц базы данных, созданной в первой лабораторной работе, извлечь данные в JSON

-- Из всех таблиц извлекла данные в json

select row_to_json(u) as users_json
from users u

select row_to_json(ar) as artists_json
from artists ar

select row_to_json(pl) as playlists_json
from playlists pl

select row_to_json(s) as songs_json
from songs s

select row_to_json(tag) as tag_json
from tag

-- Извлекла атрибуты имя артитста, жанр, кол-во слушателей в json

select row_to_json(ar)
from (select artist_name, genre, number_of_listeners
	  from artists) as ar
	  
	  
-- 2). Выполнить загрузку и сохранение JSON файла в таблицу

-- Создаем таблицу-копию, куда будем загружать json файл

create table if not exists artists_copy (
	artist_name varchar(50) not null primary key,
	genre varchar(20) not null,
	link varchar(51) not null,
	number_of_listeners int, 
	most_popular_track varchar(50) not null,
	latest_release varchar(50) not null
);

-- Выгружаем данные из таблицы artists, чтобы загрузить потом в artists_copy (json кортежи)

copy
(
	select row_to_json(ar)
	from artists as ar
) to 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\json\artists.json';

-- Создаем таблицу, в которую загружаем json кортежи из artists.json

create table if not exists artists_json(data_artists json);

copy artists_json from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\artists.json';  

select *
from artists_json;

-- Загружаем в таблицу artists_copy сконвертированные из json данные из таблицы artists_json

-- json_populate_record(base anyelement, from_json json) - разворачивает объект из from_json 
-- в табличную строку, в которой столбцы соответствуют типу строки, заданному параметром base 

-- from artists_json - обращаемся к таблице artists_json, а в качестве аргумента указываем один из столбцов типа json

insert into artists_copy
select artist_name, genre, link, number_of_listeners, most_popular_track, latest_release
from artists_json, json_populate_record(null::artists_copy, data_artists);

select *
from artists_copy;

drop table artists_json;
drop table artists_copy;


-- 3). Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или добавить атрибут с типом JSON к уже существующей таблице. 
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.

-- добавила в таблицу playlists столбец "категория"

alter table playlists add category json;
				
-- сгенерировала json файл с именем плейлиста и его категорией и скопировала его во временную таблицу
				
create table if not exists json_temp(dat json);

copy json_temp from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\csv\category.json' ;

-- обновила столбец "категория" таблицы playlist по имени плейлиста

update playlists
set category = (select category
				from json_temp, json_populate_record(null::playlists, dat)
				where playlists.playlist_name = playlist_name);
				
select *
from playlists;

drop table json_temp;

-- 4.1). Извлечь JSON фрагмент из JSON документа

-- из artist.json извлечем имя исполнителя, его жанр и кол-во слушателей

create table if not exists artists_info
(
	artist_name varchar(50),
	genre varchar(20),
	num_listeners int
);

create table if not exists  json_temp(dat jsonb);

copy json_temp from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\csv\artist.json' ;

select artist_name, genre, number_of_listeners
from json_temp, json_populate_record(null::artists_info, dat);

-- Информация об исполнителях, имя которых начинается и заканчивается на "а"

select artist_name, genre, number_of_listeners
from json_temp, json_populate_record(null::artists_info, dat)
where artist_name like 'A%a';

-- 4.2). Извлечь значения конкретных узлов или атрибутов JSON документа

-- Извлекаем имена исполнителей и их жанр с помощью оператора -> (выдаёт поле объекта JSON по ключу)

select dat->'artist_name' as artist_name, dat->'genre' as genre
from json_temp;

-- 4.3). Выполнить проверку существования узла или атрибута

create table if not exists tag_json(dat jsonb);

copy tag_json from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\csv\tag.json' ;

-- Проверить, есть ли у пользователя с заданным id какие-то плейлисты

create or replace function check_id(u_id jsonb) returns boolean
as
$body$
declare 
	existance boolean;
begin
	select into existance
	case
		when res.cnt > 0
			then true
		else false
	end
	from
	(
		select count(dat->'author_id') as cnt
		from tag_json
		where dat->'author_id' @> u_id
	) as res;
	
	return existance;
end;
$body$
language plpgsql;

select check_id('132') as existance;

-- для проверки

select count(dat->'author_id') as cnt
from tag_json
where dat->'author_id' @> '132';


-- 4.4). Изменить JSON документ

create table if not exists  json_temp(dat jsonb);

copy json_temp from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\csv\artist.json' ;

select dat->'artist_name' as artist, dat->'genre' as genre, dat->'number_of_listeners' as num_listeners
from json_temp
where (dat->'number_of_listeners')::int < 1000000;

-- С помощью операции || (Соединяет два значения json в новое значение json) 
-- везде, где кол-во слушателей < 1'000'000, изменяем жанр на "not defined"

update json_temp
set dat = dat || '{"genre":"not defined"}'
where (dat->'number_of_listeners')::int < 1000000;

select dat->'artist_name' as artist, dat->'genre' as genre, dat->'number_of_listeners' as num_listeners
from json_temp
where (dat->'number_of_listeners')::int < 1000000;

-- Измененные данные выгружаем в исходный файл (я выгрузила в новый, чтоб те данные не поломать пока поиграюсь)

copy
(
	select *
	from json_temp
) to 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\json\artists_upd.json';


-- 4.5). Разделить JSON документ на несколько строк по узлам (?)

create table json_ag(dat json);

copy json_ag from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_05\csv\ag.json';

select jsonb_array_elements(dat::jsonb)
from json_ag;

-- jsonb_array_elements разворачивает массив JSON в набор значений JSON

-- Чем json отличается от jsonb?