function Board() {
  //var liveCells = {};
  var patterns = {
                  'glider': [[0, -1], [1, 0], [1, 1], [0, 1], [-1, 1]],
                  'square': [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]],
                  'pentadecathlon': [[0, -5], [0, -4], [-1, -3], [1, -3], [0, -2], [0, -1], [0, 0], [0, 1], [-1, 2], [1, 2], [0, 3], [0, 4]]
                }
  var canvas;
  var ctx;
  var width = 600;
  var height = 400;
  var cellSize = 20;
  var rows = height/cellSize;
  var cols = width/cellSize;
  var color;
  var colorContainer;
  //var id = Math.random();

  var service = {};

  service.printCells = function(liveCells) {
    for (var i in liveCells) {
      var col = liveCells[i];
      for (var j in col) {
        var cell = col[j];
        ctx.fillStyle = 'rgb(' + cell.color[0] + ', ' + cell.color[1] + ', ' + cell.color[2] + ')';
        ctx.fillRect(cell.x * cellSize, cell.y * cellSize, cellSize, cellSize)
        //ctx.stroke()
      }
    }
  }


  // var updateBoard = function() {
  //   return cellFactory.updateCells(liveCells);
  // }


  service.printBoard = function() {
    ctx.strokeStyle = 'rgb(200,200,200)';
    for (var x = 0; x <= cols; x++) {
      ctx.moveTo(x * cellSize, 0);
      ctx.lineTo(x * cellSize, height);
    }
    for (var y = 0; y <= rows; y++) {
      ctx.moveTo(0, y * cellSize);
      ctx.lineTo(width, y * cellSize);
    }
    ctx.stroke();
  }


  service.resetBoard = function() {
    ctx.clearRect(0, 0, width, height);
  }


  var addClickListeners = function() {
    canvas.addEventListener('click', createCell);
    var patternsContainer = document.getElementById('patterns');
    patternsContainer.addEventListener('click', createPattern);

    colorContainer.addEventListener('click', changeColor);

  }


  var changeColor = function() {
    color = getRandomColor();
    colorContainer.style.background = 'rgb(' + color[0] + ', ' + color[1] + ', ' + color[2] + ')';
    return color;
  }


  var createCell = function(event) {
    //get x & y click coordinates
    var x = Math.floor(event.offsetX / cellSize);
    var y = Math.floor(event.offsetY / cellSize);

    //var newCell = new CellObject(x, y, color);
    var newCell = {x: x, y: y, color: color};
    // if (liveCells[x]) {
    //   liveCells[x][y] = newCell;
    // } else {
    //   liveCells[x] = {};
    //   liveCells[x][y] = newCell;
    // }
    printUniqCell(newCell);
    App.game.action([newCell]);
  }

  // var checkCreatorIsUser = function(data) {
  //   if (id === data.id) {
  //     return;
  //   }
  // }


  // service.createSyncCell = function(data) {
  //   //checkCreatorIsUser(data);
  //
  //   var x = data.x;
  //   var y = data.y;
  //   var newCell = new CellObject(x, y, data.color);
  //   if (liveCells[x]) {
  //     liveCells[x][y] = newCell;
  //   } else {
  //     liveCells[x] = {};
  //     liveCells[x][y] = newCell;
  //   }
  //   printUniqCell(newCell);
  // }


  var createPattern = function(event) {
    var name = event.target.getAttribute('data-pattern') || event.name;
    var pattern = patterns[name];
    cells = []
    var randX = Math.floor(Math.random() * (cols-10)) + 5;
    var randY = Math.floor(Math.random() * (rows-10)) + 5;
    for (var i = 0; i < pattern.length; i++) {
      var coord = pattern[i];
      var x = randX + coord[0];
      var y = randY + coord[1];

      var newCell = new CellObject(x, y, color);
      cells.push(newCell);
      // if (liveCells[x]) {
      //   liveCells[x][y] = newCell;
      // } else {
      //   liveCells[x] = {};
      //   liveCells[x][y] = newCell;
      // }
      printUniqCell(newCell);
    }
    App.game.action(cells);
  }


  // service.createSyncPattern = function(data) {
  //   checkCreatorIsUser(data);
  //
  //   var pattern = patterns[data.name];
  //   for (var i = 0; i < pattern.length; i++) {
  //     var coord = pattern[i];
  //     var x = data.x + coord[0];
  //     var y = data.y + coord[1];
  //     var newCell = new CellObject(x, y, data.color);
  //     if (liveCells[x]) {
  //       liveCells[x][y] = newCell;
  //     } else {
  //       liveCells[x] = {};
  //       liveCells[x][y] = newCell;
  //     }
  //     printUniqCell(newCell);
  //   }
  // }


  var printUniqCell = function(cell) {
    var color = 'rgb(' + cell.color[0] + ', ' + cell.color[1] + ', ' + cell.color[2] + ')';
    ctx.fillStyle = color;
    ctx.fillRect(cell.x * cellSize, cell.y * cellSize, cellSize, cellSize);
    //ctx.stroke()
  }


  var getRandomColor = function() {
    return [Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), Math.floor(Math.random() * 255)];
  }


  service.init = function() {
    canvas = document.getElementById('game');
    ctx = canvas.getContext('2d');
    colorContainer = document.getElementById('color');
    color = changeColor();

    addClickListeners();
    service.printBoard();
  //   printCells();
  //
  //   setInterval(function() {
  //     liveCells = updateBoard();
  //     resetBoard();
  //     printBoard();
  //     printCells();
  //   }, 5000)
  }

  return service;
}
