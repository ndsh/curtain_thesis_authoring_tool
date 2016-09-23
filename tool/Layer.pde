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
  PVector mSize = new PVector(width-30, 20);
  PVector mTranslation;
  float mColor;
  
  Layer() {
    this.mColor = random(0,360);
    this.mPosition = new PVector(random(80,width-80), height/2);
    this.mWidth = random(20,200);
    this.mMotor = new Motor("Motor 1", 1, true);
    mID = mLayerCounter;
    mLayerCounter++;
    mTranslation = new PVector(10,(mID+1)*30);
    println("### (LAYER) created");
    float r = random(0,5);
    for(float i = 0; i<r; i+=1.) add();
  }
  
  void add() {
    println("### (LAYER) adding new segment…");
    segments.add(new Segment(this, true, 500, mColor));
    
  }
  
  void draw() {
    pushStyle();
    noFill();
    stroke(0, 0, 70);
    rect(mTranslation.x, mTranslation.y,mSize.x,mSize.y);
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
  
  PVector getPosition() {
    return mPosition;
  }
  
  void setPosition(PVector p) {
    mPosition = p;
  }
  
  float getWidth() {
    return mWidth;
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