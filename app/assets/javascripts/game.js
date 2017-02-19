var Game = (function() {
  var instance;

  function instantiateGame() {
    var cell = Cell()
    var board = Board(cell);
    return {board: board};
  }

  return {
    getInstance: function() {
      if (!instance) {
        instance = instantiateGame();
        instance.board.init();
      }
      return instance;
    }
  }
})()
