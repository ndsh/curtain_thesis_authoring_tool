int dirPin = 8;
int stepperPin = 9;
int enablePin = 13;

void setup() {
 pinMode(dirPin, OUTPUT);
 pinMode(stepperPin, OUTPUT);
 pinMode(enablePin, OUTPUT);
 digitalWrite(enablePin,LOW);
}

void loop(){
   //digitalWrite(enablePin,LOW);
 step(true,1600);
 delay(500);
 step(false,1600);
 delay(500);
}

 void step(boolean dir,int steps){
 digitalWrite(dirPin,dir);
 delay(50);
 for(int i=0;i<steps;i++){
   digitalWrite(stepperPin, HIGH);
   delayMicroseconds(800);
   digitalWrite(stepperPin, LOW);
   delayMicroseconds(800);
 }
}
