class UserInterface {
  boolean mShow = false;

  UserInterface() {
    changeColor();
  }
  
  void toggle() {
    mShow = !mShow;
    println(mShow);
  }

  void changeColor() {
    cp5.setColorActive(farbe.dark());
    /*sets the active state color of tabs and controllers, 
    this cascades down to all known controllers.*/

    cp5.setColorBackground(farbe.normal());
    /*sets the background color of tabs and controllers, 
    this cascades down to all known controllers.*/

    cp5.setColorCaptionLabel(farbe.white());
    /*sets the label color of tabs and controllers, 
    this cascades down to all known controllers.*/

    cp5.setColorForeground(farbe.light());
    /*sets the foreground color of tabs and controllers, 
    this cascades down to all known controllers.*/

    cp5.setColorValueLabel(farbe.dark());
    /*sets the value color of controllers, 
    this cascades down to all known controllers.*/
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


