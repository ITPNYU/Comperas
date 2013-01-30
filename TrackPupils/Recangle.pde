class Rectangle {
  int furthestLeft;
  int furthestUp;
  int furthestRight;
  int furthestDown;

  Rectangle(int _x, int _y) {
    furthestLeft = _x;
    furthestUp = _y;
    furthestRight = _x;
    furthestDown = _y;
  }
  
  int getWidth(){
    return (furthestRight-furthestLeft);
  }
  int getHeight(){
    return (furthestDown-furthestUp);
  }
  int getArea(){
    return (getWidth()&getHeight());
  }

  void add(int _x, int _y) {
    if (_x < furthestLeft) furthestLeft = _x;
    if (_x > furthestRight) furthestRight = _x;
    if (_y < furthestUp) furthestUp = _y;
    if (_y > furthestDown) furthestDown = _y;
  }

  boolean isNear(int _x, int _y, int _reach) {
    //make sure this new spot is inside the current stretch by reach
   return ((_x >= furthestLeft-_reach && _x < furthestRight + _reach) && (_y >= furthestUp -reach && _y < furthestDown + _reach));
  }

  void draw() {
    rect(furthestLeft, furthestUp, furthestRight-furthestLeft, furthestDown-furthestUp);
  }
}

