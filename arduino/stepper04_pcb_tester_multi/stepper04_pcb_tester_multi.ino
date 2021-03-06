// 10 seconds = 14 cm
// 28160 usteps (or 880)

#include <AccelStepper.h>
/*
int enablePin;
int modePin;
int pinStep;
int pinDirection;
*/
bool steppingMode = true; // true = 32, false = half step

int microStepping;
int mode = 1;
int counter = 0;
bool showDone = false;

//********/*
//********/*

// change speed here
int newSpeed = 300; // newSpeed * 32 (microStepping resolution)
boolean reverse = false; // write here either 'true' or 'false'

//********/*
//********/*



long prevMillis = 0;
long interval = 50000;

int selection = 2; // 1-5 ->(n-1)


int selectedMotor[5][4] = {
    {14,  15,  16, 17},
    {18,  19,  20, 21},
    {22,  24, 26, 28},
    {30,  32, 34, 36},    
    {42,  44, 46, 48}
 };
int enablePin = selectedMotor[selection][0];
int modePin = selectedMotor[selection][1];
int pinStep = selectedMotor[selection][2];
int pinDirection = selectedMotor[selection][3];
AccelStepper stepper(1, pinStep, pinDirection); // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5

void setup()
{
  //selection--;
  

  pinMode(modePin, OUTPUT);
  digitalWrite(modePin, steppingMode);
  Serial.begin(9600);

  if (steppingMode) microStepping = 32;
  else microStepping = 2;


  stepper.setEnablePin(enablePin);
  stepper.setMaxSpeed(1000 * microStepping); // maxSpeed higher than 1000 might be unreliable
  stepper.setSpeed(newSpeed * microStepping);

  stepper.setPinsInverted(false, false, true);
  //stepper.disableOutputs();
  stepper.enableOutputs();
  Serial.println("get ready");
  //delay(10000);
  Serial.println("an go measure!");

}

void loop()
{
  //if(millis() < 20000) {
  if(millis()-prevMillis > interval){
    reverse = !reverse;
    prevMillis = millis();
    delay(5000); 
  }
  if (!reverse) stepper.setSpeed((newSpeed * microStepping));
  else stepper.setSpeed((newSpeed * microStepping) * -1);
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
  //   }   lastButtonState = reading;
}
