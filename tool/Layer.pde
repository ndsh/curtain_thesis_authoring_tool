class Layer {
  ArrayList<Segment> segments;
  
  boolean mHover;
  boolean mLocked;
  PVector mOffset;
  PVector mSize;
  PVector mTranslation;
  int mSegmentCounter;
  String[] mLayerMode = {"Stepper", "Servo"};
  String[] mNumber;
  
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
    mTranslation = new PVector(leftMargin, (header.getHeight()+mSize.y/2+((mID))*mSize.y)+(mSize.y/1.2*mID));
    mLayerControls = mTranslation.y+mSize.y+3;

    int tPins = 54;
    mNumber = new String[tPins];
    for(int i = 0; i<tPins; i++) mNumber[i] = i+""; 

    String[] mLayersNumber = new String[6];
    for(int i = 0; i<6; i++) mLayersNumber[i] = (i+1)+""; 

    println("### (LAYER) ("+mID+") created");

    float r = random(0,5);
    for(float i = 0; i<r; i+=1.) add();

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
  }
  
  void add() {
    println("### (LAYER) adding new segment...");
    segments.add(new Segment(this));
    
  }
  
  void draw() {
    pushStyle();
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100);
    rect(mTranslation.x, mTranslation.y, mSize.x, mSize.y);
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

  void updateTranslation() {
    mSize.x = maxWidth;
    // println(mSize.x);
    mTranslation = new PVector(leftMargin, (header.getHeight()+mSize.y/2+((mID))*mSize.y)+(mSize.y/1.2*mID));
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