import SimpleOpenNI.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation

SimpleOpenNI kinect;

int nearThreshold = 20;
int farThreshold = 1900;
int reach = 30;
long elapsedTime;
PImage cam ;
Identifier myIdentifier;
PFont myFont;


void setup() {
  size(640, 480);
  myIdentifier = new Identifier();
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // enable color image from the Kinect
  kinect.enableRGB();
  // turn on depth-color alignment
  kinect.alternativeViewPointDepthToImage();
  myFont = createFont("FFScala", 48);
  textFont(myFont,48);
 
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
      // int thisPixel = cam.pixels[offset];
      int thisDepth = allDepths[offset];
      if (thisDepth > nearThreshold && thisDepth < farThreshold) {

        //be pessimistic
        boolean foundAHome = false;
        //look throught the existing
        for (int i = 0; i < blobs.size(); i++) {
          Blob3D existingBlob =  (Blob3D) blobs.get(i);
          //is this spot is near an existing Blob
          if (existingBlob.getDistance(col, row, thisDepth, reach) < reach) {
            existingBlob.setPoint(col, row, thisDepth);
            foundAHome = true; //no need to make a new one
            cam.pixels[offset] = 0;
            break; //no need to look through the rest of the boxes
          }
        }
        //if this does not belong to one of the existing boxes make a new one at this place
        if (foundAHome == false) {
          blobs.add(new Blob3D(col, row, thisDepth));
        }
      }
    }
  }
  /*
   for (int i = 0; i < blobs.size(); i++) {
        Blob3D thisBlob =  (Blob3D) blobs.get(i);
     thisBlob.findCenter();
   }
   */
 // myIdentifier.findMatchesFromPrevious(blobs);
  //consolidate(boxes,0,0);
  image(cam, 0, 0);
  fill(0, 0, 0, 0);
  stroke(255, 0, 0);
  for (int i = 0; i < blobs.size(); i++) {
    Blob3D thisBlob =  (Blob3D) blobs.get(i);
    thisBlob.drawLines();
   // thisBlob.findCenter();
   // thisBlob.drawNumber();
  }
  // println("Number of Blobs " + blobs.size());
}




void keyPressed() {
  if (key == 'n') {
    nearThreshold--;
    println("NearThreshold " + nearThreshold);
  } 
  else if (key == 'N') {
    nearThreshold++;
    println("NearThreshold " + nearThreshold);
  } 
  else if (key == 'f') {
    nearThreshold--;
    println("FarThreshold " + farThreshold);
  } 
  else if (key == 'F') {
    nearThreshold++;
    println("FarThreshold " + farThreshold);
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

