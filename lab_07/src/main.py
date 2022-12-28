import psycopg2

from task_1 import *
from task_2 import *
from task_3 import *

def main():
    choice = int(input("Введите нужный номер задания: "))
    print()

    if (choice == 1):
        task_1()
    elif (choice == 2):
        task_2()
    elif (choice == 3):
        task_3()

if __name__ == "__main__":
    main()

'''
LINQ (Language Integrated Query) is a popular querying language available in .NET. 
This library ports the language so that developers can query collections of objects using the same syntax. 
This library would be useful for Python developers with experience using the expressiveness and power of LINQ.
'''
