import matplotlib.pyplot as plt

mode = 3

# Без изменения данных

if mode == 0:
    index = ["БД", "Redis"]
    values = [0.013663472843170166, 0.010023893350323242]
    plt.bar(index,values)
    plt.title("Без изменения данных")
    plt.show()

elif mode == 1:
# При добавлении новых строк каждые 10 секунд

    index = ["БД", "Redis"]
    values = [0.00035931119918823245, 0.0013577041625976562]
    plt.bar(index,values)
    plt.title("При добавлении новых строк каждые 10 секунд")
    plt.show()


# При удалении строк каждые 10 секунд
elif mode == 2:

    index = ["БД", "Redis"]
    values = [0.0019226646423339843, 0.0015000951766967773]
    plt.bar(index,values)
    plt.title("При удалении строк каждые 10 секунд")
    plt.show()


# При изменении строк каждые 10 секунд
else:

    index = ["БД", "Redis"]
    values = [0.000199527530670166, 0.0010328336715698242]
    plt.bar(index,values)
    plt.title("При изменении строк каждые 10 секунд")
    plt.show()



