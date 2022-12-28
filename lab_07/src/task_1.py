from py_linq import *
from artists import *

# where и order by
def request_1(artists):
    result = artists.where(lambda x: x['num_list'] > 95000000).order_by(lambda x: x['name']).select(lambda x: {x['name'], x['genre'], x['num_list']})
    return result

# фгрегатная функция count
def request_2(artists):
    genre = 'rock'
    result = artists.count(lambda x: x['genre'] == genre)
    return result

# union
def request_3(artists):
    genre_1 = 'rock'
    genre_2 = 'metal'

    gen1 = Enumerable(artists.where(lambda x: x['genre'] == genre_1).select(lambda x: {x['name'], x['genre'], x['num_list']}))
    gen2 = Enumerable(artists.where(lambda x: x['genre'] == genre_2).select(lambda x: {x['name'], x['genre'], x['num_list']}))
    
    result = Enumerable(gen1).union(Enumerable(gen2), lambda x: x)
    return result

# group by
def request_4(artists):
    result = artists.group_by(key_names = ['genre'], key = lambda x: x['genre']).select(lambda y: {'genre': y.key.genre, 'cnt artists': y.count()})
    return result

# join
def request_5(artists):
    songs = Enumerable([{'name': 'Break free', 'artist': 'Queen', 'duration': '2:07'},
                        {'name': 'Let it haunt you', 'artist': 'Slaves', 'duration': '4:32'},
                        {'name': 'True friends', 'artist': 'Bring Me The Horizon', 'duration': '3:56'}])

    result = artists.join(songs, lambda o_key: o_key['name'], lambda i_key: i_key['artist'])

    return result

def task_1():
    artists = Enumerable(create_artists('artist.csv'))

    #input("\nНажмите ENTER, чтобы продолжить...")
    print("[Исполнители, у которых кол-во слушателей больше 90'000'000]\n")
    for elem in request_1(artists):
        print(elem)

    input("\nНажмите ENTER, чтобы продолжить...")
    print("[Количество исполнителей жанра \"рок\"] : ", request_2(artists), "\n")

    input("\nНажмите ENTER, чтобы продолжить...")
    print("[Информация об исполнителях двух жанров: \"рок\" и \"метал\"]\n")
    for elem in request_3(artists):
        print(elem)

    input("\nНажмите ENTER, чтобы продолжить...")
    print("[Количество исполнителей каждого жанра]\n")
    for elem in request_4(artists):
        print(elem)

    input("\nНажмите ENTER, чтобы продолжить...")
    print("[Соединение исполнителей и их песен]\n")
    for elem in request_5(artists):
        print(elem)


task_1()
