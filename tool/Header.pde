class Header {
	PVector mDimensions;
	CallbackListener cb;
	String mLabel;
	String mBarPosition;
	int sliderTimer;
	Textlabel mTitle;
	PVector mOrigin;
	

	Header() {
		mOrigin = new PVector(0,0);
		mDimensions = new PVector(width, 88);
		mLabel = "AUTHORING TOOL";
		mBarPosition = "0:00";

	    cb = new CallbackListener() {
	        public void controlEvent(CallbackEvent theEvent) {
				if (theEvent.getController().getName().equals("buttonExport")) {
	            	if(theEvent.getController().isMousePressed()) export();
				} else if (theEvent.getController().getName().equals("sliderTimer")) {
					mTotalPlayTime = theEvent.getController().getValue()*60;
					// mTotalPlayTime = parseInt(cp5.get(Textfield.class,"sliderTimer").getText())*60;
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
		cp5.addTextlabel(mLabel)
		.setText(mLabel)
		.setPosition(leftMargin, mOrigin.y+(mDimensions.y/2))
		.setColorValue(farbe.normal())
		;

		cp5.addSlider("sliderTimer")
		.setCaptionLabel("Minutes")
		.setPosition(leftMargin+200,mOrigin.y+(mDimensions.y/2)-11)
		.setSize(90,16)
		.setRange(1,20)
		.setNumberOfTickMarks(20)
		.setValue(10)
		.setColorForeground(farbe.dark())
       	.setColorBackground(farbe.normal())
       	.setColorActive(farbe.light())
       	.setColorCaptionLabel(farbe.normal())
       	.setColorValueLabel(farbe.white())
       	.addCallback(cb)
		;
		// cp5.getController("sliderTimer")
		// .getCaptionLabel()
		// .align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE)
		// .setPaddingX(0);

		// cp5.addTextfield("sliderTimer")
	 //    .setPosition(leftMargin+200,mOrigin.y+(mDimensions.y/2)-11)
	 //    .setAutoClear(false)
	 //    .setValue(str(0))
	 //    .setSize(90,16)
	 //    .onChange(cb)
	 //    .onLeave(cb)
	 //    .onRelease(cb)
	 //    .onReleaseOutside(cb)
	 //    .setCaptionLabel("Minutes")
	 //    .setColorForeground(farbe.white())
	 //    .setColorBackground(farbe.light())
	 //    .setColorActive(farbe.light())
	 //    .setColorCaptionLabel(farbe.normal())
	 //    .setColorValueLabel(farbe.normal())
	 //    ;
		cp5.addTextlabel("timeBar")
		.setText(mBarPosition)
		.setPosition(leftMargin, mOrigin.y+(mDimensions.y/3))
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
			cp5.getController("sliderTimer").show();
			cp5.getController(mLabel).show();
			cp5.getController("addNewLayer").show();
			cp5.getController("removeLayer").show();

			cp5.getController("timeBar").setValueLabel(timeline.displayBarPosition());

			pushMatrix();
			pushStyle();
			translate(mOrigin.x, mOrigin.y);
			fill(farbe.white());
			noStroke();
			rect(0, 0, mDimensions.x, mDimensions.y);
			stroke(farbe.normal());
			line(leftMargin, mOrigin.y+(mDimensions.y-5), maxWidth, mOrigin.y+(mDimensions.y-5));
			int tGrid = 16;
			int tDivider = (int) (maxWidth/tGrid);
			fill(0,0,0);
			textAlign(LEFT);
			for(int i = 0; i<tGrid; i++) {
				int h = (int)(map(i, 0, tGrid-1, 0, mTotalPlayTime));
				text(h/60+":"+h%60, i*tDivider+(leftMargin), mOrigin.y+(mDimensions.y-10));
				line(i*tDivider+(leftMargin),mOrigin.y+(mDimensions.y-10),i*tDivider+(leftMargin),mOrigin.y+(mDimensions.y));
			}
			popStyle();
			popMatrix();
		} else {
			cp5.getController("buttonExport").hide();
			cp5.getController("buttonSaveTo").hide();
			cp5.getController("loadSettings").hide();
			cp5.getController("saveSettings").hide();
			cp5.getController("sliderTimer").hide();
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
		cp5.getController("sliderTimer").setPosition(leftMargin+200,mOrigin.y+(mDimensions.y/2)-11);
		cp5.getController(mLabel).setPosition(leftMargin, mOrigin.y+(mDimensions.y/2));
		cp5.getController("timeBar").setPosition(leftMargin, mOrigin.y+(mDimensions.y/3));
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
		try {
			JSONObject json = loadJSONObject("new.json");
			// for(int i = 0; i<json.size(); i++) {
			
				JSONArray layerData = json.getJSONArray("layers");
				for(int i = 0; i<layerData.size(); i++) {
					println("layer"+i);
					int layerID = layerData.getJSONObject(i).getInt("id");
					timeline.add(layerID);
					Layer layer = timeline.getLayer(layerID);

					for(int j = 0; j<(layerData.getJSONObject(i).size()-1); j++) {
						layer.add(
							layerData.getJSONObject(i).getJSONObject("segment"+j).getFloat("direction"), 
							new PVector(layerData.getJSONObject(i).getJSONObject("segment"+j).getFloat("positionX"), layerData.getJSONObject(i).getJSONObject("segment"+j).getFloat("positionY")),
							new PVector(layerData.getJSONObject(i).getJSONObject("segment"+j).getFloat("sizeX"), layerData.getJSONObject(i).getJSONObject("segment"+j).getFloat("sizeY"))
						);
					}
					// println(layerData.getJSONObject(i).getJSONObject("segment"+j));
					// println(layerData.getJSONObject(i).getJSONObject("segment"+j).getFloat("direction"));
					// println(layerData.getJSONObject(i).getInt("id"));
					
					
					
				}
			// }
		}
		catch(Exception e){
		   // e.printStackTrace();
		   //json was blank, do something else
		}
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
			int j = 0;
			for(Segment segment : layer.getSegments()) {
				JSONObject segmentData = new JSONObject();
				segmentData.setInt("id", segment.getID());
				segmentData.setFloat("direction", segment.getDirection());
				segmentData.setFloat("positionX", segment.getPosition().x);
				segmentData.setFloat("positionY", segment.getPosition().y);
				segmentData.setFloat("sizeX", segment.getSize().x);
				segmentData.setFloat("sizeY", segment.getSize().y);
				segmentData.setFloat("runTime", segment.getRuntime());
				layerData.setJSONObject("segment"+j, segmentData);
				
				j++;
			}
			values.setJSONObject(i, layerData);
			
			
			
			
			i++;
		}
		json.setJSONArray("layers", values);
		
	  	saveJSONObject(json, "data/new.json");

	    cp5.saveProperties();

	    String[] stringList = { mArduinoPath };
	    if(os.equals("Mac OS X")) {
	    	saveStrings("data/settings.cfg", stringList);
	    } else {
	    	saveStrings("data\\settings.cfg", stringList);
	    }
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
		// actuators_setup.h
		output = createWriter(mArduinoPath+"actuators_setup.h");
		output.println("// actuators_setup.h");
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
			if(layer.getMotorMode() == 0) {
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
				if(layer.getMotorMode() == 0) {
					output.print("&stepper"+ counter);
					counter++;
					if(counter != tSteppers) output.print(", ");
				}
			}
			output.println("};");
		}

		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() == 1) {
				counter++;
			}
		}
		int tServos = counter;
		if(tServos > 0) {
			output.println("");
			output.println("Servo servos["+tServos+"];");
		}

		
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");

  		// ++++++++++++++++++++++++++++++++++++++++++
		// actuators_attach.h
		output = createWriter(mArduinoPath+"actuators_attach.h");
		output.println("// actuators_attach.h");
		output.println("// attach actuators to pins");

		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() == 0) {
				output.println("steppers["+counter+"]->setEnablePin("+ layer.getPinEnable() +");");
				counter++;
			}
		}
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() == 1) {
				output.println("servos["+counter+"].attach("+layer.getPinEnable()+");");
				output.println("servos["+counter+"].write(0);");
				counter++;
			}
		}
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() == 2) {
				output.println("pinMode("+layer.getPinEnable()+", OUTPUT);");
				counter++;
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

		// ! was only counting filled segments !

		// for (Layer layer : timeline.getLayers()) {
		// 	print(".");
		// 	output.print(layer.countSegments());
		// 	counter++;
		// 	if(counter != timeline.countLayers()) output.println(",");
		// }

		counter = 0;
		for ( ArrayList<PVector> u : timeline.getExport()) {
			int j = 0;
			for ( PVector o : u) {
				j++;
			}
			output.print(j);
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
			int type=0;
			// if(layer.getMotorMode() == 0) type = 0;
			// else if(layer.getMotorMode() == 1) type = 1;
			// else if(layer.getMotorMode() == 2) type = 2;
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
		// extrapin.h
		print("### (HEADER) creating extrapin.h");
		output = createWriter(mArduinoPath+"extrapin.h");
		output.println("// extrapin.h");
		output.println("// for DC and steppers we need extra pin configurations");
		output.println("// stepper = M2 pin / DC = control pin");
		counter = 0;
		for (Layer layer : timeline.getLayers()) {
			if(layer.getMotorMode() == 0) {
				output.println(layer.getStepperMode() +",");
			} else if(layer.getMotorMode() == 2) {
				output.println(layer.getPinEnable() +",");
			} else output.println("-1,");
			
			counter++;
			// if(counter != timeline.countLayers()) output.println(",");
		}
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");

  		// ++++++++++++++++++++++++++++++++++++++++++
		// segments.h
		// tupels of commands
		// ordered by layer sequence
		println("### (HEADER) creating segments.h");
		output = createWriter(mArduinoPath+"segments.h");
		output.println("// segments.h");
		output.println("// tupels of commands");
		output.println("// ordered by layer sequence");
		output.println("// time in seconds, steps per second");
		output.println();
		output.println("// last update: "+ day() +"."+ month() +"."+ year() +" - "+ hour() +":"+ minute() +":"+second());
		output.println();
		counter = 0;
		int previousValue = 0;
		for ( ArrayList<PVector> u : timeline.getExport()) {
			output.print("// LAYER "+counter);
			print("// LAYER "+counter);
			try {
				output.print(" -> " + timeline.getLayers().get(counter).getMotorModeString());
				print(" -> " + timeline.getLayers().get(counter).getMotorModeString());
			} catch(Exception e) {

			}
			println();
			output.println();
			previousValue = 0;
			for ( PVector o : u) {
				println(o.x + "\t" + o.y + "\t" + o.z);
				int tMotorMode = timeline.getLayers().get(counter).getMotorMode();
				if(o.z != -1) { 
					// NullException can occur on the following line. but when?
					// println("trying to plot segment #"+ (int)o.z);
					Segment s = timeline.getLayers().get(counter).getSegment((int)o.z);
					if(tMotorMode == 0) {
						output.println("{"+(int)s.getTime()+","+s.getSteps()+"},");
						previousValue = s.getSteps(); // culprit?
					} else {
						int tDirection = (int)s.getDirection();
						if(tMotorMode == 1) tDirection = constrain(tDirection, 0, 170);
						else tDirection = constrain(tDirection, 0, 255);
						output.println("{"+(int)s.getTime()+","+tDirection+"},");
						previousValue = tDirection; // culprit?
					}
				} else {
					// ???? FIX ****
					if(tMotorMode == 0 || tMotorMode == 2) {
						output.println("{"+(int)map(o.y, 0, maxWidth, 0, mTotalPlayTime)+",000},");
					} else if(timeline.getLayers().get(counter).getMotorMode() == 1) {
						output.println("{"+(int)map(o.y, 0, maxWidth, 0, mTotalPlayTime)+","+previousValue+"},");
					}
					// println(map(o.y, mGrabArea, width-30, 0, mTotalPlayTime));
				}
			}
			counter++;
			output.println();
		}
		output.flush();
  		output.close();
  		println("");
  		println("### (HEADER) done!");
	}
}