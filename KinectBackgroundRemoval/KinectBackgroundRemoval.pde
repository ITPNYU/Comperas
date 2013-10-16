import processing.opengl.*; 
import SimpleOpenNI.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation


SimpleOpenNI kinect;
//based on Greg's Book Making things see.
boolean tracking = false; 
int userID; int[] userMap; 
// declare our images 
PImage backgroundImage; 
PImage resultImage;
void setup() {
  size(640*2, 480);
  // load the background image 
  backgroundImage = loadImage("http://www.eheart.com/SHASTA/wallpaper/alpenglow-640x480.jpg");
  kinect = new SimpleOpenNI(this);
  if(kinect.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
 kinect.enableDepth();
   
  // enable skeleton generation for all joints
  kinect.enableUser();
  // enable color image from the Kinect
  kinect.enableRGB();
  //enable the finding of users but dont' worry about skeletons

  // turn on depth/color alignment
  kinect.alternativeViewPointDepthToImage();
  //create a buffer image to work with instead of using sketch pixels
  resultImage = new PImage(640, 480, RGB);
}
void draw() {
  kinect.update();
  // get the Kinect color image
  PImage rgbImage = kinect.rgbImage();

  image(rgbImage, 640, 0);
  if (tracking) {
    //ask kinect for bitmap of user pixels
    loadPixels();
    userMap = kinect.userMap();
    for (int i =0; i < userMap.length; i++) {
      // if the pixel is part of the user
      if (userMap[i] != 0) {
        // set the pixel to the color pixel
        resultImage.pixels[i] = rgbImage.pixels[i];
      }
      else {
        //set it to the background
        resultImage.pixels[i] = backgroundImage.pixels[i];
      }
    }

    //update the pixel from the inner array to image
     resultImage.updatePixels();
    image(resultImage, 0, 0);
  }
}


void onNewUser(SimpleOpenNI curContext, int userId)
{
 userID = userId;
  tracking = true;
  println("tracking");
  //curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
