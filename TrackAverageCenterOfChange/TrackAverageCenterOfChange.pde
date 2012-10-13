
import processing.video.Capture;

//save your project at "TrackCenterChange" before running
Capture cam;// regular processing libary
int threshold = 150;  //255 is white, 0 is black
PImage backgroundImage;//this is used to hold the previous frame
PImage debugImage; //to color the all the changing pixels;
int aveX, aveY;  //this is what we are trying to find
boolean debug = true;
boolean compareAgainstPreviousFrame = true;

public void setup() {
  size(640, 480);
  println(Capture.list());
  // cam = new Capture(this, width, height, Capture.list()[6]); //this is a way to specify a specific camera
  cam = new Capture(this, width, height); 
  cam.start();
  backgroundImage = new PImage(cam.width, cam.height);
  debugImage = new PImage(cam.width, cam.height);
  grabBackground();  //grab the background now so you have a previous frame in the first loop
}

public void grabBackground() {
  backgroundImage.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  backgroundImage.updatePixels();
  if (debug) println("grab background");
}

public void draw() {
  if (cam.available()) {
    cam.read();
    if (debug) debugImage.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
    int numberOfChanges = 0;  //we are going to find the average location of change pixes so
    int sumX = 0;  //we will need the sum of all the x find, the sum of all the y find and the total finds
    int sumY = 0;
    //enter into the classic nested for statements of computer vision
    for (int row = 0; row < cam.height; row++) {
      for (int col = 0; col < cam.width; col++) {
        //the pixels file into the room long line you use this simple formula to find what row and column the sit in 

        int offset = row * width + col;
        //pull out the same pixel from the current frame and the previous frame
        int fgColor = cam.pixels[offset];
        int bgColor = backgroundImage.pixels[offset];

        //pull out the individual colors for current pixels
        float currentR = red(fgColor);
        float currentG = green(fgColor);
        float currentB = blue(fgColor);

        float bgR = red(bgColor);
        float bgG = green(bgColor);
        float bgB = blue(bgColor);

        //in a color "space" you find the distance between color the same whay you would in a cartesian space, phythag or dist in processing
        float diff = dist(currentR, currentG, currentB, bgR, bgG, bgB);

        if (diff > threshold) {  //if a pixel qualifies as changed from the previous frame add it to the average
          sumX = sumX + col;
          sumY= sumY + row;
          numberOfChanges++;
          if (debug) debugImage.pixels[offset] = 0xffff0000;
        }
      }
    }
    if(debug) image(debugImage,0,0);
    else image(cam, 0, 0);
    if (numberOfChanges> 10) {
      //find the average location of all the changed pixels
      aveX = sumX/numberOfChanges;
      aveY = sumY/numberOfChanges;
      ellipse(aveX-10, (aveY-10), 20, 20);
    }
    else {
      //if not much change just us the last average
      ellipse(aveX-10, (aveY-10), 20, 20);
    }

    if (compareAgainstPreviousFrame) grabBackground(); //dont forget to make the current frame the background to check against next time
  }
}


public void keyPressed() {
  //for adjusting things on the fly
  if (key == '-') {
    threshold--;
    println("Threshold " + threshold);
  } 
  else if (key == '=') {
    threshold++;
    println("Threshold " + threshold);
  }else if(key == 'b'){
     grabBackground();
  }else if (key == 'd'){
    debug = ! debug;
  }
}


