class Blob3D {
  //keep track of the leftMost and rightMost at each row
  Edges [] myEdges = new Edges[cam.height];

  Blob(int _col, int _row, int _d) {
    setPoint(_col, _row, _d);
  }

  void setPoint(int _col, int _row, int _d) {
    if (myEdges[_row] == null) {
      myEdges[_row] = new Edges(_col,_d);
    }
    else {
      myEdges[_row].setEdges(_col,_d);
    }
  }

  int getDistance(int _col, int _row, int _d, int _reach) {
    int closestDistance = 10000;
    // reach a little above the current row and go for a few below
    for (int row = max(0,_row - _reach); row < min(_row + reach*2,cam.height); row++) { 
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        int distFromRight = (int) dist(_col, _row, _d, theseEdges.rightEdge, row , theseEdges.backEdge);
        if (distFromRight < closestDistance) closestDistance = distFromRight;
        int distFromLeft = (int) dist(_col, _row, theseEdges.leftEdge, row, theseEges);
        if (distFromLeft < closestDistance) closestDistance = distFromLeft;
        //no need to check more if it is already within reach
        if (closestDistance < _reach) return closestDistance;
      }
    }
    return closestDistance;
  }

  void drawPoints() {
    for (int row = 0; row < cam.height; row++) {
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        point(theseEdges.rightEdge, row);
        point(theseEdges.leftEdge, row);
      }
    }
  }
  void drawLines() {
    int lastX = -1;
    int lastY = -1;
    for (int row = 0; row < cam.height; row++) {
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        if (lastX == -1){
          //this is the beginning of the first line
          lastX = theseEdges.rightEdge;
          lastY = row;
          continue; //wait until you have a second point to draw to
        }
        line(lastX, lastY,theseEdges.rightEdge, row);
        lastX = theseEdges.rightEdge;
        lastY = row;
      }
    }
    for (int row = cam.height-1; row > -1; row--) {
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        line(lastX, lastY,theseEdges.leftEdge, row);
        lastX = theseEdges.leftEdge;
        lastY = row;
      }
    }
  }
}

