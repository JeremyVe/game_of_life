App.game = App.cable.subscriptions.create("GameChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },
  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    var gameOfLife = Game.getInstance();
    gameOfLife.resetBoard();
    gameOfLife.printCells(data);
    //gameOfLife.printGrid();
  },
  action: function(cells) {
    this.perform('action', {cells: cells})
  }
})
