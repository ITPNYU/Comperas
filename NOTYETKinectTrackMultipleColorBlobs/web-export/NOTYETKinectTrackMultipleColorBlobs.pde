import SimpleOpenNI.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation

SimpleOpenNI kinect;

float goalRed = 200;
float goalGreen = 0;
float goalBlue = 0;
int threshold = 20;
int reach = 15;
long elapsedTime;
  PImage cam ;

void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // enable color image from the Kinect
  kinect.enableRGB();
  // turn on depth-color alignment
  kinect.alternativeViewPointDepthToImage();

}

void draw() {
  kinect.update();
  //make an object to recieve depth info
  int[ ] allDepths = new int[640*480];
  //recieve depth info
  kinect.depthMap(allDepths );
  cam= kinect.rgbImage();

  long startTime = millis();
  //cam.filter(BLUR, 2);

  elapsedTime = millis() - startTime;
  //println(elapsedTime);  
  //uncomment this line or press 't' to see how long the blur takes.

  ArrayList blobs = new ArrayList();
  for (int row = 0; row < cam.height; row++) {
    for (int col = 0; col < cam.width; col++) {
      int offset = row * width + col;
      int thisPixel = cam.pixels[offset];
      float r = red(thisPixel);
      float g = green(thisPixel);
      float b = blue(thisPixel);
      int d = allDepths[offset];
      float closeness = dist(r, g, b, goalRed, goalGreen, goalBlue);
      if (closeness < threshold) {
        cam.pixels[offset] = 0;
        //be pessimistic
        boolean foundAHome = false;
        //look throught the existing
        for (int i = 0; i < blobs.size(); i++) {
          Blob existingBlob =  (Blob) blobs.get(i);
          //is this spot is near an existing Blob
          if (existingBlob.getDistance(col, row, d, reach) < reach) {
            existingBlob.setPoint(col, row,d);
            foundAHome = true; //no need to make a new one
            break; //no need to look through the rest of the boxes
          }
        }
        //if this does not belong to one of the existing boxes make a new one at this place
        if (foundAHome == false) blobs.add(new Blob(col, row, d));
      }
    }
  }

  //consolidate(boxes,0,0);
  image(cam, 0, 0);
  fill(0, 0, 0, 0);
  stroke(255, 0, 0);
  for (int i = 0; i < blobs.size(); i++) {
    Blob thisBlob =  (Blob) blobs.get(i);
    thisBlob.drawLines();
  }
  println("Number of Blobs " + blobs.size());
}


void mousePressed() {
  int thisPixel = cam.pixels[mouseY * width + mouseX];
  goalRed = red(thisPixel);
  goalGreen = green(thisPixel);
  goalBlue = blue(thisPixel);
  println("Goal" + goalRed + " " + goalGreen + " " + goalBlue);
}

void keyPressed() {
  if (key == '-') {
    threshold--;
    println("Threshold " + threshold);
  } 
  else if (key == '=') {
    threshold++;
    println("Threshold " + threshold);
  } 
  else if (key == 'r') {
    reach--;
    println("reach " + reach);
  } 
  else if (key == 'R') {
    reach++;
    println("reach " + reach);
  } 
  else if (key == 't') {

    println("Elapsedtime " + elapsedTime);
  }
}

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

class Edges {

  int leftEdge ; 
  int rightEdge ;
  Edges(int _col) {
    leftEdge = _col;
    rightEdge = _col;
  }
  void setEdges(int _col) {
    if (_col < leftEdge) leftEdge = _col; 
    if (_col > rightEdge) rightEdge = _col;
  }
}

