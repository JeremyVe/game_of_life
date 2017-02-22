class GameHandler
  @@running = false
  @@players = Players.new
  @@board = Board.new
  @@cells = Cells.new

  


  def self.add_user_created_cells( cells )
    @@board.add_user_created_cells( cells )
  end

  def self.new_player
    @@players.new_player
    start_update_loop if @@players.first_connected?
  end

  def self.player_left
    @@players.player_left
    stop_update_loop if @@players.no_more_players?
  end

  def self.get_players_count
    @@players.get_players_count
  end

  private

  def self.start_update_loop
    @@running = true
    Thread.new do
      while @@running do
        prev = Time.now
        @@cells.update
        update_time = Time.now - prev
        sleep 1
      end
    end
  end

  def self.stop_update_loop
    @@running = false
  end

end
