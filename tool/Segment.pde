class Segment {
  PVector mPosition;
  float mWidth;
  Motor mMotor;
  ArrayList<Motion> motions = new ArrayList<Motion>();
  int mID;
  boolean mSelected = false; // is currently active?
  boolean mHover = false;
  boolean mLocked = false;
  PVector mOffset = new PVector(0,0);
  
  Segment() {
    this.mPosition = new PVector(random(80,width-80), height/2);
    this.mWidth = random(20,200);
    this.mMotor = new Motor("Motor 1", 1, true);
    mID = mSegmentCounter;
    mSegmentCounter++;
    println("### (SEGMENT) created");
  }
  
  void add() {
    println("### (SEGMENT) adding new motion…");
    motions.add(new Motion(true, 500));
    
  }
  
  void draw() {
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
  
  void hover() {
    mHover = true;
  }
  
}