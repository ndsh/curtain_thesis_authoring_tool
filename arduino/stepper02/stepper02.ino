// read the multi dimensional array and time processes on actuators in accord

// for now we'll work with a fake pulse. later on there will be a RTC module
// for the highest precision and timing

#include "src/Layer.h"

// temporary clock
long gPreviousPulse = 0;  
long gPulseInterval = 1;
long mSeconds = 0;

Layer* layerList;
int gTotalLayers;
int* gSegmentAmounts;
int **gCommands;
int gTotalCountSegments = 0;


void setup() {  

    Serial.begin(9600);
    Serial.print("(APP) \t\t ");
    Serial.println("starting!");

    Serial.println("(APP) \t\t reading contents of settings.h...");
    int settings[] = {
      #include "inc/settings.h"
    };
    gTotalLayers = settings[0];
    Serial.print("(APP) \t\t found (");
    Serial.print(gTotalLayers);
    Serial.println(") layers.");

    Serial.println("(APP) \t\t allocating memory for layer objects");
    if (layerList != 0) {
        delete [] layerList;
    }
    layerList = new Layer[gTotalLayers];
    Serial.println("(APP) \t\t allocation complete");

    Serial.println("(APP) \t\t reading contents of layers.h...");
    int mSegmentAmounts[] = {
      #include "inc/layers.h"
    };
    gSegmentAmounts = mSegmentAmounts;
    Serial.println("(APP) \t\t done");

    Serial.println("(APP) \t\t reading contents of segments.h...");
    int mCommands[][2] = {
      #include "inc/segments.h"
    };
    //following line returns the amount of elements we have, which should be layer*2 (tupels)
    //Serial.println(sizeof(gCommands)/sizeof(int));
    for(int i = 0; i<gTotalLayers; i++) {
        gTotalCountSegments += mSegmentAmounts[i];
    }
    gCommands = malloc(gTotalCountSegments * sizeof(int*));
    for (int i = 0; i < gTotalCountSegments; i++) {
      gCommands[i] = malloc(2 * sizeof(int));
    }
    for(uint8_t i = 0; i<gTotalCountSegments; i++) {
        for(uint8_t j = 0; j<2; j++) {
            gCommands[i][j] = mCommands[i][j];
        }
    }
    Serial.println("(APP) \t\t done");


    Serial.println("(APP) \t\t creating objects...");
    for(uint8_t i = 0; i<gTotalLayers; i++) {
        layerList[i].setup(i, gSegmentAmounts[i]);
    }
}
void loop() {
    // Serial.println(gTotalLayers);
    // Serial.println(gTotalCountSegments);
    // Serial.println(gSegmentAmounts[0]);
    // Serial.println(gCommands[0][0]);
    unsigned long tCurrentMillis = millis();
    if(tCurrentMillis - gPreviousPulse > gPulseInterval) {
        // Serial.print("tick: ");
        // Serial.println(mSeconds);
        mSeconds++;
        gPreviousPulse = tCurrentMillis;

        for(uint8_t i = 0; i<gTotalLayers; i++) {
           layerList[i].update();
        }
    }
 
  
}

