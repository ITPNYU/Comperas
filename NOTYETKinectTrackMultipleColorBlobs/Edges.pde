class Edges {

  int leftEdge ; 
  int rightEdge ;
  Edges(int _col) {
    leftEdge = _col;
    rightEdge = _col;
  }
  void setEdges(int _col) {
    if (_col < leftEdge) leftEdge = _col; 
    if (_col > rightEdge) rightEdge = _col;
  }
}
