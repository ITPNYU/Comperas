/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 */
import SimpleOpenNI.*;


SimpleOpenNI  context;


BodyParts bodyParts;
void setup()
{

  size(640, 480);
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
  bodyParts = new BodyParts(context);
  fill(255, 0, 0);
}

void draw()
{
  // update the cam
  context.update();


  // draw depthImageMap
  image(context.depthImage(), 0, 0);
  bodyParts.findParts();
  PVector leftHand = bodyParts.getLeftHand();
  PVector head = bodyParts.getHead();
  ellipse(leftHand.x, leftHand.y, 20, 20);
  if( dist(leftHand.x, leftHand.y, head.x, head.y) > 100 ){
    ellipse(head.x,head.y, 100,100);
  }
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

