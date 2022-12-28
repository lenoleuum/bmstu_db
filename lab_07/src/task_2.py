from artists import *
import json
import psycopg2

def print_artists(array):
    for elem in array:
        print(elem.get())
    print()

def read_json(cursor, cnt = 10):
    cursor.execute('select * from artist_json')
    rows = cursor.fetchmany(cnt)

    result = list()

    for elem in rows:
        result.append(artist(elem[0]['artist_name'], elem[0]['genre'], elem[0]['link'],
                             elem[0]['number_of_listeners'], elem[0]['most_popular_track'], elem[0]['latest_release']))

        print(elem[0])

    return result

def update_json(array, artist):
    for elem in array:
        if (elem.name == artist):
            print('Кол-во слушателей исполнителя ', artist, 'ДО обновления: ', elem.num_list)
            elem.num_list *= 1.5
            print('Кол-во слушателей исполнителя ', artist, 'ПОСЛЕ обновления: ', elem.num_list)
            print()


def write_json(array, artist):
    array.append(artist)
    

def task_2():
    try:
        connection = psycopg2.connect(
            dbname="lab_06",
            user="postgres",
            password="1234",
            host="127.0.0.1",
            port="5432"
        )

    except:
        messagebox.showerror("Ошибка", "Не удалось подключиться к базе данных!\n")
        return

    cursor = connection.cursor()

    print("[Чтение из JSON файла первых 10ти строк]\n")
    array = read_json(cursor)
    print_artists(array)

    input('Нажмите ENTER, чтобы продолжить...')
    print("\n[Обновление JSON файла: кол-во слушателей у заданного исполнителя увеличивается в 1.5 раза]\n")
    update_json(array, 'Bob Dylan')

    input('Нажмите ENTER, чтобы продолжить...')
    print("\n[Добавление в JSON файл информации о новом исполнителе]\n")
    write_json(array, artist("Jennifer Lopez", "disco", "@Jennifer Lopez", 91313552, "Don't Stop The Music", "Jail"))
    print_artists(array)

    connection.close()
    cursor.close()
