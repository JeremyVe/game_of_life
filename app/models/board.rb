class Board

  def initialize
    $redis = Redis::Namespace.new('gof', :redis => Redis.new)
    $redis.set("cells", {} )
  end

  def get
    JSON.parse( $redis.get('cells') )
  end

  def update( board )
    $redis.set('cells', board.to_json )
  end

  def add_user_created_cells( cells )
    board = get
    cells.each do |cell|
      board[cell['x'].to_s] = board[cell['x'].to_s] || {}
      board[cell['x'].to_s][cell['y'].to_s] = cell['color']
    end
    update( board )
  end
end
