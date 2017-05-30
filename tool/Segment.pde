class Segment {
  
  //position
  int mID = 0;
  
  
  Layer mLayer;
  
  String mLabel;
  String mUniqueID;

  //values we need to save into a file
  float mTargetDirection;
  float mRuntime;
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
  Segment(Layer tLayer) {
    this(tLayer, 0, new PVector(random(tLayer.mTranslation.x, tLayer.mSize.x), tLayer.mTranslation.y+tLayer.mMargin), new PVector(50, tLayer.mSize.y-7));
    
  }

  Segment(Layer tLayer, float tDirection, PVector tPosition, PVector tSize)  {

    mLayer = tLayer;
    mTargetDirection = tDirection;
    mPosition = tPosition;
    mSize = tSize;
    // mGrabArea = 32;
    
    println("### (SEGMENT) created on layer #"+ mLayer.getID());
    mID = mLayer.mSegmentCounter;
    mUniqueID = mLayer.getID()+"_"+mID;
    mLayer.mSegmentCounter++;
    mLabel = "";

    cb = new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (theEvent.getController().getName().equals("sliderTime"+mUniqueID)) {
            mTargetDirection = (int)theEvent.getController().getValue();
          } else if (theEvent.getController().getName().equals("removeSegment"+mUniqueID)) {
            if(theEvent.getController().isMousePressed()) removeYourself();
          } else if (theEvent.getController().getName().equals("targetInput"+mUniqueID)) {
            // mTargetDirection = parseInt(theEvent.getController().getStringValue());
            mTargetDirection = parseInt(cp5.get(Textfield.class,"targetInput"+mUniqueID).getText());
          } else if (theEvent.getController().getName().equals("durationInput"+mUniqueID)) {
            //mTargetDirection = parseInt(cp5.get(Textfield.class,"durationInput"+mUniqueID).getText());
            int tDuration = parseDuration(cp5.get(Textfield.class,"durationInput"+mUniqueID).getText());
            mSize.x = getDuration(tDuration);
          } else if (theEvent.getController().getName().equals("startingInput"+mUniqueID)) {
            //mTargetDirection = parseInt(cp5.get(Textfield.class,"durationInput"+mUniqueID).getText());
            int tDuration = parseDuration(cp5.get(Textfield.class,"startingInput"+mUniqueID).getText());
            // mSize.x = getDuration(tDuration);
            mPosition.x = getDuration(tDuration);
            // mPosition.x = readableTimeNoLabels(getTime(tDuration));
          }
        }
    };
    // cp5.addSlider("sliderTime"+mUniqueID)
    // .setCaptionLabel("cm")
    // .setPosition(mPosition.x,mPosition.y)
    // .setSize(120,16)
    // .setRange(-2000,2000)
    // .setNumberOfTickMarks(1600)
    // .setValue(0)
    // .setColorForeground(farbe.light())
    // .setColorBackground(farbe.white())
    // .setColorActive(farbe.light())
    // .setColorCaptionLabel(farbe.normal())
    // .setColorValueLabel(farbe.normal())
    // .showTickMarks(false)
    // .addCallback(cb)
    // .hide()
    // ;
    cp5.addButton("removeSegment"+mUniqueID)
    .setPosition(mPosition.x,mPosition.y)
    .setSize(16,16)
    .setCaptionLabel("x")
    .addCallback(cb)
    ;

    cp5.addTextfield("targetInput"+mUniqueID)
    .setPosition(mPosition.x,mPosition.y)
    .setAutoClear(false)
    .setValue(str(mTargetDirection))
    .setSize(120,16)
    .onChange(cb)
    .onLeave(cb)
    .onRelease(cb)
    .onReleaseOutside(cb)
    .setCaptionLabel("Target")
    .setColorForeground(farbe.white())
    .setColorBackground(farbe.light())
    .setColorActive(farbe.light())
    .setColorCaptionLabel(farbe.normal())
    .setColorValueLabel(farbe.normal())
    ;

    cp5.addTextfield("durationInput"+mUniqueID)
    .setPosition(mPosition.x,mPosition.y)
    .setAutoClear(false)
    .setValue(readableTimeNoLabels(getTime()))
    .setSize(120,16)
    .onChange(cb)
    .onLeave(cb)
    .onRelease(cb)
    .onReleaseOutside(cb)
    .setCaptionLabel("Duration")
    .setColorForeground(farbe.white())
    .setColorBackground(farbe.light())
    .setColorActive(farbe.light())
    .setColorCaptionLabel(farbe.normal())
    .setColorValueLabel(farbe.normal())
    ;

     cp5.addTextfield("startingInput"+mUniqueID)
    .setPosition(mPosition.x,mPosition.y)
    .setAutoClear(false)
    .setValue(readableTimeNoLabels(getTime(mPosition.x)))
    .setSize(120,16)
    .onChange(cb)
    .onLeave(cb)
    .onRelease(cb)
    .onReleaseOutside(cb)
    .setCaptionLabel("Starting")
    .setColorForeground(farbe.white())
    .setColorBackground(farbe.light())
    .setColorActive(farbe.light())
    .setColorCaptionLabel(farbe.normal())
    .setColorValueLabel(farbe.normal())
    ;
  }
  void update() {
    if(gLocked == null) detect();
  }

  void draw() {
    if(!simulationMode) {
      cp5.getController("targetInput"+mUniqueID).show();
      cp5.getController("removeSegment"+mUniqueID).show();
      cp5.getController("durationInput"+mUniqueID).show();
      cp5.getController("startingInput"+mUniqueID).show();

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
      if(mSize.x > 110) mLabel = readableTime(getTime()) + " | "+ (int)mTargetDirection +"mm";
      else if(mSize.x <= 110 && mSize.x > 60) mLabel = readableTime(getTime());
      else mLabel = "";
      text(mLabel, 0,0);
      
      popStyle();
      popMatrix();      
    } else {
      cp5.getController("targetInput"+mUniqueID).hide();
      cp5.getController("removeSegment"+mUniqueID).hide();
      cp5.getController("durationInput"+mUniqueID).hide();
      cp5.getController("startingInput"+mUniqueID).hide();
    }
    contextMenu(mContext);
  }

  void removeYourself() {
    mLayer.removeQueue(mID);
  }

  void removeItems() {
    cp5.getController("targetInput"+mUniqueID).remove();
    cp5.getController("removeSegment"+mUniqueID).remove();
    cp5.getController("durationInput"+mUniqueID).remove();
    cp5.getController("startingInput"+mUniqueID).remove();
  }

  void contextMenu(boolean b) {
    if(!simulationMode) {
      cp5.getController("targetInput"+mUniqueID).show();
      cp5.getController("removeSegment"+mUniqueID).show();
      cp5.getController("durationInput"+mUniqueID).show();
      cp5.getController("startingInput"+mUniqueID).show();
      if(b) {
        cp5.getController("removeSegment"+mUniqueID).setVisible(true);
        cp5.getController("targetInput"+mUniqueID).setVisible(true);
        cp5.getController("durationInput"+mUniqueID).setVisible(true);
        cp5.getController("startingInput"+mUniqueID).setVisible(true);
        cp5.getController("removeSegment"+mUniqueID).setPosition(mPosition.x+160-16, mPosition.y+mSize.y+2);
        cp5.getController("targetInput"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+4);
        cp5.getController("durationInput"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+64);
        cp5.getController("startingInput"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+34);
        pushMatrix();
        translate(mPosition.x, mPosition.y+mSize.y);
        pushStyle();
        fill(farbe.white());
        rect(0,0, 160, 110);
        stroke(farbe.normal());
        line(-1,-1,160, -1);
        popStyle();
        popMatrix();
      } else {
        cp5.getController("targetInput"+mUniqueID).setVisible(false);
        cp5.getController("removeSegment"+mUniqueID).setVisible(false);
        cp5.getController("durationInput"+mUniqueID).setVisible(false);
        cp5.getController("startingInput"+mUniqueID).setVisible(false);
      }
    } else {
      cp5.getController("targetInput"+mUniqueID).hide();
      cp5.getController("removeSegment"+mUniqueID).hide();
      cp5.getController("durationInput"+mUniqueID).hide(); 
      cp5.getController("startingInput"+mUniqueID).hide(); 
    }
  }

  void updateTranslation() {
    mPosition.y = mLayer.mTranslation.y+mLayer.mMargin;
    // cp5.getController("sliderTime"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+4);
  }

  PVector getPosition() {
    return mPosition;
  }

  PVector getSize() {
    return mSize;
  }

  float getRuntime() {
    return mRuntime;
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

  float getDirection() {
    return mTargetDirection;
  }

  float getTime() {
    return map(mSize.x, 0, maxWidth, 0, mTotalPlayTime);
    // println((int)map(6, 32, 1260, 0, 10*60)); hmmmmmm++++++++++++++ grabArea = 0?
  }

  float getTime(float f) {
    return map(mPosition.x, 0, maxWidth, 0, mTotalPlayTime);
  }

  int parseDuration(String s) {
    int tReturn = 0;
    String[] splitter = split(s, ':');
    try {
      if(splitter[1].length() > 0) {
        tReturn = (parseInt(splitter[0])*60) + parseInt(splitter[1]);
      }
    }
    catch(Exception e) {
      tReturn = parseInt(splitter[0])*60;
    }
    // returns input in seconds
    // return splitter;
    return tReturn;
  }
  float getDuration(int tDuration) {
    return map(tDuration, 0, mTotalPlayTime, 0, maxWidth);
    // println((int)map(6, 32, 1260, 0, 10*60)); hmmmmmm++++++++++++++ grabArea = 0?
  }

  float getTime(int factor) {
    return map(mSize.x, 0, maxWidth, 0, mTotalPlayTime*factor);
  }

  String readableTime(float t) {
    return t<=60?(int)t+"s":(int)t/60+":"+(int)t%60+"min";
  }

  String readableTimeNoLabels(float t) {
    return t<=60?"0:"+(int)t:(int)t/60+":"+(int)t%60;
  }

  int getSteps() {
    int calc = (int)(abs(mTargetDirection)/(mStepResolution*getTime()));
    calc = constrain(calc, 0, 1000);
    return mTargetDirection>=0?calc:calc*-1;
  }

  int getSteps(int factor) {
    int calc = (int)(abs(mTargetDirection*factor)/(mStepResolution*getTime()));
    return mTargetDirection>=0?calc:calc*-1;
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
        }
      }
    }
  }
  
  void mouseReleased() {
    mLocked = false;
    if(gLocked == this) gLocked = null;
  }
}