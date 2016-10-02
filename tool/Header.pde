class Header {
	PVector mDimensions;
	CallbackListener cb;
	String mLabel;
	int sliderTime;
	Textlabel mTitle;
	

	Header() {
		mDimensions =  new PVector(width, 88);
		mLabel = "AUTHORING TOOL";

	    cb = new CallbackListener() {
	        public void controlEvent(CallbackEvent theEvent) {
				if (theEvent.getController().getName().equals("buttonExport")) {
	            	if(theEvent.getController().isMousePressed()) export();
				} else if (theEvent.getController().getName().equals("sliderTime")) {
					mTotalPlayTime = theEvent.getController().getValue()*60;
				} else if (theEvent.getController().getName().equals("buttonSaveTo")) {
					if(theEvent.getController().isMousePressed()) selectFolder("Select a folder to process:", "folderSelected");
				}
			}
		};

		cp5.addButton("buttonExport")
		.setValue(0)
		.setPosition(width-(100+leftMargin),10)
		.setSize(100,20)
		.setCaptionLabel("Export")
		.addCallback(cb)
		;
		cp5.addButton("buttonSaveTo")
		.setValue(0)
		.setPosition(width-(100+leftMargin),32)
		.setSize(100,20)
		.setCaptionLabel("Save to...")
		.addCallback(cb)
		;

		cp5.addSlider("sliderTime")
		.setCaptionLabel("Minutes")
		.setPosition(leftMargin+200,(mDimensions.y/2)-11)
		.setSize(90,16)
		.setRange(1,10)
		.setNumberOfTickMarks(10)
		.setValue(5)
		.setColorForeground(farbe.dark())
       	.setColorBackground(farbe.normal())
       	.setColorActive(farbe.light())
       	.setColorCaptionLabel(farbe.normal())
       	.setColorValueLabel(farbe.white())
       	.addCallback(cb)
		;
		
		cp5.getController("sliderTime")
		.getCaptionLabel()
		.align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE)
		.setPaddingX(0);

		mTitle = cp5.addTextlabel(mLabel)
		.setText(mLabel)
		.setPosition(leftMargin, (mDimensions.y/2))
		.setColorValue(farbe.normal())
		;

        

		println("### (HEADER) created");
	}
	void draw() {
		pushStyle();
		fill(farbe.white());
		noStroke();
		rect(0,0,mDimensions.x,mDimensions.y);
		// fill(farbe.dark());
		// rect(leftMargin,(mDimensions.y/2)-11,88,11);
		// fill(farbe.normal());
    	// text(mLabel, leftMargin, (mDimensions.y/2));
    	// mTitle.draw(this);
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
		println("### (HEADER) export started");
		// https://processing.org/reference/selectFolder_.html
		// settings.h
		// how many layers we have
		println("### (HEADER) creating settings.h");
		PrintWriter output = createWriter(mPath+"/settings.h");
		output.println("// settings.h");
        output.println(timeline.countLayers());
		output.flush(); // Writes the remaining data to the file
  		output.close(); // Finishes the file
  		println("### (HEADER) done!");

		// steppers.h
		// setup objects for steppers array

		// layers.h
		// how many segments per layer
		// ordered by layer sequence
		print("### (HEADER) creating layers.h");
		output = createWriter(mPath+"/layers.h");
		output.println("// layers.h");
		int counter = 0;
		for (Layer layer : timeline.getLayers()) {
			print(".");
			output.print(layer.countSegments());
			counter++;
			if(counter != timeline.countLayers()) output.println(",");
		}
		output.flush(); // Writes the remaining data to the file
  		output.close(); // Finishes the file
  		println("");
  		println("### (HEADER) done!");

		// segments.h
		// tupels of commands
		// ordered by layer sequence
	}


}