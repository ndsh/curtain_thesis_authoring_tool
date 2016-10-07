class Timeline {
  // https://processing.org/reference/ArrayList.html
  // need a debounce for (+) button
  
  ArrayList<Layer> layers = new ArrayList<Layer>();
  boolean mPlay = false;
  float mBarPosition = leftMargin;
  float mTotalPlayTime;
  int mPrevMillis = 0;
  boolean mHover = false;
  boolean mLocked = false;
  float xOffset = 0;
  int mTimeBarWidth = 5;
  int mTimeBarColor = 360;
  int mGrabArea = 20;

  Timeline(float _mTotalPlayTime) {
    this.mTotalPlayTime = _mTotalPlayTime;
    println("### (TIMELINE) created");
  }
  
  void add() {
    println("### (TIMELINE) adding new layer…");
    layers.add(new Layer());
    layers.add(new Layer());
    // layers.add(new Layer());
    // layers.add(new Layer());
    // layers.add(new Layer());
    // layers.add(new Layer());
    
  }
  
  void toggle() {
    mPlay = !mPlay;
  }
  
  void update() {
    if(mPlay) {
      if(mPrevMillis != millis()) {
        mBarPosition += 0.1;
        mPrevMillis = millis();
      }
    }
    detectLayers();
  }

  void detectLayers() {
    for (Layer layer : layers) {
      //layer.getPosition();
      //println(layer.getPosition());
      //println(mBarPosition);

      for (Segment segment : layer.getSegments()) {
        if (mBarPosition >= segment.getPosition().x && mBarPosition <= (segment.getPosition().x+segment.getWidth())) {
        // println("segment: "+ segment.getID());
        
        }
      }
      
    }
  }
  
  void draw() {
    for (Layer layer : layers) {
      layer.draw();
    }
    
    if(gLocked == null) detect();
    pushStyle();
    stroke(0,0,100);
    noFill();
    if(mHover) {
      fill(mTimeBarColor,0,70);
      if(mLocked) fill(mTimeBarColor,0,100);
    } else fill(mTimeBarColor,0,50);
    // rect(mBarPosition, mTimeBarWidth+headexr.getHeight(), mTimeBarWidth, height-(mTimeBarWidth*2));
    line(mBarPosition,mTimeBarWidth+header.getHeight(),mBarPosition,height-(mTimeBarWidth*2));
    popStyle();
    //line(mBarPosition, 10, mBarPosition, height-10);
    
    
  }
  
  void detect() {
    if (mouseX >= mBarPosition-(mGrabArea/2) && mouseX <= mBarPosition+(mGrabArea/2) && 
      mouseY >= mTimeBarWidth+header.getHeight() && mouseY <= height-(mTimeBarWidth+header.getHeight())) {
        mHover = true;
    } else {
      mHover = false;
    }
  }
 

  void mousePressed() {
    if(mHover && gLocked == null) { 
      mLocked = true;
      timeBarLock = true;
    } else {
      mLocked = false;
      timeBarLock = false;
    }
    xOffset = mouseX-mBarPosition; 
    
    for (Layer layer : layers) {
      layer.mousePressed();
    }
  }
  
  void mouseDragged() {
    if(mLocked) {
      mBarPosition = mouseX-xOffset;
    }
    
    for (Layer layer : layers) {
      layer.mouseDragged();
    }
  }
  
  void mouseReleased() {
    mLocked = false;
    timeBarLock = false;
    
    for (Layer layer : layers) {
      layer.mouseReleased();
    }
  }

  int countLayers() {
    return layers.size();
  }

  ArrayList<Layer> getLayers() {
    return layers;
  }

  void updateTranslation() {
   for (Layer layer : layers) {
      layer.updateTranslation();
    } 
  }


  void getExport() {
    for (Layer layer : layers) {

      // REMOVE ME!!!
      // if(layer.getID() == 1) {
        // println(layer.sortSegments());
        // println(layer.getNullSegments());
        println(layer.sortSegments(layer.mergeLists(layer.getSegmentsWithID(), layer.getNullSegments())));
      // }
      
    }
  }
  
 }