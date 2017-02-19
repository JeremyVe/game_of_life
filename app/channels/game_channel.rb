class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def action data
    cells = JSON.parse($redis.get('cells'))
    data['cells'].each do |cell|
      cells[cell['x'].to_s] = cells[cell['x'].to_s] || {}
      cells[cell['x'].to_s][cell['y'].to_s] = {'x' => cell['x'], 'y' => cell['y'], 'color' => cell['color']}
    end
    $redis.set('cells', cells.to_json )
    #ActionCable.server.broadcast "game_channel", {test: 'test'}
  end
end
