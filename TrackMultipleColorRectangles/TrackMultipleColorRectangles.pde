import processing.video.*;

float goalRed = 200;
float goalGreen = 0;
float goalBlue = 0;
int threshold = 40;
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

    ArrayList boxes = new ArrayList();
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
          for (int i = 0; i < boxes.size(); i++) {
            Rectangle existingBox =  (Rectangle) boxes.get(i);
            //is this spot in an  existing box
            if (existingBox.isNear(col, row,reach)) {
              existingBox.add(col,row);
              foundAHome = true; //no need to make a new one
              break; //no need to look through the rest of the boxes
            }
          }
          //if this does not belong to one of the existing boxes make a new one at this place
          if (foundAHome == false) boxes.add(new Rectangle(col, row));
        }
      }
    }

    //consolidate(boxes,0,0);
    image(cam, 0, 0);
    fill(0, 0, 0, 0);
    stroke(255, 0, 0);
    for (int i = 0; i < boxes.size(); i++) {
      Rectangle thisBox =  (Rectangle) boxes.get(i);
      thisBox.draw();
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
