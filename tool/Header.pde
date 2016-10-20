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
		println("### (HEADER) created");
	}
	void draw() {
		if(!simulationMode) {
			cp5.getController("buttonExport").show();
			cp5.getController("buttonSaveTo").show();
			cp5.getController("loadSettings").show();
			cp5.getController("saveSettings").show();
			cp5.getController("sliderTime").show();
			cp5.getController(mLabel).show();
			cp5.getController("addNewLayer").show();
			cp5.getController("removeLayer").show();

			pushMatrix();
			pushStyle();
			translate(mOrigin.x, mOrigin.y);
			fill(farbe.white());
			noStroke();
			rect(0, 0, mDimensions.x, mDimensions.y);
			popStyle();
			popMatrix();
		} else {
			cp5.getController("buttonExport").hide();
			cp5.getController("buttonSaveTo").hide();
			cp5.getController("loadSettings").hide();
			cp5.getController("saveSettings").hide();
			cp5.getController("sliderTime").hide();
			cp5.getController(mLabel).hide();
			cp5.getController("addNewLayer").hide();
			cp5.getController("removeLayer").hide();
		}

	}

	void updateTranslation() {
		mDimensions.x = width;
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

	void loadTimeline() {
		JSONObject json;
		json = loadJSONObject("new.json");
		
		JSONArray layerData = json.getJSONArray("layers");
		println(layerData.getJSONObject(0).getJSONObject("segment"));
		println(layerData.getJSONObject(0).getJSONObject("segment").getFloat("direction"));
		println(layerData.getJSONObject(0).getInt("id"));
		timeline.add(layerData.getJSONObject(0).getInt("id"));
		Layer layer = timeline.getLayer(layerData.getJSONObject(0).getInt("id"));
		layer.add(
			layerData.getJSONObject(0).getJSONObject("segment").getFloat("direction"), 
			new PVector(layerData.getJSONObject(0).getJSONObject("segment").getFloat("positionX"),	layerData.getJSONObject(0).getJSONObject("segment").getFloat("positionY")),
			new PVector(layerData.getJSONObject(0).getJSONObject("segment").getFloat("sizeX"),	layerData.getJSONObject(0).getJSONObject("segment").getFloat("sizeY"))
		);
	}

	void loadSettings() {
    	cp5.loadProperties();
    	
	}

	void saveSettings() {
		// save our timeline!
		JSONObject json = new JSONObject();

		JSONArray values = new JSONArray();
		int i = 0;
		for(Layer layer : timeline.getLayers()) {
			JSONObject layerData = new JSONObject();
			layerData.setInt("id", layer.getID());
			for(Segment segment : layer.getSegments()) {
				JSONObject segmentData = new JSONObject();
				segmentData.setInt("id", segment.getID());
				segmentData.setFloat("direction", segment.getDirection());
				segmentData.setFloat("positionX", segment.getPosition().x);
				segmentData.setFloat("positionY", segment.getPosition().y);
				segmentData.setFloat("sizeX", segment.getSize().x);
				segmentData.setFloat("sizeY", segment.getSize().y);
				layerData.setJSONObject("segment", segmentData);
			}
			values.setJSONObject(i, layerData);
			i++;
		}
		json.setJSONArray("layers", values);
	  	saveJSONObject(json, "data/new.json");

	    cp5.saveProperties();

	    String[] stringList = { mArduinoPath };
	    saveStrings("data/settings/settings.cfg", stringList);
	}


	void export() {
		int counter = 0;
		println("### (HEADER) export started");
		// https://processing.org/reference/selectFolder_.html

		// ++++++++++++++++++++++++++++++++++++++++++
		// settings.h
		println("### (HEADER) creating settings.h");
		PrintWriter output = createWriter(mArduinoPath+"settings.h");
		output.println("// settings.h");
		output.println("// how many layers we have");
        output.println(timeline.countLayers());
		output.flush();
  		output.close();
  		println("### (HEADER) done!");

		// ++++++++++++++++++++++++++++++++++++++++++
		// actuators.h
		output = createWriter(mArduinoPath+"actuators.h");
		output.println("// actuators.h");
		output.println("// setup objects for actuators array");
		output.println("// holds information for all pins");
		// example:
		// AccelStepper stepper0(1,9,8);
		// AccelStepper stepper1(1,9,8);
		// AccelStepper *steppers[2] = {&stepper0, &stepper1};
		// *steppers[2] <- 2 = amount!!!

		/*
		Servo servos[6];
	    servos[i].attach(pin);
		*/

		//
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() != 2) {
				output.println("AccelStepper stepper"+ counter +"(1, "+layer.getPinStep()+", "+layer.getPinDir()+");");
				counter++;
			}
			//if(counter != timeline.countLayers()) output.println(",");
		}
		int tSteppers = counter;
		if(tSteppers > 0) {
			output.print("AccelStepper *steppers["+tSteppers+"] = {");

			counter = 0;
			for (Layer layer : timeline.getLayers()) {
				if(layer.getMotorMode() != 2) {
					output.print("&stepper"+ counter);
					counter++;
					if(counter != tSteppers) output.print(", ");
				}
			}
			output.println("};");
		}

		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() == 2) {
				counter++;
			}
		}
		int tServos = counter;
		if(tServos > 0) {
			output.println("");
			output.println("Servo servos["+tServos+"];");
			counter = 0;
			for (Layer layer : timeline.getLayers()) {
				if(layer.getMotorMode() == 2) {
					output.println("servos["+counter+"].attach("+layer.getPinEnable()+");");
					counter++;
				}
			}
		}

		
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");

  		// ++++++++++++++++++++++++++++++++++++++++++
		// layers.h
		print("### (HEADER) creating layers.h");
		output = createWriter(mArduinoPath+"layers.h");
		output.println("// layers.h");
		output.println("// how many segments per layer");
		output.println("// ordered by layer sequence");
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			print(".");
			output.print(layer.countSegments());
			counter++;
			if(counter != timeline.countLayers()) output.println(",");
		}
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");

  		// ++++++++++++++++++++++++++++++++++++++++++
		// types.h
		print("### (HEADER) creating types.h");
		output = createWriter(mArduinoPath+"types.h");
		output.println("// types.h");
		output.println("// what each layer represents");
		output.println("// ordered by layer sequence");
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			output.print(layer.getMotorMode());
			counter++;
			if(counter != timeline.countLayers()) output.println(",");
		}
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");

  		// ++++++++++++++++++++++++++++++++++++++++++
		// identification.h
		print("### (HEADER) creating identification.h");
		output = createWriter(mArduinoPath+"identification.h");
		output.println("// identification.h");
		output.println("// holds each motor # (id) for later sorting purposes");
		output.println("// ordered by layer sequence");
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			output.print(layer.getMotorNumber());
			counter++;
			if(counter != timeline.countLayers()) output.println(",");
		}
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");

  		// ++++++++++++++++++++++++++++++++++++++++++
		// segments.h
		// tupels of commands
		// ordered by layer sequence
		print("### (HEADER) creating segments.h");
		output = createWriter(mArduinoPath+"segments.h");
		output.println("// segments.h");
		output.println("// tupels of commands");
		output.println("// ordered by layer sequence");
		output.println("// time in seconds, steps per second");
		counter = 0;
		for ( ArrayList<PVector> u : timeline.getExport()) {
			output.println("// LAYER "+counter);
			for ( PVector o : u) {

				if(o.z != -1) { 
					Segment s = timeline.getLayers().get(counter).getSegments().get((int)o.z);
					output.println("{"+(int)s.getTime()+","+s.getSteps()+"},");
					//  {
					//   5, 20
					// },
					// println(s.getTime());
					// println(s.getSteps());
					
				} else {
					//map(mSize.x, mGrabArea, width-30, 0, mTotalPlayTime)
					// println(o.y);
					output.println("{"+(int)map(o.y, 0, maxWidth, 0, mTotalPlayTime)+",0},");
					// println(map(o.y, mGrabArea, width-30, 0, mTotalPlayTime));
				}
			}
			counter++;
		}
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");
	}


}