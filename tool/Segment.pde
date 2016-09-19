class Segment {
  boolean mDirection;
  int mSpeed;
  boolean mHover = false;
  boolean mLocked = false;
  float xOffset = 0.0;
  float yOffset = 0.0;
  PVector mPosition;
  int mID = 0;
  int mWidth = 200;
  Layer mLayer;
  
  
  Segment(Layer _mLayer, boolean _mDirection, int _mSpeed) {
    this.mLayer = _mLayer;
    this.mPosition = new PVector(random(0, mLayer.mTranslation.x), mLayer.mTranslation.y);
    this.mDirection = _mDirection;
    this.mSpeed = _mSpeed;
    //mPosition = new PVector(0,0);
    println("### (SEGMENT) created");
  }
  
  void draw() {
    detect();
    pushStyle();
    //rectMode(CORNER);
    stroke(255);
    if(mHover) {
      fill(0,125,255);
      if(mLocked) fill(0,255,0);
    } else fill(0,160,160); 
    
    
    rect(mPosition.x, mPosition.y, mWidth, 20);
    fill(125);
    //text("#"+mID, mPosition.x, mPosition.y+5);
    //text(mPosition.x + "|" + mPosition.y, mPosition.x, mPosition.y+40);
    popStyle();
    //mHover = false;
  }
  
  void detect() {
    if(gLocked == null) {
      if (mouseX >= mPosition.x && mouseX <= mPosition.x+mWidth && 
        mouseY >= mPosition.y && mouseY <= mPosition.y+20) mHover = true;
      else mHover = false;
    }
  }
  
  void mousePressed() {
    if(mHover && gLocked == null) { 
      mLocked = true;
      gLocked = this;
    } else {
      mLocked = false;
    }
    xOffset = mouseX-mPosition.x; 
    yOffset = mouseY-mPosition.y; 
  }
  
  void mouseDragged() {
    if(mLocked && gLocked == this) {
      println(mLayer.mSize.x);
      mPosition.x = constrain(mouseX-xOffset, mLayer.mTranslation.x, (mLayer.mSize.x-mWidth));
      //mPosition.y = mouseY-yOffset; 
    }
  }
  
  void mouseReleased() {
    mLocked = false;
    if(gLocked == this) gLocked = null;
  }
}