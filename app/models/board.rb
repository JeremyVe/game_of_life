class Board
  include SuckerPunch::Job
  workers 4

  def perform
    Board.new.updateCells
  end

  def updateCells
    cells = JSON.parse($redis.get('cells'))
    updatedCells = {}
    neighborCells = {}
    cells.each do |i, col|
      col.each do |j, cell|
        living = Board.updateCell(cell, cells, neighborCells)
        if (living)
          if (updatedCells.key?(cell['x'].to_s))
            updatedCells[cell['x'].to_s][cell['y'].to_s] = cell
          else
            updatedCells[cell['x'].to_s] = {}
            updatedCells[cell['x'].to_s][cell['y'].to_s] = cell
          end
        end
      end
    end

    neighborCells.each do |i, col|
      col.each do |j, neighbor|
        if (neighbor['count'] === 3)
          color = Board.getNewColor(neighbor['colors'])
          cell = {'x' => i.to_i, 'y' => j.to_i, 'color' => color}
          if (updatedCells.key?(cell['x'].to_s))
            updatedCells[cell['x'].to_s][cell['y'].to_s] = cell
          else
            updatedCells[cell['x'].to_s] = {}
            updatedCells[cell['x'].to_s][cell['y'].to_s] = cell
          end
        end
      end
    end
    $redis.set('cells', updatedCells.to_json)
    ActionCable.server.broadcast 'game_channel', updatedCells
    Board.perform_in(1)
  end


  def self.getNewColor(colors)
    color = [0,0,0]

    colors.each do |colorArray|
      color[0] += colorArray[0]
      color[1] += colorArray[1]
      color[2] += colorArray[2]
    end
    color[0] = (color[0] / 3).round
    color[1] = (color[1] / 3).round
    color[2] = (color[2] / 3).round

    return color
  end


  def self.updateCell cell, cells, neighborCells
    # check surounding
    livingNeighborsCount = Board.calculateNeighbors(cell, cells, neighborCells)
    return Board.nextCellState(livingNeighborsCount)
  end


  def self.calculateNeighbors(cell, cells, neighbors)
    x = cell['x']
    y = cell['y']
    color = cell['color']
    width = 30
    height = 20
    neighborPatterns = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]]
    livingNeighborsCount = 0
    neighborPatterns.each do |neighbor|
      nX = neighbor[0]
      nY = neighbor[1]
      # skip to next neighbor if the current doesn't exist
      if (nX < 0 || nX > width || nY < 0 || nY > height)
        next
      end
      # living neighbor
      nX = nX.to_s
      nY = nY.to_s
      if (cells.key?(nX) && cells[nX].key?(nY))
        livingNeighborsCount += 1
      else
        if (neighbors.key?(nX))
          if (neighbors[nX].key?(nY))
            neighbors[nX][nY]['count'] += 1;
            neighbors[nX][nY]['colors'].push(color);
          else
            neighbors[nX][nY] = {'count' => 1, 'colors' => [color]};
          end
        else
          neighbors[nX] = {};
          neighbors[nX][nY] = {'count' => 1, 'colors' => [color]};
        end
      end
    end
    return livingNeighborsCount
  end


  def self.nextCellState livingNeighborsCount

      if (livingNeighborsCount < 2)
        return false # dead
      end
      if (livingNeighborsCount < 4)
        return true # live
      end
      return false # if none of above, kill cell
  end
end
