class Layer {
  PVector mPosition;
  float mWidth;
  Motor mMotor;
  ArrayList<Segment> segments = new ArrayList<Segment>();
  int mID;
  boolean mSelected = false; // is currently active?
  boolean mHover = false;
  boolean mLocked = false;
  PVector mOffset = new PVector(0,0);
  PVector mSize = new PVector(maxWidth, 59);
  PVector mTranslation;
  int mSegmentCounter = 0;
  
  Layer() {
    this.mPosition = new PVector(random(80,width-80), height/2);
    this.mWidth = random(20,200);
    this.mMotor = new Motor("Motor 1", 1, true);
    mID = mLayerCounter;
    mLayerCounter++;
    mTranslation = new PVector(leftMargin, (header.getHeight()+mSize.y/2+((mID))*mSize.y)+(mSize.y/2*mID));
    println("### (LAYER) created");
    float r = random(0,5);
    for(float i = 0; i<r; i+=1.) add();
  }
  
  void add() {
    println("### (LAYER) adding new segment...");
    segments.add(new Segment(this, true, 500));
    
  }
  
  void draw() {
    pushStyle();
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100);
    rect(mTranslation.x, mTranslation.y, mSize.x, mSize.y);
    popStyle();
    /*
    pushStyle();
    rectMode(CORNER);
    stroke(255);
    if(mHover) fill(0,125,255);
    else fill(0); 
    
    rect(mPosition.x, mPosition.y, mWidth, 20);
    fill(255);
    text("#"+mID, mPosition.x, mPosition.y+5);
    text(mPosition.x + "|" + mPosition.y, mPosition.x, mPosition.y+40);
    popStyle();
    mHover = false;
    */
    
    for (Segment segment : segments) {
      segment.draw();
    }
  }

  ArrayList<Segment> getSegments() {
    return segments;
  }

  int countSegments() {
    return segments.size();
  }

  ArrayList<PVector> getPVectors() {
    ArrayList<PVector> dots = new ArrayList<PVector>();
    for (Segment segment : segments) {
      PVector v = segment.getPosition();
      dots.add(v);
    }
    return dots;
  }

  ArrayList<PVector> sortSegments() {
    ArrayList<PVector> positions = getPVectors();
    Collections.sort(positions, new DistanceComparator(new PVector(0,0)));
    return positions;
  }

  ArrayList<PVector> sortSegments(ArrayList<PVector> vektoren) {
    Collections.sort(vektoren, new DistanceComparator(new PVector(0,0)));
    return vektoren;
  }

  ArrayList<PVector> getSegmentsWithID() {
    ArrayList<PVector> withID = new ArrayList<PVector>();
    ArrayList<PVector> tSegments = sortSegments();
    for (PVector sortedSegment : tSegments) {
      for (Segment segment : segments) {
        if(segment.getPosition() == sortedSegment) {
          PVector v = new PVector(segment.getPosition().x, segment.getPosition().y, segment.getID());
          withID.add(v);
          break;
        }
      }
    }
    return withID;
  }

  ArrayList<PVector> getNullSegments() {
    ArrayList<PVector> withID = getSegmentsWithID();
    // walk through our new vectors
    // look up the width
    // and try to calculate the white spaces
    // add those white spaces into a new ArrayList
    ArrayList<PVector> nullSegments = new ArrayList<PVector>();
    float leftBorder = leftMargin;
    // always look to the left, except the last element
    // there we should also look to the right

    // something is still wrong with the margins. gotta check that.
    int counter = 0;
    for (PVector sortedSegment : withID) {

      // println(sortedSegment.x-leftBorder);
      // there is something left from us
      if(sortedSegment.x-leftBorder > 0) {
        PVector v = new PVector(leftBorder, (sortedSegment.x-leftBorder), -1);
        nullSegments.add(v);
        leftBorder = (segments.get((int)sortedSegment.z).getWidth())+sortedSegment.x;
      }
      counter++;
      // when we encounter our last element
      if(counter == withID.size() && maxWidth-leftBorder > 0) {
          PVector v = new PVector(leftBorder, (maxWidth-leftBorder)+leftMargin, -1);
          nullSegments.add(v);
      }
    }
    return nullSegments;
  }

  ArrayList<PVector> mergeLists(ArrayList<PVector> a, ArrayList<PVector> b) {
    for (PVector element : a) {
      b.add(element);
    }
    return b;
  }
  
  PVector getPosition() {
    return mPosition;
  }
  
  void setPosition(PVector p) {
    mPosition = p;
  }
  
  float getWidth() {
    return mWidth;
  }

  int getID() {
    return mID;
  }
 
  
  void mousePressed() {
    for (Segment segment : segments) {
      segment.mousePressed();
    }
  }
  
  void mouseDragged() {
    for (Segment segment : segments) {
      segment.mouseDragged();
    }
  }
  
  void mouseReleased() {
    for (Segment segment : segments) {
      segment.mouseReleased();
    }
  }
  
}