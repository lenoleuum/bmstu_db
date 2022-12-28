-- 1). скалярная функция

-- Вычиляет разницу между переданным количеством слушателей и средним кол-вом слушателей

create or replace function difference(num_listeners int) returns int as 
$BODY$
begin
	return abs(num_listeners - (select avg(number_of_listeners) from artists));
end;
$BODY$
language plpgsql;

select artist_name, genre, difference(number_of_listeners) as dif
from artists;

-- 2). подставляемая табличная функция

-- Для каждого жанра выводит название жанра, количество слушателей и количество исполнителей

create or replace function get_genres()
returns table(gen varchar(20), num_listeners int, cnt_artists int) as
$BODY$
begin
	return query(select genre, max(number_of_listeners), cast(count(artist_name) as int) 
	from artists
	group by genre);
end;
$BODY$
language plpgsql;

select *
from get_genres();

-- count / sum возвращают bigint

-- 3). многооператорная табличная функция

-- Выводит информацию о песнях двух заданных категорий

create or replace function get_songs_by_category(category_1 varchar(30), category_2 varchar(30))
returns table (out_song varchar(50),
			   out_artist varchar(50),
			   out_duration time)
as 
$body$
begin
	return query 
	select song_name, artist, song_duration
	from songs
	where category = category_1
	order by song_duration;
	
	return query 
	select song_name, artist, song_duration
	from songs
	where category = category_2
	order by song_duration;
end;
$body$
language plpgsql; 

select *
from get_songs_by_category('charts', 'for children');

-- Выводит информацию о плейлистах с max и min количеством песен в них

create or replace function get_playlists_max_min ()
returns table(_p_name varchar(50), _author_id int, _cnt_songs int)
as
$BODY$
begin
	return query
	select *
	from (select tag.playlist_name, tag.author_id, cast(count(*) as int) as cnt_songs
		  from tag join playlists on tag.playlist_name = playlists.playlist_name
		  group by tag.playlist_name, tag.author_id) as t_1
	where cnt_songs = (select max(t_2.cnt)
					   from (select playlist_name, count(*) as cnt
							 from tag
							 group by playlist_name) as t_2);
							 
	return query
	select *
	from (select tag.playlist_name, tag.author_id,  cast(count(*) as int) as cnt_songs
		  from tag join playlists on tag.playlist_name = playlists.playlist_name
		  group by tag.playlist_name, tag.author_id) as t_1
	where cnt_songs = (select min(t_2.cnt)
					   from (select playlist_name, count(*) as cnt
							 from tag
							 group by playlist_name) as t_2);
end;
$BODY$
language plpgsql;

select * 
from get_playlists_max_min()

-- 4). рекурсивная функция или функция с рекурсивным ОТВ

alter table users add invited_id int -- user, который позвал в spotify aka друг (если null, значит сам скачал)

update users
set invited_id = random()*(1001 - 1) + 1; -- случайное число от 1 до 1000

-- Выводит информацию обо всех пользователях, приглашенных пользователем с _id

create or replace function get_invited_by_id(_id int) returns table(_user_id int, _id_who_invited int, _level int)
as
$body$
begin
	return query
	(with recursive rec_cte(user_id, id_who_invited, level)
     as
	 (select id, invited_id, 1 as level
	  from users as anchor
	  where id = _id

	  union all

	  select anchor.id, anchor.invited_id, level + 1
	  from users as anchor join rec_cte as iter on anchor.invited_id = iter.user_id
	 )
		
	 select * 
	 from rec_cte);
end;
$body$
language plpgsql;

select *
from get_invited_by_id(99);

-- 5). хранимая процедура без параметров или с параметрами

-- с параметрами

-- Добавляет в заданный плейлист новую песню (из songs), т.е (добавляет в tag новую строку с уже существующими данными)

create or replace procedure insert_data(song varchar(50), artist varchar(50), playlist varchar(50), author int)
language plpgsql
as
$body$
	insert into tag values(song, artist, playlist, author);
$body$;

call insert_data('willow', 'Skillet', 'playlist_1', 772);

-- без параметров
-- Увеличивает количество слушателей у тех артистов, название последнего релиза которых заканчивается на 'a'

create or replace procedure update_data()
language plpgsql
as
$body$
begin
	update artists
	set number_of_listeners = number_of_listeners * 1.5
	where latest_release like '%a';
end
$body$

select *
from artists
where latest_release like '%a';

call update_data();

select *
from artists
where latest_release like '%a';

-- 6). рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ

-- invited_id - пользователь, который вас позвал в spotify

-- За каждого приглашенного нового пользователя, пользоватеть _id получает награду
-- За самого себя (т.е. регистрация) получает 250 дополнительный часов прослушивания
-- Далее по убвающей, чем ниже в дереве приглашений пользователь, тем меньше награда

create or replace procedure get_award(award inout int, _id int, coef float default 1.0)
as
$body$
declare 
	elem users;
begin
	award = award + 250 * coef;
	
	if (coef <= 0) 
		then coef = 0.1;
	end if;
	
	for elem in
		select *
		from users
		where invited_id = _id
		loop
			call get_award(award, elem.id, coef - 0.1);
			raise info 'For inviting user with id = %, you get % free hours', elem.id, cast(250 * (coef - 0.1) as int);
		end loop;
end;
$body$
language plpgsql;

call get_award(0, 99);

-- для проверки (все пользователи приглашенные id = 99 и он сам)

with recursive rec_cte(user_id, id_who_invited, level)
as
(select id, invited_id, 1 as level
 from users as anchor
 where id = 99

 union all

 select anchor.id, anchor.invited_id, level + 1
 from users as anchor join rec_cte as iter on anchor.invited_id = iter.user_id
)
		
select * 
from rec_cte

-- 7). хранимая процедура с курсором

-- Для заданного плейлиста выводится имя песни из него и количество плейлистов, в которых она пристуствует

create or replace procedure with_cursor(p_name varchar(50))
as
$body$
declare
	curs cursor for
		select song_name
		from tag
		where playlist_name = p_name;
		
	elem tag;
	cnt int;
begin
	raise info '[Songs from %]', p_name;
	
	open curs;
	
	loop
		fetch curs into elem;
		exit when not found;
		
		select cast(count(*) as int) into cnt
		from tag
		where song_name = elem.song_name;
		
		raise info 'Song "%" exists in % playlists', elem.song_name, cnt;
	end loop;
end;
$body$
language plpgsql;

call with_cursor('playlist_13');

-- 8). хранимую процедуру доступа к метаданным

-- Вывод информации об атрибутах: имя и тип

create or replace procedure meta_data_access(t_name varchar(50))
as
$body$
declare
	iter record;
begin
	for iter in
		select column_name, data_type
		from information_schema.columns
		where table_name = t_name
	loop
		raise notice 'Column name = %, data type = %', iter.column_name, iter.data_type;
	end loop;	
end;
$body$
language plpgsql;

call meta_data_access('artists');

-- 9). триггер after

-- После добавления нового артиста, его последний и самый популярный треки заносятся в таблицу songs
-- с дефолтными полями date_of_release, song_duration, category. Выдаем напоминание, что их надо не забыть поменять

create or replace function after_insert() returns trigger
as
$body$
begin
	raise notice 'New artist = %', new.artist_name;
	raise notice 'Do not firget to change default attributes!';
	
	insert into songs(song_name, artist, date_of_release, song_duration, category)
	values(new.latest_release, new.artist_name, '01-01-2000', '00:01:00', 'charts');
	
	insert into songs(song_name, artist, date_of_release, song_duration, category)
	values(new.most_popular_track, new.artist_name, '01-01-2000', '00:01:00', 'charts');
	
	return new; 
end;
$body$
language plpgsql;

create trigger t_after_insert after insert on artists
for each row execute function after_insert();

insert into artists(artist_name, genre, link, number_of_listeners, most_popular_track, latest_release)
values ('Blind Channel', 'rock', '@blindchannel', 1236035, 'Dark Side', 'Left Outside Alone');

select *
from songs
where artist = 'Blind Channel';

-- После изменения никнейма в таблице users меняем поле author у плейлистов, созданных данным пользователем

create or replace function after_update() returns trigger
as
$body$
begin
	raise notice 'new nickname = %, old nickname was = %', new.nickname, old.nickname;
	
	update playlists
	set author = new.nickname
	where author = old.nickname;
	
	return new;
end;
$body$
language plpgsql volatile;

create trigger after_nickname_update after update on users
for each row execute function after_update()

select *
from playlists
where author = 'Botus';

update users
set nickname = 'New nickname'
where nickname = 'Botus';

select *
from playlists
where author = 'New nickname';

-- 11). триггер instead of

-- Вместо того, чтобы удалить песню из songs, удаляем ее из всех плейлистов
-- (удаляем все записи в tag, где присутствует эта песня)

-- view для проверки

create view songs_new as
select *
from songs;

create or replace function instead_of_del() returns trigger
as
$body$
begin
	raise notice 'The song % - % will be deleted from all playlists!', old.song_name, old.artist;
	
	delete from tag
	where song_name = old.song_name and artist_name = old.artist;
	
	return new;
end;
$body$
language plpgsql volatile;

create trigger instead_of_del instead of delete on songs_new
for each row execute function instead_of_del();

select *
from tag
where song_name = 'Jail' and artist_name = 'Dava'

delete from songs_new
where song_name = 'Jail' and artist_name = 'Dava'

select *
from tag
where song_name = 'Jail' and artist_name = 'Dava'



-- по никнейму плейлисты