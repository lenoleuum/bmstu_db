class artist():
    name = str()
    genre = str()
    link = str()
    num_list = int()
    most_popular_track = str()
    latest_release = str()
    
    def __init__(self, name, genre, link, num_list, most_popular_track, latest_release):
        self.name = name
        self.genre = genre
        self.link = link
        self.num_list = num_list
        self.most_popular_track = most_popular_track
        self.latest_release = latest_release
        
    def get(self):
        return {'name': self.name, 'genre': self.genre, 'link': self.link, 'num_list': self.num_list, 
        'most_popular_track': self.most_popular_track, 'latest_release': self.latest_release}
        
        
        
def create_artists(file_name):
    file = open(file_name, 'r')
    artists = list()
    
    for line in file:
        arr = line.split(',')
        arr[3] = int(arr[3])
        
        artists.append(artist(*arr).get())
    
    return artists