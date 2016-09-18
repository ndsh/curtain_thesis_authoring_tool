class Timeline {
  // https://processing.org/reference/ArrayList.html
  // need a debounce for (+) button
  
  ArrayList<Segment> segments = new ArrayList<Segment>();
  boolean mPlay = false;
  float mTotalPlayTime;
  
  Timeline(float _mTotalPlayTime) {
    this.mTotalPlayTime = _mTotalPlayTime;
    println("### (TIMELINE) created");
  }
  
  void add() {
    println("### (TIMELINE) adding new segment…");
    segments.add(new Segment());
    
  }
  
  void draw() {
    detection();
    
    pushStyle();
    stroke(255);
    fill(0);
    //text("0", 35, (height/2)+15);
    ellipse(35, height/2, 10, 10);
    line(40, height/2, width-40, height/2);
    //text(mTotalPlayTime, width-35, (height/2)+15);
    ellipse(width-35, height/2, 10, 10);
    popStyle();
    
    for (Segment segment : segments) {
      segment.draw();
    }
  }
  
  void detection() {
    // collision detect, so we can grab onto the segments
    for (Segment segment : segments) {
      PVector tPosition = segment.getPosition();
      float tWidth = segment.getWidth();
      if((mouseX < (tPosition.x+tWidth) && mouseX >= tPosition.x) &&
         (mouseY < (tPosition.y+20) && mouseY >= tPosition.y)) {
          if (mousePressed == true) {
            segment.hover();
            segment.setPosition(new PVector(mouseX, tPosition.y)); // weird
            //segment.setPosition(new PVector(abs(tPosition.x-mouseX), abs(tPosition.y-mouseY)));
          }
      }
    }
  }
}