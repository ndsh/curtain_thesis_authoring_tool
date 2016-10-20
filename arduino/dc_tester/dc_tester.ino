#define fadePin1 2
#define fadePin2 13

void setup(){
  pinMode(fadePin1, OUTPUT);  
  pinMode(fadePin2, OUTPUT);  
}

void loop(){

  for(int i = 0; i<360; i++){
    //convert 0-360 angle to radian (needed for sin function)
    float rad = DEG_TO_RAD * i;

    //calculate sin of angle as number between 0 and 255
    int sinOut = constrain((sin(rad) * 128) + 128, 0, 255); 

    analogWrite(fadePin1, sinOut);
    analogWrite(fadePin2, sinOut);

    delay(15);
  }


}
