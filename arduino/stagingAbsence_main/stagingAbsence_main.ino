// read the multi dimensional array and time processes on actuators in accord

// for now we'll work with a fake pulse. later on there will be a RTC module
// for the highest precision and timing
//

#include "src/Layer.h"
#include <AccelStepper.h>
#include <Servo.h>
// #include <VirtualWire.h>

#include "inc/actuators_setup.h"

// temporary clock
unsigned long gPreviousPulse = 0;  
unsigned long gPulseInterval = 0;

Layer* layerList;
int gTotalLayers;
int* gSegmentAmounts;
int **gCommands;
int* gIdentification;
int* gExtraPin;
int* gTypes;
int gTotalCountSegments = 0;

bool mIsPlaying = true;
bool mAllLayersFinished = false;


void setup() {  

    Serial.begin(9600);

    // vw_set_ptt_inverted(true); // Required for DR3100
    // vw_set_rx_pin(2);
    // vw_setup(4000);  // Bits per sec
    // vw_rx_start();       // Start the receiver PLL running

    Serial.print("(APP) \t\t ");
    Serial.println("starting!");

    // +++++++++++++++++++
    Serial.print("(APP) \t\t reading contents of settings.h...");
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

    // +++++++++++++++++++
    Serial.println("(APP) \t\t reading contents of layers.h...");
    int mSegmentAmounts[] = {
      #include "inc/layers.h"
    };
    gSegmentAmounts = mSegmentAmounts;
    Serial.println("(APP) \t\t done");

    // +++++++++++++++++++
    Serial.print("(APP) \t\t reading contents of identification.h...");
    int mIdentification[] = {
      #include "inc/identification.h"
    };
    gIdentification = mIdentification;
    Serial.println("(APP) \t\t done");

    // +++++++++++++++++++
    Serial.print("(APP) \t\t reading contents of extrapin.h...");
    int mExtraPin[] = {
      #include "inc/extrapin.h"
    };
    gExtraPin = mExtraPin;
    Serial.println("(APP) \t\t done");

    // +++++++++++++++++++
    Serial.print("(APP) \t\t reading contents of types.h...");
    int mTypes[] = {
      #include "inc/types.h"
    };
    gTypes = mTypes;
    Serial.println("(APP) \t\t done");

    // +++++++++++++++++++
    Serial.print("(APP) \t\t reading contents of segments.h...");
    int mCommands[][2] = {
      #include "inc/segments.h"
    };
    //following line returns the amount of elements we have, which should be layer*2 (tupels)
    //Serial.println(sizeof(gCommands)/sizeof(int));
    for(int i = 0; i<gTotalLayers; i++) {
        gTotalCountSegments += mSegmentAmounts[i];
    }
    gCommands = (int**)malloc(gTotalCountSegments * sizeof(int*));
    for (int i = 0; i < gTotalCountSegments; i++) {
      gCommands[i] = (int*)malloc(2 * sizeof(int));
    }
    for(uint8_t i = 0; i<gTotalCountSegments; i++) {
        for(uint8_t j = 0; j<2; j++) {
            gCommands[i][j] = mCommands[i][j];
        }
    }
    Serial.println("(APP) \t\t done");

    // attach actuators to pins
    #include "inc/actuators_attach.h"


    Serial.println("(APP) \t\t creating objects...");
    for(uint8_t i = 0; i<gTotalLayers; i++) {
        layerList[i].setup(i, gSegmentAmounts[i], gTypes[i], gIdentification[i], gExtraPin[i]);
    }

    for(uint8_t i = 0; i<gTotalLayers; i++) {
        layerList[i].start();
    }
}
void loop() {
    // if mIsPlaying -> false
        // check for input
        // if button == true -> mIsPlaying
            // layer.start()
    // if mIsPlaying -> true
        // check if allLayersFinished
        // if yes -> mIsPlaying -> false
            // break
        // else
            // layers.update()
    if(!mIsPlaying) {
        // uint8_t buf[VW_MAX_MESSAGE_LEN];
        // uint8_t buflen = VW_MAX_MESSAGE_LEN;
        // if (vw_get_message(buf, &buflen)) { // Non-blocking
        //     // if(buf[0]=='1'){
        //     //   digitalWrite(13,1);
        //     // }  
        //     // if(buf[0]=='0'){
        //     //   digitalWrite(13,0);
        //     // }
        //     if(buf[0]=='1'){
        //       for(uint8_t i = 0; i<gTotalLayers; i++) {
        //             layerList[i].start();
        //         }
                // mIsPlaying = true;
        //     }  
        // }
        // mAllLayersFinished = false;


    } else {
        // Serial.println(gTotalLayers);
        // Serial.println(gTotalCountSegments);
        // Serial.println(gSegmentAmounts[0]);
        // Serial.println(gCommands[0][0]);
        int tFinishes = 0;
        for(uint8_t i = 0; i<gTotalLayers; i++) {
            if(layerList[i].isFinished()) tFinishes++;
        }
        if((tFinishes+1) == gTotalLayers) {
            mAllLayersFinished = true;
            mIsPlaying = false;
            for(uint8_t i = 0; i<gTotalLayers; i++) {
                layerList[i].disable();
            }
        }
        if(!mAllLayersFinished) {
            unsigned long tCurrentMillis = millis();
            gPreviousPulse = tCurrentMillis;
            for(uint8_t i = 0; i<gTotalLayers; i++) {
                layerList[i].update();
            }   
        }
        // } 
    }
}
