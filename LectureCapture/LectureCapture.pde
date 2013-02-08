import SimpleOpenNI.*;
import java.awt.Robot;
import java.awt.image.BufferedImage;
import java.awt.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation


SimpleOpenNI kinect;
boolean handsTrackFlag = false; 
PVector handVec = new PVector();
//based on Greg's Book Making things see.
boolean userPresent = false; 
int userID; int[] userMap; 
// declare our images 
PImage backgroundImage; 
PImage resultImage;
Robot myRobot;
int drawingThreshold = 1000;
float lastX = -1;
float lastY = -1;

PGraphics whiteBoard;

void setup() {
  size(1280, 480);
  whiteBoard =   createGraphics(width, height);
  whiteBoard.endDraw();
  // load the background image 
 // backgroundImage = loadImage("http://www.eheart.com/SHASTA/wallpaper/alpenglow-640x480.jpg");
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // enable color image from the Kinect
  kinect.enableRGB();
  
  //unfortunately have to track guestures to get hands
  kinect.enableGesture();
  kinect.enableHands();
  kinect.addGesture("RaiseHand");
  fill(255, 0, 0);
  kinect.setMirror(true);
  
  //enable the finding of users but dont' worry about skeletons
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
  // turn on depth-color alignment
  kinect.alternativeViewPointDepthToImage();
  //create a buffer image to work with instead of using sketch pixels
  resultImage = new PImage(640, 480, RGB);
}
void draw() {
  kinect.update();
  // get the Kinect color image
  PImage rgbImage = kinect.rgbImage();

  //image(rgbImage, 640, 0);
   backgroundImage =getScreen();
 
  
  if (userPresent) {
    //ask kinect for bitmap of user pixels
    userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);
   // for (int i =0; i < userMap.length; i++) {
  for (int row =0; row < rgbImage.height; row++) {
     for (int col =0; col < rgbImage.width; col++) {
       int videoOffset = row*rgbImage.width + col;
       int screenGrabOffset = row*backgroundImage.width + col;
      // if the pixel is part of the user
      if (userMap[videoOffset] != 0) {
        // set the pixel to the color pixel
        resultImage.pixels[videoOffset] = rgbImage.pixels[videoOffset];
      }
      else {
        //set it to the background
        resultImage.pixels[videoOffset] = backgroundImage.pixels[screenGrabOffset];
      }
    }
   }
    //update the pixel from the inner array to image
    resultImage.updatePixels();
    image(resultImage, 0, 0);
  }
  
   if (handsTrackFlag) 
  {
    PVector myPositionScreenCoords  = new PVector(); //storage device
    //convert the weird kinect coordinates to screen coordinates.
    kinect.convertRealWorldToProjective(handVec, myPositionScreenCoords);
    
    println("hand z:" + myPositionScreenCoords.z );
    if (myPositionScreenCoords.z < drawingThreshold){
       whiteBoard.beginDraw();
       
       whiteBoard.fill(255,0,0);
       if (lastX == -1) {
         lastX = myPositionScreenCoords.x;
         lastY = myPositionScreenCoords.y;
       }
       whiteBoard.line(lastX,lastY,myPositionScreenCoords.x, myPositionScreenCoords.y);
     lastX = myPositionScreenCoords.x;
     lastY = myPositionScreenCoords.y;
     
     // whiteBoard.ellipse(myPositionScreenCoords.x, myPositionScreenCoords.y, 2, 2);
    whiteBoard.endDraw();
  }  
  }
  image(whiteBoard,0,0);
}
void keyPressed() {
  switch(key)
  {
  case ' ':
    kinect.setMirror(!kinect.mirror());
    break;
  case 'd':
    drawingThreshold--;
    println("Drawing Threshold " + drawingThreshold);
    break;
  case 'D':
    drawingThreshold++;
    println("Drawing Threshold " + drawingThreshold);
    break;
  }
}


void onNewUser(int uID) {
  userID = uID;
  userPresent = true;
  println("userPresent");
}


// ----------------------------------------------------------------- // hand events
void onCreateHands(int handId, PVector pos, float time) {
  println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handsTrackFlag = true;
  handVec = pos;
}
void onUpdateHands(int handId, PVector pos, float time) {
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  //store the location of the hand in a vector object
  handVec = pos;
}
void onDestroyHands(int handId, float time) {
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);
  handsTrackFlag = false;
  lastX = -1;
  //go back to looking for the guesture that gave you hand.
  kinect.addGesture("RaiseHand");
}
// ----------------------------------------------------------------- // gesture events
void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition) {
  println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);
  //stop looking for the gesture
  kinect.removeGesture(strGesture);
  //use the location of this guesture tell you where to start userPresent the hand
  kinect.startTrackingHands(endPosition);
}


void onProgressGesture(String strGesture, PVector position, float progress) {
  //println("onProgressGesture - strGesture: " + strGesture + ", position: " + position + ", progress:" + progress);
}
// ----------------------------------------------------------------- // Keyboard event


PImage getScreen() {
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] gs = ge.getScreenDevices();
 // int whichScreen = gs.length-1;
 int whichScreen = 0;
  DisplayMode mode = gs[whichScreen].getDisplayMode();
  Rectangle bounds = new Rectangle(0, 0, mode.getWidth(), mode.getHeight());
  BufferedImage desktop = new BufferedImage(mode.getWidth(), mode.getHeight(), BufferedImage.TYPE_INT_RGB);

  try {
    desktop = new Robot(gs[whichScreen]).createScreenCapture(bounds);
  }
  catch(AWTException e) {
    System.err.println("Screen capture failed.");
  }

  return (new PImage(desktop));
}

