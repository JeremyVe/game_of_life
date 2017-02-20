class Life

  def self.update_cells
    cells = Life.get_current_board

    # neighborCells = {}

    updated_cells = Life.calculate_next_state( cells )


    $redis.set('cells', updated_cells.to_json)
    ActionCable.server.broadcast 'game_channel', updated_cells
    GameUpdateJob.perform_in(1)
  end

private

  def self.get_current_board
    return JSON.parse($redis.get('cells'))
  end

  def self.calculate_next_state cells
    life = {
      'updated_cells' => {},
      'neighbor_cells' => {},
    }
    cells.each do |x, col|
      col.each do |y, cell|
        living = Life.update_cell( cell, cells, life['neighbor_cells'] )
        life['updated_cells'] = Life.set_cell( cell, life['updated_cells'], living )
      end
    end

    life['neighbor_cells'].each do |x, col|
      col.each do |y, neighbor|
        if (neighbor['count'] === 3)
          color = Life.get_new_color(neighbor['colors'])
          cell = Life.create_cell( x, y, color)
          life['updated_cells'] = Life.set_cell( cell, life['updated_cells'] )
        end
      end
    end

    return life['updated_cells']
  end

  def self.create_cell( x, y, color )
    return {'x' => x, 'y' => y, 'color' => color}
  end

  def self.set_cell( cell, cells, living = true )
    if (living)
      if (cells.key?(cell['x']))
        cells[cell['x']][cell['y']] = cell
      else
        cells[cell['x']] = {}
        cells[cell['x']][cell['y']] = cell
      end
    end
    return cells
  end

  def self.get_new_color( colors )
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


  def self.update_cell( cell, cells, neighbor_cells )
    # check surounding
    living_neighbors_count = Life.calculate_neighbors(cell, cells, neighbor_cells)
    return Life.next_cell_state(living_neighbors_count)
  end


  def self.calculate_neighbors(cell, cells, neighbors)
    x = cell['x'].to_i
    y = cell['y'].to_i
    color = cell['color']
    width = 30
    height = 20
    neighbor_patterns = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]]
    living_neighbors_count = 0
    neighbor_patterns.each do |neighbor|
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
        living_neighbors_count += 1
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
    return living_neighbors_count
  end


  def self.next_cell_state living_neighbors_count

      if (living_neighbors_count < 2)
        return false # dead
      end
      if (living_neighbors_count < 4)
        return true # live
      end
      return false # if none of above, kill cell
  end
end
