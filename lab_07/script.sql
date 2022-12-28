create table artist_json (dat json);

insert into artist_json
select row_to_json(ar)
from artists as ar;