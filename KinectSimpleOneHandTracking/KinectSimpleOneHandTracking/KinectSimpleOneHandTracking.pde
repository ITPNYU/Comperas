import SimpleOpenNI.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation



SimpleOpenNI context; 
boolean handsTrackFlag = false; 
PVector handVec = new PVector();
void setup() {
  size(640, 480);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
  //size(1024,768,OPENGL);
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }   

  context.setMirror(false);
  context.enableDepth();

  context.enableHand();
  context.startGesture(SimpleOpenNI.GESTURE_WAVE);
  //unfortunately have to track guestures to get hands
  // set how smooth the hand capturing should be
  fill(255, 0, 0);
}
void draw() {
  // update the cam
  context.update();
  //paint the image
  println( handsTrackFlag);
  image(context.depthImage(), 0, 0, width, height);
  if (handsTrackFlag) 
  {
    PVector myPositionScreenCoords  = new PVector(); //storage device
    //convert the weird kinect coordinates to screen coordinates.
    context.convertRealWorldToProjective(handVec, myPositionScreenCoords);
    ellipse(myPositionScreenCoords.x, myPositionScreenCoords.y, 20, 20);
  }
}
// ----------------------------------------------------------------- // hand events
void onNewHand(SimpleOpenNI curContext, int handId, PVector pos) {
  println("onnewHand - handId: " + handId + ", pos: " + pos );
  handsTrackFlag = true;
  handVec = pos;
}

void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos)
{  
  println("onTrackedHand - handId: " + handId + ", pos: " + pos );
  //store the location of the hand in a vector object
  handVec = pos;
}
void onLostHand(SimpleOpenNI curContext, int handId)
{
  println("onLostHand - handId: " + handId);  
  handsTrackFlag = false;
}
// ----------------------------------------------------------------- // gesture events
void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);

  int handId = context.startTrackingHand(pos);
  println("hand stracked: " + handId);
}
// ----------------------------------------------------------------- // Keyboard event
void keyPressed() {
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}
