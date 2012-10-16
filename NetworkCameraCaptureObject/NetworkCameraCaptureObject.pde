
//128.122.151.... ask Marlon for the last numbers
//SHOP AREA 128.122.151.221
//Room 15 128.122.151.224
//Room 20 128.122.151.227
//Main Lounge 128.122.151.228
//Japanese Rm 128.122.151.200
//Lounge 128.122.151.22

String whichCamera = "128.122.151.228";
//Capture video; 
//this is what you use for ordinary video cameras
//requires pointing at the video.jar library from processing

CaptureAxisCamera cam;//This acts the same the regular but connects to axis net cam

public void setup() {

  size(640, 480);
  cam = new CaptureAxisCamera(this, whichCamera, width, height, false);
  //see the code for this CaptureAxisCamera in next tab
}

public void draw() {
  if (cam.available()) {
    cam.read();
    image(cam, 0, 0);
  }
}

