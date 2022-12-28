from tkinter import *
from tkinter import ttk
from execution import *

def task_1(cursor):
    root_1 = Tk()

    root_1.title('Пункт №1')
    
    ws = root_1.winfo_screenwidth()
    hs = root_1.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root_1.geometry('%dx%d+%d+%d' % (300, 150, x, y))

    lab = Label(root_1, text = "Введите id пользователя:").place(x = 10, y = 40)
    ent = Entry(root_1, width = 10, justify = CENTER)
    ent.place(x = 180, y = 42)

    ttk.Button(root_1, text = "Выполнить", width = 15, command = lambda: execute_task_1(cursor, ent)).place(x = 30, y = 90)

    root_1.mainloop()


def task_2(cursor):
    root_2 = Tk()

    root_2.title('Пункт №2')
    
    ws = root_2.winfo_screenwidth()
    hs = root_2.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root_2.geometry('%dx%d+%d+%d' % (350, 150, x, y))

    lab = Label(root_2, text = "Введите название плейлиста:").place(x = 10, y = 40)
    ent = Entry(root_2, width = 20, justify = CENTER)
    ent.place(x = 190, y = 42)

    ttk.Button(root_2, text = "Выполнить", width = 15, command = lambda: execute_task_2(cursor, ent)).place(x = 30, y = 90)

    root_2.mainloop()


def task_4(cursor):
    root_4 = Tk()

    root_4.title('Пункт №4')
    
    ws = root_4.winfo_screenwidth()
    hs = root_4.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root_4.geometry('%dx%d+%d+%d' % (350, 150, x, y))

    lab = Label(root_4, text = "Введите название таблицы:").place(x = 10, y = 40)
    ent = Entry(root_4, width = 20, justify = CENTER)
    ent.place(x = 190, y = 42)

    ttk.Button(root_4, text = "Выполнить", width = 15, command = lambda: execute_task_4(cursor, ent)).place(x = 30, y = 90)

    root_4.mainloop()


def task_5(cursor):
    root_5 = Tk()

    root_5.title('Пункт №5')
    
    ws = root_5.winfo_screenwidth()
    hs = root_5.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root_5.geometry('%dx%d+%d+%d' % (350, 150, x, y))

    lab = Label(root_5, text = "Введите жанр:").place(x = 10, y = 40)
    ent = Entry(root_5, width = 20, justify = CENTER)
    ent.place(x = 160, y = 42)

    ttk.Button(root_5, text = "Выполнить", width = 15, command = lambda: execute_task_5(cursor, ent)).place(x = 30, y = 90)

    root_5.mainloop()


def task_6(cursor):
    root_6 = Tk()

    root_6.title('Пункт №6')
    
    ws = root_6.winfo_screenwidth()
    hs = root_6.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root_6.geometry('%dx%d+%d+%d' % (350, 200, x, y))

    lab = Label(root_6, text = "Введите две категории:").place(x = 10, y = 40)
    
    ent1 = Entry(root_6, width = 20, justify = CENTER)
    ent1.place(x = 160, y = 42)

    ent2 = Entry(root_6, width = 20, justify = CENTER)
    ent2.place(x = 160, y = 72)

    ttk.Button(root_6, text = "Выполнить", width = 15, command = lambda: execute_task_6(cursor, ent1, ent2)).place(x = 30, y = 120)

    root_6.mainloop()


def task_7(cursor):
    root_7 = Tk()

    root_7.title('Пункт №7')
    
    ws = root_7.winfo_screenwidth()
    hs = root_7.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root_7.geometry('%dx%d+%d+%d' % (350, 150, x, y))

    lab = Label(root_7, text = "Введите имя исполнителя:").place(x = 10, y = 40)
    ent = Entry(root_7, width = 20, justify = CENTER)
    ent.place(x = 190, y = 42)

    ttk.Button(root_7, text = "Выполнить", width = 15, command = lambda: execute_task_7(cursor, ent)).place(x = 30, y = 90)

    root_7.mainloop()


##def task_10(cursor, connection):
##    root_10 = Tk()
##
##    root_10.title('Пункт №10')
##    
##    ws = root_10.winfo_screenwidth()
##    hs = root_10.winfo_screenheight()
##
##    x = (ws / 2) - 500
##    y = (hs / 2) - 200
##
##    root_10.geometry('%dx%d+%d+%d' % (350, 250, x, y))
##
##    uid = Label(root_10, text = "Введите id пользователя:").place(x = 10, y = 40)
##    ent1 = Entry(root_10, width = 12, justify = CENTER)
##    ent1.place(x = 190, y = 42)
##
##    song = Label(root_10, text = "Введите название песни:").place(x = 10, y = 70)
##    ent2 = Entry(root_10, width = 12, justify = CENTER)
##    ent2.place(x = 190, y = 72)
##
##    artist = Label(root_10, text = "Введите название песни:").place(x = 10, y = 100)
##    ent3 = Entry(root_10, width = 12, justify = CENTER)
##    ent3.place(x = 190, y = 102)
##    
##    ttk.Button(root_10, text = "Выполнить", width = 15, command = lambda: execute_task_10(cursor, connection, ent1, ent2, ent3)).place(x = 30, y = 150)
##
##    root_10.mainloop()


