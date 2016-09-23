// read the multi dimensional array and time processes on actuators in accord

void setup() {  
    Serial.begin(9600);
    String MacAddresses[][2] = {
      #include "inc/play.h"
    };
    uint8_t podChannel = 0;
    for(uint8_t i = 0; i<2; i++) {
        for(uint8_t j = 0; j<2; j++) {
            Serial.print(MacAddresses[i][j]);
            Serial.print("\t");
        }
        Serial.println();
    }
}
void loop() {
    
}
