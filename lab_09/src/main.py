import redis
import psycopg2
import threading
import json
import time
from faker import Faker

from random import choice
from random import randint

songs = [line.strip() for line in open("data/song.txt", "r")]
artists = [line.strip() for line in open("data/artist.txt", "r")]
genres = [line.strip() for line in open("data/genre.txt", "r")]


def add_artist(cursor, connection):
    threading.Timer(10.0, add_artist, [cursor, connection]).start()
    
    cursor.execute("insert into users values(%s, %s, %s, %s, %s);",
                   (randint(1001, 2000), choice(genres), "@" + "aaa",
                   str(randint(1970, 2010)) + "." + str(randint(1, 12)) + "." + str(randint(1, 28)) + ".", choice(["female", "male"]), ))

    redis_client = redis.Redis()
    
    connection.commit()

def del_artist(cursor, connection):
    threading.Timer(10.0, del_artist, [cursor, connection]).start() 

    user = randint(1, 1000)
    
    cursor.execute("delete from users where id = %s;", (user, ))

    redis_client = redis.Redis()
    redis_client.delete(user)
    
    connection.commit()


def update_artist(cursor, connection):
    threading.Timer(10.0, update_artist, [cursor, connection]).start()
    user = randint(1, 1000)
    
    cursor.execute("update users set nickname = %s where id = %s;", ("aaa", user, ))

    redis_client = redis.Redis()
    redis_client.delete(user)
    
    connection.commit()

def request_db(cursor, id):
    threading.Timer(5.0, request_db, [cursor, id]).start()
    
    cursor.execute("select *\
                   from users\
                   where id = %s;", (id, ))

    result = cursor.fetchone()



def request_with_cache(cursor, id):
    threading.Timer(5.0, request_with_cache, [cursor, id]).start()
    
    redis_client = redis.Redis()
    
    cache_value = redis_client.get(id)

    if cache_value is not None:
        
        redis_client.close()

        return cache_value

    cursor.execute("select *\
                   from users\
                   where id = %s;", (id, ))

    result = cursor.fetchone()

    redis_client.set(id, str(result), ex = 300)

    redis_client.close()


if __name__ == "__main__":
    print()
    
    try:
        connection = psycopg2.connect(
            dbname="lab_06",
            user="postgres",
            password="1234",
            host="127.0.0.1",  
            port="5432"		   
        )
    except:
        print("error!")
        exit()

    cursor = connection.cursor()
    
    var = 3

    if (var == 0):
        print("[Без изменения данных в БД]\n")

        start = time.time()
        for i in range(100):
            request_db(cursor, randint(1, 1000))
        print("БД: ", (time.time() - start) / 100)

        start = time.time()
        for i in range(100):
            request_with_cache(cursor, randint(1, 1000))
        print("Redis: ", (time.time() - start) / 1000)
        
    elif (var == 1):
        print("[При добавлении новых строк каждые 10 секунд]")

        add_artist(cursor,connection)

        start = time.time()
        for i in range(100):
            request_db(cursor, randint(1, 1000))
        print("БД: ", (time.time() - start) / 100)

        start = time.time()
        for i in range(100):
            request_with_cache(cursor, randint(1, 1000))
        print("Redis: ", (time.time() - start) / 100)
        
    elif (var == 2):
        print("[При удалении строк каждые 10 секунд]")

        del_artist(cursor,connection)

        start = time.time()
        for i in range(100):
            request_db(cursor, randint(1, 1000))
        print("БД: ", (time.time() - start) / 100)

        start = time.time()
        for i in range(100):
            request_with_cache(cursor, randint(1, 1000))
        print("Redis: ", (time.time() - start) / 1000)
    else:
        print("[При изменении строк каждые 10 секунд]")

        update_artist(cursor,connection)

        start = time.time()
        for i in range(100):
            request_db(cursor, randint(1, 1000))
        print("БД: ", (time.time() - start) / 100)

        start = time.time()
        for i in range(100):
            request_with_cache(cursor, randint(1, 1000))
        print("Redis: ", (time.time() - start) / 100)

    #connection.close()

# redis_client = redis.Redis(host="localhost", port=6379, db=0)

