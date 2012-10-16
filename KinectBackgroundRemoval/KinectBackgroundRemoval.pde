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
  size(1280, 480);
  // load the background image 
  backgroundImage = loadImage("http://www.eheart.com/SHASTA/wallpaper/alpenglow-640x480.jpg");
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // enable color image from the Kinect
  kinect.enableRGB();
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

  image(rgbImage, 640, 0);
  if (tracking) {
    //ask kinect for bitmap of user pixels
    userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);
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
void onNewUser(int uID) {
  userID = uID;
  tracking = true;
  println("tracking");
}
