
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
# There three labels troughout the assembly code. Each label will be explained
# and will have a meaningful comment where it is inizalized. 

# ****Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
# Every branch, jump, and call will have a meaningful message whenever they
# are used. 

# ******Description of Each Global Variables' Use and Purpose******
# Global Variables: 
# -initAD: This label will initalize DIDR0 and ADCSRA.
# -readAD: This label will read in an analog input, convert it to digital, and 
#          return it to the .ino file.

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

# Set several variables in order to make the programming easier. These 
# memory addresses were retrived from the lab instruction.

   .set DIDR0, 0x007E
   .set ADCSRA, 0x007A
   .set ADMUX, 0x007C
   .set ADCH, 0x0079
 
# Starting the data memory segment.
# NOTE: There are no data segment for this lab.
  
# Starting the program memory segment.

   .text
   .global initAD
   .global readAD
   
# initAD label. This label will initalize DIDR0 and ADCSRA.
initAD:

   # Protect all registers
   pushall
   
   # In DIDR0, set ADC[2-3]D to 1 in order to turn off digital input buffers. This will make 
   # pins 2 and 3 at PORTC "analog." If we want to make certain ports in C as "digital,"
   # we would need to place a 0 into the corresponding bit. (Ex: 0b00111110 would make
   # sockets A5-A1 analog while socket A0 digital).
   ldi r17, 0b00001100
   sts DIDR0, r17

   # In ADCSRA we initialize ADEN to 1 (turn on A/D), ADPS2-0 to 111 (divide system 
   # clock by 128), and the rest bits to 0.
   ldi r18, 0b10000111
   sts ADCSRA, r18

   # Pop all registers
   popall
   
   # Return to the caller.
   ret

# readAD label. This label is reponsible for reading in an analog input, then 
# converting it to a digital value. This value will then be returned to the
# .ino file.
readAD:
   
   # In ADMUX we set REFS1-REFS0 to 01 (this selects +5V as reference), 
   # ADLAR to 1 (left adjusts output bits), and MUX3-0 to 4 bits 
   # that denote the desired input pin (e.g. pin 5 would be 0101).

   # NOTE: Place the last 4 bits will all be zeros since we 
   # will use the parameter passed in the .ino file.
   ldi r20, 0b01100000
   
   # NOTE: The parameter passed in the .ino file was stored in r24.
   # Therefore, to get the last 4 bits we need, add them to r20.
   add r20, r24

   # Store the resulting byte in ADMUX.
   sts ADMUX, r20
   
   # In ADCSRA, set ADSC to 1 to start a conversion. In other words,
   # when we set the 6th bit to 1, we will start converting 
   # the analog input into digital.
   ldi r21, 0b11000111
   sts ADCSRA, r21
   
# readADSC label. This label is reponsible for serving as a loop.
# This loop will read ADSC until it reads 0. In other words, wait until 
# ADCSRA stops converting. 
readADSC:

   # Load the 8 bits found in ADCSRA. 
   lds r22, ADCSRA
   
   # Side Note: sbrc Rr,b will skip the next instruction if bit b in 
   # register Rr is cleared.
   sbrc r22, 6
   
   # jmp to readADSC again if bit 6 was not cleared. In other words, jmp
   # back to readADSC again if the conversion in ADCSRA has not finished.
   jmp readADSC
   
   # Fetch result byte from ADCH; ignore ADCL which includes the 2 least 
   # significant bits for the 10 bit digital value. NOTE: We will need to 
   # store it in r24 since this is the register used for the return value.
   lds r24, ADCH

   # Note: In returning a 1-byte result in r24, r25 must be cleared.
   clr r25

   # Return to the caller.
   ret
