import processing.video.*;

float skinRedLower = .35f;
float skinRedUpper = .55f;
float skinGreenLower = .26f;
float skinGreenUpper = .35f;
int reach = 3;
Capture cam;
int w = 640;
int h = 480;
boolean debug = true;
long elapsedTime = 0;

void setup() {
  size(w, h);  
  cam = new Capture(this, w, h, 30);
  cam.start();
}

public void draw() {  //called everytime there is a new frame

  long startTime = System.currentTimeMillis();

  if (cam.available()) {
    cam.read(); //get the incoming frame as a picture
    ArrayList rects = findRectangles();

    //println(elapsedTime);  
    consolidate(rects, 0, 0);
    cleanUp(rects, 100);
    if (debug) image(cam, 0, 0);
    fill(0, 0, 0, 0);
    stroke(255, 0, 0);
    for (int i = 0; i < rects .size(); i++) {
      Rectangle thisBox =  (Rectangle) rects .get(i);
      thisBox.draw();
    }

    elapsedTime = System.currentTimeMillis() - startTime;
  }
}

boolean test(int _thisPixel) {
  float r = red(_thisPixel);
  float g = green(_thisPixel);
  float total = r + g + blue(_thisPixel);
//convert into a "normalized" instead of RGB
  float percentRed = r/total;
  float percentGreen = g/total;
  return (percentRed < skinRedUpper && percentRed > skinRedLower  && percentGreen < skinGreenUpper && percentGreen > skinGreenLower);
}



void keyPressed() {

  //for adjusting things on the fly
  if (key == '-') {
    skinRedUpper = skinRedUpper - .01f;

    skinRedLower = skinRedLower - .01f;
  } 
  else if (key == '=') {
    skinRedUpper = skinRedUpper + .01f;

    skinRedLower = skinRedLower + .01f;
  }
  else if (key == '_') {
    skinGreenUpper = skinGreenUpper - .01f;

    skinGreenLower = skinGreenLower - .01f;
  } 
  else if (key == '+') {
    skinGreenUpper = skinGreenUpper + .01f;

    skinGreenLower = skinGreenLower + .01f;
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
  else if (key == 'd') {
    debug = !debug;
    println("debug  " + debug);
  }
  println("RU:" + skinRedUpper + " RL:" + skinRedLower +"GU:" + skinGreenUpper + " GL:" + skinGreenLower );
}
void cleanUp(ArrayList _rects, int _sizeThreshold) {
  for (int j = _rects.size() - 1; j > -1; j--) { 

    Rectangle newRect = (Rectangle) _rects.get(j);
    if (newRect.getHeight()*newRect.getWidth() < _sizeThreshold) _rects.remove(j); //if the area to small, loose it
  }
} 


public void consolidate(ArrayList _shapes, int _consolidateReachX, int _consolidateReachY) { 

  //check every combination of shapes for overlap 
  //make the repeat loop backwards so you delete off the bottom of the stack
  for (int i = _shapes.size() - 1; i > -1; i--) {
    //only check the ones up 
    Rectangle shape1 = (Rectangle) _shapes.get(i);

    for (int j = i - 1; j > -1; j--) {
      Rectangle shape2 = (Rectangle) _shapes.get(j);
      if (shape1.intersects(shape2) ) {
        shape1.add(shape2);
        //System.out.println("Remove" + j);
        _shapes.remove(j);
        break;
      }
    }
  }
} 
ArrayList findRectangles() {
  ArrayList boxes = new ArrayList();

  for (int row = 0; row < cam.height; row++) {
    for (int col = 0; col < cam.width; col++) {
      int offset = row * width + col;
      int thisPixel = cam.pixels[offset];
      if (test(thisPixel)) {
        cam.pixels[offset] = 0xffff00;
        //be pessimistic
        boolean foundAHome = false;
        //look throught the existing
        for (int i = 0; i < boxes.size(); i++) {
          Rectangle existingBox =  (Rectangle) boxes.get(i);

          //is this spot in an  existing box
          if (existingBox.isNear(col, row,reach)) {
            existingBox.add(col, row);
            foundAHome = true; //no need to make a new one
            break; //no need to look through the rest of the boxes
          }
        }
        //if this does not belong to one of the existing boxes make a new one at this place
        if (foundAHome == false) boxes.add(new Rectangle(col, row));
      }
    }
  }
  return boxes;
}

