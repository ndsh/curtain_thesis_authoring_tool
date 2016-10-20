#ifndef Layer_h
#define Layer_h
#include <Arduino.h>
#include <AccelStepper.h>

extern int gTotalLayers;
extern int* gSegmentAmounts;
extern int **gCommands;
extern int gTotalCountSegments;
extern AccelStepper *steppers[];

class Layer
{
  public:
  	Layer();
  	void setup(int tID, int tSegments);
    void update();

  private:
  	int mID;
    int mMotorID; // for the respective array
    int mMotorType; // 0 = stepper; 1 = servo
  	int** mCommands;
  	int mSegments; // how many segments are in this layer
  	int mCurrentSegment; // our pointer, which current segment
  	int mCurrentRuntime; // how long this segment runs, in ms
  	int mCurrentSteps;
};

#endif