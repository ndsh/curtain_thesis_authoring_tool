/* Sweep
 by BARRAGAN <http://barraganstudio.com>
 This example code is in the public domain.

 modified 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Sweep
*/

#include <Servo.h>

Servo myservo;  // create servo object to control a servo
int pin = 3;

int pos = 0;    // variable to store the servo position

void setup() {
  //myservo.attach(pin);  // attaches the servo on pin 9 to the servo object
}

void loop() {
 posServ(0);
 delay(2000);
 posServ(180);
 delay(2000);
}

void posServ(int pos) {
   myservo.attach(pin);
  digitalWrite(pin, HIGH);
  myservo.write(pos);
  delay(250); 
  digitalWrite(pin, LOW);
  myservo.detach();
}

