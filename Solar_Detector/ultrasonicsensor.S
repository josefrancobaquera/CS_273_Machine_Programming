
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

# ******Labels******
# There several labels troughout the assembly code. Each label will be explained
# and will have a meaningful comment where it is inizalized. 

# ****Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
# Every branch, jump, and call will have a meaningful message whenever they
# are used. 

# ******Description of Each Global Variables' Use and Purpose******
# Global Variables: 
# -pinbstate: This variable will store either a 1 or a 0. It will be a 1 if 
#             the bit that maps pin 1 in PINB is set. It will store 0 otherwise.
# -ultrasensor: This function is reponsible for setting the sensor and sending an echo.
# -readPINBState: This function is responsible for setting the pinbstate variable to 1 or 0. 

# Setting constants for ultrasonic sensor 
  .set trigpin, 4; port c pin 4
  .set echopin, 1; port b pin 1
  .set PINB, 0x03
  .set DDIRB, 0x04
  .set DDIRC, 0x07
  .set PORTC, 0x08

# Starting the data segment of my code.
.data

   # Define a global variable used to store the current state of
   # PINB
   .comm pinbstate, 1
   .global pinbstate ; used to store the current state of PINB

# macro pushall. pushall will push all the registers into 
# the execution stack.
.macro pushall
  push r16
  push r17
  push r18
  push r19
  push r20
  push r21
  push r22
  push r23
  push r24
  push r25
  push r26
  push r27
  push r28
  push r29
  push r30
  push r31
.endm ; of pushall

# macro popall. popall will pop all the registers off 
# the execution stack.
.macro popall 
  pop r31
  pop r30
  pop r29
  pop r28
  pop r27
  pop r26
  pop r25
  pop r24
  pop r23
  pop r22
  pop r21
  pop r20
  pop r19
  pop r18
  pop r17
  pop r16
.endm ; of popall

   # Starting the program segment of my code.
   .text
   .global ultrasensor
   .global readPINBState
   .extern delayMicroseconds

# ultrasensor label. This label is responsible for setting up the 
# ultrasonic sensor to send an echo.
ultrasensor:

   # Protect all registers.
   pushall

   # Set trig pin to output and echo pin to input
   sbi DDIRC, trigpin
   cbi DDIRB, echopin
   
   # Trig pin is low for 2 microseconds
   cbi PORTC, trigpin
   # call delay2 to delay 2 microseconds.
   call delay2

   # Trig pin is high for 10 microseconds
   sbi PORTC, trigpin
   # call delay10 to delay for 10 microseconds.
   call delay10

   # Finally set trig pin to low, this will send an echo
   cbi PORTC, trigpin
   
   # Pop all registers used.
   popall

   # Return to the caller.
   ret
   
# readPINBState label. This routine is responsible for looking at the echo pin and set the global variable "pinbstate" 
# to 1 or 0 based on the pin.
readPINBState:

   # Protect all registers.
   pushall

   # Read PINB in a register since we want to see if the echo pin has been set
   in r18, PINB 

   # If the echo pin has been set, it means that the echo has been sent, store 1 in 'pinbstate'
   # Side Note: sbrc Rr,b will skip the next instruction if bit b in 
   # register Rr is cleared.
   sbrc r18, echopin
   jmp truelabel
   jmp falselabel
   
# falselabel label. This label is responsible for storing a 0 in pinbstate.
falselabel:
   # If the echo pin has been cleared, it means that the echo might have come 
   # back, store 0 in 'pinbstate'
   ldi r20, 0
   sts pinbstate, r20

   # jmp to done in order to return to the caller.
   jmp done

# truelabel label. This label is responsible for storing a 1 in pinbstate.
truelabel:
   # If the echo pin has been set, it means that the echo might 
   # have not come back, store 1 in 'pinbstate'  
   ldi r20, 1
   sts pinbstate, r20
   
# done label. This label is responsible for poping all
# registers and returning to the caller.   
done:

   # Pop all registers.
   popall

   # Return to the caller.
   ret

# delay10 label. This label is responsible for 
# delaying a total of 10 microseconds.
delay10:

   # Protect registers.
   pushall
   
   # delayMicroseconds uses registers 22 - 25 
   # as its paramters. Store 0x0A on register 22
   # to delay 10 microseconds. 

   ldi r24, 0x0A
   ldi r25, 0x00

   # Call the delayMicroseconds function.
   call delayMicroseconds

   # Pop all registers.
   popall

   # Return to the caller.
   ret
   
# delay2 label. This label is responsible for 
# delaying a total of 2 microseconds.
delay2:

   # Protect all registers.
   pushall
   
   # delayMicroseconds uses registers 22 - 25 
   # as its paramters. Store 0x02 on register 22
   # to delay 2 microseconds. 

   ldi r24, 0x02
   ldi r25, 0x00

   # Call the delayMicroseconds function.
   call delayMicroseconds

   # Pop all registers.
   popall

   # Return to the caller.
   ret
