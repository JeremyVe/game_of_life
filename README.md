# Game of Life
Multiplayer version of the game of life, using Websockets with ActionCable

<p align="center">
    <img src="game of life.png" />
</p>

You can check the live version of the game here :
<a href='http://young-refuge-98238.herokuapp.com/' target="_blank">Live version</a>


####To build on your computer : 


You need Redis, and Rails 5 (which need Ruby >= 2.2.2). Accordingly :


If Redis is not installed :
    
    brew install redis
    

If Ruby need to be updated : 
    
    \curl -sSL https://get.rvm.io | bash -s stable
    rvm install ruby-2.3.0
    rvm use ruby-2.3.0
    

If Rails is not installed :
    
    sudo gem install rails
    


Then :

    
    git clone https://github.com/JeremyVe/game_of_life.git
    cd game_of_life
    bundle install
      
    run redis-server in a new terminal window
    run rails s
    

And visit : http://localhost:3000
  
 
There is some tests present, testing the update function, in /spec/models/life_spec.rb
