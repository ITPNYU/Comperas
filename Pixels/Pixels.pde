void setup(){
  size(640,480);
}

void draw(){
  background(255);
  loadPixels();
  for(int i = 0; i < pixels.length; i++){
    if (i > pixels.length/2){
      pixels[i] = 0xffff0000;
    }
  }
  updatePixels();
}
