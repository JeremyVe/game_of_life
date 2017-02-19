# function CellObject(x, y, color) {
#   this.x = x;
#   this.y = y;
#   this.color = color
# }
#
#
# function Cell() {
#   var service = {};
#
#   service.updateCells = function(cells) {
#     var updatedCells = {};
#     var neighborCells = {};
#     for (var i in cells) {
#       var col = cells[i];
#       for (var j in col) {
#         var cell = col[j];
#         var living = updateCell(cell, cells, neighborCells);
#         if (living) {
#           if (updatedCells[cell.x]) {
#             updatedCells[cell.x][cell.y] = cell;
#           } else {
#             updatedCells[cell.x] = {};
#             updatedCells[cell.x][cell.y] = cell;
#           }
#         }
#       }
#     }
#     for (var i in neighborCells) {
#       var col = neighborCells[i];
#       for (var j in col) {
#         var neighbor = col[j];
#
#         if (neighbor.count === 3) {
#           var color = getNewColor(neighbor.colors);
#           cell = new CellObject(parseInt(i), parseInt(j), color);
#           if (updatedCells[cell.x]) {
#             updatedCells[cell.x][cell.y] = cell;
#           } else {
#             updatedCells[cell.x] = {};
#             updatedCells[cell.x][cell.y] = cell;
#           }
#         }
#       }
#     }
#     return updatedCells;
#   }
#
#
#   var getNewColor = function(colors) {
#     var color = [0,0,0];
#
#     for (var c = 0; c < 3; c++) {
#       colorArray = colors[c];
#       color[0] += colorArray[0];
#       color[1] += colorArray[1];
#       color[2] += colorArray[2];
#     }
#     color[0] = Math.round(color[0] / 3);
#     color[1] = Math.round(color[1] / 3);
#     color[2] = Math.round(color[2] / 3);
#
#     return color;
#   }
#
#
#   var updateCell = function(cell, cells, neighbors) {
#     //check surounding
#     var livingNeighborsCount = calculateNeighbors(cell, cells, neighbors);
#     return nextCellState(livingNeighborsCount);
#   }
#
#
#   var calculateNeighbors = function(cell, cells, neighbors) {
#     var x = cell.x;
#     var y = cell.y;
#     var color = cell.color;
#     var width = 30;
#     var height = 20;
#
#     var neighborPatterns = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]];
#     var livingNeighborsCount = 0;
#     for (var i = 0; i < neighborPatterns.length; i++) {
#       var neighbor = neighborPatterns[i];
#       var nX = neighbor[0];
#       var nY = neighbor[1];
#       // skip to next neighbor if the current doesn't exist
#       if (nX < 0 || nX > width || nY < 0 || nY > height) {
#         continue;
#       }
#
#       // living neighbor
#       if (cells[nX] && cells[nX][nY]) {
#         livingNeighborsCount++;
#
#       // dead neighbor
#       } else {
#         if (neighbors[nX]) {
#           if (neighbors[nX][nY]) {
#             neighbors[nX][nY].count++;
#             neighbors[nX][nY].colors.push(color);
#           } else {
#             neighbors[nX][nY] = {count: 1, colors: [color]};
#           }
#         } else {
#           neighbors[nX] = {};
#           neighbors[nX][nY] = {count: 1, colors: [color]};
#         }
#       }
#     }
#     return livingNeighborsCount;
#   }
#
#
#   var nextCellState = function(livingNeighborsCount) {
#       if (livingNeighborsCount < 2) {
#         return false; //dead
#       }
#       if (livingNeighborsCount < 4) {
#         return true; //live
#       }
#       return false; // if none of above, kill cell;
#   }
#
#   return service;
# }
