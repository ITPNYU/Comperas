import SimpleOpenNI.*;
//install this on your machine and also the library in processing
//http://code.google.com/p/simple-openni/wiki/Installation

SimpleOpenNI context;
int rearThreshold  = 1200;
int frontThreshold = 1000;
int changeThreshold = 1000;
int[ ] lastDepths = new int[640*480];

void setup() {
  // startup the kinnect
  size(640, 480);
  context = new SimpleOpenNI(this);
  context.enableDepth();
}

void draw() {
  //listne to the kinect
  context.update();
  PImage myImg = context.depthImage();
  image(myImg, 0, 0);
  fill(255, 0, 0);
  
  int[ ] allDepths = new int[640*480];
  context.depthMap(allDepths );
  //what is the x y of the closes pixel to the camera

  int allX = 0;
  int allY = 0 ;
  int all=0 ;
  for (int row = 0; row < 480; row++) {
    for (int col = 0; col < 640; col++) {
      int placeInBigArray = row*640 + col;
      int thisDepth = allDepths[placeInBigArray] ;
      if ((thisDepth > frontThreshold ) && (thisDepth < rearThreshold ))
      //&& abs(thisDepth-lastDepths[placeInBigArray]) > changeThreshold)
      {
        allX +=col;
        allY +=row;
        all++;
        //point(col,row);
      }
    }
  }
  lastDepths = allDepths.clone();
 // arrayCopy(allDepths,lastDepths);


  


  if (all > 0){  
    int x = allX/all;
    int y = allY/all;
    ellipse(x, y, 20, 20);
  }
}

public void keyPressed() {
  //for adjusting things on the fly
  if (key == 'f') {
    frontThreshold--;
    println("frontThreshold " + frontThreshold);
  } 
  else if (key == 'F') {
    frontThreshold++;
    println("frontThreshold " + frontThreshold);
  }else if (key == 'r') {
    rearThreshold--;
    println("rearThreshold " + rearThreshold);
  } 
  else if (key == 'R') {
    rearThreshold++;
    println("rearThreshold " + rearThreshold);
  }else if (key == 'c') {
    changeThreshold--;
    println("changeThreshold " + changeThreshold);
  } 
  else if (key == 'C') {
    changeThreshold++;
    println("changeThreshold " + changeThreshold);
  }
}


