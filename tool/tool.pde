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

float mTotalPlayTime = 5.5; // in minutes
Timeline timeline = new Timeline(mTotalPlayTime);
UserInterface UI = new UserInterface();

int mSegmentCounter = 0;

ArrayList<Motor> motors = new ArrayList<Motor>();

void setup() {
  println("### (AUTHORING_TOOL) welcome!");
  println("### (AUTHORING_TOOL) running the UserInterface with the help of ControlP5:");
  size(displayWidth, 400);

  cp5 = new ControlP5(this);
  println();

  // change the original colors
  cp5.setColorForeground(0xffaa0000);
  cp5.setColorBackground(0xff660000);
  //cp5.setColorLabel(0xffdddddd);
  //cp5.setColorValue(0xffff88ff);
  cp5.setColorActive(0xffff0000);

  // Labels
  label1 = cp5.addTextlabel("label1")
    .setText("0 min")
    .setPosition(20, (height/2)+10)
    ;
  label2 = cp5.addTextlabel("label2")
    .setText(mTotalPlayTime+ " min")
    .setPosition(width-50, (height/2)+10)
    ;

  // Segment controls
  cp5.addToggle("addSegment")
    .setCaptionLabel("Add")
    .setValue(true)
    .setValue(1)
    .setPosition(0, 0)
    .setSize(40, 40)
    ;
  cp5.get(Toggle.class, "addSegment").toggle();

  // Motor controls
  cp5.addButton("addMotor")
    .setValue(1)
    .setPosition(width-130, 0)
    .setSize(20, 20)
    .setCaptionLabel("+")
    ;
  cp5.addTextfield("motorName")
    .setPosition(width-250, 0)
    .setSize(120, 20)
    .setCaptionLabel("Motor Name")
    ;

  d1 = cp5.addDropdownList("motorList")
    .setPosition(width-100, 0)
    .setCaptionLabel("MOTOR OVERVIEW")
    .setItemHeight(20)
    .setBarHeight(20)
    ;
  d2 = cp5.addDropdownList("motorMode")
    .setPosition(width-250, 40)
    .setCaptionLabel("MOTOR MODE")
    .setItemHeight(20)
    .setBarHeight(20)
    ;
  d3 = cp5.addDropdownList("addMode")
    .setPosition(50, 0)
    .setCaptionLabel("WHAT TO ADD?")
    .setItemHeight(20)
    .setBarHeight(20)
    ;
  d2.addItem("UP/DOWN", true);
  d2.addItem("SYMMETRICAL", false);
  d3.addItem("SEGMENT", true);
  d3.addItem("MOTION", false);
  //cp5.get(DropdownList.class,"addMode").hide();
  background(0);

  // add some things
  motors.add(new Motor("Motor S", 1, true));
  d1.addItem("Motor S", 1);
  timeline.add();
}

void draw() {
  background(0);
  for (Motor motor : motors) {
    motor.draw();
  }
  timeline.draw();
  
  pushStyle();
  stroke(255);
  line(mouseX, mouseY, mouseX+33, mouseY+33);
  line(mouseX+33, mouseY+33, mouseX+45, mouseY+33);
  text(mouseX + "|" + mouseY, mouseX+50, mouseY+38);
  popStyle();
}

void mousePressed() {
  //timeline.detection();
}