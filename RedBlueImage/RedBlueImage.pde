PImage img;

void setup() {
  img = loadImage("http://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Red_state,_blue_state.svg/300px-Red_state,_blue_state.svg.png");
  size(img.width, img.height);
}

void draw() {
  int SumBlueDotX = 0;
  int NumofBlueDots =0;
  for (int row = 0; row< img.height; row++) {
    for (int col = 0; col < img.width; col++) {
      int offsetInBigArray = col + row*img.width;
      int allColorsPackedIn = img.pixels[offsetInBigArray];
      float b = blue(allColorsPackedIn);
      if (b> 127) {
        SumBlueDotX = SumBlueDotX + col;
        NumofBlueDots++;
      }
    }
  }
  image(img, 0, 0);
  int averageXLocOfBlue = SumBlueDotX/NumofBlueDots;
  fill(0, 0, 255);
  line(averageXLocOfBlue, 0, averageXLocOfBlue, height);
}

