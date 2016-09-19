class Segment {
  boolean mDirection;
  int mSpeed;
  boolean mHover = false;
  boolean mLocked = false;
  float xOffset = 0.0;
  float yOffset = 0.0;
  PVector mPosition;
  int mID = 0;
  int mWidth = (int)random(50,200);
  int mGrab = -1;
  Layer mLayer;
  float mColor;
  
  
  Segment(Layer _mLayer, boolean _mDirection, int _mSpeed, float _mColor) {
    
    this.mLayer = _mLayer;
    this.mColor = _mColor;
    this.mPosition = new PVector(random(mLayer.mTranslation.x, mLayer.mSize.x), mLayer.mTranslation.y);
    this.mDirection = _mDirection;
    this.mSpeed = _mSpeed;
    //mPosition = new PVector(0,0);
    println("### (SEGMENT) created");
  }
  
  void draw() {
    if(gLocked == null) detect();
    pushStyle();
    //rectMode(CORNER);
    stroke(0, 0, 100);
    if(mHover) {
      fill(mColor,70,70);
      if(mLocked && mGrab == 0) fill(mColor,70,100);
    } else fill(mColor,70,50); 
    
    
    rect(mPosition.x, mPosition.y, mWidth, 20);
    fill(125);
    rect(mPosition.x+mWidth-10, mPosition.y, 10, 20);
    //text(mWidth, mPosition.x, mPosition.y+5);
    //text("#"+mID, mPosition.x, mPosition.y+5);
    //text(mPosition.x + "|" + mPosition.y, mPosition.x, mPosition.y+40);
    popStyle();
    //mHover = false;
  }
  
  void detect() {
    if (mouseX >= mPosition.x && mouseX <= mPosition.x+mWidth && 
      mouseY >= mPosition.y && mouseY <= mPosition.y+20) {
        mHover = true;
        // left corner
        if (mouseX >= mPosition.x && mouseX <= mPosition.x+10 && 
        mouseY >= mPosition.y && mouseY <= mPosition.y+20) mGrab = 1;
        else if (mouseX >= (mPosition.x+mWidth)-10 && mouseX <= mPosition.x+mWidth && 
        mouseY >= mPosition.y && mouseY <= mPosition.y+20) mGrab = 2;
        else mGrab = 0;
    } else {
      mHover = false;
      mGrab = -1;
    }
  }
  
  void mousePressed() {
    if(mHover && gLocked == null && !timeBarLock) { 
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
      
      if(mGrab == 0) mPosition.x = constrain(mouseX-xOffset, mLayer.mTranslation.x, (mLayer.mSize.x-mWidth));
      else if(mGrab > 0) {
        if(mGrab == 2) mWidth = ((int)(mouseX-mPosition.x)>=20?(int)(mouseX-mPosition.x):mWidth);
        else if(mGrab == 1) {
          //
          //mWidth = (int)(mouseX-mPosition.x);
        }
      }
      //mPosition.y = mouseY-yOffset; 
    }
  }
  
  void mouseReleased() {
    mLocked = false;
    if(gLocked == this) gLocked = null;
  }
}