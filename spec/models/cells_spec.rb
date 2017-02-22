require 'rails_helper'

describe Cells do
  context '#create_cell' do
    cell = {'x'=>5, 'y'=>4, 'color'=>[2,3,4]}
    result = Cells.new.send(:create_cell, cell)
    it 'should return a cell' do
      expect(result).to eq({'x' => '5', 'y' => '4', 'color' => [2,3,4]})
    end
  end

  context '#get_new_color' do
    colors = [[200, 200, 200], [100, 130, 10], [60, 60, 60]]
    result = Cells.new.send(:get_new_color, colors)
    it 'shoud return an average of the colors provided' do
      expect(result).to eq([120, 130, 90])
    end
  end

  context '#add_cell' do
    cell = {'x' => '5', 'y' => '4', 'color' => [2,3,4]}

    it 'should add the cell to the list if living is true' do
      cells = {}
      result = Cells.new.send(:add_cell, cell, cells, true )

      expectation = {'5' => {'4' => [2,3,4]}}
      expect(result).to eq(expectation)
    end

    it 'should not add the cell to the list if living is false' do
      cells = {}
      result = Cells.new.send(:add_cell, cell, cells, false )

      expectation = {}
      expect(result).to eq(expectation)
    end

    it 'should not override the list when appending a cell' do
      cells = {}
      cells['5'] = {'3' => [2,3,4]}
      result = Cells.new.send(:add_cell, cell, cells, true )

      expectation = 2
      expect(result['5'].length).to eq(expectation)
    end
  end

  context '#next_cell_state' do
    it 'should return true if living neighbors is 2 or 3' do
      result = Cells.new.send(:next_cell_state, 2)
      expect(result).to eq(true)

      result = Cells.new.send(:next_cell_state, 3)
      expect(result).to eq(true)
    end

    it 'should return false if living neighbors is < 2' do
      result = Cells.new.send(:next_cell_state, 1)
      expect(result).to eq(false)
    end

    it 'should return false if living neighbors is > 3' do
      result = Cells.new.send(:next_cell_state, 4)
      expect(result).to eq(false)
    end
  end

  context '#calculate_neighbors' do
    cell = {'x' => 5, 'y' => 5, 'color' => [2,3,4]}

    it 'should return the number of living neighbors if none' do
      cells = {}
      neighbors = {}
      result = Cells.new.send( :calculate_neighbors, cell, cells, neighbors )
      expect(result).to eq( 0 )
    end

    it 'should return the number of living neighbors' do
      cells = {'5' => {'4' => [2,3,4]}, '6' => {'4' => [2,3,4]}}
      neighbors = {}
      result = Cells.new.send( :calculate_neighbors, cell, cells, neighbors )
      expect(result).to eq( 2 )
    end

    it 'should set the number of living cell for each neighbor' do
      cells = {}
      neighbors = {
        "4"=>{"4"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "5"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "6"=>{"count"=>1, "colors"=>[[2, 3, 4]]}},
        "5"=>{"4"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "6"=>{"count"=>1, "colors"=>[[2, 3, 4]]}},
        "6"=>{"4"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "5"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "6"=>{"count"=>1, "colors"=>[[2, 3, 4]]}}
      }
      Cells.new.send( :calculate_neighbors, cell, cells, neighbors )
      expect(neighbors).to eq( neighbors )
    end
  end

  context '#calculate_cell' do

    cell = {'x' => 5, 'y' => 5, 'color' => [2,3,4]}
    cells = {'5' => {'4' => [2,3,4]}, '6' => {'4' => [2,3,4]}}
    neighbors = {}

    it 'should return true if the cell will live' do
      new_cell = Cells.new
      allow(new_cell).to receive(:calculate_neighbors).and_return( 3 )
      result = new_cell.send(:calculate_cell, cell, cells, neighbors )
      expect(result).to eq(true)
    end

    it 'should return false if the cell will die' do
      new_cell = Cells.new
      allow(new_cell).to receive(:calculate_neighbors).and_return( 4 )
      result = new_cell.send(:calculate_cell, cell, cells, neighbors )
      expect(result).to eq(false)
    end
  end

  context '#calculate_next_state' do
    it 'should return a hash with the cells living the next round' do
      life = {
        'updated_cells' => {},
        'neighbor_cells' => {},
      }
      cells = { "4"=>{"4"=>[2, 3, 4], "5"=>[2, 3, 4], "6"=>[2, 3, 4]} }

      expectation = {"neighbor_cells" => {"3"=>{"3"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "4"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]},
                                          "5"=>{"count"=>3, "colors"=>[[2, 3, 4], [2, 3, 4], [2, 3, 4]]}, "6"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]},
                                          "7"=>{"count"=>1, "colors"=>[[2, 3, 4]]}}, "4"=>{"3"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "7"=>{"count"=>1, "colors"=>[[2, 3, 4]]}},
                                          "5"=>{"3"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "4"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]}, "5"=>{"count"=>3, "colors"=>[[2, 3, 4], [2, 3, 4], [2, 3, 4]]},
                                          "6"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]}, "7"=>{"count"=>1, "colors"=>[[2, 3, 4]]}}},
                     "updated_cells" => {"4"=>{"5"=>[2, 3, 4]}},
                   }
      result = Cells.new.send(:calculate_next_state, cells, life)
      expect(result).to eq(expectation)
    end
  end

  context '#reborn_neighbors' do
    it 'should return a hash with the cells living the next round' do

      life = {"neighbor_cells" => {"3"=>{"3"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "4"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]},
                                         "5"=>{"count"=>3, "colors"=>[[2, 3, 4], [2, 3, 4], [2, 3, 4]]}, "6"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]},
                                         "7"=>{"count"=>1, "colors"=>[[2, 3, 4]]}}, "4"=>{"3"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "7"=>{"count"=>1, "colors"=>[[2, 3, 4]]}},
                                         "5"=>{"3"=>{"count"=>1, "colors"=>[[2, 3, 4]]}, "4"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]}, "5"=>{"count"=>3, "colors"=>[[2, 3, 4], [2, 3, 4], [2, 3, 4]]},
                                         "6"=>{"count"=>2, "colors"=>[[2, 3, 4], [2, 3, 4]]}, "7"=>{"count"=>1, "colors"=>[[2, 3, 4]]}}},
                     "updated_cells" => {"4"=>{"5"=>[2, 3, 4]}},
                   }
      expectation = { "neighbor_cells" => life["neighbor_cells"],
         "updated_cells"=>{"4"=>{"5"=>[2, 3, 4]}, "3"=>{"5"=>[2, 3, 4]}, "5"=>{"5"=>[2, 3, 4]}}}
      result = Cells.new.send(:reborn_neighbors, life)
      expect(result).to eq(expectation)
    end
  end
end
