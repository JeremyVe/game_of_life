var Game = (function() {
  var instance;

  function instantiateGame() {
    var game = GameOfLife();
    return game;
  }

  return {
    getInstance: function() {
      if (!instance) {
        instance = instantiateGame();
        instance.init();
      }
      return instance;
    }
  }
})()
