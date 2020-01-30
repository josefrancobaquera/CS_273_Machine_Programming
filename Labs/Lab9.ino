/*

# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 9 -- UltraSonic Sensor 

# ******The Name and Prupose of the Code******
# The name of the first code is Lab9.ino and it has several purposes.
# Its first purpose is to implement/setup the interrupt service routine 
# (i.e. ISR). The code will then constatnly call the ultrasensor()
# function in order to continously send an "echo" in order to 
# measure the distance an object is away from the sensor.
# The file also has the ISR function that will calculate the
# total time (in microseconds) that it took to send and 
# receive the "echo". If this time was less than 812 microseconds,
# then we conclude that an object is less than 5 inches away from the sensor, 
# which is not a safe distance. If the object is to close, the procedure will 
# print a warning message, else a "safe dsitance achived" will be printed. 

# The name of the second code is Lab9.S and it also has several 
# and important purposes. Its first purpose is to setup the 
# ultrasonix sensor and send an echo. In addition, this file is responsible 
# for reading the byte from PINB and setting the pinbstate to either 1
# or 0, depending on the current state of pin 1 in PINB. If pin 1
# is 1, that means that an echo was sent. If pin 1 is 0, that means that 
# the echo was reacived "back".

# ********Purpose of the Lab************** 
# The purpose of the lab is to learn how to use 
# an interrupt service routine (ISR) to sucessfully
# measure the distance between the ultrasonic sensor and
# an object. In addition, the purpose of the lab was to 
# learn how to convert the time it took for the ultrasonic sensor 
# to send and receive the echo into a distance using the
# "science" (i.e. trial and error).

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# April 19, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******

# There is no "real" input from the user for this lab. The ultrasonic sensor
# will constantly send and receive an echo and the ISR will 
# measure this time difference and store this number into 
# variable totduration, which is a long integer type.

# The output will be either "WARNING: TOO CLOSE TO THE SENSOR" 
# or "Safe distance achieved" on the serial monitor, depending
# on how close an object is to the sensor. If the object is less than 
# 5 inches away from the sensor, the the warning string will be printed.
# If the object is 5 or more inches away from the sensor, then the object
# will be in a "safe distance" away from the senor.

# There are no real assumptions about the input. We assume 
# that the ultrasonic senor will send and reacive echos constantly, 
# which will then change pin 1 in PINB. This will the allow us to 
# change the value of pinbstate. This change of value will then be
# trigger the ISR routine and measure the difference of time and print
# an appropriate message to the user.

# The algorithm for the ultrasensor function is simple:
# set certain pins to high and/or for a certain amount of microseconds.
# This function will setup the ultrasonic sensor and make it send 
# an echo. 

# The algorithm for readPINBState is also simple:
# read in PINB into a register and check if the bit
# corresponding to pin 1 is set or cleared. If set, store 
# a 1 into the global variable pinbstate, else store a 0.

# ******Test Results******
# Whenever I placed an object 5 inches or more away from the sensor, the monitor
# only displayed "Safe distance achieved", which is what we expected. If I placed a 
# object less than 5 inches away from the senor, the message "WARNING: TOO CLOSE TO THE SENSOR"
# was displayed. NOTE: When I placed an object right next to the sensor (i.e. a distance of 0 inches),
# the monitor displayed "Safe distance achieved". This occurs because this particular 
# sensor fails when an object is 0.787 inches or less next to it.

# ******Answers to Questions******

   # 1) Take 5 different distance measurements noting the exact distance.  Report these values.
   # Here are several distance measurements of my ultrasonic sensor. 
   # Actual Distance:         Amount of time transpired (i.e. totduration value in microseconds):
     # 1 inch                 256 microseconds
     # 2 inches               400 microseconds
     # 5 inches               812  microseconds
     # 6 inches               960 microseconds
     # 8 inches               1464 microseconds
   
   # 2) Calculate how many microseconds one foot is.  Show your work.
   
   # First Way:
   # Use the equation Distance= (time * speed of sound)/2.
   # We note that the equation can be written as time = (2*distance)/speed of sound.
   # Note: This equation only works if we convert 1 foot into cm. 
   # 1 foot is about 30.48 cm and the speed of sound is about 0.0343 cm per microsecond.
   # Therefore, 1 foot is about (2*30.48)/0.0343 = 1777.25 microseconds.
   # 1 foot is about 1777.25 microseconds.
   
   # Second Way (Less Precise):
   # We know that there are 12 inches in a foot. From question 1, we note
   # that it took about 960 microseconds to measure 6 inches. Therefore, 
   # by basic arithmetic: 
   # Total microseconds in one foot = 2 * total time of 6 inches = 2 * 960 = 1920 microseconds
   # ANSWER: One foot is ABOUT 1920 microseconds. NOTE: This answer will vary form user to user
   # since the hardware is different for all of us.
  
   # 3) What is the minimum and maximum effective measuring distance of the device?  Provide a link along with your answer
   # According to the website randomnerdtutorials, the minimum effective distance is about 2 cm (or 0.02 meters) while its
   # maximum effective distance is about 400 cm (or 4 meters). Here is the devices range
   # in several units:
   # Range in cm: 2 cm - 400 cm
   # Range in meters: 0.02 m - 4 m
   # Range in inches: 0.787 inches - 157.48 inches
   # Here is the link where I got the information from: https://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/

   # 4) Is it possible for our ISR to be interrupted with another PINB, pin 1 state change? 
   # No, it is impossible for our ISR to be interrupted with another PINB, pin 1 state change
   # because the I flag in the SREG register is cleared once our ISR is called. This means that the
   # hardware cannot be interrupted during this time. Once our ISR is finished, the I flag is set back
   # to 1. Another way to to describe this is by the following: Our ISR routine cannot be interrupted by
   # another ISR because the I flag is cleared during this period time. 

# ******Discussion: What I learned. What was easy, What was hard.******
# For this lab I learned how to use an interrupt service routine (ISR)
# to accopmlish the task of measuring the ditsance between the sensor and an object.
# I also learned how to use the delayMicroseconds function and which registers it 
# uses as its parameters.

# I personally thought that the lab as a whole was easy and straightfoward
# since the intructions on what to fix were given to us in both the
# .ino and .S files. In addition, the "science" of converting 
# microseconds to inches was also pretty easy.

# ******************Contribution of TeamWork*******************
# This was an individual assignment, so no teamwork was used.

# *****************References*************************
# We used the following websites to answer some the lab questions: 
# https://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/
# https://circuitdigest.com/microcontroller-projects/arduino-ultrasonic-sensor-based-distance-measurement


# **********************************End Of Lab Report/Header*****************************

*/

// Include the header file for the 
// interrupt vector.
#include <avr/interrupt.h>
// Declare two long integers used to store 
// the start time and total duration.
long start_time;
long totduration;

// Extern the pinbstate byte.
extern byte pinbstate;

// Extern the appropriate functions from the 
// assembly file.
extern "C" {
  
  void ultrasensor();
  void readPINBState();
  
} // end extern.

// Setup function.
void setup() {
  
  Serial.begin(9600);
  
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
  
} // end setup.

// loop function.
void loop() {

  // Continuously call the ultrasensor function 
  // in order to send the echo.
  ultrasensor();
  // Delay a second
  delay(1000); 
  
} // end loop.

/*
 * The interrupt service routine that would activate on 
 * a value change of PB1
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

      Serial.print( "Reported Difference: " );
      Serial.println( totduration, DEC );
      
      // If totalduration was 812 or less, print a warning.
      if( totduration < 812 ) {
         Serial.println( "*****WARNING: TOO CLOSE TO THE SENSOR*****\n" );
      } // end if.
      else {
        // Else print that the user is at a safe distance.
        Serial.println( "Safe distance achieved\n" );
      } // end else.
      
   } // end if.
   
} // end ISR function.

