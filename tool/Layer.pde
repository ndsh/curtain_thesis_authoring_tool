class Layer {
  ArrayList<Segment> segments;
  
  boolean mHover;
  boolean mLocked;
  PVector mOffset;
  PVector mSize;
  PVector mTranslation;
  int mSegmentCounter;
  String[] mLayerMode = {"Curtain: Up+Down", "Curtain: Left+Right", "Servo"};
  String[] mNumber;
  boolean mQueued = false;
  boolean mSegmentQueue = false;
  int mRemovableSegment = -1;
  int mMargin = 3;
  
  float mLayerControls;

  // values we need to save into a file
  int mID;

  //cp5
  CallbackListener cb;
  Textlabel mLabelNumber;
  Textlabel mLabelStep;
  Textlabel mLabelDir;
  Textlabel mLabelEnable;
  int mMotorMode;
  int mMotorNumber;
  int mPinStep;
  int mPinDir;
  int mPinEnable;

  Layer() {
    this(mLayerCounter);
  }
  Layer(int _mID) {
    segments = new ArrayList<Segment>();
    mOffset = new PVector(0,0);
    mSegmentCounter = 0;
    mHover = false;
    mLocked = false;
    mSize = new PVector(maxWidth, 39);
    mID = _mID;
    mLayerCounter++;
    mTranslation = new PVector(leftMargin, (header.getHeight()+mSize.y/2+((getPosition()))*mSize.y)+(mSize.y/1.2*getPosition()));
    mLayerControls = mTranslation.y+mSize.y+3;

    int tPins = 54;
    mNumber = new String[tPins];
    for(int i = 0; i<tPins; i++) mNumber[i] = i+""; 

    String[] mLayersNumber = new String[6];
    for(int i = 0; i<6; i++) mLayersNumber[i] = (i+1)+""; 

    println("### (LAYER) ("+mID+") created");

    // float r = random(0,5);
    // for(float i = 0; i<r; i+=1.) add();

    cb = new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getController().getName().equals("layerMode"+mID)) {
          mMotorMode = (int)theEvent.getController().getValue();
        } else if (theEvent.getController().getName().equals("layerNumber"+mID)) {
          mMotorNumber = (int)theEvent.getController().getValue();
        } else if (theEvent.getController().getName().equals("layerStepDD"+mID)) {
          mPinStep = (int)theEvent.getController().getValue();
        } else if (theEvent.getController().getName().equals("layerDirDD"+mID)) {
          mPinDir = (int)theEvent.getController().getValue();
        } else if (theEvent.getController().getName().equals("layerEnableDD"+mID)) {
          mPinEnable = (int)theEvent.getController().getValue();
        } else if (theEvent.getController().getName().equals("addSegment"+mID)) {
          if(theEvent.getController().isMousePressed()) addQueue();
        } else if (theEvent.getController().getName().equals("removeSegment"+mID)) {
          // if(theEvent.getController().isMousePressed()) remove(); // das muss noch ausgebufft werdne. aktives element löschen?
        }
        // println(mMotorMode + " /" + mMotorNumber + " /" + mPinStep + " /" + mPinDir + " /" + mPinEnable);
      }
    };

    cp5.addScrollableList("layerMode"+mID)
      .setPosition(mTranslation.x-1, mLayerControls)
      .setSize(200, 100)
      .setBarHeight(20)
      .setItemHeight(20)
      .addItems(mLayerMode)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
      .addCallback(cb)
      .setCaptionLabel("MOTOR")
      .setOpen(false)
      .setColorForeground(farbe.white())
      .setColorBackground(farbe.light())
      .setColorActive(farbe.light())
      .setColorCaptionLabel(farbe.normal())
      .setColorValueLabel(farbe.normal())
      ;
    mLabelNumber = cp5.addTextlabel("labelNumber"+mID)
      .setText("#")
      .setPosition(mTranslation.x+200, mLayerControls+4)
      .setColorValue(farbe.white())
      ;
    cp5.addScrollableList("layerNumber"+mID)
      .setPosition((mTranslation.x)+215, mLayerControls)
      .setSize(30, 70)
      .setBarHeight(20)
      .setItemHeight(20)
      .addItems(mLayersNumber)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
      .addCallback(cb)
      .setCaptionLabel("-")
      .setOpen(false)
      .setColorForeground(farbe.white())
      .setColorBackground(farbe.light())
      .setColorActive(farbe.light())
      .setColorCaptionLabel(farbe.normal())
      .setColorValueLabel(farbe.normal())
      ;
    mLabelStep = cp5.addTextlabel("labelStep"+mID)
      .setText("STEP")
      .setPosition(mTranslation.x+265, mLayerControls+4)
      .setColorValue(farbe.white())
      ;
    cp5.addScrollableList("layerStepDD"+mID)
      .setPosition((mTranslation.x)+300, mLayerControls)
      .setSize(30, 70)
      .setBarHeight(20)
      .setItemHeight(20)
      .addItems(mNumber)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
      .addCallback(cb)
      .setCaptionLabel("-")
      .setOpen(false)
      .setColorForeground(farbe.white())
      .setColorBackground(farbe.light())
      .setColorActive(farbe.light())
      .setColorCaptionLabel(farbe.normal())
      .setColorValueLabel(farbe.normal())
      ;
    mLabelDir = cp5.addTextlabel("labelDir"+mID)
      .setText("DIR")
      .setPosition(mTranslation.x+340, mLayerControls+4)
      .setColorValue(farbe.white())
      ;
    cp5.addScrollableList("layerDirDD"+mID)
      .setPosition((mTranslation.x)+365, mLayerControls)
      .setSize(30, 70)
      .setBarHeight(20)
      .setItemHeight(20)
      .addItems(mNumber)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
      .addCallback(cb)
      .setCaptionLabel("-")
      .setOpen(false)
      .setColorForeground(farbe.white())
      .setColorBackground(farbe.light())
      .setColorActive(farbe.light())
      .setColorCaptionLabel(farbe.normal())
      .setColorValueLabel(farbe.normal())
      ;
    mLabelEnable = cp5.addTextlabel("labelEnable"+mID)
      .setText("ENABLE")
      .setPosition(mTranslation.x+400, mLayerControls+4)
      .setColorValue(farbe.white())
      ;
    cp5.addScrollableList("layerEnableDD"+mID)
      .setPosition((mTranslation.x)+445, mLayerControls)
      .setSize(30, 70)
      .setBarHeight(20)
      .setItemHeight(20)
      .addItems(mNumber)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
      .addCallback(cb)
      .setCaptionLabel("-")
      .setOpen(false)
      .setColorForeground(farbe.white())
      .setColorBackground(farbe.light())
      .setColorActive(farbe.light())
      .setColorCaptionLabel(farbe.normal())
      .setColorValueLabel(farbe.normal())
      ;
    mLabelEnable = cp5.addTextlabel("labelSegments"+mID)
      .setText("SEGMENTS")
      .setPosition(mTranslation.x+500, mLayerControls+4)
      .setColorValue(farbe.white())
      ;
    cp5.addButton("addSegment"+mID)
      .setPosition((mTranslation.x)+560, mLayerControls)
      .setSize(20,20)
      .setCaptionLabel("+")
      .addCallback(cb)
      .setColorForeground(farbe.white())
      .setColorBackground(farbe.light())
      .setColorActive(farbe.light())
      .setColorCaptionLabel(farbe.normal())
      .setColorValueLabel(farbe.normal())
      ;
  }
  
  void add() {
    println("### (LAYER) adding new segment...");
    segments.add(new Segment(this));
    mQueued = false;
  }

  void add(float tDirection, PVector tPosition, PVector tSize) {
    println("### (LAYER) adding new segment...");
    segments.add(new Segment(this, tDirection, tPosition, tSize));
    mQueued = false;
  }

  void addQueue() {
    mQueued = true;
  }

  boolean getQueued() {
    return mQueued;
  }

  void removeSegment(int tID) {
    int i = 0;
    int qID = -1;
    for (Segment segment : segments) {
      if(segments.get(i).getID() == tID) {
        // segments.remove(i);
        qID = segments.get(i).getID();
        break;
      }
      i++;
    }
    if(qID != -1 && qID == tID) {
      segments.get(i).removeItems();
      segments.remove(i);
      mSegmentQueue = false;
      mRemovableSegment = -1;
    }
  }
  void removeQueue(int tID) {
    mSegmentQueue = true;
    mRemovableSegment = tID;
  }

  boolean getQueuedSegments() {
    return mSegmentQueue;
  }

  int getQueuedSegmentsID() {
    return mRemovableSegment;
  }

  void removeSegments() {
    cp5.getController("layerEnableDD"+mID).remove();
    cp5.getController("labelEnable"+mID).remove();
    cp5.getController("layerDirDD"+mID).remove();
    cp5.getController("labelDir"+mID).remove();
    cp5.getController("layerStepDD"+mID).remove();
    cp5.getController("labelStep"+mID).remove();
    cp5.getController("layerNumber"+mID).remove();
    cp5.getController("labelNumber"+mID).remove();
    cp5.getController("layerMode"+mID).remove();
    cp5.getController("labelSegments"+mID).remove();
    cp5.getController("addSegment"+mID).remove();
    for (int i = segments.size() - 1; i >= 0; i--) {
        // segments.get(i).removeYourself();

        segments.remove(i);
    }
  }

  int getPosition() {
    int c = 0;
    for (Layer layer : timeline.getLayers()) {
      if(layer.getID() == mID) {
        break;
      }
      c++;
    }
    return c;
  }

  int getMotorMode() {
    return mMotorMode;
  }

  int getMotorNumber() {
    return mMotorNumber;
  }

  int getPinStep() {
    return mPinStep;
  }

  int getPinDir() {
    return mPinDir;
  }

  int getPinEnable() {
    return mPinEnable;
  }

  void update(){
    for (Segment segment : segments) {
      segment.update();
    }
  } 
  
  void draw() {
    if(!simulationMode) {
      cp5.getController("layerEnableDD"+mID).show();
      cp5.getController("labelEnable"+mID).show();
      cp5.getController("layerDirDD"+mID).show();
      cp5.getController("labelDir"+mID).show();
      cp5.getController("layerStepDD"+mID).show();
      cp5.getController("labelStep"+mID).show();
      cp5.getController("layerNumber"+mID).show();
      cp5.getController("labelNumber"+mID).show();
      cp5.getController("layerMode"+mID).show();
      cp5.getController("layerEnableDD"+mID).show();
      cp5.getController("labelSegments"+mID).show();
      cp5.getController("addSegment"+mID).show();

      pushMatrix();
      pushStyle();
      translate(mTranslation.x, mTranslation.y);
      noFill();
      strokeWeight(2);
      stroke(0, 0, 100);
      rect(0, 0, mSize.x, mSize.y);
      popStyle();
      popMatrix();    
      for (Segment segment : segments) {
        segment.draw();
      }
    } else {
      cp5.getController("layerEnableDD"+mID).hide();
      cp5.getController("labelEnable"+mID).hide();
      cp5.getController("layerDirDD"+mID).hide();
      cp5.getController("labelDir"+mID).hide();
      cp5.getController("layerStepDD"+mID).hide();
      cp5.getController("labelStep"+mID).hide();
      cp5.getController("layerNumber"+mID).hide();
      cp5.getController("labelNumber"+mID).hide();
      cp5.getController("layerMode"+mID).hide();
      cp5.getController("layerEnableDD"+mID).hide();
      cp5.getController("labelSegments"+mID).hide();
      cp5.getController("addSegment"+mID).hide();
    }
  }

  void updateTranslation() {
    mSize.x = maxWidth;
    // println(mSize.x);
    mTranslation = new PVector(leftMargin, (header.getHeight()+mSize.y/2+((getPosition()))*mSize.y)+(mSize.y/1.2*getPosition()));
    mLayerControls = mTranslation.y+mSize.y+3; // does not work. have to update all controls one by one
    // cp5.getController("sliderTime"+mUniqueID).setPosition(mPosition.x+3,mPosition.y+mSize.y+4);
    cp5.getController("layerEnableDD"+mID).setPosition((mTranslation.x)+445, mLayerControls);
    cp5.getController("labelEnable"+mID).setPosition(mTranslation.x+400, mLayerControls+4);
    cp5.getController("layerDirDD"+mID).setPosition((mTranslation.x)+365, mLayerControls);
    cp5.getController("labelDir"+mID).setPosition(mTranslation.x+340, mLayerControls+4);
    cp5.getController("layerStepDD"+mID).setPosition((mTranslation.x)+300, mLayerControls);
    cp5.getController("labelStep"+mID).setPosition(mTranslation.x+265, mLayerControls+4);
    cp5.getController("layerNumber"+mID).setPosition((mTranslation.x)+215, mLayerControls);
    cp5.getController("labelNumber"+mID).setPosition(mTranslation.x+200, mLayerControls+4);
    cp5.getController("layerMode"+mID).setPosition(mTranslation.x-1, mLayerControls);    
    cp5.getController("layerEnableDD"+mID).setPosition((mTranslation.x)+445, mLayerControls);
    cp5.getController("labelSegments"+mID).setPosition(mTranslation.x+500, mLayerControls+4);
    cp5.getController("addSegment"+mID).setPosition((mTranslation.x)+560, mLayerControls);
    for (Segment segment : segments) {
      segment.updateTranslation();
    } 
  }

  ArrayList<Segment> getSegments() {
    return segments;
  }

  int countSegments() {
    return segments.size();
  }

  ArrayList<PVector> getPVectors() {
    ArrayList<PVector> dots = new ArrayList<PVector>();
    for (Segment segment : segments) {
      PVector v = segment.getPosition();
      dots.add(v);
    }
    return dots;
  }

  ArrayList<PVector> sortSegments() {
    ArrayList<PVector> positions = getPVectors();
    Collections.sort(positions, new DistanceComparator(new PVector(0,0)));
    return positions;
  }

  ArrayList<PVector> sortSegments(ArrayList<PVector> vektoren) {
    Collections.sort(vektoren, new DistanceComparator(new PVector(0,0)));
    return vektoren;
  }

  ArrayList<PVector> getSegmentsWithID() {
    ArrayList<PVector> withID = new ArrayList<PVector>();
    ArrayList<PVector> tSegments = sortSegments();
    for (PVector sortedSegment : tSegments) {
      for (Segment segment : segments) {
        if(segment.getPosition() == sortedSegment) {
          PVector v = new PVector(segment.getPosition().x, segment.getPosition().y, segment.getID());
          withID.add(v);
          break;
        }
      }
    }
    return withID;
  }

  ArrayList<PVector> getNullSegments() {
    ArrayList<PVector> withID = getSegmentsWithID();
    // walk through our new vectors
    // look up the width
    // and try to calculate the white spaces
    // add those white spaces into a new ArrayList
    ArrayList<PVector> nullSegments = new ArrayList<PVector>();
    float leftBorder = leftMargin;
    // always look to the left, except the last element
    // there we should also look to the right

    // something is still wrong with the margins. gotta check that.
    int counter = 0;
    for (PVector sortedSegment : withID) {

      // println(sortedSegment.x-leftBorder);
      // there is something left from us
      if(sortedSegment.x-leftBorder > 0) {
        PVector v = new PVector(leftBorder, (sortedSegment.x-leftBorder), -1);
        nullSegments.add(v);
        leftBorder = (segments.get((int)sortedSegment.z).getWidth())+sortedSegment.x;
      }
      counter++;
      // when we encounter our last element
      if(counter == withID.size() && maxWidth-leftBorder > 0) {
          PVector v = new PVector(leftBorder, (maxWidth-leftBorder)+leftMargin, -1);
          nullSegments.add(v);
      }
    }
    return nullSegments;
  }

  ArrayList<PVector> mergeLists(ArrayList<PVector> a, ArrayList<PVector> b) {
    for (PVector element : a) {
      b.add(element);
    }
    return b;
  }
  

  int getID() {
    return mID;
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