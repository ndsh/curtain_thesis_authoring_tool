#include "Layer.h"

Layer::Layer() {
	// empty because i am too stupid
	// to init this the c++ way
}

void Layer::setup(int tID, int tSegments) {
	// topkeksetup()
	mID = tID;
	mSegments = tSegments;
	mCurrentSegment = 0;
	mCommands = malloc(mSegments * sizeof(int*));
    for (int i = 0; i < mSegments; i++) {
      mCommands[i] = malloc(2 * sizeof(int));
    }

	Serial.print("(LAYER) \t setting up layer ");
	Serial.print(mID);
	Serial.print(" with ");
	Serial.print(mSegments);
	Serial.println(" segments.");

	// find out how many segments are before this layer
	
	// these are all global variables :)
	//	  Serial.println(gTotalLayers);
 	//    Serial.println(gTotalCountSegments);
 	//    Serial.println(gSegmentAmounts[0]);
 	//    Serial.println(gCommands[0][0]);
	int tCounter = 0;
	for(uint8_t i = 0; i<gTotalCountSegments; i++) {		
		if(i == mID) break;
		tCounter += gSegmentAmounts[i];
	}

	// import values from big gCommands array into our own
	// class mCommands class array
	for(uint8_t i = tCounter; i<(tCounter+mSegments); i++) {
		mCommands[i][0] = gCommands[i][0];
		mCommands[i][1] = gCommands[i][1];
		// Serial.print("(");
		// Serial.print(mCommands[i][0]);
		// Serial.print("|");
		// Serial.print(mCommands[i][1]);
		// Serial.println(")");
	}
	// Serial.println(millis());
	// Serial.println(millis());
	mCurrentRuntime = (mCommands[mCurrentSegment][0])*1000;
}

void Layer::update() {
	if(mID == 0) {
	// Serial.print("(LAYER) \t current segment in ");
	// Serial.print(mID);
	// Serial.print(" is ");
	// Serial.print(mCurrentSegment);
	// Serial.print(" with a runtime of ");
	// Serial.print(mCurrentRuntime);
	// Serial.println(" milliseconds");
	}
	if(mCurrentRuntime > 0) mCurrentRuntime--;
	if(mCurrentRuntime <= 0 && mCurrentSegment < mSegments) {
		mCurrentSegment++;
		mCurrentRuntime = (mCommands[mCurrentSegment][0])*1000;
		Serial.print("changing segment in layer ");
		Serial.println(mID);
	}

}