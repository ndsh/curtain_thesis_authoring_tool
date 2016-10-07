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

float mTotalPlayTime = 5*60; // in second
float mStepResolution = 0.014; // 10 seconds = 14 cm
Timeline timeline;
UserInterface ui;

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

String mArduinoPath = "/Volumes/Macintosh HD/Users/julianhespenheide/Programming/Gitshit/Non-work/irena_thesis/curtain_thesis_authoring_tool/tool/export/";

void setup() {
  size(displayWidth, 400);
  surface.setResizable(true);
  mFont = loadFont("Inconsolata-Regular-13-smooth.vlw");
  textFont(mFont, 13);

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
  timeline = new Timeline(mTotalPlayTime);
  motors.add(new Motor("Motor S", 1, true));
  timeline.add();

  timeline.getExport();
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
  }
  if (key == CODED) {
    if (keyCode == UP) {
      header.scrollUp();
    } else if (keyCode == DOWN) {
      header.scrollDown();
    } else if (keyCode == LEFT) {
      timeline.add();
    } else if (keyCode == RIGHT) {
      timeline.remove();
    }
  }
}

void folderSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      mArduinoPath = selection.getAbsolutePath();
      println("User selected " + selection.getAbsolutePath());
    }
  }