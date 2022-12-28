1).
--Выбрать все общедоступные плейлисты, которые были созданы пользователями младше 12 лет, мужского пола

select users.id, users.nickname, playlists.playlist_name, playlists.playlist_duration
from users join playlists on users.id = playlists.author_id
where users.date_of_birth > '2009-01-01' and users.sex = 'male'
		and playlists.privacy = 'public'
order by users.id


2).
--Выбрать все песни, которые были выпущены зимой 2020 года

select distinct song_name, artist, date_of_release
from songs
where date_of_release between '2020-01-01' and '2020-03-01'

3).
--Выбрать все песни, у которых в названии присутуствует слово be

select distinct song_name, artist, date_of_release
from songs
where songs.song_name like '%be%'

4). 
--Выбрать все песни, выпущенные артистами жанра рок в период с 2000 по 2010 год

select distinct song_name, artist, date_of_release
from songs
where date_of_release between '2000-01-01' and '2010-01-01'
      and artist in (select distinct artist_name
					from artists
					where genre = 'rock')
					
--Выбрать все песни, выпущенные артистами жанра рэп, которые имеют от 1 до 5 млн слушателей
					
select distinct song_name, artist, date_of_release
from songs
where artist in (select artist_name
				from artists
				where genre = 'rap' and number_of_listeners between 1000000 and 5000000)
				 
5).

--Вывести информацию о песнях, если существует песня, выпущенная '2002-01-01'

select song_name, category, song_duration, date_of_release
from songs
where exists (select *
			  from songs
			  where date_of_release = '2002-01-01')


select artist_name, genre, latest_release, number_of_listeners
from artists
where exists (select *
			  from artists
			  where number_of_listeners = 10059000)

6).
--Выбрать все песни, выпущенные исполнителями, которые имеют меньше слушателей, 
--чем исполнители класической музыки

select song_name, artist_name, genre, songs.song_duration
from songs join artists on songs.artist = artists.artist_name
where number_of_listeners < ALL (select number_of_listeners
								from artists
								where genre = 'classical music')
								
								
7).
--Для каждого жанра вывести max, min и среднее число слушателей данного жанра 

select genre, max(number_of_listeners) as max_num,
			min(number_of_listeners) as min_num,
			avg(number_of_listeners) as avg_num
from artists
group by genre


8).

--Вывести всех исполнителей, жанра хип-хоп с информациейей о max и среднем числе слушателей данного жанра
select artist_name, genre, number_of_listeners,
	(select avg(number_of_listeners) 
	 from artists
	 where genre = 'hip hop') as avg_number,
	 (select max(number_of_listeners)
	  from artists
	  where genre = 'hip hop') as max_number
from artists
where genre = 'hip hop'

9).

--Выбрать плейлисты, созданные после декабря 2020 года, с указаднием доступа

select playlist_name, author,
	case privacy
		when 'private' then 'access denied'
		when 'public' then 'welcome to listening'
		else 'error!'
	end as access_
from playlists
where date_of_creation > '2020-12-01'

10).

-- Выбрать песни артистов жанра поп с указанием степени их "старости" по году выпуска

select song_name, artist, genre,
	case
		when date_of_release < '1990-01-01' then 'very old'
		when date_of_release < '2010-01-01' then 'old'
		when date_of_release < '2018-01-01' then 'new'
		else 'very new'
	end as feature
from songs join artists on songs.artist = artists.artist_name
where genre = 'pop'

-- Выбрать артистов жанра поп с указанием степени их популярности по количеству слушателей

select artist_name, genre,
	case
		when number_of_listeners < 3000000 then 'locals'
		when number_of_listeners < 80000000 then 'popular'
		else 'trending now'
	end as popularity
from artists
where genre = 'pop'

11).

--Вывести во временную таблицу информацию об артистах жанра рок с указанием макс и ср числа слушателей

select song_name, artist_name, genre, number_of_listeners,
		(select avg(number_of_listeners) 
		 from artists
		 where genre = 'rock') as avg_number,
		(select max(number_of_listeners)
		 from artists
		 where genre = 'rock') as max_number
into List
from songs join artists on songs.artist = artists.artist_name
where genre = 'rock'


12).

--Список жанров, отсортированных по количеству слушателей в порядке убывания

select genre
from (select genre, avg(number_of_listeners) as avg_num
	  from artists
	  group by genre
	  order by avg_num desc) as _temp

13).
*
--Вывести информацию об артистах самого популярного жанра (с наибольшим количеством слушателей)

select distinct genre
from artists
where genre = (select genre
					 from artists
					 group by genre
					 having sum(number_of_listeners) = (select max(sq)
													    from (select sum(number_of_listeners) as sq
															  from artists
															  group by genre) as od))
															  
				
-- Для каждого жанра найти количество слушателей
				
select sum(number_of_listeners) as sq
from artists
group by genre

-- Найти максимальное число слушателей среди количество слушателей каждого жанра

select max(sq)
from (select sum(number_of_listeners) as sq
	 from artists
	 group by genre) as od
	 
	
-- Найти жанр, количество слушателей которого является максимальным
	
select genre
from artists
group by genre
having sum(number_of_listeners) = (select max(sq)
								   from (select sum(number_of_listeners) as sq
								   from artists
								   group by genre) as od)

14).

-- Для каждой песни, выпущенной в 2020 году, получить его цену, среднюю цену, 
-- минимальную цену и имя исполнителя

select song_name, avg(number_of_listeners) as avg_num, 
			min(number_of_listeners) as min_num, max(number_of_listeners) as max_n
from songs join artists on songs.artist = artists.artist_name
group by song_name

-- where date_of_release > '2020-01-01'


15).

--Получить список категорий продуктов, средняя цена которых больше общей средней цены


select artist_name, number_of_listeners, (select avg(number_of_listeners) as avg_num
										  from artists)
from artists
group by artist_name
having number_of_listeners > (select avg(number_of_listeners) as avg_num
							  from artists)


16).

--Вставка в таблицу одной строки значений

insert into songs(song_name, artist, date_of_release, song_duration, category)
values ('wonderful life', 'Bring Me The Horizon', '2017-07-10', '00:04:34', 'feats')

insert into song song_name = ''

17).

--

insert into tag(song_name, artist_name, playlist_name, author_id)
select  'Leaving this world behind', 'Starset', playlist_name,
		(select id
		 from users
		 where nickname = 'Nele')
from playlists


insert into tag(song_name, artist_name, playlist_name, author_id)
select  'Leaving this world behind', 'Starset', playlist_name,
		(select id
		 from users
		 where nickname = 'Nele')
from playlists
where author_id = (select id
				   from users
				   where nickname = 'Nele')
				   
insert into tag(song_name, artist_name, playlist_name, author_id)
select  'Leaving this world behind', 'Starset', ''
		(select id
		 from users
		 where nickname = 'Nele')
from tag
where playlist_name = ''


18).

--Увеличить количество слушателей исполнителя ABBA в 1.5 раза

update artists
set number_of_listeners = number_of_listeners * 1.5
where artist_name = 'ABBA'

19).

--Установить количество слушателей исполнителя Starset равным максимальному числу слушателей среди всех исполнителей

update artists
set number_of_listeners = (select max(number_of_listeners)
						   from artists)
where artist_name = 'Starset'



20).

--Удалить из tag все записи, в которых имя песни оканчивается символом 'a'

delete from tag
where song_name like '%a'


21).

--Удалить из tag все записи, в которых плейлист был создан пользователем с id = 20

delete from tag
where playlist_name in (select playlist_name
				    from tag
				    where author_id = 20)
					

22).

--Среднее число слушателей жанра рок (можно поменять на любой другой жанр)

with cte(artist, popular_song, number_of_listeners, category) as
(select artist_name, most_popular_track, number_of_listeners, category
from songs join artists on songs.artist = artists.artist_name
where genre = 'rock')

select avg(number_of_listeners) as avg_num
from cte


23).

--Выбрать все песни с таким же названием, что и заданная песня

with recursive _temp(artist, song, category, depth) as
(
	select artist, song_name, category, 1
	from songs as a_1
	where song_name = '24/5'
	
	union all
	
	select distinct a_1.artist, a_1.song_name, a_1.category, depth + 1
	from songs as a_1 join _temp as a_2 on a_1.song_name = a_2.song
	where depth < 4
)

select distinct artist, song, category
from _temp

24).

-- Для каждого жанра вывести среднее количество слушателей

select artist_name, genre, number_of_listeners,
		avg(number_of_listeners) over(partition by genre) as avg_num,
		min(number_of_listeners) over(partition by genre) as min_num,
		max(number_of_listeners) over(partition by genre) as max_num
from artists

partition для вывода следующей

25). 

--Придумать запрос, в результате которого в данных появляются полные дубли

select row_number() over() as row_num, song_name,
		avg(number_of_listeners) over(partition by song_name) as avg_num,
		min(number_of_listeners) over(partition by song_name) as min_num,
		max(number_of_listeners) over(partition by song_name) as max_num
from artists join songs on artists.artist_name = songs.artist
order by row_num

select row_number() over() as row_num, song_name, category,
		avg(number_of_listeners) over(partition by song_name) as avg_num,
		min(number_of_listeners) over(partition by song_name) as min_num,
		max(number_of_listeners) over(partition by song_name) as max_num
from artists join songs on artists.artist_name = songs.artist
order by row_num