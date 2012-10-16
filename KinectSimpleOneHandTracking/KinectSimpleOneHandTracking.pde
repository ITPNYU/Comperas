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
  context.setMirror(false);
  context.enableDepth();
  //unfortunately have to track guestures to get hands
  context.enableGesture();
  context.enableHands();
  context.addGesture("RaiseHand");
  fill(255, 0, 0);
}
void draw() {
  // update the cam
  context.update();
  //paint the image
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
  //go back to looking for the guesture that gave you hand.
  context.addGesture("RaiseHand");
}
// ----------------------------------------------------------------- // gesture events
void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition) {
  println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);
  //stop looking for the gesture
  context.removeGesture(strGesture);
  //use the location of this guesture tell you where to start tracking the hand
  context.startTrackingHands(endPosition);
}
void onProgressGesture(String strGesture, PVector position, float progress) {
  //println("onProgressGesture - strGesture: " + strGesture + ", position: " + position + ", progress:" + progress);
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

