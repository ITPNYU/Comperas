//tracking the average pixel makes it shake less
import processing.video.Capture;
Capture cam;// regular processing libary
int threshold = 20; //255 is white, 0 is black
int aveX, aveY; //this is what we are trying to find
float objectR =255;
float objectG = 0;
float objectB = 0;
boolean debug = true;
int lastTime, ellapsedTime; //for checking performance
void setup() {
  size(640, 480);
  println(Capture.list());
  cam = new Capture(this,width,height);
  cam.start();
}
void draw(){
  if (cam.available()){
    ellapsedTime = millis() - lastTime;  //find time since last time, only print it out if you press "t"
    lastTime = millis();  //reset timer for checking time next fram
    cam.read();
    int totalFoundPixels= 0;  //we are going to find the average location of change pixes so
    int sumX = 0;  //we will need the sum of all the x find, the sum of all the y find and the total finds
    int sumY = 0;
    //enter into the classic nested for statements of computer vision
    for (int row = 0; row < cam.height; row++) {
      for (int col = 0; col < cam.width; col++) {
        //the pixels file into the room long line you use this simple formula to find what row and column the sit in 

        int offset = row * cam.width + col;
        //pull out the same pixel from the current frame 
        int thisColor = cam.pixels[offset];

        //pull out the individual colors for both pixels
        float r = red(thisColor);
        float g = green(thisColor);
        float b = blue(thisColor);

        //in a color "space" you find the distance between color the same whay you would in a cartesian space, phythag or dist in processing
        float diff = dist(r, g, b, objectR, objectG, objectB);

        if (diff < threshold) {  //if it is close enough in size, add it to the average
          sumX = sumX + col;
          sumY= sumY + row;
          totalFoundPixels++;
          if (debug) cam.pixels[offset] = 0xff000000;//debugging
        }
      }
    }
    image(cam,0,0);
    if (totalFoundPixels > 0){
      aveX = sumX/totalFoundPixels;
      aveY = sumY/totalFoundPixels;
      ellipse(aveX-10,(aveY-10),20,20);
    }
  }
}
void mousePressed(){
  //if they click, use that picture for the new thing to follow
  int offset = mouseY * cam.width + mouseX;
  //pull out the same pixel from the current frame 
  int thisColor = cam.pixels[offset];

  //pull out the individual colors for both pixels
   objectR = red(thisColor);
   objectG = green(thisColor);
   objectB = blue(thisColor);
  println("Chasing new color  " + objectR + " " + objectG + " " + objectB);
}
void keyPressed() {
  //for adjusting things on the fly
  if (key == '-') {
    threshold--;
    println("Threshold " + threshold);
  } 
  else if (key == '=') {
    threshold++;
    println("Threshold " + threshold);
  }
  else if (key == 'd') {
    background(255);
    debug = !debug;
    println("Debug " + debug);
  }
  else if (key == 't') {
    println("Time Between Frames " + ellapsedTime);
  }
}

