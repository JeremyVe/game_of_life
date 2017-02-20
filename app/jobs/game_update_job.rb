class GameUpdateJob
  include SuckerPunch::Job
  workers 4

  def perform
    Life.update_cells
  end
end
