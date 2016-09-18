class Motor {
  String mName;
  int mID;
  boolean mMode; // true: up/down | false: left/right; it's actually just for visualizing
  
  Motor(String _mName, int _mID, boolean _mMode) {
    this.mName = _mName; 
    this.mID = _mID;
    this.mMode = _mMode;
  }
  
  void draw() {
  }
  
  String getName() {
    return mName;
  }
  
  int getID() {
    return mID;
  }
  
  boolean getMode() {
    return mMode;
  }
  
  
}