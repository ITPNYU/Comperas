import processing.video.*;

float goalRed = 200;
float goalGreen = 0;
float goalBlue = 0;
int threshold = 20;
int reach = 15;
long elapsedTime;
Capture cam;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height);
  cam.start();
}

void draw() {
  if (cam.available()) {


    cam.read();
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
        float closeness = dist(r, g, b, goalRed, goalGreen, goalBlue);
        if (closeness < threshold) {
          cam.pixels[offset] = 0;
          //be pessimistic
          boolean foundAHome = false;
          //look throught the existing
          for (int i = 0; i < blobs.size(); i++) {
            Blob existingBlob =  (Blob) blobs.get(i);
            //is this spot is near an existing Blob
            if (existingBlob.getDistance(col, row, reach) < reach) {
              existingBlob.setPoint(col, row);
              foundAHome = true; //no need to make a new one
              break; //no need to look through the rest of the boxes
            }
          }
          //if this does not belong to one of the existing boxes make a new one at this place
          if (foundAHome == false) blobs.add(new Blob(col, row));
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
}




class Blob {
  //keep track of the leftMost and rightMost at each row
  Edges [] myEdges = new Edges[cam.height];

  Blob(int _col, int _row) {
    setPoint(_col, _row);
  }

  void setPoint(int _col, int _row) {
    if (myEdges[_row] == null) {
      myEdges[_row] = new Edges(_col);
    }
    else {
      myEdges[_row].setEdges(_col);
    }
  }

  int getDistance(int _col, int _row, int _reach) {
    int closestDistance = 10000;
    // reach a little above the current row and go for a few below
    for (int row = max(0,_row - _reach); row < min(_row + reach*2,cam.height); row++) { 
      Edges theseEdges = myEdges[row];
      if (theseEdges != null) {
        int distFromRight = (int) dist(_col, _row, theseEdges.rightEdge, row);
        if (distFromRight < closestDistance) closestDistance = distFromRight;
        int distFromLeft = (int) dist(_col, _row, theseEdges.leftEdge, row);
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

