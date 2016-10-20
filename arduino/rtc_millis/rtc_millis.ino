#include <DS3232RTC.h>    //http://github.com/JChristensen/DS3232RTC
#include <Time.h>         //http://www.arduino.cc/playground/Code/Time  
#include <Wire.h>         //http://arduino.cc/en/Reference/Wire (included with Arduino IDE)

elapsedMicros um;
unsigned long lastum, nowum;

void oneHz(void) {
 nowum = um;
 Serial.println(nowum-lastum);
 lastum = nowum;
}

void setup() {
  
  Serial.begin(115200);
  
  pinMode(14, INPUT);
  attachInterrupt(14, oneHz, FALLING);
  RTC.squareWave(SQWAVE_1_HZ);

}

void loop() {
}