class Edges {

  int leftEdge ; 
  int rightEdge ;
  int leftDepth;
  int rightDepth;
  
  Edges(int _col, int _d) {
    leftEdge = _col;
    rightEdge = _col;
    rightDepth = _d;
    leftDepth = _d;
  }
  void setEdges(int _col, int _d) {
    if (_col < leftEdge) {
      leftEdge = _col; 
      leftDepth = _d;
    }
    if (_col > rightEdge){
      rightEdge = _col;
      rightDepth = _d;
    }
    
  }
}
