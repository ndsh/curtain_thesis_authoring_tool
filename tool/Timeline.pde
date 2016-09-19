class Timeline {
  // https://processing.org/reference/ArrayList.html
  // need a debounce for (+) button
  
  ArrayList<Layer> layers = new ArrayList<Layer>();
  boolean mPlay = false;
  float mTotalPlayTime;
  
  Timeline(float _mTotalPlayTime) {
    this.mTotalPlayTime = _mTotalPlayTime;
    println("### (TIMELINE) created");
  }
  
  void add() {
    println("### (TIMELINE) adding new layer…");
    layers.add(new Layer());
    
  }
  
  void draw() {
    //detection();
    /*
    pushStyle();
    stroke(255);
    fill(0);
    //text("0", 35, (height/2)+15);
    ellipse(35, height/2, 10, 10);
    line(40, height/2, width-40, height/2);
    //text(mTotalPlayTime, width-35, (height/2)+15);
    ellipse(width-35, height/2, 10, 10);
    popStyle();
    */
    
    for (Layer layer : layers) {
      layer.draw();
    }
  }
  
  void detection() {
    // collision detect, so we can grab onto the segments
    for (Layer layer : layers) {
      PVector tPosition = layer.getPosition();
      float tWidth = layer.getWidth();
      if((mouseX < (tPosition.x+tWidth) && mouseX >= tPosition.x) &&
         (mouseY < (tPosition.y+20) && mouseY >= tPosition.y)) {
          if (mousePressed == true) {
            layer.hover();
            layer.setPosition(new PVector(mouseX, tPosition.y)); // weird
            //segment.setPosition(new PVector(abs(tPosition.x-mouseX), abs(tPosition.y-mouseY)));
          }
      }
    }
  }
 

  void mousePressed() {
    for (Layer layer : layers) {
      layer.mousePressed();
    }
  }
  
  void mouseDragged() {
    for (Layer layer : layers) {
      layer.mouseDragged();
    }
  }
  
  void mouseReleased() {
    for (Layer layer : layers) {
      layer.mouseReleased();
    }
  }
  
 }