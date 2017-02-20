class GameUpdateJob
  include SuckerPunch::Job
  workers 4

  def perform
    Life.update_board
  end
end
