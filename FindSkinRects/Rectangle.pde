class Rectangle {
  public int furthestLeft;
  public int furthestUp;
  public int furthestRight;
  public int furthestDown;

  Rectangle(int _x, int _y) {
    furthestLeft = _x;
    furthestUp = _y;
    furthestRight = _x;
    furthestDown = _y;
  }

  void add(int _x, int _y) {
    if (_x < furthestLeft) furthestLeft = _x;
    if (_x > furthestRight) furthestRight = _x;
    if (_y < furthestUp) furthestUp = _y;
    if (_y > furthestDown) furthestDown = _y;
  }
  
  void add(Rectangle _rect){
    if (_rect.furthestLeft < furthestLeft) furthestLeft = _rect.furthestLeft;
    if (_rect.furthestRight  > furthestRight) furthestRight = _rect.furthestRight ;
    if (_rect.furthestUp   < furthestUp) furthestUp = _rect.furthestUp ;
    if (_rect.furthestDown  > furthestDown) furthestDown = _rect.furthestDown ;
  }
  

  boolean isNear(int _x, int _y, int _reach) {
    //make sure this new spot is inside the current stretch by reach
   return ((_x >= furthestLeft-_reach && _x < furthestRight + _reach) && (_y >= furthestUp -reach && _y < furthestDown + _reach));
  }

  void draw() {
    rect(furthestLeft, furthestUp, furthestRight-furthestLeft, furthestDown-furthestUp);
  }
  
  int getWidth(){
    return furthestRight-furthestLeft;
  }
  
  int getHeight(){
    return furthestDown-furthestUp;
  }
  
  boolean intersects(Rectangle _other){
    return ! ( _other.furthestLeft > furthestRight
    || _other.furthestRight < furthestLeft
    || _other.furthestUp > furthestDown
    || _other.furthestDown < furthestUp
    );
  }
}

