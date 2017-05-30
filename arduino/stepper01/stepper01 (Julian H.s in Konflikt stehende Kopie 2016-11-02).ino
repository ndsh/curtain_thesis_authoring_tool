// ConstantSpeed.pde
// -*- mode: C++ -*-
//
// Shows how to run AccelStepper in the simplest,
// fixed speed mode with no accelerations
/// \author  Mike McCauley (mikem@airspayce.com)
// Copyright (C) 2009 Mike McCauley
// $Id: ConstantSpeed.pde,v 1.1 2011/01/05 01:51:01 mikem Exp mikem $

#include <AccelStepper.h>
int pinStep = 9;
int pinDirection = 8;
int enablePin = 13;
int microStepping = 32;
int mode = 1;
int counter = 0;

AccelStepper stepper(1,pinStep, pinDirection); // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5

void setup()
{  
   //Serial.begin(9600);
   stepper.setEnablePin(enablePin);
   stepper.setMaxSpeed(100*microStepping); // maxSpeed higher than 1000 might be unreliable
   stepper.setSpeed(10*microStepping);
   
   stepper.setPinsInverted(false, false, true);	
   //stepper.disableOutputs();
   stepper.enableOutputs();
}

void loop()
{  
  Serial.println(counter);
  counter++;
  if(counter >= 40000) {
    counter = 0;
    mode *= -1;
    Serial.println("bounce");
  }
  
  if(mode == 1) { 
    stepper.setSpeed(50*microStepping);
    stepper.runSpeed();
  } else {
    stepper.setSpeed((50*microStepping)*-1);
    stepper.runSpeed();
  }
  //stepper.enableOutputs();
   //stepper.setSpeed((mSpeed*microStepping)*-1);
   
}
