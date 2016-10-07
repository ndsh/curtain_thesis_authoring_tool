class Segment {
  
  //position
  int mID = 0;
  float mGrabArea;
  
  Layer mLayer;
  
  int mMargin = 3;
  String mLabel;
  String mUniqueID;

  //values we need to save into a file
  float mTargetDirection = 0;
  PVector mPosition;
  PVector mSize;

  //volatiles
  boolean mContext = false;
  boolean mHover = false;
  boolean mLocked = false;
  int mGrab = -1; // mGrab = 0
  float xOffset = 0.0;
  float yOffset = 0.0;


  //cp5
  CallbackListener cb;
  Knob mKnobDistance;

  // display where the current cm is right now at any given point of time
  
  Segment(Layer _mLayer)  {
    mLayer = _mLayer;
    mPosition = new PVector(random(mLayer.mTranslation.x, mLayer.mSize.x), mLayer.mTranslation.y+mMargin);
    mSize = new PVector((int)random(50,200), mLayer.mSize.y-7);
    mGrabArea = 32;
    
    println("### (SEGMENT) created");
    mID = mLayer.mSegmentCounter;
    mUniqueID = mLayer.getID()+"_"+mID;
    mLayer.mSegmentCounter++;
    mLabel = "";

    cb = new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (theEvent.getController().getName().equals("sliderTime"+mUniqueID)) {
            mTargetDirection = (int)theEvent.getController().getValue();
          }
        }
    };
    cp5.addSlider("sliderTime"+mUniqueID)
    .setCaptionLabel("cm")
    .setPosition(mPosition.x,mPosition.y)
    .setSize(120,16)
    .setRange(-2000,2000)
    .setNumberOfTickMarks(800)
    .setValue(0)
    .setColorForeground(farbe.light())
    .setColorBackground(farbe.white())
    .setColorActive(farbe.light())
    .setColorCaptionLabel(farbe.normal())
    .setColorValueLabel(farbe.normal())
    .showTickMarks(false)
    .addCallback(cb)
    ;

  }
  
  void draw() {
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
    
    noStroke();
    rect(mPosition.x, mPosition.y, mSize.x, mSize.y);

    // grab area
    
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
    pushMatrix();
    pushStyle();
    translate(mPosition.x+10, mPosition.y+(mSize.y/2)+5);

    // needs refinement
    // stroke(farbe.white());
    //line(0,0,10,(map(abs(getSteps()), 0, 150000, 0, 200))*-1);
    // String tSpeed = "";
    // if(getSteps() == 0) tSpeed = "stationary";
    // else if(getSteps() > 0 && getSteps() <= 50) tSpeed = "slow";
    // else if(getSteps() > 50 && getSteps() <= 150) tSpeed = "medium";
    // else if(getSteps() > 150) tSpeed = "fast";
    // fill(farbe.normal());
    // text(tSpeed, 0,10);
    
    //mHover = false;
    
    fill(farbe.normal());
    if(mSize.x > 110) mLabel = readableTime(getTime()) + " | "+ (int)mTargetDirection +"cm";
    else if(mSize.x <= 110 && mSize.x > 60) mLabel = readableTime(getTime());
    else mLabel = "";
    text(mLabel, 0,0);
    
    popStyle();
    popMatrix();

    contextMenu(mContext);
  }

  void contextMenu(boolean b) {
    if(b) {
      cp5.getController("sliderTime"+mUniqueID).setVisible(true);
      cp5.getController("sliderTime"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+4);
      pushMatrix();
      translate(mPosition.x, mPosition.y+mSize.y);
      pushStyle();
      fill(farbe.white());
      rect(0,0, constrain(mSize.x, 100, mSize.x), 23);
      stroke(farbe.normal());
      line(-1,-1,constrain(mSize.x, 100, mSize.x), -1);
      popStyle();
      popMatrix();
    } else {
      cp5.getController("sliderTime"+mUniqueID).setVisible(false);
    }
  }

  void updateTranslation() {
    mPosition.y = mLayer.mTranslation.y+mMargin;
    // cp5.getController("sliderTime"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+4);
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

  String readableTime(float t) {
    return t<=60?(int)t+"s":(int)t/60+":"+(int)t%60+"min";
  }
  
  void detect() {
    if (mouseX >= mPosition.x && mouseX <= mPosition.x+mSize.x && 
      mouseY >= mPosition.y && mouseY <= mPosition.y+mSize.y) {
        mHover = true;
        // left corner
        // if (mouseX >= mPosition.x && mouseX <= mPosition.x+mGrabArea && 
        // mouseY >= mPosition.y && mouseY <= mPosition.y+mSize.y) mGrab = 1; // grab area
        // else 
          if (mouseX >= (mPosition.x+mSize.x)-mGrabArea && mouseX <= mPosition.x+mSize.x && 
        mouseY >= mPosition.y && mouseY <= mPosition.y+mSize.y) mGrab = 2; // normal area
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
      print("### (SEGMENT) ");
      print("clicked on segment #"+ mID +" with position: "+ mPosition);
      println(" - playtime: "+ getTime());
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

  int getSteps() {
    return (int)(mTargetDirection/(mStepResolution*getTime()));
  }
  


}