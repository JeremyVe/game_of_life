class Life

  def self.update_cells
    cells = get_current_board

    updated_cells = calculate_next_state( cells )

    $redis.set('cells', updated_cells.to_json)
    ActionCable.server.broadcast 'game_channel', updated_cells
    GameUpdateJob.perform_in(1)
  end

private

  def self.get_current_board
    return JSON.parse($redis.get('cells'))
  end


  def self.calculate_next_state( cells )
    life = {
      'updated_cells' => {},
      'neighbor_cells' => {},
    }
    cells.each do |x, col|
      col.each do |y, cell|
        current_cell = {'x' => x, 'y' => y, 'color' => cell}
        living = calculate_cell( current_cell, cells, life['neighbor_cells'] )
        life['updated_cells'] = set_cell( current_cell, life['updated_cells'], living )
      end
    end

    life['neighbor_cells'].each do |x, col|
      col.each do |y, neighbor|
        if (neighbor['count'] === 3)
          color = get_new_color(neighbor['colors'])
          cell =  create_cell( x, y, color)
          life['updated_cells'] = set_cell( cell, life['updated_cells'] )
        end
      end
    end

    return life['updated_cells']
  end

  def self.create_cell( x, y, color )
    return {'x' => x.to_s, 'y' => y.to_s, 'color' => color}
  end



  def self.calculate_neighbors(cell, cells, neighbors)
    x = cell['x'].to_i
    y = cell['y'].to_i

    color = cell['color']
    width = 60
    height = 40
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


  def self.set_cell( cell, cells, living = true )
    if (living)
      if (cells.key?(cell['x']))
        cells[cell['x']][cell['y']] = cell['color']
      else
        cells[cell['x']] = {}
        cells[cell['x']][cell['y']] = cell['color']
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


  def self.calculate_cell( cell, cells, neighbor_cells )
    # check surounding
    living_neighbors_count = calculate_neighbors(cell, cells, neighbor_cells)
    return next_cell_state(living_neighbors_count)
  end

end
