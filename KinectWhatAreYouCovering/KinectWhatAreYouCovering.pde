/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;

SimpleOpenNI  context;
<<<<<<< HEAD

PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector leftHip = new PVector();
PVector rightHip = new PVector();
PVector torso = new PVector();
PVector head = new PVector();
PVector neck = new PVector();
PVector leftElbow = new PVector();
PVector rightElbow = new PVector();
PVector rightShoulder = new PVector();
PVector leftShoulder = new PVector();
PVector rightKnee = new PVector();
PVector leftKnee = new PVector();

=======
 
  PVector leftHand = new PVector();
  PVector rightHand = new PVector();
  PVector leftHip = new PVector();
  PVector rightHip = new PVector();
  PVector torso = new PVector();
  PVector head = new PVector();
  PVector neck = new PVector();
  PVector leftElbow = new PVector();
  PVector rightElbow = new PVector();
  PVector rightShoulder = new PVector();
  PVector leftShoulder = new PVector();
  PVector rightKnee = new PVector();
  PVector leftKnee = new PVector();
  
>>>>>>> back at you
String whatAreYouCovering = "Nothing";

void setup()
{
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();

  background(200, 0, 0);

  stroke(0, 0, 255);
  strokeWeight(3);
  smooth();
  PFont myFont = createFont("FFScala", 32);
  textFont(myFont);

  size(context.depthWidth(), context.depthHeight());
}

void draw()
{
  // update the cam
  context.update();

  // draw depthImageMap
  image(context.depthImage(), 0, 0);


  // draw the skeleton if it's available
  if (context.isTrackingSkeleton(1)) {
    kinectDrawsSkeleton(1);
    locatePartsInLocalCoordinates(1);
    float groinDist = PVector.dist(leftHand, leftHip) + PVector.dist(rightHand, rightHip);
    float heartDist = PVector.dist(leftHand, torso) + PVector.dist(rightHand, torso);
    float headDist = PVector.dist(leftHand, head) + PVector.dist(rightHand, head);

    if (groinDist < heartDist && groinDist < headDist) {
      whatAreYouCovering = "Groin";
      println("Groing " + groinDist);
    }
    else if (heartDist < groinDist && heartDist < headDist) {
      whatAreYouCovering = "Heart";
      println("Heart " + heartDist);
    }
    else if (headDist < groinDist && headDist < heartDist) {
      whatAreYouCovering = "Head";
      println("Head " + headDist);
    }
  }
  text(whatAreYouCovering, 100,100);
}

void locatePartsInLocalCoordinates(int userId) {


  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, leftHip);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, torso);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, leftKnee);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, rightKnee);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, leftElbow);
}


void kinectDrawsSkeleton(int userId)
{
  //Let the Kinect Draw the Skeleton without you seeing its weird numbers
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}
void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
