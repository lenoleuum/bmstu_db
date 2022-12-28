-- Написать запрос, получающий статистическую информацию на основе
-- данных БД.

-- Получение количества исполнителей каждого жанра

select genre, count(*) as cnt_artists
from artists
group by genre

-- Жанр с наибольшим числом слушателей

with cte(gen, cnt_listeners)
as
(
	select genre, sum(number_of_listeners)
	from artists
	group by genre
)

select *
from cte
where cnt_listeners = (select max(cnt_listeners)
					   from cte)
					   
-- 5 самых прослушиваемых жанров

with cte(gen, cnt_listeners)
as
(
	select genre, sum(number_of_listeners)
	from artists
	group by genre
)

select *
from cte
order by cnt_listeners desc
limit 5