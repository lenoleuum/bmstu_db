create database lab_01;

create table if not exists users (
	id int not null primary key,
	nickname varchar(30) not null,
	mail varchar(40) not null,
	date_of_birth date,
	sex varchar(10) not null
);

copy users(id, nickname, mail, date_of_birth, sex) from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_01\csv\user.csv' delimiter ',' csv;
copy users(id, nickname, mail, date_of_birth, sex) from 'C:\data\csv\user.csv' delimiter ',' csv;

create table if not exists playlists (
	playlist_name varchar(50) not null,
	author varchar(50) not null, --
	author_id int not null,
	primary key(playlist_name, author_id),
	foreign key(author_id) references users(id), 
	playlist_duration time,
	privacy varchar(10) not null,
	date_of_creation date
);

copy playlists(playlist_name, author, author_id, playlist_duration, privacy, date_of_creation) from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_01\csv\playlist.csv' delimiter ',' csv;
copy playlists(playlist_name, author, author_id, playlist_duration, privacy, date_of_creation) from 'C:\data\csv\playlist.csv' delimiter ',' csv;

create table if not exists artists (
	artist_name varchar(50) not null primary key,
	genre varchar(20) not null,
	link varchar(51) not null,
	number_of_listeners int, 
	most_popular_track varchar(50) not null,
	latest_release varchar(50) not null
);

copy artists(artist_name, genre, number_of_listeners, link, most_popular_track, latest_release) from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_01\csv\artist.csv' delimiter ',' csv;
copy artists(artist_name, genre, number_of_listeners, link, most_popular_track, latest_release) from 'C:\data\csv\artist.csv' delimiter ',' csv;

create table if not exists songs (
	song_name varchar(50) not null,
	artist varchar(50) not null,
	primary key(song_name, artist),
	foreign key(artist) references artists(artist_name),
	date_of_release date,
	song_duration time,
	category varchar(30) not null
);

copy songs(song_name, artist, date_of_release, song_duration, category) from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_01\csv\song.csv' delimiter ',' csv;
copy songs(song_name, artist, date_of_release, song_duration, category) from 'C:\data\csv\song.csv' delimiter ',' csv;

create table if not exists tag (
	song_name varchar(50) not null,
	artist_name varchar(50) not null,
	playlist_name varchar(50) not null,
	author_id int not null,
	foreign key(song_name, artist_name)references songs(song_name, artist),
	foreign key(playlist_name, author_id)references playlists(playlist_name, author_id)
);

copy tag(song_name, artist_name, playlist_name, author_id) from 'C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_01\csv\tag.csv' delimiter ',' csv;
copy tag(song_name, artist_name, playlist_name, author_id) from 'C:\data\csv\tag.csv' delimiter ',' csv;
