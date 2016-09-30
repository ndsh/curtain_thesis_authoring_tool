import java.util.Comparator;

public class DistanceComparator implements Comparator<PVector> {

  PVector compareToVector;

  public DistanceComparator(PVector compareToVector) {
    this.compareToVector = compareToVector;
  }

  public int compare(PVector v1, PVector v2) {

    float d1 = v1.dist(compareToVector);
    float d2 = v2.dist(compareToVector);

    if (d1 < d2) {
      return -1;
    } 
    else if (d1 > d2) {
      return 1;
    } 
    else {
      return 0;
    }
  }
  
  
}