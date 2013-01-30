import java.util.*;
public class CoordinatesTranslator {

  boolean calibrationDotBlinkState;
  float xSlope = 1.0f;
  float ySlope = 1.0f;
  float xIntercept = 0f;
  float yIntercept = 0f;
  public ArrayList calibrationPoints = new ArrayList();

  int sceneX = 0;
  int sceneY = 0;
  ArrayList recordedXPoints = new ArrayList();
  ArrayList recordedYPoints = new ArrayList();
  int calibrationOps = 0;
  boolean calibrate = false;
  int numberOfSamples;
  long milliSecondsPerPoint = 10000;
  Point[] allScenePoints;
  long lastPositionStart;
  int whichPoint = 0;

  public boolean isCurrentlyCalibrating() {
    return calibrate;
  }



  public int[] translate(int _x, int _y) {

    int[] out = { 
      (int) (_x * xSlope + xIntercept), (int) (_y * ySlope + yIntercept)
      };

      return out;
  }



  public void startCalibrationRoutine(int _numberAcross, int _pixelsAcross, int _numberDown, int _pixelsDown, int _secondsPerPoint) {

    clearCalibrations();
    milliSecondsPerPoint = _secondsPerPoint * 1000;
    int xInc = _pixelsAcross / (_numberAcross + 1);
    int yInc = _pixelsDown / (_numberDown + 1);
    allScenePoints = new Point[_numberDown * _numberAcross];
    for (int r = 0; r < _numberDown; r++) {
      for (int c = 0; c < _numberAcross; c++) {
        allScenePoints[r * _numberAcross + c] = new Point(c * xInc + xInc, r * yInc + yInc);
        System.out.println("cal point" + allScenePoints[r * _numberAcross + c]);
      }
    }

    // lastPositionStart = 0; //long time ago

    whichPoint = 0;
    lastPositionStart = System.currentTimeMillis();
    Point currPoint = allScenePoints[whichPoint];
    startCalibratingNewPoint(currPoint.x, currPoint.y, -1);
    calibrate = true;
  }



  public int[] doCalibrationRoutine(boolean _valid, int _x, int _y) {

    if (calibrate) {
      //check on the progression of the target dots
      long now = System.currentTimeMillis();
      if ((now - lastPositionStart) > milliSecondsPerPoint) {
        System.out.println("New Calibration" + whichPoint);
        if (whichPoint != -1) {
          finishCalibrationForNewPoint();
        }
        whichPoint++;
        if (whichPoint >= allScenePoints.length) {
          calibrate = false;
          return null;
        }

        lastPositionStart = now;
        Point currPoint = allScenePoints[whichPoint];
        startCalibratingNewPoint(currPoint.x, currPoint.y, -1);
      }
    }

    if (_valid) {
      calibrationDotBlinkState = !calibrationDotBlinkState;
      addToCalibrationForThisPoint(_x, _y);
    }

    int[] r = { 
      sceneX, sceneY
    };

    return r;
  }



  public Point getScenePoint() {

    if (calibrate) {
      return new Point(sceneX, sceneY);
    } 
    else {
      return null;
    }
  }



  public void startCalibratingNewPoint(int _sceneX, int _sceneY, int _numberOfSamples) {

    numberOfSamples = _numberOfSamples;
    calibrationOps = 0;
    sceneX = _sceneX;
    sceneY = _sceneY;
    System.out.println("startNewCalibrationPoint");
    recordedXPoints = new ArrayList();
    recordedYPoints = new ArrayList();
    calibrate = true;
  }



  private void addToCalibrationForThisPoint(int x, int y) {

    calibrationOps++;
    recordedXPoints.add(new Integer(x));
    recordedYPoints.add(new Integer(y));
    if ((numberOfSamples != -1) && (calibrationOps >= numberOfSamples))
      finishCalibrationForNewPoint();
  }





  public void finishCalibrationForNewPoint() {

    System.out.println("finishNewCalibrationPoint");
    calibrate = false;
    // for(int a = 0; a < recordedXPoints.
    if (recordedXPoints.size() > calibrationOps / 2) {
      Object[] rxp = recordedXPoints.toArray();
      Arrays.sort(rxp);
      Object[] ryp = recordedYPoints.toArray();
      Arrays.sort(ryp);
      int eyeX = ((Integer) (rxp[rxp.length / 2])).intValue();
      int eyeY = ((Integer) (ryp[ryp.length / 2])).intValue();
      System.out.println("calibs " + recordedXPoints.toString() + " " + eyeX + " scene " + sceneX);
      System.out.println("calibs " + recordedYPoints.toString() + " " + eyeY + " scene " + sceneY);
      int[] newPoints = { 
        eyeX, eyeY, sceneX, sceneY
      };
      calibrationPoints.add(newPoints);
      linearRegressionCalibration();
    } 
    else {
      System.out.println("calibraion aborted, no calibration points");
    }
  }



  public void clearCalibrations() {

    calibrate = false;
    xSlope = 1.0f;
    ySlope = 1.0f;
    xIntercept = 0f;
    yIntercept = 0f;
    calibrationPoints = new ArrayList();
    System.out.println("clear calibrations");
  }



  public void linearRegressionCalibration() {

    System.out.println("Linear Regression");
    float Exy = 0.0f; // sum of products = x1y1 + x2y2 + . . . + xnyn
    float Ex = 0.0f; // sum of x-values = x1 + x2 + . . . + xn
    float Ey = 0.0f; // sum of y-values = y1 + y2 + . . . + yn
    float Ex2 = 0.0f; // sum of squares of x-values = x12 + x22+ . . . +
    // xn2

    for (int i = 0; i < calibrationPoints.size(); i++) {

      int[] target = (int[]) calibrationPoints.get(i);
      System.out.println("samples " + i + " " + target[0] + " " + target[1] + " " + target[2] + " " + target[3]);
      Exy = Exy + target[0] * target[2];
      Ex = Ex + target[0];
      Ey = Ey + target[2];
      Ex2 = Ex2 + target[0] * target[0];
    }

    // System.out.println("samples " + " " + Exy + " " + Ex + " " + Ey + " " + Ex2);

    float n = (float) calibrationPoints.size();
    System.out.println("n" + n);
    float denom = (float) (n * (Ex2) - (Ex * Ex));
    // if (denom == 0.0)

    // denom = 1.0f;

    xSlope = (n * Exy - Ex * Ey) / (n * Ex2 - Ex * Ex);
    xIntercept = (Ey - xSlope * Ex) / n;
    Exy = 0;
    Ex = 0;
    Ey = 0;
    Ex2 = 0;

    for (int i = 0; i < calibrationPoints.size(); i++) {

      int[] target = (int[]) calibrationPoints.get(i);
      Exy = Exy + target[1] * target[3];
      Ex = Ex + target[1];
      Ey = Ey + target[3];
      Ex2 = Ex2 + target[1] * target[1];
    }

    n = calibrationPoints.size();
    ySlope = (n * Exy - Ex * Ey) / (n * Ex2 - Ex * Ex);
    yIntercept = (Ey - ySlope * Ex) / n;

    // variablesToPrefs(prefs);

    System.out.println("xslope " + xSlope + " intercept" + xIntercept);
    System.out.println("yslope " + ySlope + " intercept" + yIntercept);

    // http://people.hofstra.edu/faculty/Stefan_Waner/RealWorld/calctopic1/regression.html
  }



  public boolean getCalibrationDotBlinkState() {
    return calibrationDotBlinkState;
  }



  public void setCalibrationDotBlinkState(boolean calibrationDotBlinkState) {
    this.calibrationDotBlinkState = calibrationDotBlinkState;
  }
}

