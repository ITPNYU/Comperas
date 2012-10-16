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

