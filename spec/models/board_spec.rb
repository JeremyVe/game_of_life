require 'rails_helper'

describe Board do
  context '#initialize' do
    it 'should set up an empty hash as "cells" save in redis' do
      board = Board.new
      expect($redis.get('cells')).to eq({}.to_json)
    end
  end

  context '#get' do
    it 'should parse and return the saved board' do
      board = Board.new
      expect(board.get).to eq({})
    end
  end

  context '#update' do
    it 'should jsonify and save the updated board' do
      board = Board.new
      updated_board = {'3'=> {'4'=>[2,3,4]}}
      board.update( updated_board )
      expect($redis.get('cells')).to eq(updated_board.to_json)
    end
  end

  context '#add_user_created_cells' do
    it 'should add a user cell to the cells board' do
      board = Board.new
      user_cells = [{'x'=> 3, 'y'=>5, 'color'=>[2,3,4]}]
      board.add_user_created_cells user_cells

      expectation = {'3'=> {'5'=> [2,3,4]}}.to_json
      expect($redis.get('cells')).to eq(expectation)
    end

    it 'should add a user pattern to the cells board' do
      board = Board.new

      user_cells = [{'x'=> 3, 'y'=>5, 'color'=>[2,3,4]},
                    {'x'=> 3, 'y'=>6, 'color'=>[2,3,4]},
                    {'x'=> 3, 'y'=>7, 'color'=>[2,3,4]}]
      board.add_user_created_cells user_cells

      expectation = {'3'=> {'5'=> [2,3,4], '6'=> [2,3,4], '7'=> [2,3,4]}}
      expect($redis.get('cells')).to eq(expectation.to_json)
    end

    it 'should override a cell with the new cell' do
      board_cells = {'3'=> {'5'=> [2,3,4]}}
      board = Board.new
      board.update board_cells

      user_cells = [{'x'=> 3, 'y'=>5, 'color'=>[10,11,12]}]
      board.add_user_created_cells user_cells

      expectation = {'3'=> {'5'=> [10,11,12]}}
      expect($redis.get('cells')).to eq(expectation.to_json)
    end
  end
end
