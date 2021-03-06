/*
 *  AUTHORING TOOL
 *   IRENA KUKRIC
 *   TIMELINE PLANER + VISUALIZATION
 */

/*
  Timeline
    /--> Segment
       /--> Motion
          /--> Motor
 */

/*
  todo:
 Timeline Class: holds seperate segments
 Segment Class: holds information about time, motor number, position in timeline, etc.pp
 Motion Class: is inside of a segment and just describes that motor's velocity and direction
 Motor Class: holds meta information about if it's a up/down pulley or a symmetrical left/right pulley; name
 UserInterface Class: show/hide the ui. simple stuff.
 */

import controlP5.*;
import java.util.Collections;

ControlP5 cp5;
DropdownList d1, d2, d3;
Textlabel label1, label2;

float mTotalPlayTime = 10*60; // in second
float mStepResolution = 0.014; // 10 seconds = 14 cm
Timeline timeline;
UserInterface ui;

float mGrabArea = 32;

PFont mFont;

// int mSegmentCounter = 0;
int mLayerCounter = 0;

Segment gLocked = null;
boolean timeBarLock = false;

boolean mouseDebug = false;

ArrayList<Motor> motors = new ArrayList<Motor>();

Header header;
Farbe farbe;

int maxWidth;
int previousWidth;
int leftMargin;
int rightMargin;

String mArduinoPath = "";

boolean simulationMode = false;

String os;

void setup() {
  size(displayWidth, 600);
  surface.setResizable(true);
  mFont = loadFont("Inconsolata-Regular-13-smooth.vlw");
  textFont(mFont, 13);
  os = System.getProperty("os.name");

  leftMargin = 10; // the margin to the left side
  rightMargin = leftMargin*2;
  maxWidth = width-rightMargin;
  colorMode(HSB, 360, 100, 100);
  
  noSmooth();
  println("### (AUTHORING_TOOL) welcome!");
  println("### (AUTHORING_TOOL) running the UserInterface with the help of ControlP5:");
  
  cp5 = new ControlP5(this);  
  cp5.getProperties().setFormat(ControlP5.SERIALIZED);
  println();

  farbe = new Farbe();
  ui = new UserInterface();
  header = new Header();
  
  previousWidth = width;

  background(farbe.normal());

  // add some things
  timeline = new Timeline();
  header.loadTimeline();
  header.loadSettings();
  // motors.add(new Motor("Motor S", 1, true));
  // timeline.add();

  String tLines[] = loadStrings("settings.cfg");
  println("loaded path for export config in: "+ tLines[0]);
  if(tLines.length > 0) {
    if(tLines[0].length() > 0) {
      if(os.equals("Mac OS X")) {
        // println("os x");
        // println(pathSplit(tLines[0], "/"));
        mArduinoPath = "/"+pathSplit(tLines[0], "/");
      } else {
        // println("different os");
        // println(pathSplit(tLines[0], "\\"));
        mArduinoPath = pathSplit(tLines[0], "\\");
      }
    }
  }

  // timeline.getExport();
}

void draw() {
  if(width != previousWidth) {
    maxWidth = width-rightMargin;
    timeline.updateTranslation();
    header.updateTranslation();
    previousWidth = width;
  }
  background(farbe.normal());
  
  timeline.update();
  timeline.draw();
  header.draw();
  
  if(mouseDebug) {
    pushStyle();
    stroke(255);
    line(mouseX, mouseY, mouseX+33, mouseY+33);
    line(mouseX+33, mouseY+33, mouseX+45, mouseY+33);
    text(mouseX + "|" + mouseY, mouseX+50, mouseY+38);
    popStyle();
  }  

  if(timeline.getQueued()) timeline.add();
  timeline.queues();

  if(simulationMode) {

    pushMatrix();
    pushStyle();

    fill(farbe.light());
    rect(0,0,width,height);


    stroke(farbe.white());
    translate(width/12*0, height/2);
    translate(100, -150);
    line(0,0,200,100);
    line(0,0,0,20); // links
    line(200,100,200,120); // rechts
    line(0,20,200,120);
    println(timeline.detectLayers());

    // get active segment and active layer
    // determine segment width and x position (map this)
    // get values from segments before
    popStyle();
    popMatrix();
  }
  
}

String pathSplit(String value, String delim) {
  String[] splitter = split(value, delim);
  String newPath = "";
  int counter = 0;
  for(String s : splitter) {
    if(!s.equals("")) {
    if(counter!=0) newPath += delim;
    newPath = newPath + s;
    counter++;
    }
  }
  newPath += delim;
  return newPath;
}

void mousePressed() {
  timeline.mousePressed();
}
  
void mouseDragged() {
  timeline.mouseDragged();
}

void mouseReleased() {
  timeline.mouseReleased();
}

void keyPressed() {
  if (key == ' ') {
      timeline.toggle();
  } else if (key == 's' || key == 'S') {
    simulationMode = !simulationMode;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      header.scrollUp();
    } else if (keyCode == DOWN) {
      header.scrollDown();
    } else if (keyCode == LEFT) {
      // timeline.add();
    } else if (keyCode == RIGHT) {
      // timeline.remove();
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  // println(e);
  if(e > 0) header.scrollUp();
  else header.scrollDown();
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    mArduinoPath = selection.getAbsolutePath() +"/";
    println("User selected " + selection.getAbsolutePath());
  }
}