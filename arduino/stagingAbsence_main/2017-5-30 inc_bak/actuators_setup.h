// actuators_setup.h
// setup objects for actuators array
// holds information for all pins
AccelStepper stepper0(1, 16, 17);
AccelStepper stepper1(1, 20, 21);
AccelStepper stepper2(1, 26, 28);
AccelStepper stepper3(1, 34, 36);
AccelStepper *steppers[4] = {&stepper0, &stepper1, &stepper2, &stepper3};

Servo servos[6];
