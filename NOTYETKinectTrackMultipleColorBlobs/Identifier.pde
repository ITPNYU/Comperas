public class Identifier{
  int biggestId = 1;
  ArrayList masterList = new ArrayList();

  
  void findMatchesFromPrevious(ArrayList _newRects){
     
     int[] distances = new int[_newRects.size()*masterList.size()];
      int[][] pairings = new int[masterList.size()*_newRects.size()][3]; //dist,masterIndex,newIndex
      for (int i = 0; i < masterList.size(); i++) {
        Blob3D masterBlob = (Blob3D) masterList.get(i);
        for (int j = 0; j < _newRects.size(); j++) {
          int placeInArray = i*_newRects.size() + j;
          Blob3D newBlob = (Blob3D) _newRects.get(j);
          int dist = (int) dist(masterBlob.centerX, masterBlob.centerY,newBlob.centerX, newBlob.centerY) ;
          distances[placeInArray] = dist;
          pairings[placeInArray] = new int[] {dist,i,j};

        }
      }

      // sort the distances
      Arrays.sort(distances);
      //keep track if these things have been spoken for already 
      boolean[] checkListFormaster = new boolean[masterList.size()];
      boolean[] checkListForNew = new boolean[_newRects.size()];
      //keep a variable that knows if you you have found enough
      int found = 0;
      //go down the distances in order and find the pairing with the least distance
      for (int i = 0; i < distances.length; i++) {
        int closeOne = distances[i];
        for (int j = 0; j < pairings.length; j++){
          int[] thisPairing = pairings[j];
          int dist = thisPairing[0];
          int masterIndex = thisPairing[1];
          int newIndex = thisPairing[2];
          //if this pairing has the distance you are after and it's parts are not spoken for
          if (dist == closeOne &&  checkListForNew[newIndex] == false && checkListFormaster[masterIndex] == false) { 
                                              // not spoken for
            Blob3D masterBlob = (Blob3D) masterList.get(masterIndex);
            Blob3D newBlob = (Blob3D) _newRects.get(newIndex);
            checkListFormaster[masterIndex] = true; // mark this found as used
            checkListForNew[newIndex] = true;
            newBlob.serialNumber = masterBlob.serialNumber;
            masterBlob.centerX = newBlob.centerX;
            masterBlob.centerY = newBlob.centerY;
            masterBlob.myEdges = newBlob.myEdges;
            found++;
          }
          if (found >= _newRects.size()) break;
        }
        if (found >= _newRects.size()) break;
      }
      for(int i = 0; i<checkListForNew.length; i++){
        if (checkListForNew[i] == false){
           Blob3D newBlob = (Blob3D) _newRects.get(i);
           newBlob.serialNumber = biggestId;
           biggestId++;
           masterList.add(newBlob);
        }
        
      }
  }
  
  
}


