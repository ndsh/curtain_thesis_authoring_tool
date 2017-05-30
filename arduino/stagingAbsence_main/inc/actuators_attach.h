// actuators_attach.h
// attach actuators to pins
steppers[0]->setEnablePin(14);
steppers[1]->setEnablePin(18);
steppers[2]->setEnablePin(22);
steppers[3]->setEnablePin(30);
servos[0].attach(3);
servos[0].write(0);
servos[1].attach(4);
servos[1].write(0);
servos[2].attach(5);
servos[2].write(0);
servos[3].attach(6);
servos[3].write(0);
servos[4].attach(7);
servos[4].write(0);
servos[5].attach(8);
servos[5].write(0);
pinMode(2, OUTPUT);
