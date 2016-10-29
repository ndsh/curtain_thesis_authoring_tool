/* Sweep
 by BARRAGAN <http://barraganstudio.com>
 This example code is in the public domain.

 modified 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Sweep
*/

#include <Servo.h>

Servo myservo0;
Servo myservo1;
Servo myservo2;
Servo myservo3;
int mDelay = 12;
// twelve servo objects can be created on most boards

int pos = 0;

void setup() {
  myservo0.attach(3);
  myservo1.attach(4);
  myservo2.attach(5);
  myservo3.attach(7);
  
  myservo0.write(0);
  myservo1.write(0);
  myservo2.write(0);
  myservo3.write(170);
}

void loop() {
  for (pos = 0; pos <= 170; pos += 1) {
    // in steps of 1 degree
    myservo0.write(pos);
    delay(mDelay );
  }
  for (pos = 170; pos >= 0; pos -= 1) { 
    myservo0.write(pos);
    delay(mDelay );                       
  }
  
   for (pos = 0; pos <= 170; pos += 1) {
    // in steps of 1 degree
    myservo1.write(pos);
    delay(mDelay );             
  }
  for (pos = 170; pos >= 0; pos -= 1) { 
    myservo1.write(pos);
    delay(mDelay );                       
  }
  
   for (pos = 0; pos <= 170; pos += 1) {
    // in steps of 1 degree
    myservo2.write(pos);
    delay(mDelay );                                   
  }
  for (pos = 170; pos >= 0; pos -= 1) { 
    myservo2.write(pos);
    delay(mDelay );                                          
  }

   for (pos = 0; pos <= 170; pos += 1) {
    // in steps of 1 degree
    myservo3.write(pos);
    delay(mDelay );                                 
  }
  for (pos = 170; pos >= 0; pos -= 1) { 
    myservo3.write(pos);
    delay(mDelay );                                            
  }
}

