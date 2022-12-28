from peewee import *

db = PostgresqlDatabase('lab_04', user='postgres', password='1234',
                           host='127.0.0.1', port=5432)

class BaseModel(Model):
    class Meta:
        database = db

class User(BaseModel):
    id = IntegerField(column_name = 'id', primary_key = True)
    nickname = CharField(column_name = 'nickname')
    mail = CharField(column_name = 'mail')
    date_of_birth = DateField(column_name = 'date_of_birth')
    sex = CharField(column_name = 'sex')

    class Meta:
        table_name = 'users'


class Artist(BaseModel):
    name = CharField(column_name = 'artist_name', primary_key = True)
    genre = CharField(column_name = 'genre')
    link = CharField(column_name = 'link')
    number_of_listeners = IntegerField(column_name = 'number_of_listeners')
    most_popular_track = CharField(column_name = 'most_popular_track')
    latest_release = CharField(column_name = 'latest_release')

    class Meta:
        table_name = 'artists'

class Song(BaseModel):
    name = CharField(column_name = 'song_name')
    artist = CharField(column_name = 'artist')
    date_of_release = DateField(column_name = 'date_of_release')
    duration = TimeField(column_name = 'song_duration')
    category = CharField(column_name = 'category')

    class Meta:
        table_name = 'songs'
        primary_key = CompositeKey('name', 'artist')

class Playlist(BaseModel):
    name = CharField(column_name = 'playlist_name')
    author = CharField(column_name = 'author')
    author_id = IntegerField(column_name = 'author_id') 
    duration = TimeField(column_name = 'playlist_duration')
    privacy = CharField(column_name = 'privacy')
    date_of_creation = DateField(column_name = 'date_of_creation')

    class Meta:
        table_name = 'playlists'
        primary_key = CompositeKey('name', 'author_id')


class Tag(BaseModel):
    song = ForeignKeyField(Song, field = 'name')
    artist = ForeignKeyField(Song, field = 'artist')
    playlist = ForeignKeyField(Playlist, field = 'name')
    author_id = ForeignKeyField(Playlist, field = 'author_id')

    class Meta:
        table_name = 'tag'

def request_1():
    print("[Однотабличный запрос на выборку]\n")
    print("Пользователи, которые родились после 2010-01-01 (первые 5 записей)\n")

    selection = User.select().where(User.date_of_birth > '2010-01-01').limit(5).order_by(User.id)
    result = selection.dicts().execute()
    
    for elem in result:
        print(elem['id'], elem['nickname'], elem['mail'], elem['date_of_birth'], elem['sex'])


def request_2():
    print("\n[Многотабличный запрос на выборку]\n")
    print("Первые 5 публичных плейлистов:")

    selection = Playlist.select(Playlist.name, Playlist.duration,
                                User.id, User.nickname).join(User, on = (Playlist.author_id == User.id)).limit(4).where(Playlist.privacy == 'public')
    result = selection.dicts().execute()
    
    for elem in result:
        print("Плейлист: ", elem['name'], elem['duration'], ", автор: ", elem['id'], elem['nickname'])


    print("\nИнформация о последних релизах исполнителей(первые 5 записей):")
    selection = Artist.select(Artist.name, Artist.latest_release, Song.duration,
                              Song.category).join(Song, on = (Song.name == Artist.latest_release)).order_by(Artist.latest_release.desc()).limit(5)
    result = selection.dicts().execute()

    for elem in result:
        print("{:20s}". format(elem['name']), ", ", elem['latest_release'], elem['duration'], elem['category'])

def print_last_five_users():
    selection = User.select().limit(5).order_by(User.id.desc())
    result = selection.dicts().execute()

    print("\nИнформация о последних 5 пользователях:")
    for elem in result:
        print(elem['id'], elem['nickname'], elem['mail'], elem['date_of_birth'], elem['sex'])


def add_user(_id, _nickname, _mail, _date_of_birth, _sex):
    User.create(id = _id, nickname = _nickname, mail = _mail, date_of_birth = _date_of_birth, sex = _sex)

    print("Добавлен новый пользователь с id = ", _id)

def update_user(_id, _nickname):
    user_upd = User.get(User.id == _id)
    old_nickname = user_upd.nickname
    user_upd.nickname = _nickname
    user_upd.save()

    print("Никнейм пользователя с id = ", _id, "изменен с ", old_nickname, "на ", _nickname)

def delete_user(_id):
    user_del = User.get(User.id == _id)
    user_del.delete_instance()

    print("\nУдален пользователь с id = ", _id)

def request_3():
    print("[Три запроса на добавление, изменение и удаление данных в базе данных]")

    print_last_five_users()
    print("\n[Добавление пользователя]")
    add_user(1001, "Rindo", "rindo@gmail.com", "2002-01-01", "female")
    print_last_five_users()

    input("\nНажмите ENTER, чтобы продолжить...")
    print("\n[Изменение информации о пользователе]")
    update_user(1, 'Danny')

    input("\nНажмите ENTER, чтобы продолжить...")
    print("\n[Удаление пользователя]")
    print_last_five_users()
    delete_user(1001)
    print_last_five_users()


def request_4():
    print("\n[Получение доступа к данным, выполняя только хранимую процедуру]\n")

    cursor = db.cursor()

    _name = 'Sia'

    artist = Artist.get(Artist.name == _name)
    old_cnt = artist.number_of_listeners

    cursor.execute("call update_artist(%s);", ('Sia',))

    artist = Artist.get(Artist.name == _name)

    print("Кол-во слушателей исполнителя ", _name, "увеличено с ", old_cnt, " до ", artist.number_of_listeners)

def task_3():
    request_1()
    input("\nНажмите ENTER, чтобы продолжить...")

    request_2()
    input("\nНажмите ENTER, чтобы продолжить...")

    request_3()
    input("\nНажмите ENTER, чтобы продолжить...")

    request_4()
