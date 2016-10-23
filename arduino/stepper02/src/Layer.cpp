#include "Layer.h"

Layer::Layer() {
	// empty because i am too stupid
	// to init this the c++ way
}

void Layer::setup(int tID, int tSegments, int tType, int tMotorID, int tExtraPin) {
	mFinished = false;
	// topkeksetup()
	mID = tID;
	mMotorID = tMotorID;
	mMotorType = tType;

	mMotorPin = tExtraPin;
	// this MotorPin can be used in 3 different ways:
	// stepper = M2 pin
	// dc motor = control pin
	// servo = just set to -1 and dont do anything. lel

	// what is this object? stepper or servo?
	// what's the id? there can be actually
	// two Layers

	
	
	mSegments = tSegments;
	mCurrentSegment = 0;
	mCommands = (long**)malloc(mSegments * sizeof(int*));
    for (int i = 0; i < mSegments; i++) {
      mCommands[i] = (long*)malloc(2 * sizeof(int));
    }

	Serial.print("(LAYER) \t setting up layer ");
	Serial.print(mID);
	Serial.print(" with ");
	Serial.print(mSegments);
	Serial.println(" segments.");

	if(mMotorType == 0) {
		Serial.print("stepper #");
		Serial.println(mMotorID);
	} else if(mMotorType == 1) {
		Serial.print("servo #");
		Serial.println(mMotorID);
	} else if(mMotorType == 2) {
		Serial.print("dc #");
		Serial.println(mMotorID);
	}

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
	// Serial.println(tCounter);

	// import values from big gCommands array into our own
	// class mCommands class array
	int tIncrement = 0;
	for(int i = tCounter; i<(tCounter+mSegments); i++) {
		
		mCommands[tIncrement][0] = gCommands[i][0];
		mCommands[tIncrement][1] = gCommands[i][1];
		
		Serial.print(tIncrement);
		Serial.print("\t");
		Serial.print("(");
		Serial.print(mCommands[tIncrement][0]);
		Serial.print("|");
		Serial.print(mCommands[tIncrement][1]);
		Serial.println(")");
		tIncrement++;
	}
	// Serial.println(millis());
	// Serial.println(millis());

	// setup for steppers
	if(mMotorType == 0) {
		digitalWrite(mMotorPin, HIGH);
		// steppers[mMotorID]->setEnablePin(42);
	   	steppers[mMotorID]->setMaxSpeed(1000*32); // maxSpeed higher than 1000 might be unreliable
	   	// steppers[mMotorID]->setSpeed(200*32);
	   	steppers[mMotorID]->setPinsInverted(false, false, true); 
		steppers[mMotorID]->enableOutputs();
	// setup for servos
	} else if (mMotorType == 1) {
		mServoPos = 0;
    	mServoGoTo = 0;
	// setup for dcs
	} else if (mMotorType == 2) {
	}
	
	/* +++++++ */

	mCurrentRuntime = (mCommands[mCurrentSegment][0])*1000;

	mCurrentSteps = mCommands[mCurrentSegment][1];

	Serial.print("------\t\t");
	Serial.print(mCurrentRuntime);
	Serial.print("\t");
	Serial.println(mCommands[0][0]);
	// Serial.println(mCurrentSteps);
}

void Layer::update() {
	int microStepping = 32;
	if(!mFinished) {
		if(mMotorType == 0) {
			// Serial.print("stepper");
			// Serial.print("\t");
			// Serial.print(mMotorID);
			// Serial.print("\t speed ");
			// Serial.print(mCurrentSteps);
			// Serial.print("\t mCurrentRuntime ");
			// Serial.println(mCurrentRuntime);
			steppers[mMotorID]->setSpeed((mCurrentSteps*microStepping));
			steppers[mMotorID]->runSpeed();
		} else if(mMotorType == 1) {
			if(mServoPos != mServoGoTo) {
				mServoPos+=mServoIncrement;
				// Serial.print(mServoPos);
				// Serial.print("\t");
				// Serial.println(mServoGoTo);
				servos[mMotorID].write(mServoPos);
			}
		} else if(mMotorType == 2) {
			analogWrite(mMotorPin, mCurrentSteps);
		}
	    if ((millis() - mLastMillis) > mCurrentRuntime) {
	    	if(mMotorType == 0) {
	    		Serial.println("stepper change");
	    	}
			mCurrentSegment++;
			if(mCurrentSegment == mSegments) {
				mFinished = true;
				Serial.print("layer ");
				Serial.print(mID);
				Serial.println(" finished");
				analogWrite(mMotorPin, 0);
			} else {
				mCurrentRuntime = (mCommands[mCurrentSegment][0])*1000;
				mCurrentSteps = mCommands[mCurrentSegment][1];
				Serial.print("changing segment in layer ");
				Serial.print(mID);
				Serial.print(" to ");
			  	Serial.print(mCurrentSegment);
			  	Serial.print(" - new speed: ");
			  	Serial.println(mCurrentSteps);

			  	if(mMotorType == 0) {
					steppers[mMotorID]->setSpeed(0);
					steppers[mMotorID]->runSpeed();
					steppers[mMotorID]->setSpeed((mCurrentSteps*microStepping));
				} else if(mMotorType == 1) {
					mServoGoTo = mCurrentSteps;
					if(mServoPos < mServoGoTo) mServoIncrement = 1;
					else mServoIncrement = -1;	
				}

				mLastMillis = millis();
			}
	    }
	}	
	// Serial.print("(LAYER) \t current segment in ");
	// Serial.print(mID);
	// Serial.print(" is ");
	// Serial.print(mCurrentSegment);
	// Serial.print(" with a runtime of ");
	// Serial.print(mCurrentRuntime);
	// Serial.println(" milliseconds");
}

void Layer::start() {
	mLastMillis = millis();
	mFinished = false;
}

void Layer::reset() {
	mCurrentSegment = 0;
}

bool Layer::isFinished() {
	return mFinished;
}