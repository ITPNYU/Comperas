import processing.video.*;//this library downloads with processing
Capture cam;
float idealRed = 17; 
float idealGreen = 123; 
float idealBlue = 184;

void setup() {
  size(1280, 720);
  cam = new Capture(this,Capture.list()[0]);
  cam.start();     
}
void mousePressed(){
  //click to pick a color to chase
  int thisPixel = cam.pixels[mouseY* cam.width + mouseX];
  idealRed = red(thisPixel);
  idealGreen = green(thisPixel);
  idealBlue =  blue(thisPixel);
  println("ideal" + idealRed+ " " + idealGreen + " " + idealBlue);
}
void draw() {
  if (cam.available()) {
    cam.read();

    float closestSoFar = 65000; //start out very far away
    int winnerX = 0;
    int winnerY = 0;
    for(int row = 0; row < cam.height; row++){
      for(int col = 0; col < cam.width; col++){
        int offset = row*cam.width + col;
        int thisPixel = cam.pixels[offset];
        //color comes out as one big number, have to tease out component colors
        float currentR = red(thisPixel);
        float currentG = green(thisPixel);
        float currentB = blue(thisPixel);
        //find the distance in color space between the current pixel and ideal
        float closeness = dist(currentR,currentG,currentB,idealRed, idealGreen, idealBlue);
        //check to see if this beats the world record for best match so far
        if (closeness < closestSoFar ){
          winnerX = col;
          winnerY = row;
          closestSoFar = closeness; //update the world record to this match
        }
      }
    }
    image(cam,0,0);
    fill(255,0,0);
    ellipse(winnerX, winnerY,30,30); //draw a circle over the winner
  }
}

