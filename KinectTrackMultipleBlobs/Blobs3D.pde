class Blob3D {
  //keep track of the leftMost and rightMost at each row
  Edges [] myEdges = new Edges[cam.height];
  int myColor = 0;
  int centerX;
  int centerY;
  int serialNumber;

  Blob3D(int _col, int _row, int _d) {
    setPoint(_col, _row, _d);
    centerX = _col;
    centerY = _row;
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
    int depthThreshold = _reach*3 ; //the resoultion of depth is more than the xy screen resolution so reach needs to be bigger
    for (int row = max(0,_row - _reach); row < min(_row + reach*2,cam.height); row++) { 
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        int distFromDepth = abs(_d-theseEdges.rightDepth);
        int distFromRight = (int) dist(_col, _row, theseEdges.rightEdge, row);
        if (distFromRight < closestDistance && distFromDepth < depthThreshold ) {
          closestDistance = distFromRight;
        }
        distFromDepth = abs(_d-theseEdges.leftDepth);
        int distFromLeft = (int) dist(_col, _row, theseEdges.leftEdge, row);
        if (distFromLeft < closestDistance && distFromDepth < depthThreshold) {
          closestDistance = distFromLeft;
        }
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
  
  void drawNumber(){
    textFont(myFont,72);
    println("serial " + serialNumber + " " + centerX + "  " + centerY);
    text(">"+ serialNumber, centerX,centerY);
  }
  void findCenter(){
     int sumX = 0;
     int sumY = 0;
     int allRows = 0;
     for (int row = 0; row < cam.height; row++) {
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        sumY = sumY + row;
        sumX = sumX + theseEdges.rightEdge + theseEdges.leftEdge;
        allRows++;
      }
     }
     centerX  = sumX/2*allRows;
     centerY  = sumY/allRows;
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

