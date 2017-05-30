#ifndef Layer_h
#define Layer_h
#include <Arduino.h>
#include <AccelStepper.h>
#include <Servo.h>

extern int gTotalLayers;
extern int* gSegmentAmounts;
extern int **gCommands;
extern int gTotalCountSegments;
extern AccelStepper *steppers[];
extern Servo servos[];

class Layer
{
  public:
  	Layer();
  	void setup(int tID, int tSegments, int tTypes, int tMotorID, int tExtraPin);
    void update();
    void start();
    void reset();
    void disable();
    bool isFinished();

  private:
    long mLastMillis;
    long mSegmentTime;
  	int mID;
    int mMotorID; // for the respective array
    int mMotorType; // 0 = stepper; 1 = servo
    int mMotorPin;
  	int** mCommands;
  	int mSegments; // how many segments are in this layer
  	int mCurrentSegment; // our pointer, which current segment
  	long mCurrentRuntime; // how long this segment runs, in ms
  	int mCurrentSteps;
    int mServoPos;
    int mServoGoTo;
    int mServoIncrement;
    bool mFinished;
};

#endif