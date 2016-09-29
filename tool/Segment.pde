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
  color mColor;
  Knob mKnobDistance;
  boolean mContext = false;
  float mTargetDirection = 0;
  CallbackListener cb;
  
  
  Segment(Layer _mLayer, boolean _mDirection, int _mSpeed, color _mColor) {
    
    this.mLayer = _mLayer;
    this.mColor = _mColor;
    this.mPosition = new PVector(random(mLayer.mTranslation.x, mLayer.mSize.x), mLayer.mTranslation.y);
    this.mDirection = _mDirection;
    this.mSpeed = _mSpeed;
    //mPosition = new PVector(0,0);
    println("### (SEGMENT) created");
    mID = mSegmentCounter;
    mSegmentCounter++;

    cb = new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
           if (theEvent.getController().getName().equals("knob"+mID)) {
            
          }
        }
    };

    mKnobDistance = cp5.addKnob("knob"+mID)
               .setRange(-2000,2000)
               .setCaptionLabel("distance")
               .setValue(0)
               .setPosition(mPosition.x,mPosition.y)
               .setRadius(30)
               .setDragDirection(Knob.VERTICAL)
               .addCallback(cb)
               ;

    

  }
  
  void draw() {
    if(mContext) {
      mKnobDistance.setVisible(true);
      mKnobDistance.setPosition(mPosition.x,mPosition.y);
    } else mKnobDistance.setVisible(false);
    if(gLocked == null) detect();
    pushStyle();
    //rectMode(CORNER);
    stroke(0, 0, 100);
    if(mHover) {
      fill(mColor);
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

  float getTime() {
    //mTotalPlayTime
    //mWidth
    //length: 10-width-30

    return map(mWidth, 10, width-30, 0, mTotalPlayTime);
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
      mContext = !mContext;
      println("i am layer #"+ mID +" and my position is: "+ mPosition);
      println("my platime is: "+ getTime());
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

  void yo() {
    println("yo");
  }

  


}