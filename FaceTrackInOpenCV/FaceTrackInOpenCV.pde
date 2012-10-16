import hypermedia.video.*; 
import java.awt.Rectangle;

//make sure you install openCV on your machine
//http://ubaa.net/shared/processing/opencv/
OpenCV opencv;

Rectangle bestRect = new Rectangle(0,0,0,0);
void setup() {
    size(640, 480 );

    opencv = new OpenCV( this );
    opencv.capture( width, height );                   // open video stream
    opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
}
public void stop() {
    opencv.stop();
    super.stop();
}
void draw() {
    opencv.read();

    // proceed detection
    Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

    // display the image
    image( opencv.image(), 0, 0 );

    // draw face area(s)
    noFill();
    stroke(255,0,0);
    for( int i=0; i<faces.length; i++ ) {
      //the first face is the best
      if (i == 0) bestRect = new Rectangle(faces[i]);
        rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height ); 
    }
     stroke(0,255,0);
    rect(bestRect.x,bestRect.y,bestRect.width,bestRect.height);
}

