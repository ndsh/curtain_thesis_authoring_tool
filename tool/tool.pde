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
 UserInterface Class: show/hide the UI. simple stuff.
 */

import controlP5.*;

ControlP5 cp5;
DropdownList d1, d2, d3;
Textlabel label1, label2;

float mTotalPlayTime = 5*60; // in second
Timeline timeline;
UserInterface UI = new UserInterface();

int mSegmentCounter = 0;
int mLayerCounter = 0;

Segment gLocked = null;
boolean timeBarLock = false;

boolean mouseDebug = false;

ArrayList<Motor> motors = new ArrayList<Motor>();

// color definitions
color darkBlue, lightBlue;

color white = color(0, 0, 100);

void setup() {
  size(displayWidth, 400);
  colorMode(HSB, 360, 100, 100);
  darkBlue = color(207, 100, 64);
  lightBlue = color(208, 51, 77);
  noSmooth();
  println("### (AUTHORING_TOOL) welcome!");
  println("### (AUTHORING_TOOL) running the UserInterface with the help of ControlP5:");
  

  cp5 = new ControlP5(this);
  println();

  background(darkBlue);

  // add some things
  timeline = new Timeline(mTotalPlayTime);
  motors.add(new Motor("Motor S", 1, true));
  timeline.add();
}

void draw() {
  background(darkBlue);
  for (Motor motor : motors) {
    motor.draw();
  }
  timeline.update();
  timeline.draw();
  
  if(mouseDebug) {
  pushStyle();
  stroke(255);
  line(mouseX, mouseY, mouseX+33, mouseY+33);
  line(mouseX+33, mouseY+33, mouseX+45, mouseY+33);
  text(mouseX + "|" + mouseY, mouseX+50, mouseY+38);
  popStyle();
  }
  
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
}