from random import choice
from random import randint

CNT = 1000

def generate_category():
    file = open("csv/c.csv", "w")
    categories = [line.strip() for line in open("data/category.txt", "r")]
    
    for i in range(CNT):
        line = "{0},{1}\n".format(
            "{playlist_name:playlist_" + str(i), "category:" + choice(categories) + "}")
            
        file.write(line)

    file.close()
    
def generate_artist():
    file = open("csv/artist.csv", "w")
    
    songs = [line.strip() for line in open("data/song.txt", "r")]
    artists = [line.strip() for line in open("data/artist.txt", "r")]
    genres = [line.strip() for line in open("data/genre.txt", "r")]
    
    for i in range(CNT):  
        line = "{0},genre:{1},number_of_listeners:{2},link:{3},most_popular_track:{4},latest_release:{5}\n".format(
            "{artist_name:" + artists[i], choice(genres), randint(10000, 100000000), "@" + artists[i], choice(songs), choice(songs) + "}")
       
        file.write(line)

    file.close()
    
def generate_tag():
    file = open("csv/tag.csv", "w")
    
    songs = [line.strip() for line in open("data/song.txt", "r")]
    artists = [line.strip() for line in open("data/artist.txt", "r")]
    
    for i in range(CNT):
        for j in range(randint(3, 12)):
            
            line = "{0},{1},{2},{3}\n".format(
                "{song_name:" + choice(songs), "artist_name:" + choice(artists), "playlist_name:playlist_" + str(i + 1), "author_id:" + str(randint(1, CNT)) + "}")
           
            file.write(line)

    file.close()
    
def generate_ag():
    file = open("csv/ag.csv", "w")
    file.write("[")
    
    genres = [line.strip() for line in open("data/genre.txt", "r")]
    artists = [line.strip() for line in open("data/artist.txt", "r")]
    
    for i in range(randint(100, 1000)):
            line = "{0},{1}\n".format(
                "{artist:" + choice(artists), "genre:" + choice(genres))
           
            file.write(line)
            
    file.write("]")
    file.close()
    
if __name__ == "__main__":
    #generate_category()
    #generate_artist()
    #generate_tag()
    generate_ag()