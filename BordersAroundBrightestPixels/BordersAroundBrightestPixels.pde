import processing.video.Capture;
Capture cam;// regular processing libary    
int threshold = 230; //255 is white, 0 is black
void setup() {
  size(640, 480);
  cam = new Capture(this, width,height);
  cam.start();
}
void draw() {
  if (cam.available()) {
    cam.read();
    int leftMost = width;  //starts out as the right most
    int topMost = height; // starts out as the bottom most
    int rightMost = 0; // starts out left most
    int bottomMost = 0; //sarts out top most
    //enter into the classic nested for statements of computer vision
    for (int row = 0; row < cam.height; row++) {
      for (int col = 0; col < cam.width; col++) {
        //the pixels file into the room long line you use this simple formula to find what row and column the sit in 
        int offset = row * cam.width + col;  
        int thisPixel = cam.pixels[offset];
        float b = brightness(thisPixel);
        if (b > threshold) {  //we are looking for all the pixels that are brighter than the threshold
          cam.pixels[offset] = 255; //color it black for debuggin
          //if the pixel qualifies and is outside the current boundaries, stretch the boundaries
          if (col < leftMost) leftMost = col;
          if (col > rightMost) rightMost = col;
          if (row > bottomMost ) bottomMost = row;
          if (row < topMost) topMost = row;
        }
      }
    }
    image(cam, 0, 0); //draw the cam image (optional)
    //draw the rectangle around the bright pixels
    stroke(255, 0, 255);
    fill(0, 255, 0, 0);
    rect(leftMost, topMost, rightMost-leftMost, bottomMost-topMost);
  }
}
void keyPressed() {
  //for adjusting things on the fly
  if (key == '-') {
    threshold--;
    println("Threshold " + threshold);
  } 
  else if (key == '=') {
    threshold++;
    println("Threshold " + threshold);
  }
}

