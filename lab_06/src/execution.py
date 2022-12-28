from tkinter import messagebox
from tkinter import *
import tkinter as tk
from tkinter import ttk

def execute_task_1(cursor, ent):
    try:
        uid = int(ent.get())
    except:
        messagebox.showerror("Ошибка","Некорректный ввод!\n")
        return

    cursor.execute("\
                    select count(*) as cnt\
                    from playlists\
                    where author_id = %s", (uid,))

    row = cursor.fetchone()
    
    messagebox.showinfo("Результат",f"Кол-во плейлистов у пользователя с id = {uid} составляет: {row[0]}\n")


def execute_task_2(cursor, ent):
    try:
        name = ent.get()
        
    except:
        messagebox.showerror("Ошибка","Некорректный ввод!\n")
        return

    cursor.execute("\
                    select distinct pl.playlist_name, pl.author, s.song_name, s.artist, s.song_duration\
                    from tag join playlists pl on tag.playlist_name = pl.playlist_name\
                            join songs s on tag.song_name = s.song_name and tag.artist_name = s.artist\
                    where tag.playlist_name = %s", (name,))

    row = cursor.fetchall()

    res = Tk()

    res.title('Результат')
    
    ws = res.winfo_screenwidth()
    hs = res.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    res.geometry('%dx%d+%d+%d' % (550, 300, x, y))

    columns = ("#1", "#2", "#3", "#4", "#5")
    
    table = ttk.Treeview(res, show="headings", columns = columns, height = 12)

    table.column("#1", width = 100, anchor = tk.CENTER)
    table.column("#2", width = 100, anchor = tk.CENTER)
    table.column("#3", width = 100, anchor = tk.CENTER)
    table.column("#4", width = 100, anchor = tk.CENTER)
    table.column("#5", width = 100, anchor = tk.CENTER)
    
    table.heading("#1", text = "Плейлист")
    table.heading("#2", text = "Автор")
    table.heading("#3", text = "Песня")
    table.heading("#4", text = "Исполнитель")
    table.heading("#5", text = "Длительность")

    table.place(x = 10, y = 10)

    for elem in row:
        table.insert("", tk.END, values = elem)

    res.mainloop()


def execute_task_3(cursor):
    cursor.execute("\
                    with cte(genre, number_of_listeners)\
                    as\
                    (\
                    select genre, number_of_listeners\
                    from artists\
                    )\
                    select distinct genre,\
			min(number_of_listeners) over(partition by genre) as min_num,\
			avg(number_of_listeners) over(partition by genre) as avg_num,\
			max(number_of_listeners) over(partition by genre) as max_num\
                    from cte")

    row = cursor.fetchall()

    res = Tk()

    res.title('Результат')
    
    ws = res.winfo_screenwidth()
    hs = res.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    res.geometry('%dx%d+%d+%d' % (575, 300, x, y))

    columns = ("#1", "#2", "#3", "#4")
    
    table = ttk.Treeview(res, show="headings", columns = columns, height = 12)

    table.column("#1", width = 100, anchor = tk.CENTER)
    table.column("#2", width = 150, anchor = tk.CENTER)
    table.column("#3", width = 150, anchor = tk.CENTER)
    table.column("#4", width = 150, anchor = tk.CENTER)
    
    table.heading("#1", text = "Жанр")
    table.heading("#2", text = "Минимальное кол-во")
    table.heading("#3", text = "Среднее кол-во")
    table.heading("#4", text = "Максимальное кол-во")

    table.place(x = 10, y = 10)

    for elem in row:
        table.insert("", tk.END, values = elem)

    res.mainloop()


def execute_task_4(cursor, ent):
    try:
        name = ent.get()
        
    except:
        messagebox.showerror("Ошибка","Некорректный ввод!\n")
        return

    cursor.execute("\
                    select table_name, column_name, data_type\
                    from information_schema.columns\
                    where table_name = %s", (name,))

    row = cursor.fetchall()
    
    res = Tk()

    res.title('Результат')
    
    ws = res.winfo_screenwidth()
    hs = res.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    res.geometry('%dx%d+%d+%d' % (550, 300, x, y))

    columns = ("#1", "#2", "#3")
    
    table = ttk.Treeview(res, show="headings", columns = columns, height = 12)

    table.column("#1", width = 100, anchor = tk.CENTER)
    table.column("#2", width = 180, anchor = tk.CENTER)
    table.column("#3", width = 180, anchor = tk.CENTER)
    
    table.heading("#1", text = "Таблица")
    table.heading("#2", text = "Атрибут")
    table.heading("#3", text = "Тип")

    table.place(x = 10, y = 10)

    for elem in row:
        table.insert("", tk.END, values = elem)

    res.mainloop()


def execute_task_5(cursor, ent):
    try:
        genre = ent.get()
        
    except:
        messagebox.showerror("Ошибка","Некорректный ввод!\n")
        return

    cursor.execute("\
                    select artist_name, genre, difference(number_of_listeners) as dif\
                    from artists\
                    where genre = %s", (genre,))

    row = cursor.fetchall()
    
    res = Tk()

    res.title('Результат')
    
    ws = res.winfo_screenwidth()
    hs = res.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    res.geometry('%dx%d+%d+%d' % (550, 300, x, y))

    columns = ("#1", "#2", "#3")
    
    table = ttk.Treeview(res, show="headings", columns = columns, height = 12)

    table.column("#1", width = 200, anchor = tk.CENTER)
    table.column("#2", width = 130, anchor = tk.CENTER)
    table.column("#3", width = 130, anchor = tk.CENTER)
    
    table.heading("#1", text = "Исполнитель")
    table.heading("#2", text = "Жанр")
    table.heading("#3", text = "Прирост слушателей")

    table.place(x = 10, y = 10)

    for elem in row:
        table.insert("", tk.END, values = elem)

    res.mainloop()


def execute_task_6(cursor, ent1, ent2):
    try:
        cat1 = ent1.get()
        cat2 = ent2.get()
    except:
        messagebox.showerror("Ошибка","Некорректный ввод!\n")
        return

    cursor.execute("\
                    select *\
                    from get_songs_by_category(%s, %s);", (cat1, cat2,))

    row = cursor.fetchall()
    
    res = Tk()

    res.title('Результат')
    
    ws = res.winfo_screenwidth()
    hs = res.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    res.geometry('%dx%d+%d+%d' % (550, 300, x, y))

    columns = ("#1", "#2", "#3")
    
    table = ttk.Treeview(res, show="headings", columns = columns, height = 12)

    table.column("#1", width = 200, anchor = tk.CENTER)
    table.column("#2", width = 200, anchor = tk.CENTER)
    table.column("#3", width = 125, anchor = tk.CENTER)
    
    table.heading("#1", text = "Исполнитель")
    table.heading("#2", text = "Песня")
    table.heading("#3", text = "Длительность")

    table.place(x = 10, y = 10)

    for elem in row:
        table.insert("", tk.END, values = elem)

    res.mainloop()


def execute_task_7(cursor, ent):
    try:
        name = ent.get()
    except:
        messagebox.showerror("Ошибка","Некорректный ввод!\n")
        return

    cursor.execute("\
                    call update_data(%s);", (name,))

    cursor.execute("\
                    select number_of_listeners\
                    from artists\
                    where artist_name = %s;", (name,))

    row = cursor.fetchone()

    messagebox.showinfo("Результат",f"Кол-во слушателей у исполнителя\n{name}\nувеличено в 1.5 раза.\nНовое кол-во слушателей: {row[0]}\n")

def execute_task_8(cursor):
    cursor.execute("\
                    select *\
                    from current_database(), current_user, version(), cast(pg_postmaster_start_time() as time)")

    row = cursor.fetchone()

    messagebox.showinfo("Результат",f"[Информация о сеансе]\n\nТекущая БД - {row[0]}\n\
Имя пользователя - {row[1]}\n\
Версия PostgreSQL - {row[2]}\n\
Время запуска сервера - {row[3]}\n")


def execute_task_9(cursor, connection):
    try:
        cursor.execute("\
                        create table recs\
                        (\
                            id int,\
                            song varchar(50) not null,\
                            artist varchar(50) not null,\
                            foreign key(id) references users(id),\
                            foreign key(song, artist) references songs(song_name, artist)\
                        );")
    except:
        messagebox.showinfo("Результат",f"Таблица 'Рекомендации' уже создана.\n")
        return

    messagebox.showinfo("Результат",f"Создана новая таблица 'Рекомендации'\n")

    connection.commit()


def execute_task_10(cursor, connection):
    f = open(r'C:\data\csv\rec.csv', 'r')
    try:
        cursor.copy_from(f, 'recs', sep = ',')
        connection.commit()
    except:
        messagebox.showinfo("Результат",f"Данные уже загружены в таблицу 'Рекомендации'\n")
        
    f.close()

    cursor.execute("\
                    select *\
                    from recs;")

    row = cursor.fetchall()
    
    res = Tk()

    res.title('Результат')
    
    ws = res.winfo_screenwidth()
    hs = res.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    res.geometry('%dx%d+%d+%d' % (550, 300, x, y))

    columns = ("#1", "#2", "#3")
    
    table = ttk.Treeview(res, show="headings", columns = columns, height = 12)

    table.column("#1", width = 100, anchor = tk.CENTER)
    table.column("#2", width = 200, anchor = tk.CENTER)
    table.column("#3", width = 200, anchor = tk.CENTER)
    
    table.heading("#1", text = "Пользователь")
    table.heading("#2", text = "Песня")
    table.heading("#3", text = "Исполнитель")

    table.place(x = 10, y = 10)

    for elem in row:
        table.insert("", tk.END, values = elem)

    res.mainloop()

