class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel"

    GameHandler.new_player
    players_count = GameHandler.get_players_count
    ActionCable.server.broadcast 'game_channel', {'action'=> 'players', 'count'=> players_count}
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    GameHandler.player_left
    players_count = GameHandler.get_players_count
    ActionCable.server.broadcast 'game_channel', {'action'=> 'players', 'count'=> players_count}
  end

  def action( data )
    GameHandler.add_user_created_cells( data['cells'] )
  end
end
