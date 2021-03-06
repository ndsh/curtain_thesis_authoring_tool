// ConstantSpeed.pde
// -*- mode: C++ -*-
//
// Shows how to run AccelStepper in the simplest,
// fixed speed mode with no accelerations
/// \author  Mike McCauley (mikem@airspayce.com)
// Copyright (C) 2009 Mike McCauley
// $Id: ConstantSpeed.pde,v 1.1 2011/01/05 01:51:01 mikem Exp mikem $
// 10 seconds = 14 cm
// 28160 usteps (or 880)

#include <AccelStepper.h>
int enablePin = 14;
int modePin = 15;
int pinStep = 16;
int pinDirection = 17;

int microStepping = 32;
int mode = 1;
int counter = 0;
bool showDone = false;

//********/*
//********/*

// change speed here
int newSpeed = 100; // newSpeed * 32 (microStepping resolution)
boolean reverse = true; // write here either 'true' or 'false'

//********/*
//********/*


AccelStepper stepper(1,pinStep, pinDirection); // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5

void setup()
{  
   Serial.begin(9600);
   
digitalWrite(modePin, HIGH);
   stepper.setEnablePin(enablePin);
   stepper.setMaxSpeed(newSpeed*microStepping); // maxSpeed higher than 1000 might be unreliable
   stepper.setSpeed(newSpeed*microStepping);
   
   stepper.setPinsInverted(false, false, true); 
   //stepper.disableOutputs();
   stepper.enableOutputs();
   Serial.println("get ready");
   //delay(10000);
   Serial.println("an go measure!");

}

void loop()
{    
  if(millis() < 40000) {
    if(!reverse) stepper.setSpeed((newSpeed*microStepping));
    else stepper.setSpeed((newSpeed*microStepping)*-1);
    stepper.runSpeed();
    //counter += newSpeed*microStepping;
    /*
   } else {
    if(!showDone) {
        Serial.println("done");
        Serial.print("steps: ");
        Serial.print(counter);
        showDone = true;
    }
    */
    }
//   }   lastButtonState = reading;
}
