from faker import Faker
import datetime
from random import choice
from random import randint
import threading

CNT = 10
id = 1
sex = ["male", "female"]

def generate_user():
    global id

    threading.Timer(60.0, generate_user).start() # 20 секунд

    f = Faker()
    date = datetime.datetime.now().strftime("%d-%m-%Y_%H-%M")
    name = 'users_' + date  + '.csv'
    file = open(name, 'w')

    nicknames = [line.strip() for line in open("data/nickname.txt", "r")]

    line = "{0},{1},{2},{3},{4}\n".format(
        "id", "nickname", "mail", "date_of_birth", "sex")

    file.write(line)

    for i in range(CNT):
        line = "{0},{1},{2},{3},{4}\n".format(
            id, choice(nicknames), f.email(), f.date(), choice(sex))

        id += 1

        file.write(line)

    print("Создан файл ", name)

    file.close()

if __name__ == "__main__":
    id = 1

    generate_user()