class Players
@@count = 0

  def new_player
    puts 'new player'
    @@count += 1
  end


  def player_left
    puts 'player left'
    @@count -= 1
  end

  def get_players_count
    return @@count
  end


  def first_connected?
    return @@count == 1 ? true : false
  end

  def no_more_players?
    return @@count == 0 ? true : false
  end

end
