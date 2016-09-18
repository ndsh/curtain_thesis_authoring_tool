class UserInterface {
  boolean mShow = false;
  UserInterface() {
  }
  
  void toggle() {
    mShow = !mShow;
    println(mShow);
  }
}

public void addSegment(boolean theFlag) {
  if(frameCount >1){
    if(theFlag==true) {
      cp5.get(DropdownList.class,"addMode").show();
    } else {
      cp5.get(DropdownList.class,"addMode").hide();
    }
    //timeline.add();
    //UI.toggle();
  }
}

public void addMotor(int theValue) {
  if(frameCount >1){
    
    String mMotorNameValue = cp5.get(Textfield.class,"motorName").getText();
    //d2 = cp5.addDropdownList("motorMode")
    float mMotorModeValue = cp5.get(DropdownList.class,"motorMode").getValue();
    
    if(mMotorNameValue.length() > 0) {
      println("### (MOTOR) dropdown value: "+ mMotorModeValue);
      println("### (MOTOR) input value: "+ mMotorNameValue);
      
      d1.addItem(mMotorNameValue, 1);
      motors.add(new Motor(mMotorNameValue, 1, true));
      println("### (MOTOR) success: added a motor");
      
      // clear fields
      cp5.get(Textfield.class,"motorName").clear();
    } else {
      println("### (MOTOR) fail: nothing added. motor name field empty?");
    }
    
    
  }
}