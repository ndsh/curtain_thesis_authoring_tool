class Header {
	PVector mDimensions;
	CallbackListener cb;
	String mLabel;
	int sliderTime;
	Textlabel mTitle;
	PVector mOrigin;
	

	Header() {
		mOrigin = new PVector(0,0);
		mDimensions = new PVector(width, 88);
		mLabel = "AUTHORING TOOL";

	    cb = new CallbackListener() {
	        public void controlEvent(CallbackEvent theEvent) {
				if (theEvent.getController().getName().equals("buttonExport")) {
	            	if(theEvent.getController().isMousePressed()) export();
				} else if (theEvent.getController().getName().equals("sliderTime")) {
					mTotalPlayTime = theEvent.getController().getValue()*60;
				} else if (theEvent.getController().getName().equals("buttonSaveTo")) {
					if(theEvent.getController().isMousePressed()) selectFolder("Select a folder to process:", "folderSelected");
				} else if (theEvent.getController().getName().equals("loadSettings")) {
	            	if(theEvent.getController().isMousePressed()) loadSettings();
	            } else if (theEvent.getController().getName().equals("saveSettings")) {
	            	if(theEvent.getController().isMousePressed()) saveSettings();
	            } else if (theEvent.getController().getName().equals("addNewLayer")) {
	            	if(theEvent.getController().isMousePressed()) timeline.addQueue();
	            } else if (theEvent.getController().getName().equals("removeLayer")) {
	            	if(theEvent.getController().isMousePressed()) timeline.remove();
	            }
			}
		};

		cp5.addButton("buttonExport")
		.setValue(0)
		.setPosition(width-(100+leftMargin),mOrigin.y+10)
		.setSize(100,20)
		.setCaptionLabel("Export")
		.addCallback(cb)
		;
		cp5.addButton("buttonSaveTo")
		.setValue(0)
		.setPosition(width-(100+leftMargin),mOrigin.y+32)
		.setSize(100,20)
		.setCaptionLabel("Save Export to...")
		.addCallback(cb)
		;
		cp5.addButton("loadSettings")
		.setValue(0)
		.setPosition(width-(202+leftMargin),mOrigin.y+10)
		.setSize(100,20)
		.setCaptionLabel("Load Settings")
		.addCallback(cb)
		;
		cp5.addButton("saveSettings")
		.setValue(0)
		.setPosition(width-(202+leftMargin),mOrigin.y+32)
		.setSize(100,20)
		.setCaptionLabel("Save Settings")
		.addCallback(cb)
		;
		cp5.addButton("addNewLayer")
		.setPosition(width-(304+leftMargin),mOrigin.y+10)
		.setSize(100,20)
		.setCaptionLabel("Add Layer")
		.addCallback(cb)
		;
		cp5.addButton("removeLayer")
		.setPosition(width-(304+leftMargin),mOrigin.y+32)
		.setValue(0)
		.setSize(100,20)
		.setCaptionLabel("Remove Layer")
		.addCallback(cb)
		;
		cp5.addSlider("sliderTime")
		.setCaptionLabel("Minutes")
		.setPosition(leftMargin+200,mOrigin.y+(mDimensions.y/2)-11)
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
		cp5.addTextlabel(mLabel)
		.setText(mLabel)
		.setPosition(leftMargin, mOrigin.y+(mDimensions.y/2))
		.setColorValue(farbe.normal())
		;

  //       cp5.addButton("addLayer")
		// .setValue(0)
		// .setPosition(width-(202+leftMargin),10)
		// .setSize(100,20)
		// .setCaptionLabel("Add Layer")
		// .addCallback(cb)
		// ;

		println("### (HEADER) created");
	}
	void draw() {
		pushStyle();
		fill(farbe.white());
		noStroke();
		rect(mOrigin.x, mOrigin.y, mDimensions.x, mDimensions.y);
		// fill(farbe.dark());
		// rect(leftMargin,(mDimensions.y/2)-11,88,11);
		// fill(farbe.normal());
    	// text(mLabel, leftMargin, (mDimensions.y/2));
    	// mTitle.draw(this);
		popStyle();


	}

	void updateTranslation() {
		mDimensions.x = width;
		// cp5.getController("layerEnableDD"+mID).setPosition((mTranslation.x)+445, mLayerControls);
		cp5.getController("buttonExport").setPosition(width-(100+leftMargin),mOrigin.y+10);
		cp5.getController("buttonSaveTo").setPosition(width-(100+leftMargin),mOrigin.y+32);
		cp5.getController("loadSettings").setPosition(width-(202+leftMargin),mOrigin.y+10);
		cp5.getController("saveSettings").setPosition(width-(202+leftMargin),mOrigin.y+32);
		cp5.getController("sliderTime").setPosition(leftMargin+200,mOrigin.y+(mDimensions.y/2)-11);
		cp5.getController(mLabel).setPosition(leftMargin, mOrigin.y+(mDimensions.y/2));
		cp5.getController("addNewLayer").setPosition(width-(304+leftMargin),mOrigin.y+10);
		cp5.getController("removeLayer").setPosition(width-(304+leftMargin),mOrigin.y+32);
	}

	PVector getDimensions() {
		return mDimensions;
	}
	float getWidth() {
		return mDimensions.x;
	}
	float getHeight() {
		// return mDimensions.y;
		return mOrigin.y+mDimensions.y;
	}

	void scrollUp() {
		mOrigin.y -= 10;
		timeline.updateTranslation();
		updateTranslation();
	}

	void scrollDown() {
		if(mOrigin.y+10 <= 0) {
		mOrigin.y += 10;
		timeline.updateTranslation();
		updateTranslation();
		}
	}

	void loadSettings() {
    	cp5.loadProperties();
    	
	}

	void saveSettings() {
	    cp5.saveProperties();
	}


	void export() {
		println("### (HEADER) export started");
		// https://processing.org/reference/selectFolder_.html
		// settings.h
		// how many layers we have
		println("### (HEADER) creating settings.h");
		PrintWriter output = createWriter(mArduinoPath+"/settings.h");
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
		output = createWriter(mArduinoPath+"/layers.h");
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