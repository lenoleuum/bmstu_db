from tkinter import *
from tkinter import ttk
import sys
from tkinter import messagebox
import psycopg2
from tasks import *

def exit_root():
    root.after(1, root.destroy)
    sys.exit

def help():
    print("help\n")

def menu(root, cursor, connection):
    
    main_menu = Menu(root) 
    root.configure(menu = main_menu) 

    item_1 = Menu(main_menu)
    main_menu.add_command(label = 'Помощь', command = help)
    item_2 = Menu(item_1)
    main_menu.add_command(label = 'Выход', command = exit_root)
    
    l0 = Label(root, text = "Выберите нужный пункт меню:", background = "lavender")
    l0.place(x = 10, y = 10)
    
    var = IntVar()
    var.set(0)

    l1 = Label(root, text = "1. Выполнить скалярный запрос", background = "lavender")
    l1.place(x = 10, y = 30)
    l2 = Label(root, text = "2. Выполнить запрос с несколькими соединениями (JOIN)", background = "lavender")
    l2.place(x = 10, y = 50)
    l3 = Label(root, text = "3. Выполнить запрос с ОТВ(CTE) и оконными функциями", background = "lavender")
    l3.place(x = 10, y = 70)
    l4 = Label(root, text = "4. Выполнить запрос к метаданным", background = "lavender")
    l4.place(x = 10, y = 90)
    l5 = Label(root, text = "5. Вызвать скалярную функцию", background = "lavender")
    l5.place(x = 10, y = 110)
    l6 = Label(root, text = "6. Вызвать многооператорную или табличную функцию", background = "lavender")
    l6.place(x = 10, y = 130)
    l7 = Label(root, text = "7. Вызвать хранимую процедуру", background = "lavender")
    l7.place(x = 10, y = 150)
    l8 = Label(root, text = "8. Вызвать системную функцию или процедуру", background = "lavender")
    l8.place(x = 10, y = 170)
    l9 = Label(root, text = "9. Создать таблицу в базе данных, соответствующую тематике БД", background = "lavender")
    l9.place(x = 10, y = 190)
    l10 = Label(root, text = "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY", background = "lavender")
    l10.place(x = 8, y = 210)


    canvas = Canvas(root, width = 220, height = 240, bg = "sky blue")
    canvas.place(x = 600, y = 0)    

    ttk.Button(root, text = "Пункт №1", width = 12, command = lambda: task_1(cursor)).place(x = 620, y = 30)
    ttk.Button(root, text = "Пункт №2", width = 12, command = lambda: task_2(cursor)).place(x = 620, y = 70)
    ttk.Button(root, text = "Пункт №3", width = 12, command = lambda: execute_task_3(cursor)).place(x = 620, y = 110)
    ttk.Button(root, text = "Пункт №4", width = 12, command = lambda: task_4(cursor)).place(x = 620, y = 150)
    ttk.Button(root, text = "Пункт №5", width = 12, command = lambda: task_5(cursor)).place(x = 620, y = 190)
    
    ttk.Button(root, text = "Пункт №6", width = 12, command = lambda: task_6(cursor)).place(x = 720, y = 30)
    ttk.Button(root, text = "Пункт №7", width = 12, command = lambda: task_7(cursor)).place(x = 720, y = 70)
    ttk.Button(root, text = "Пункт №8", width = 12, command = lambda: execute_task_8(cursor)).place(x = 720, y = 110)
    ttk.Button(root, text = "Пункт №9", width = 12, command = lambda: execute_task_9(cursor, connection)).place(x = 720, y = 150)
    ttk.Button(root, text = "Пункт №10", width = 12, command = lambda: execute_task_10(cursor, connection)).place(x = 720, y = 190)

    
def window(connection, cursor):
    root = Tk()
    
    root.title('Лабораторная работа №6')
    
    ws = root.winfo_screenwidth()
    hs = root.winfo_screenheight()

    x = (ws / 2) - 500
    y = (hs / 2) - 200

    root.geometry('%dx%d+%d+%d' % (900, 300, x, y))

    root.configure(bg = "lavender")
    
    menu(root, cursor, connection)
    root.mainloop()
    
def main():
    try:
        connection = psycopg2.connect(
            dbname="lab_06",
            user="postgres",
            password="123",
            host="127.0.0.1",  
            port="5432"		   
        )
        
    except:
        messagebox.showerror("Ошибка", "Не удалось подключиться к базе данных!\n")
        return

    cursor = connection.cursor()
    
    window(connection, cursor)

    connection.close()
    cursor.close()
    
if __name__ == "__main__":
    main()
