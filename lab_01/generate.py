from random import choice
from random import randint

CNT = 1000
sex = ["male", "female"]
privacy = ["private", "public"]

users_arr = dict()
playlists_arr = dict()
songs_arr = []

def generate_user():
    file = open(r"C:\data\csv\user.csv", "w")
    
    nicknames = [line.strip() for line in open("data/nickname.txt", "r")]
    mails = [line.strip() for line in open("data/mail.txt", "r")]
    
    for i in range(CNT):
        name = nicknames[i]
        mail = mails[i]
        user_id = i + 1
        date_of_birth = str(randint(1970, 2010)) + "." + str(randint(1, 12)) + "." + str(randint(1, 28)) + "."
        
        users_arr[name] = user_id
        
        line = "{0},{1},{2},{3},{4}\n".format(
            user_id, name, mail, date_of_birth, choice(sex))
        '''
        line = "{0},{1},{2},{3},{4},{5}\n".format(
            user_id, name, mail, date_of_birth, choice(sex), randint(1, CNT))'''
       
        file.write(line)

    file.close()
    

def generate_song():
    file = open("C:\data\csv\song.csv", "w")
    
    songs = [line.strip() for line in open("data/song.txt", "r")]
    artists = [line.strip() for line in open("data/artist.txt", "r")]
    category = [line.strip() for line in open("data/category.txt", "r")]
    
    for i in range(CNT):
        date = str(randint(1970, 2020)) + "." + str(randint(1, 12)) + "." + str(randint(1, 28)) + "."
        name = choice(songs)
        duration = "00:" + str(randint(1, 4)) + ":" + str(randint(1, 59))
        
        line = "{0},{1},{2},{3},{4}\n".format(
            name, artists[i], date, duration, choice(category))
            
        songs_arr.append([name, artists[i]])
       
        file.write(line)

    file.close()

''' 
def generate_artist():
    file = open(r"C:\data\csv\artist.csv", "w")
    
    songs = [line.strip() for line in open("data/song.txt", "r")]
    artists = [line.strip() for line in open("data/artist.txt", "r")]
    genres = [line.strip() for line in open("data/genre.txt", "r")]
    
    for i in range(CNT):  
        line = "{0},{1},{2},{3},{4},{5}\n".format(
            artists[i], choice(genres), randint(10000, 100000000), "@" + artists[i], choice(songs), choice(songs))
       
        file.write(line)

    file.close()
'''    
    
def generate_artist():
    file = open(r"C:\Users\admin\Desktop\newlife\5 семестр\БАЗОЧКИ ДАННЫХ РОДНЕНЬКИЕ\lab_07\src\artist.csv", "w")
    
    songs = [line.strip() for line in open("data/song.txt", "r")]
    artists = [line.strip() for line in open("data/artist.txt", "r")]
    genres = [line.strip() for line in open("data/genre.txt", "r")]
    
    for i in range(CNT):  
        line = "{0},{1},{2},{3},{4},{5}\n".format(
            artists[i], choice(genres), "@" + artists[i], randint(10000, 100000000), choice(songs), choice(songs))
       
        file.write(line)

    file.close()
    
    
def generate_playlist():
    file = open(r"C:\data\csv\playlist.csv", "w")
    
    nicknames = [line.strip() for line in open("data/nickname.txt", "r")]
    
    for i in range(CNT):
        date = str(randint(2016, 2020)) + "." + str(randint(1, 12)) + "." + str(randint(1, 28)) + "."
        author = choice(nicknames)
        name = "playlist_" + str(i + 1)
        author_id = users_arr.get(author)
        duration = str(randint(0, 2)) + ":" + str(randint(0, 59)) + ":" + str(randint(1, 59))
        
        line = "{0},{1},{2},{3},{4},{5}\n".format(
            name, author, author_id, duration, choice(privacy), date)
            
        playlists_arr[name] = author_id
       
        file.write(line)

    file.close()
    
    
def generate_tag():
    file = open(r"C:\data\csv\tag.csv", "w")
    
    for i in range(CNT):
        for j in range(randint(3, 12)):
            temp = choice(songs_arr)
            
            line = "{0},{1},{2},{3}\n".format(
                temp[0], temp[1], "playlist_" + str(i + 1), playlists_arr.get("playlist_" + str(i + 1)))
           
            file.write(line)

    file.close()
    
def generate_rec():
    file = open(r"C:\data\csv\rec.csv", "w")
    
    for i in range(CNT):
        for j in range(randint(1, 3)):
            temp = choice(songs_arr)
            
            line = "{0},{1},{2}\n".format(
                i + 1, temp[0], temp[1])
           
            file.write(line)

    file.close()

if __name__ == "__main__":
    #generate_user()
    #generate_song()
    generate_artist()
    #generate_playlist()
    #generate_tag()
    #generate_rec()
