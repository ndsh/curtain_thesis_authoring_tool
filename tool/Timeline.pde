class Timeline {
  // https://processing.org/reference/ArrayList.html
  // need a debounce for (+) button
  
  ArrayList<Layer> layers = new ArrayList<Layer>();
  boolean mPlay = false;
  float mBarPosition = leftMargin;
  int mPrevMillis = 0;
  boolean mHover = false;
  boolean mLocked = false;
  float xOffset = 0;
  int mTimeBarWidth = 5;
  int mTimeBarColor = 360;
  int mGrabArea = 20;
  boolean mQueued = false;

  Timeline() {
    // this.mTotalPlayTime = _mTotalPlayTime;
    println("### (TIMELINE) created");
  }
  
  void add() {
    println("### (TIMELINE) adding new layer...");
    layers.add(new Layer());
    mQueued = false;
  }

  void add(int tID) {
    println("### (TIMELINE) adding new layer...");
    layers.add(new Layer(tID));
    mQueued = false;
  }

  void addQueue() {
    mQueued = true;
  }

  boolean getQueued() {
    return mQueued;
  }

  void remove() { //overload this constructor. now it should just remove the last element
    // println(layers.size());
    // for (int i = layers.size() - 1; i >= layers.size() - 2; i--) {
      // Layer layer = layers.get(layers.size() - 1);
      if(layers.size() > 0) {
        layers.get(layers.size() - 1).removeSegments();
        layers.remove(layers.size() - 1);
      }
      // println(i);
    // }
  }
  
  void toggle() {
    mPlay = !mPlay;
  }
  
  void update() {
    for (Layer layer : layers) {
      layer.update();
    }
    // not good yet
    if(mPlay) {
      if(millis()-mPrevMillis >= 1000) {
        int tStep = (int)(maxWidth/mTotalPlayTime);
        mBarPosition += tStep;
        mPrevMillis = millis();
      }
    }
    detectLayers();
  }

  void queues() {
    for(Layer layer : layers) {
      if(layer.getQueued()) layer.add();
      if(layer.getQueuedSegments()) layer.removeSegment(layer.getQueuedSegmentsID());
    }
  }

  ArrayList<PVector> detectLayers() {
    ArrayList<PVector> tReturn = new ArrayList<PVector>();
    for (Layer layer : layers) {
      for (Segment segment : layer.getSegments()) {
        if (mBarPosition >= segment.getPosition().x && mBarPosition <= (segment.getPosition().x+segment.getWidth())) {        
          //println("a");
          //for detecting layers.. go here.
          tReturn.add(new PVector(layer.getID(), segment.getID()));
        }
      }
      
    }
    return tReturn;
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
    float tBarPosition = constrain(mBarPosition, leftMargin, maxWidth);
    line(tBarPosition, mTimeBarWidth+header.getHeight(), tBarPosition, height-(mTimeBarWidth*2));
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

  float getBarPosition() {
    return mBarPosition;
  }

  
  String displayBarPosition() {
    //return ""+mTotalPlayTime;
    int seconds = ((int)map(timeline.getBarPosition(), 0, maxWidth, 0, mTotalPlayTime))%60;
    String tSeconds = "";
    if(seconds < 10) tSeconds = "0"+seconds;
    else tSeconds = ""+seconds;
    return ((int)map(timeline.getBarPosition(), 0, maxWidth, 0, mTotalPlayTime))/60+":"+ tSeconds;
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
      int tStep = (int)(maxWidth/mTotalPlayTime);
      mBarPosition = (mouseX-xOffset);
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

  Layer getLayer(int tID) {
    int i = 0;
    Layer mReturn = null;
    for (Layer layer : layers) {
      if(layers.get(i).getID() == tID) {
        mReturn = layers.get(i);
        break;
      }
      i++;
    }
    return mReturn;
  }

  void updateTranslation() {
   for (Layer layer : layers) {
      layer.updateTranslation();
    } 
  }


  ArrayList<ArrayList> getExport() {
    ArrayList<ArrayList> tReturn = new ArrayList<ArrayList>();
    for (Layer layer : layers) {

      // REMOVE ME!!!
      // if(layer.getID() == 1) {
        if(layer.getID() == 1) {
          // println("max:" + maxWidth);
          // println("sorteds: "+layer.sortSegments());
          // println("nulls: "+ layer.getNullSegments());
        
        // println(tReturn);
       } 
        tReturn.add(layer.sortSegments(layer.mergeLists(layer.getSegmentsWithID(), layer.getNullSegments())));          
      // }
      
    }
    return tReturn;
  }
  
 }