/*

# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 10 -- Solar Detector 

# ******The Name and Prupose of the Code******
# The name of the first code is FinalProject.ino and it has several purposes.
# Its first purpose is to implement/setup the interrupt service routine 
# (i.e. ISR). The code will then constantly call the ultrasensor()
# function in order to continously send an "echo" in order to 
# measure the distance an object is away from the sensor.
# The file also has the ISR function that will calculate the
# total time (in microseconds) that it took to send and 
# receive the "echo". If this time was less than 812 microseconds,
# then we conclude that an object is less than 5 inches away from the sensor, 
# which is not a safe distance. If the object is too close, the procedure will 
# print a warning message, turn on the LED, and turn off the motor. If the object is 8 inches 
# but >5 inches away from the sensor, then the object is getting a little too close. 
# A warning message will be printed, the LED will be turned on, but the motor will be allowed
# to spin. If none of the two previous cases apply, then a "safe dsitance achived" 
# will be printed, the LED will be turned off, and the motor will be allowed to 
# spin. Another purpose of the file is to initialize DIDR0 and ADCSRA 
# by calling the initAD( ) function (only once). In addition, the file will
# read in light through the photoresisters (i.e. sockets #2 and #3) and measure 
# how much they differ in light. If the light difference is less than 10,
# the motor will stop, else spin the motor to the direction that the 
# photoresistor has more light. Another purpose of the code is to enable the 
# IR pin connected to PB2 or digital pin 10. The code will then call the function called 
# "control" in the assembly file to setup the motor. Its last purpose is to get the input 
# from the remote controller (using the IR receiver) and storing 
# the two low bytes in a shared array called "remotecommand." Once 
# these two bytes are found, it will then call the controlMotor function 
# found in the assembly file and print out a meaningful message if
# the new command was different from the previous one. This "get remote 
# input and call the controlMotor function" is called indefinetly.
# Lastly, the file will keep track of several "flags" that will
# keep track of the master enables.
# In essence, this file will accomplish the following:
#    1) Your motor should spin towards the photo sensor which has more power.  If they differ less than 10 apart, the motor should not spin
#    2) You should be able to enable/disable your motor with the remote control (master enable).
#    3) Your remote control should be able to turn off and off an LED light that is on your bread board
#    4) Your system should turn on the LED light when you are "close" to the system and print out "Getting Close"
#    5) Your system should leave the LED light on and stop the motor, and print "Too Close" when you are too close to the system.
#    6) Your system should turn off the LED light and turn on the motor when you get far away provided that the motor is enabled
#    7) You should be able to control the motor and LED from the remote (unless you are too close -- then the LED is on and the motor could be off).

# The name of the second file is photoresistor.S and its 
# purpose is to implement the initAD and readAD functions.
# In essence, these functions are reponsible for initialization
# an reading in a value (i.e. analog to digital convertion). 
 
# The name of the third file is motorcontroller.S it also has several 
# and important purposes. Its first pupose is to implement 
# the control function which will call the setupMotor function. 
# This file also has another important function called controlMotor 
# that will help traverse through several arrays to match the 
# corresponding two bytes of the remoteCommand array with its 
# equivalent ascii character. It will then make an action depending 
# on the character it matched (e.g. '>' means forward (clockwise)).  
# The file also has several other functions (e.g. turnofflight, delayThreeSeconds, 
# sendOneBit, etc) that will make it easier to program the motor 
# and the LED. Ultimetly, these functions will follow the same protocol 
# and instructions found on the class booklet, including latching the 
# data and sending the correspoding bits in their corresponding order.

# The name of the fourth file is ultrasonicsensor.S and its first purpose is to setup the 
# ultrasonic sensor and send an echo. In addition, this file is responsible 
# for reading the byte from PINB and setting the pinbstate to either 1
# or 0, depending on the current state of pin 1 in PINB. If pin 1
# is 1, that means that an echo was sent. If pin 1 is 0, that means that 
# the echo was reacived "back".

# ********Purpose of the Lab************** 
# The purpose of the lab is to combine labs 7, 8, and 9
# into a "LARGE/FINAL" project. These labs will interact with 
# one another and will simulate a "windmill" that will turn off if an 
# object gets too close. The remote control will represent the
# master shut off.

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# April 30, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******

# The ultrasonic sensor will constantly send and receive an echo and the ISR will 
# measure this time difference and store this number into 
# variable totduration, which is a long integer type. 

# The input is a botton pressed by the user from the remote control.
# This botton is represented as two bytes by the IR receiver. We assume
# that the user pressed one of the 5 allowed bottons. If the user 
# inputted another botton other than one of these 5, nothing 
# will happen (i.e. the hardware will still be the "same" ).

# There is no input from the user when it comes to the photoresistors
# per say but the .ino file will send a value to the .S (in the form of a parameter) 
# when the readAD function is called. For example, in our .ino 
# file we will call the function like this "readAD( 2 );" because we 
# will connect the photoresister to socket A2 of the A/D interface. 
# The paramater, therefore, represents the A/D socket which we want 
# to use. The other "input" we will be using is the light of the 
# current environment which the photoresistor is found.

# The output will depend on how far away an object is from the sensor.
# If an object is 5 inches or closer, the LED will turn on, the motor will not spin, 
# and the user cannot use the controler. If the object is 8 inches or less away from 
# the sensor but > 5 inches, then the LED light will turn on, but the motor will
# continue to spin. The user can use the remote at this time. If the object is
# 8 inches or more away from the sensor, then the LED light will be off, the motor will 
# spin, and the user can use the remote control. For each of these cases, a message will be printed 
# on the Serial Monitor, depending on how far the object is away from the sensor.

# There are no real assumptions about the input. We assume 
# that the ultrasonic senor will send and reacive echos constantly, 
# which will then change pin 1 in PINB. This will the allow us to 
# change the value of pinbstate. This change of value will then be
# trigger the ISR routine and measure the difference of time and print
# an appropriate message to the user.

# We also assume that the user pressed 
# one of the 5 acceptable buttons on the remote controler. 

# lastly, the assumptions of the "parameter" for the photoresistors is that 
# it will bea number between 0 and 7 since these represent the pin number.
# The assumption about this parameter can also be that it is
# a number between 0 and 5 (i.e. the ANALOG sockets only range from 
# A0 - A5). ULtimately, we assume that the photoresisters are plugged 
# in into the corresponding socket that maps to this parameter value.

# The algorithm for the ultrasensor function is simple:
# set certain pins to high and/or for a certain amount of microseconds.
# This function will setup the ultrasonic sensor and make it send 
# an echo. 

# The algorithm for readPINBState is also simple:
# read in PINB into a register and check if the bit
# corresponding to pin 1 is set or cleared. If set, store 
# a 1 into the global variable pinbstate, else store a 0.

# The algorithm for control is simply to setup the motor. 
 
# The algorithm for controlmotor is a little more complicated.
# We have to store the high and low bytes received from the IR receiver
# into registers. Then traverse through all three data array. It is important 
# to note that we need to compare both the lower and higher bytes, so we need 
# two different labels that will accomplish this. In addition, we only want to traverse 
# through the array 5 times. If a match was not found, store a '.' into 
# the command variable. This indicated that the user inputted an unkown botton.
# If a match is found, store the corresponding character into the shared 
# varible "command" and call the corresponding command. For example, if the
# user pressed the volume up botton, the 'v' into the command variable and
# the turnonLED routine will be called. pop all the registers and return to the caller.
# We do this "traversing" and "cehcking" everytime the user presses a button.   

# The algorithm for initAD is simple: Load the appropriate binary strings
# into arbitrary registers and use the sts command to store them into 
# the corresponding memory addresses. In other words, there is no 
# "algorithm" in function initAD. We are simply doing the desired 
# inizalization specifications that the instructions told us to do. 

# The "algorithm" for readAD is a bit more complicated.
# First, use the add assembly command to add the parameter sent
# through the .ino file (i.e. the parameter is stored in r24)
# in order to send the correct "socket" that wee're using. Send 
# this byte to ADMUX. Set the 6th bit in ADCSRA to 1 in order to start 
# conversion of the analog input to digital. Use a for loop to 
# read in the 8 bits from ADCSRA until the 6th bit is cleared.
# That is, wheenever the bit is cleared, that means that the conversion 
# finished. Store the high byte (ADCH) since this is the value 
# we want to return to the .ino file. Clear r25. Return. 

# ******Test Results******
# Whenever an object was 5 inches or closer to the sensor, the user could not use
# the remote at all. The motor was completly off and the LED light stayed on 
# constantly. Whenever an object was between 5 and 8 inches, the LED light 
# on the breadboard was on, but the motor would still spin
# in the corresponding direction. The user could also use the remote controller
# to control the motor and the LED light. If the object was 8 inches and more away from the
# sensor then the LED was turned off, the user could use the remote, and the motor
# was allowed to spin. NOTE: If the user pressed pause, rewind, or foward, then this
# would stop the motor COMPLETELY, meaning that these three bottons represent the "master shut-off".
# The only way to resart the system is to press the restart button ontop of the arduino. If the user
# pressed the foward botton, for example, the motor would spin clockwise for one second then completely stop.
# The motor CANNOT turn on unless we press the restart button on the arduino.

# ******Answers to Questions******
# There are no questions to answer for this assignment.

# ******Discussion: What I learned. What was easy, What was hard.******
# For this lab, I learned how to combine several projects into one. I also
# learned how to use multiple falgs to accomplish the assignment's objectives.
# I personally thought that this lab was easy beacuse it involved mostly adding C code
# and not really changing the .S files. I did think that keeping track of all the else-if
# conditions was a little confusing and hard. Other than that, the assignment was pretty much
# straight-forward. 

# ******************Contribution of TeamWork*******************
# This was an individual assignment, so no teamwork was used.

# *****************References*************************
# No references were used for this assignment. 

# **********************************End Of Lab Report/Header*****************************
 
*/
 
// Include several header files
// in order to help aid our project.
#include <avr/interrupt.h>
#include <IRremote.h> 

// Declare several variables for enabling remote commands.
int receiver = 10; 
IRrecv irrecv(receiver);  
decode_results results; 

// ********************************** Motorcontroller
// The array we would be sharing with AVR.
extern byte remotecommand[]; 
// Used for int to byte conversion.
unsigned char * onechar; 
// Used for int to byte conversion.
int remotevalue; 
// Used to return the command for the respective remote signal.
extern byte command; 
// If the current command is equivalent to the last command, do nothing!
byte lastcommand; 

// ********************************** Ultrasonic sensor
// Declare two long integers used to store 
// the start time and total duration.
long start_time;
long totduration;

// Extern the pinbstate byte.
extern byte pinbstate;

// Declare two variables that will serve as flags. The first flag will help us flag if the user is too close
// to the sensor. The second flag will help us determine if the user pressed a master shut off button.
int warningFlag = 0;
int masterShutOff = 0;

// extern functions.
extern "C" {

  void initAD( );
  byte readAD( byte );
  void ultrasensor();
  void readPINBState();
  void control();
  void controlMotor();
  void turnonclockwise();
  void turnoffmotor( );
  void turnoncounterclockwise( );
  void turnonlight( );
  void turnofflight( );

} // end extern.

// setup function.
void setup() {

   // Setup the serial communications baud
   Serial.begin( 9600 );

   // ********************************** Photoresisters
   // Call assembly init A/D routine.
   initAD( );

   // ********************************** MotorControl
   // Enable the IR pin connected to PB2 or digital pin 10.
   irrecv.enableIRIn();
   // Setup the motor by calling the control function. 
   control( );
   
   // ********************************** Ultrasonic sensor 
   
   /*
   * Set the bits of the appropriate PCMSKx register high
   * to enable pin change detection on PB1 (port b pin 1). 
   * PCINT1 in our case.
   */ 
   
   PCMSK0 = (1<<PCINT1);
   // Enable the corresponding vector, PCIE0 in our case.
   PCICR = (1<<PCIE0);

   // Enable the interrupt flag
   sei();

} // end setup function.

// loop function.
void loop() {
   
   // ********************************** Ultrasonic sensor
   // Continuously call the ultrasensor function 
   // in order to send the echo.
   ultrasensor();

   // ********************************** Motorcontroller
   // First check if the warningFlag equals to 2. If it does equal to 
   // 2 then user cannot use the remote commands because he/she is too close.
   if( warningFlag != 2 ) {
      
      lastcommand = command;

      // Use an if statement that will check if we received an IR signal.
      if ( irrecv.decode(&results) ) {
         
         Serial.println( "Signal received!" );
         remotevalue = results.value;

         // Use a for loop that will retrive only the last 2 bytes.
         for(size_t i=0; i<2; i++) {
            // Convert the base address of integer 'remotevalue' to an unsigned char address.
            onechar = (unsigned char *)(&remotevalue); 
            // Add the offset to get the respective byte.
            onechar = onechar + i; 
            // Store the byte into 'remotecommand'.
            remotecommand[i] = *onechar;       
         } // end for.

         // To avoid signal interference.
         delay(1000); 
         // Receive the next value.
         irrecv.resume();
    
      } // end if.

      // Check that the user did non shut off the motor at the "master" level. That is, 
      // if the user pressed the master shut off (the pause, rewind, or foward buttons)
      // then he or she turned off the motor compeletly. The only way to restart the program is 
      // to press the reset botton on the arduino board.
      if( masterShutOff != 1 )
         controlMotor(); 
   
      // This will make sure that the same command is not printed multiple times as the 
      // 'results' remembers the last signal until it receives a new one
      if( lastcommand != command )  {
     
         switch( (char) command ) {
         // Print a meaningful message in the Serial Port monitor
         // depending on the corresponding button that was pushed 
         // on the remote controller.  
         case '>':
           Serial.println("Moving motor in clockwise direction!!");
           // Update masterShutOff variable to 1.
           // Motor will not turn on until the reset 
           // botton on the arduino is pushed. 
           masterShutOff = 1;
           // Delay for a second.
           delay(1000);
           // Turn off motor completetly.
           turnoffmotor();
           break;
        case '<':
           Serial.println("Moving motor in counter clockwise direction!!");
           // Update masterShutOff variable to 1.
           // Motor will not turn on until the reset 
           // botton on the arduino is pushed. 
           masterShutOff = 1;
           // Deley for a second.
           delay(1000);
           // Turn off motor completetly.
           turnoffmotor( );
           break;
        case '!':
           Serial.println("Stopping motor!!");
           // Update masterShutOff variable to 1.
           // Motor will not turn on until the reset 
           // botton on the arduino is pushed. 
           masterShutOff = 1;
           break;
        case '^':
           Serial.println("Turn off LED!!");
           break; 
        case 'v':
           Serial.println("Turn on LED!!");
           // Delay a second in order to turn on the LED for a second.
           delay(1000);
           break;
        default:
           Serial.println("Unknown Command");  
         } // end switch
      
      } // end if.

   } // end master if.

   // ********************************** Photoresisters
   // Call assembly read sensor routine, A/D pin #2 and pin #3. 
   // NOTE: The left byte represents the left photoresister while 
   // right byte represents the right photoresister
   
   byte left; 
   byte right; 

   // If WarningFlag is 2 user is too close to the sensor.
   // Turn on the LED and shut off motor completely.
   if( warningFlag == 2 ) {
        turnonlight( );
        turnoffmotor( );   
   } // end if. 

   // If the warningFlag is 1 then the user is getting a little too close to the sensor.
   // Turn on LED but still allow the motor to spin.
   else if(  warningFlag == 1 ) {
      // Turn on LED.
      turnonlight( );
      
      // Read in both photoresistors. Left corresponds to socket 2 while
      // right corresponds to socket 3.
      left = readAD( 2 );
      right = readAD( 3 );

      // Check the three cases: Is left greater than right, 
      // is right grater than left, or are they equal. 
      // If they are equal, turn off motor, else check if they differ by 10.
      // Also check if the masterShutOff flag is 1 (i.e. if the user pressed 
      // the master shut off botton).
      if( left > right ) {
         if( ( left - right ) < 10 )
            turnoffmotor( );
         else{
            if( masterShutOff != 1 )
               turnoncounterclockwise( );
         } // end else
      } // end if.
      else if( right > left ) {
        if( ( right - left ) < 10 )
           turnoffmotor( );
        else{
           if( masterShutOff != 1 )
              turnonclockwise( ); 
        } // end else
      } // end else if
      else {
         turnoffmotor( );
      } // end else.
   } // end else if.

   // If we get to this else then the user is at a safe distance from the user.
   else {
     // Turn off LED since user is at a safe distance.
     turnofflight( );

     // Read in both photoresistors. Left corresponds to socket 2 while
     // right corresponds to socket 3.
     left = readAD( 2 );
     right = readAD( 3 );

     // Check the three cases: Is left greater than right, 
     // is right grater than left, or are they equal. 
     // If they are equal, turn off motor, else check if they differ by 10.
     // Also check if the masterShutOff flag is 1 (i.e. if the user pressed 
     // the master shut off botton).
     if( left > right ) {
         if( ( left - right ) < 10 )
            turnoffmotor( );
         else{ 
            if( masterShutOff != 1 )
               turnoncounterclockwise( );   
         } // end else
      } // end if.
      else if( right > left ) {
        if( ( right - left ) < 10 )
           turnoffmotor( );
        else{
          if( masterShutOff != 1 )
            turnonclockwise( );  
        }// end else
      } // end else ife
      else {
         turnoffmotor( );
      } // end else
   } // end else.

   // Delay one second.
   delay( 1000 );

} // end loop function.

/*
 
  The interrupt service routine that would activate on 
  a value change of PB1
 
 */
 
ISR( PCINT0_vect ) {
  
  /* The echo pin is changed twice
   * 1. First echo pin is set, this is when the echo is sent,
   * record start time in microseconds
   * 2. Then echo pin is cleared, this is when the echo came
   * back, record the end time now.
   */

   // Read the pin b state to know if its 0 or 1
   readPINBState();

   if(pinbstate == 1) {
      // If pinbstate is 1, an echo was sent.
      start_time = micros();
   } // end if.

   if( pinbstate == 0) {
      // If pinbstate is 0, we have reacived the echo back.
      // NOTE: Assume a safe distance is 5 inches. Anything lower 
      // than 5 inches is unsafe. Based on our science, anything
      // that had less than a totalduration of 780 is considered 
      // "too close".

      // Calculate the total time.
      totduration = micros() - start_time;
      
      // If totduration was greater than 1464 (i.e. greater than 8 inches in my case), 
      // then the user is at a safe distance from the sensor. Set warningFlag to 0.
      if( totduration > 1464 ) {
         // Use an if statement that will prevent repetetive and unecessary print outs.
         if( warningFlag != 0 )
            Serial.println( "Safe distance achieved." );
         // Update warningFlag.
         warningFlag = 0;       
      } // end if.

      // If totduration was not greater than 1464 but greater than 812 (i.e. the user
      // is at a distance between 5 to 8 inches), then the user is getting a little too
      // close to the user. Set warningFlag to 1. 
      else if( totduration > 812 ) {
         // Use an if statement that will prevent repetetive and unecessary print outs.
         if( warningFlag != 1 )
            Serial.println( "YIKES: Getting a little TOO close." );
         // Update warningFlag.
         warningFlag = 1;
      } // end if.

      // If none of the cases executed, the user is at a dangerous distance from the sensor.
      // Set warningFlag to 2. In our case, anything closer than 5 inches is considered a
      // dangerous disatance. 
      else {
         // Use an if statement that will prevent repetetive and unecessary print outs.
         if( warningFlag != 2 )
            Serial.println( "WARNING: TOO CLOSE TO THE SENSOR. SHUTTING MOTOR OFF." );
         // Update warningFlag.
         warningFlag = 2;  
      } // end else.
      
   } // end if.
   
} // end ISR function.

