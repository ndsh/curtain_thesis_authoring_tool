class Segment {
  boolean mDirection;
  int mSpeed;
  boolean mHover = false;
  boolean mLocked = false;
  float xOffset = 0.0;
  float yOffset = 0.0;
  PVector mPosition;
  PVector mSize;
  float mGrabArea;
  int mID = 0;
  int mGrab = -1;
  Layer mLayer;
  Knob mKnobDistance;
  boolean mContext = false;
  float mTargetDirection = 0;
  CallbackListener cb;
  int mMargin = 3;
  
  
  Segment(Layer _mLayer, boolean _mDirection, int _mSpeed) {
    this.mSize = new PVector((int)random(50,200), 52);
    this.mLayer = _mLayer;
    this.mPosition = new PVector(random(mLayer.mTranslation.x, mLayer.mSize.x), mLayer.mTranslation.y+mMargin);
    this.mDirection = _mDirection;
    this.mSpeed = _mSpeed;
    this.mGrabArea = 32;
    println("### (SEGMENT) created");
    mID = mSegmentCounter;
    mSegmentCounter++;

    cb = new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
           if (theEvent.getController().getName().equals("knob"+mID)) {
            mTargetDirection = theEvent.getController().getValue();
          }
        }
    };

    mKnobDistance = cp5.addKnob("knob"+mID)
       .setRange(-2000,2000)
       .setCaptionLabel("distance")
       .setValue(0)
       .setPosition(mPosition.x,mPosition.y)
       .setRadius(26)
       .setNumberOfTickMarks(200)
       .setDragDirection(Knob.VERTICAL)
       .addCallback(cb)
       .setColorForeground(farbe.light())
       .setColorBackground(farbe.normal())
       .setColorActive(farbe.white())
       ;

    

  }
  
  void draw() {
    if(mContext) {
      mKnobDistance.setVisible(true);
      mKnobDistance.setPosition(mPosition.x,mPosition.y);
    } else mKnobDistance.setVisible(false);
    if(gLocked == null) detect();
    pushStyle();
    stroke(farbe.light());
    if(mHover) {
      stroke(farbe.white());
      fill(farbe.light());
      if(mLocked && mGrab == 0) fill(farbe.white());
    } else {
      if(mContext) fill(farbe.white()); 
      else fill(farbe.light()); 
    }
    
    
    rect(mPosition.x, mPosition.y, mSize.x, mSize.y);

    // grab area
    noStroke();
    // fill(360,100,100);
    rect(mPosition.x+mSize.x-mGrabArea+1, mPosition.y+1, mGrabArea-1, mSize.y-1);
    stroke(farbe.normal());
    // stroke(90,100,100);
    line(mPosition.x+mSize.x-mGrabArea, mPosition.y+1, mPosition.x+mSize.x-mGrabArea, mPosition.y+mSize.y-1);
    pushMatrix();
    translate(mPosition.x+mSize.x-mGrabArea+(mGrabArea/4), mPosition.y+(mSize.y/2));
    line(0,-3,16,-3);
    line(0,0,16,0);
    line(0,3,16,3);
    popMatrix();
    noStroke();
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
    return mSize.x;
  }

  int getID() {
    return mID;
  }

  float getTime() {
    //mTotalPlayTime
    //mWidth
    //length: 10-width-30

    return map(mSize.x, mGrabArea, width-30, 0, mTotalPlayTime);
  }
  
  void detect() {
    if (mouseX >= mPosition.x && mouseX <= mPosition.x+mSize.x && 
      mouseY >= mPosition.y && mouseY <= mPosition.y+mSize.y) {
        mHover = true;
        // left corner
        if (mouseX >= mPosition.x && mouseX <= mPosition.x+mGrabArea && 
        mouseY >= mPosition.y && mouseY <= mPosition.y+mSize.y) mGrab = 1;
        else if (mouseX >= (mPosition.x+mSize.x)-mGrabArea && mouseX <= mPosition.x+mSize.x && 
        mouseY >= mPosition.y && mouseY <= mPosition.y+mSize.y) mGrab = 2;
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
      if(mouseButton == RIGHT) mContext = !mContext;
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
      if(mGrab == 0) mPosition.x = constrain(mouseX-xOffset, mLayer.mTranslation.x, (mLayer.mSize.x-mSize.x));
      else if(mGrab > 0) {
        if(mGrab == 2) mSize.x = ((int)(mouseX-mPosition.x)>=mSize.y?(int)(mouseX-mPosition.x):mSize.x);
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