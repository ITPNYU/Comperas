import SimpleOpenNI.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation

SimpleOpenNI context;

void setup() {
  // startup the kinnect
  size(640, 480);
  context = new SimpleOpenNI(this);
  context.enableDepth();
}

void draw() {
  //listne to the kinect
  context.update();

  int[ ] allDepths = new int[640*480];
  context.depthMap(allDepths );
  //what is the x y of the closes pixel to the camera

  int worldRecordClosest = 100000;
  int winX =0;
  int winY= 0;
  for (int row = 0; row < 480; row++) {
    for (int col = 0; col < 640; col++) {
      int placeInBigArray = row*640 + col;
      if (allDepths[placeInBigArray] < worldRecordClosest && allDepths[placeInBigArray] != 0 ) {
        worldRecordClosest = allDepths[placeInBigArray];
        winX= col;
        winY = row;
      }
    }
  }
  PImage myImg = context.depthImage();
  image(myImg, 0, 0);
  fill(255, 0, 0);
  //map width to depth so it give a 3D effect
  int wid = (int) map(worldRecordClosest, 0, 2000, 255, 0);
  ellipse(winX, winY, wid, wid);
}

