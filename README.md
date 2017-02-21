# Game of Life
### Multiplayer version of the game of life, using Websockets with ActionCable

You can check the live version of the game here :
<a href='http://young-refuge-98238.herokuapp.com/'>Live version</a>


To build it on your computer : 

You need Rails 5, and Redis :

If Redis is not installed :
  brew install redis
  
If Rails is not installed :
  sudo gem install rails

Ruby >= 2.2.2 : 
  \curl -L https://get.rvm.io | bash -s stable –ruby
  rvm install ruby-2.3.0
  rvm use ruby-2.3.0

Then :

git clone https://github.com/JeremyVe/game_of_life.git
cd game_of_life
bundle install
  
redis-server
rails s

visit : http://localhost:3000
  
 
