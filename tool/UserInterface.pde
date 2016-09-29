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


