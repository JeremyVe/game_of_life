function GameOfLife() {
  // set different pattern coordinates
  var patterns = {
                  'glider': [[0, -1], [1, 0], [1, 1], [0, 1], [-1, 1]],
                  'square': [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]],
                  'pentadecathlon': [[0, -5], [0, -4], [-1, -3], [1, -3], [0, -2], [0, -1], [0, 0], [0, 1], [-1, 2], [1, 2], [0, 3], [0, 4]]
                }

  // set canvas related config
  var canvas = {
    el: undefined,
    ctx: undefined,
    colorContainer: undefined,
    playersCountEl: undefined,
    width: 600,
    height: 400,
    cellSize: 10,
    color: undefined
  }
  canvas.rows = canvas.height / canvas.cellSize;
  canvas.cols = canvas.width / canvas.cellSize;

  var service = {};


  service.updateBoard = function(cells) {
    resetBoard();
    printCells(cells);
    // printGrid()
  }

  service.changePlayersCount = function(count) {
    var playerString = count + ' Player'
    playerString += count > 1 ? 's' : ''
    canvas.playersCountEl.innerHTML = playerString;
    canvas.playersCountEl.classList.add('player-count-change')
    setTimeout(function() {
      canvas.playersCountEl.classList.remove('player-count-change')
    }, 300)
  }


  var printCells = function(cells) {
    for (var i in cells) {
      var col = cells[i];
      for (var j in col) {
        var color = col[j];
        printUniqCell({x: i, y: j, color: color})
      }
    }
  }


  var printGrid = function() {
    canvas.ctx.strokeStyle = 'rgb(200,200,200)';
    // columns
    for (var x = 0; x <= canvas.cols; x++) {
      canvas.ctx.moveTo(x * canvas.cellSize, 0);
      canvas.ctx.lineTo(x * canvas.cellSize, canvas.height);
    }
    // rows
    for (var y = 0; y <= canvas.rows; y++) {
      canvas.ctx.moveTo(0, y * canvas.cellSize);
      canvas.ctx.lineTo(canvas.width, y * canvas.cellSize);
    }
    canvas.ctx.stroke();
  }


  var resetBoard = function() {
    canvas.ctx.clearRect(0, 0, canvas.width, canvas.height);
  }


  var createCell = function(event) {
    //get x & y click coordinates
    var x = Math.floor(event.offsetX / canvas.cellSize);
    var y = Math.floor(event.offsetY / canvas.cellSize);

    var newCell = {x: x, y: y, color: canvas.color};

    printUniqCell(newCell);
    App.game.action([newCell]);
  }


  var createPattern = function(event) {
    var name = event.target.getAttribute('data-pattern');
    var pattern = patterns[name];
    var cells = [];
    var randX = Math.floor(Math.random() * (canvas.cols-10)) + 5;
    var randY = Math.floor(Math.random() * (canvas.rows-10)) + 5;

    for (var i = 0; i < pattern.length; i++) {
      var coord = pattern[i];
      var x = randX + coord[0];
      var y = randY + coord[1];

      var newCell = {x: x, y: y, color: canvas.color};
      cells.push(newCell);
      printUniqCell(newCell);
    }
    App.game.action(cells);
  }


  var changeColor = function() {
    canvas.color = getRandomColor();
    canvas.colorContainer.style.background = 'rgb(' + canvas.color[0] + ', ' +
                                                      canvas.color[1] + ', ' +
                                                      canvas.color[2] + ')';
    return color;
  }


  var getRandomColor = function() {
    return [Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), Math.floor(Math.random() * 255)];
  }


  var printUniqCell = function(cell) {
    var color = 'rgb(' + cell.color[0] + ', ' + cell.color[1] + ', ' + cell.color[2] + ')';
    canvas.ctx.fillStyle = color;
    canvas.ctx.fillRect(cell.x * canvas.cellSize, cell.y * canvas.cellSize, canvas.cellSize, canvas.cellSize);
    //canvas.ctx.stroke()
  }


  var addClickListeners = function() {
    canvas.el.addEventListener('click', createCell);
    var patternsContainer = document.getElementById('patterns');
    patternsContainer.addEventListener('click', createPattern);
    canvas.colorContainer.addEventListener('click', changeColor);
  }


  service.init = function() {
    canvas.el = document.getElementById('game');
    canvas.ctx = canvas.el.getContext('2d');
    canvas.colorContainer = document.getElementById('color');
    canvas.playersCountEl = document.getElementById('players');
    changeColor();

    addClickListeners();
    // service.printGrid();
  }

  return service;
}
