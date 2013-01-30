
/*You can copy and paste but you have to rename your processing project EyeTrack.
 Also you have to add an image called "myPicture.jpg" to the project. This will be 
 the picture they look at. You should look at the keypresses to see how to adjust 
 things, most notably "d" for toggling debug mode and "p" an "P" for ajusting the 
 threshold for the pupil and "g" and "G" for the threshold for the glint.
 */
import java.awt.Point; 
import java.awt.Rectangle; 
import java.util.*;
import processing.video.Capture; 

Capture video;// regular processing libary

int pupilThreshold = 100;
int glintThreshold = 240;
int edge = 50;
int reach = 5;
int minPupilArea = 75;
long elapsedTime;
float calibrationSlope;
int calibrationIntercept;
Rectangle pupil;
Rectangle glint;
CoordinatesTranslator calibrator;
boolean debug = false;
PImage testImage;
PGraphics debugScreen;
boolean leaveTrails;


public void setup() {
  size(640, 480);
  //println(Capture.list());
    video = new Capture(this);
 // video = new Capture(this,"Sony HD Eye for PS3 (SLEH 00201)");
  debugScreen= createGraphics(width, height);
  debugScreen.loadPixels();  //video.settings();
  video.start();
  testImage = loadImage("http://www.biography.com/imported/images/Biography/Images/Profiles/M/Marilyn-Monroe-9412123-4-402.jpg");
  size(testImage.width, testImage.height);
  calibrator = new CoordinatesTranslator();
  //image(testImage, 0, 0);
}

public void draw() {
  if (video.available()) {

    video.read();
    long startTime = millis();
    elapsedTime = millis() - startTime;
    if (debug) {
      //background(0);
      debugScreen.beginDraw();
      debugScreen.image(video, 0, 0);
    }
    else {
      if (leaveTrails == false) image(testImage, 0, 0);
    }
    pupil = findPupil();
    glint = null;
    if (pupil != null) glint = findGlint(pupil);
    if (glint != null && pupil != null) { // if we got both
      // find out where the pupil is relative to the glint
      int rawX = pupil.x+ pupil.width/2 - glint.x + glint.width/2;
      int rawY =glint.y + glint.height/2- pupil.y + pupil.height/2  ;
      if (calibrator.isCurrentlyCalibrating()) { // check if we are in calibration mode
        Point placeToLook = calibrator.getScenePoint(); // get where they are supposed to look at
        stroke(255, 0, 0);
        ellipse(placeToLook.x - 4, placeToLook.y - 4, 8, 8);// draw it so they look
        calibrator.doCalibrationRoutine(true, rawX, rawY);
        println("cablibrating");
      } 
      else {
        int[] adjustedPoint = calibrator.translate(rawX, rawY); //use the calibrator to find out where the x,y from camera corolate to on image
        //println("Adjusted x" + adjustedPoint[0]  + " adjusted y" + adjustedPoint[1]);
        ellipse(adjustedPoint[0] - 2, adjustedPoint[1] - 2, 4, 4);
      }
    }
    if (debug) {
      debugScreen.endDraw();
      debugScreen.updatePixels();
      image(debugScreen, 0, 0);
    }
  }
}

public Rectangle findPupil() {
  // /FIND THE PUPIL
  ArrayList boxes = new ArrayList();
  for (int row = edge; row < video.height - edge * 2; row++) {
    for (int col = edge; col < video.width - edge * 2; col++) {
      int offset = row * video.width + col;
      int thisPixel =  video.pixels[offset];
      //look for dark things
      if (brightness(thisPixel) < pupilThreshold) {
       // debugScreen.pixels[offset] = 0;
        // be pessimistic
        boolean foundAHome = false;
        // look throught the existing
        for (int i = 0; i < boxes.size(); i++) {
          Rectangle existingBox = (Rectangle) boxes.get(i);
          // is this spot in an existing box
          Rectangle inflatedBox = new Rectangle(existingBox); // copy the existing box
          inflatedBox.grow(reach, reach); // widen it's reach
          if (inflatedBox.contains(col, row)) {
            existingBox.add(col, row);
            foundAHome = true; // no need to make a new one
            break; // no need to look through the rest of the boxes
          }
        }
        // if this does not belong to one of the existing boxes make a new one at this place
        if (foundAHome == false) boxes.add(new Rectangle(col, row, 0, 0));
      }
    }
  }

  consolidate(boxes, 0, 0);

  // OF EVERYTHING YOU FIND TAKE THE ONE CLOSEST TO THE CENTER
  Rectangle pupil = findClosestMostBigOne(boxes, video.width / 2, video.height / 2, minPupilArea);
  if (debug) {
    // show the the edges of the search
    debugScreen.fill(0, 0, 0, 0);
    debugScreen.stroke(0, 255, 255);
    debugScreen.rect(edge, edge, video.width - 2 * edge, video.height - 2 * edge);
    // show all the pupil candidates
    debugScreen.stroke(255, 255, 0);
    for (int i = 0; i < boxes.size(); i++) {
      Rectangle thisBox = (Rectangle) boxes.get(i);
      debugScreen.rect(thisBox.x, thisBox.y, thisBox.width, thisBox.height);
    }
    // show the winning pupil candidate in red
    if (pupil != null) {
      stroke(255, 0, 0);
      debugScreen.rect(pupil.x, pupil.y, pupil.width, pupil.height);
    }
  }
  return pupil;
}

public Rectangle findGlint(Rectangle _pupil) {
  // ADJUST THE BOUNDS OF YOUR SEARCH TO BE AROUND AND UNER THE PUPIL
  int glintEdgeL = Math.max(edge, _pupil.x - _pupil.width * 2);
  int glintEdgeR = Math.min(video.width - edge, _pupil.x +  _pupil.width * 2);
  int glintTop = _pupil.y;
  int glintBottom = Math.min(video.height - edge, _pupil.y +  _pupil.height * 2);

  ArrayList glintsCandidates = new ArrayList();
  for (int row = glintTop; row < glintBottom; row++) {
    for (int col = glintEdgeL; col < glintEdgeR; col++) {
      int offset = row * video.width + col;
      int thisPixel = video.pixels[offset];
      //look for bright things
      if (brightness(thisPixel) > glintThreshold) {
        if (debug) debugScreen.pixels[offset] = 0xffff00;
        // be pessimistic
        boolean foundAHome = false;
        // look throught the existing
        for (int i = 0; i < glintsCandidates.size(); i++) {
          Rectangle existingBox = (Rectangle) glintsCandidates.get(i);
          // is this spot in an existing box
          Rectangle inflatedBox = new Rectangle(existingBox); // copy the existing box
          inflatedBox.grow(reach, reach); // widen it's reach
          if (inflatedBox.contains(col, row)) {
            existingBox.add(col, row);
            foundAHome = true; // no need to make a new one
            break; // no need to look through the rest of the boxes
          }
        }
        // if this does not belong to one of the existing boxes make a new one at this place
        if (foundAHome == false) glintsCandidates.add(new Rectangle(col, row, 0, 0));
      }
    }
  }
  // FIND THE GLINT THAT IS CLOSEST TO THE PUPIL
  Rectangle glint = findClosestMostBigOne(glintsCandidates, _pupil.x + _pupil.width, _pupil.y + _pupil.height / 2, 0);
  debugScreen.stroke(0, 0, 255);

  if (debug) {// show all the candidate
    // show the edges of the search for the glint
    debugScreen.stroke(0, 255, 0);
    debugScreen.rect(glintEdgeL, glintTop, glintEdgeR - glintEdgeL, glintBottom - glintTop);
    for (int i = 0; i < glintsCandidates.size(); i++) {
      Rectangle thisBox = (Rectangle) glintsCandidates.get(i);
      debugScreen.rect(thisBox.x, thisBox.y, thisBox.width, thisBox.height);
    } // show the winner in red
    if (glint != null) {
      debugScreen.stroke(255, 0, 0);
      debugScreen.rect(glint.x, glint.y, glint.width, glint.height);
    }
  }

  return glint;
}

public void consolidate(ArrayList _shapes, int _consolidateReachX, int _consolidateReachY) {
  // check every combination of shapes for overlap
  // make the repeat loop backwards so you delete off the bottom of the stack
  for (int i = _shapes.size() - 1; i > -1; i--) {
    // only check the ones up
    Rectangle shape1 = (Rectangle) _shapes.get(i);
    Rectangle inflatedShape1 = new Rectangle(shape1); // copy the existing box
    inflatedShape1.grow(_consolidateReachX, _consolidateReachY); // widen it's reach

    for (int j = i - 1; j > -1; j--) {
      Rectangle shape2 = (Rectangle) _shapes.get(j);
      if (inflatedShape1.intersects(shape2)) {
        shape1.add(shape2);
        // System.out.println("Remove" + j);
        _shapes.remove(j);
        break;
      }
    }
  }
}

public Rectangle findClosestMostBigOne(ArrayList _allRects, int _x, int _y, int _minArea) {
  if (_allRects.size() == 0) return null;
  int winner = 0;
  float closest = 1000;

  for (int i = 0; i < _allRects.size(); i++) {
    Rectangle thisRect = (Rectangle)  _allRects.get(i);
    if (thisRect.width * thisRect.height < _minArea) continue;
    float thisDist = dist(_x, _y, thisRect.x + thisRect.width / 2, thisRect.y + thisRect.height / 2);
    if (thisDist < closest) {
      closest = thisDist;
      winner = i;
    }
  }
  return (Rectangle) _allRects.get(winner);
}

public void keyPressed() {
  if (key == 's') {
    //video.settings();
  } 
  else if (key == 'c') {
    calibrator.startCalibrationRoutine(3, width, 3, height, 3);
    debug = false;
  } 
  else if (key == 'l') {
    leaveTrails = !leaveTrails;
    if (leaveTrails == false) image(testImage, 0, 0);
  } 
  else if (key == 'd') {

    debug = !debug;
    if (debug == false) image(testImage, 0, 0);
    println("debug " + debug);
  } 
  else if (key == 'p') {
    pupilThreshold--;
    println("PuplilThreshold " + pupilThreshold);
  } 
  else if (key == 'P') {
    pupilThreshold++;
    println("PuplilThreshold " + pupilThreshold);
  } 
  else if (key == 'r') {
    reach--;
    println("reach " + reach);
  } 
  else if (key == 'R') {
    reach++;
    println("reach " + reach);
  } 

  else if (key == 'A') {
    minPupilArea++;
    println("minArea " + minPupilArea);
  } 
  else if (key == 'a') {
    minPupilArea--;
    println("minArea " + minPupilArea);
  } 
  else if (key == 'G') {
    glintThreshold++;
    println("glintThreshold " + glintThreshold);
  } 
  else if (key == 'g') {
    glintThreshold--;
    println("glintThreshold " + glintThreshold);
  } 
  else if (key == 'E') {
    edge++;
    println("edge " + edge);
  } 
  else if (key == 'e') {
    edge --; // = Math.max(0, edge--);
    println("edge " + edge);
  } 
  else if (key == 't') {

    println("Elapsedtime " + elapsedTime);
  }
}

