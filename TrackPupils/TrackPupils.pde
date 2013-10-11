import processing.video.*;
float goal = 0;
int threshold = 5;
int reach = 1;
long elapsedTime;


Capture cam;
int graphpos = 0;

void setup() {
  size(1280, 480);
  //println(Capture.list());
  // println(Capture.list());
  //println(Capture.list());
  //delay(1000);
  cam = new Capture(this,640,480);
     cam.settings();
  delay(1000);
 // cam.start();
  delay(1000);
}
void draw() {
  if (cam.available()) {


    cam.read();
    long startTime = millis();
    //cam.filter(BLUR, 2);

    elapsedTime = millis() - startTime;
    //println(elapsedTime);  
    //uncomment this line or press 't' to see how long the blur takes.

    ArrayList boxes = new ArrayList();
    for (int row = 0; row < cam.height; row++) {
      for (int col = 0; col < cam.width; col++) {
        int offset = row * cam.width + col;
        int thisPixel = cam.pixels[offset];
        float b = brightness(thisPixel);
        if (abs(b-goal) < threshold) {
          cam.pixels[offset] = 0xffff00;
          //be pessimistic
          boolean foundAHome = false;
          //look throught the existing
          for (int i = 0; i < boxes.size(); i++) {
            Rectangle existingBox =  (Rectangle) boxes.get(i);
            //is this spot in an  existing box
            if (existingBox.isNear(col, row, reach)) {
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
    //get rid of little ones
    for (int i = boxes.size()-1; i >-1; i--) {
      Rectangle thisBox =  (Rectangle) boxes.get(i);
      if (thisBox.getWidth()*thisBox.getHeight() < 100) {
        boxes.remove(i);
      }
      thisBox.draw();
    }

    //consolidate(boxes,0,0);
    image(cam, 0, 0);
    fill(0, 0, 0, 0);
    stroke(255, 0, 0);
    int biggestArea = 0;
    int winner = -1;
    for (int i = 0; i < boxes.size(); i++) {
      Rectangle thisBox =  (Rectangle) boxes.get(i);
      thisBox.draw();
      int area = thisBox.getArea();
      if ( area > biggestArea) {
        winner = i;
        biggestArea = area;
      }
    }
    int widthOfPupil =0;
    if (winner != -1) {
      fill(0, 0, 0, 0);
      stroke(0, 255, 0);
      Rectangle thisBox =  (Rectangle) boxes.get(winner);
      widthOfPupil = thisBox.getWidth();
      thisBox.draw();
    }
    graphpos++;
    if (graphpos > width) {
      fill(255, 255, 255);
      rect(width/2, 0, width/2, height);
      graphpos = width/2;
    }
    fill(0, 0, 0);
    stroke(0, 0, 0);
    point(graphpos, widthOfPupil);
  }
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
    else if (key == 'g') {
    goal--;
    println("goal " + goal);
  } 
  else if (key == 'G') {
    goal++;
    println("goal " + goal);
  } 
  else if (key == 't') {

    println("Elapsedtime " + elapsedTime);
  }else if (key == 's') {
   cam.settings();
 
  }
}


