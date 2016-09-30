class Header {
	PVector mDimensions;
	CallbackListener cb;

	Header() {
		mDimensions =  new PVector(width, 88);

	    cb = new CallbackListener() {
	        public void controlEvent(CallbackEvent theEvent) {
	           if (theEvent.getController().getName().equals("buttonExport")) {
	            if(theEvent.getController().isMousePressed()) export();
	            	
	          }
	        }
	    };

		cp5.addButton("buttonExport")
	     .setValue(0)
	     .setPosition(width-110,10)
	     .setSize(100,20)
	     .setCaptionLabel("Export")
	     .addCallback(cb)
	     ;
		println("### (HEADER) created");
	}
	void draw() {
		pushStyle();
		fill(farbe.white());
		noStroke();
		rect(0,0,mDimensions.x,mDimensions.y);
		fill(farbe.normal());
		rect(42,(mDimensions.y/2)-11,88,11);
		popStyle();


	}

	PVector getDimensions() {
		return mDimensions;
	}
	float getWidth() {
		return mDimensions.x;
	}
	float getHeight() {
		return mDimensions.y;
	}

	void export() {
		// https://processing.org/reference/selectFolder_.html
		String path = "/Volumes/Macintosh HD/Users/julianhespenheide/Programming/Gitshit/Non-work/irena_thesis/curtain_thesis_authoring_tool/tool/export/";
		// settings.h
		// how many layers we have
		PrintWriter output = createWriter(path+"settings.h");
		output.println("// settings.h");
        output.println(timeline.getCount());
		output.flush(); // Writes the remaining data to the file
  		output.close(); // Finishes the file

		// steppers.h
		// setup objects for steppers array

		// layers.h
		// how many segments per layer
		// ordered by layer sequence

		// segments.h
		// tupels of commands
		// ordered by layer sequence
	}
}