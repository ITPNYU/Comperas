class BodyParts extends PApplet {
  SimpleOpenNI  kinect;

  PVector leftHand = new PVector();
  PVector rightHand = new PVector();
  PVector leftHip = new PVector();
  PVector rightHip = new PVector();
  PVector torso = new PVector();
  PVector head = new PVector();
  PVector neck = new PVector();
  PVector leftElbow = new PVector();
  PVector rightElbow = new PVector();
  PVector rightShoulder = new PVector();
  PVector leftShoulder = new PVector();
  PVector rightKnee = new PVector();
  PVector leftKnee = new PVector();

  BodyParts(SimpleOpenNI  _kinect) {
    kinect= _kinect;
    //got access to the context object but called it kinect instead
  }

  void findParts() {

    if (kinect.isTrackingSkeleton(1)) {
      locatePartsInKinectCoordinates(1);
      kinectDrawsSkeleton(1);
    }
  }
  PVector getHead() {
    return convertToScreenCoordinates(head);
  }
  PVector getTorso() {
    return convertToScreenCoordinates(torso);
  }
  PVector getLeftHand() {
    return convertToScreenCoordinates(leftHand);
  }
  PVector getRightHand() {
    return convertToScreenCoordinates(rightHand);
  }
  PVector getLeftElbow() {
    return convertToScreenCoordinates(leftElbow);
  }
  PVector getRightElbow() {
    return convertToScreenCoordinates(rightElbow);
  }
  PVector getLeftShoulder() {
    return convertToScreenCoordinates(leftShoulder);
  }
  PVector getRightShoulder() {
    return convertToScreenCoordinates(rightShoulder);
  }
  PVector getLeftHip() {
    return convertToScreenCoordinates(leftHip);
  }
  PVector getRightHip() {
    return convertToScreenCoordinates(rightHip);
  }
  PVector getLeftKnee() {
    return convertToScreenCoordinates(leftKnee);
  }
  PVector getRightKnee() {
    return convertToScreenCoordinates(rightKnee);
  }






  PVector convertToScreenCoordinates(PVector _kinectCoordinates) {
    PVector myPositionScreenCoords  = new PVector(); //storage device
    //convert the weird kinect coordinates to screen coordinates.
    kinect.convertRealWorldToProjective(_kinectCoordinates, myPositionScreenCoords);
    return myPositionScreenCoords;
  }

  void locatePartsInKinectCoordinates(int userId) {
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, leftHip);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, torso);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, leftKnee);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, rightKnee);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, leftElbow);
  }


  void kinectDrawsSkeleton(int userId) {
    //Let the Kinect Draw the Skeleton without you seeing its weird numbers
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  }
}

