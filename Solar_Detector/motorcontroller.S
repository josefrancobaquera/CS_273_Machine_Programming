
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
# -remotecommand: This data array will store the low and high bytes inputted from 
#                 the remote when a user presses a button. 
# -command: This global variable will map the corresponding character to the 
#           the botton pressed by the remote. 
# -control: This global function will make the routine provided to us a 
#           a TOTAL OF THREE TIMES. 
# -controlMotor: This global function will be called every time the 
#                IR receiver reads a value. 
# -turnonlight: This function will turn on the LED light on the breadboard.
# -turnofflight: This function will turn off the LED light on the breadboard.
# -turnoncounterclockwise: This function will turn on the motor counterclockwise.
# -turnonclockwise: This function will turn on the motor clockwise.
# -turnoffmotor: This function will turn off the motor completely. 

# Set several variables in order to make the programming easier. These 
# memory addresses were already given to us.

# Constants for motor:

   # On port B:
   .set PORTB,0x05
   .set DDIRB,0x04
   .set PINB, 0x03
   .set MOTDATA,0
   .set MOTLATCH,4
   .set M1ENABLE,3
   .set BOARDLED, 5
   .set SWITCH2, 2
      
   # On port D:
   .set PORTD,0x0B
   .set DDIRD,0x0A
   .set MOTCLOCK,4
   .set M2ENABLE,3
   .set M4ENABLE,6
   .set M3ENABLE,5
            
# Constants for LED:

   # On port C:
   .set PORTC, 0x08
   .set DDIRC, 0x07
   .set DIDR0, 0x007E

# Macros to push and pop registers without writing them multiple times
# Fun fact : One would prefer a function over macro but you cannot use a function that 
# pushes onto stack, why? 

# Macro to push all registers.
.macro pushall 
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
.endm

# Macro to pop all registers.
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
.endm

# Starting the data memory segment.

   .data
   .comm remotecommand, 2
   .global remotecommand ; For getting the 2 byte remote command sent from the .ino side

   .comm command, 1
   .global command ; To return the respective command for a button press

   # All low bytes in order of 'commandcode'.
   commandlowbyte: 
   .byte 0xFD, 0xDD, 0x3D,  0x57, 0x1F

   # All high bytes in order of 'commandcode'.
   commandhighbyte:  
   .byte 0x02, 0x22, 0xC2, 0xA8, 0xE0  

   # Command codes -- where '>' means forward (clockwise), '<' means backward (counter clockwise), 
   # '!' means stop motor '^' means turn a LED off and 'v' mean turn a LED on.
   # You should set command to one of these values based on the values in 
   # remotecommand, '.' for not found 
   commandcode: 
   .byte '>', '<', '!', 'v', '^', '.'
     
   # Store the maximum number of commands.
   commandlen: 
   .byte 5

# Starting the program memory segment.
   .text
   .global control
   .global controlMotor
   .global turnonlight
   .global turnofflight
   .global turnoncounterclockwise
   .global turnonclockwise
   .global turnoffmotor
   .extern delay

# control label. This label will be responsible for setting up the motor.
control: 

   # push all the registers.
   pushall

   # Setup the motor protocol.
   call setupMotor

   # pop all registers.
   popall

   # Return to the caller.
   ret  

# setupMotor label. This label is responsible for
# setting up the appropriate ports and pins 
# as outputs.
setupMotor:

   # Protect the used registers.
   push r20
   push r21
   
   # Set ports B and D to be output
   ldi r20, 0b11111001
   out DDIRB, r20
   out DDIRD, r20

   # Setup port C, pin 5 as output.
   ldi r21, 0b00100000
   out DDIRC, r21 

   # Every push must pop.
   pop r21
   pop r20

   # Return to the caller.
   ret 

# remoteCommand label. This label will compare the two bytes 
# of the botton pushed to the data arrays previously defined.
remoteCommand: #  This routine uses the 2 bytes of remote command to determine which of the 
               #  5 inputs are selected
               #  on completion, the shared global variable "command" will be one of 6 values
               #   '<', '>', '!','^','v','.'
                 
   # Push all registers so that 'we' do not overwrite a register used by compiler/linker/loader           
   pushall

   # Use register X to get the bytes stored in the 
   # remotecommand array.  
   ldi r26, lo8(remotecommand) 
   ldi r27, hi8(remotecommand) 

   # Load the high and low bytes that the user inputted 
   # from the remote. 
   ld r20, X+ 
   ld r21, X

   # We now "reuse" register X.
   # Use register X for the commandlowbyte data array. 
   ldi r26, lo8(commandlowbyte) 
   ldi r27, hi8(commandlowbyte) 

   # Use register Y for the commandhighbyte data array.  
   ldi r28, lo8(commandhighbyte)
   ldi r29, hi8(commandhighbyte)

   # Use register Z for the commandcode data array.
   ldi R30, lo8(commandcode)
   ldi R31, hi8(commandcode) 

   # Load the command length to an arbitrary register. 
   lds r19, commandlen

# loop label. This label is reponsible  
# for comparing the bytes entered on the remote
# to the commandlowbyte and commandhighbyte arrays.
loop:
   # We need to traverse through all three data arrays
   # at the same time. Use the X, Y, and Z registers.
   ld r22, X+
   ld r23, Y+
   ld r24, Z+

   # First comapre the low byte, if a match 
   # call branch to the second comparsion, else 
   # fall through. 
   cp R20, r22
   breq secondComparison

   # Decrement r19 (which contains our "counter")
   # and compare to 0. If zero, none of the 5 commands were
   # found, so branch to error.
   dec r19
   cpi r19, 0
   breq error

   # jump to the loop if we haven't found a 
   # match and we still have not traverse through the
   # entire list. 
   jmp loop

# secondComparison label. This label will compare the 
# second byte to make sure that the both bytes match. 
secondComparison:
   cp r21, r23
   breq found
   jmp loop
   
# The error label. If none of the commands 
# matched, load the current character on
# the Z register (which should be a '.').
error:

   # Since we used a Z+ while traversing through the list, 
   # we now only have to store Z into an arbitrary register.
   ld r24, Z
   sts command, r24

   # pop all registers.
   popall

   # Return to the caller.
   ret

# found label. This label is responsible for storing the command
# that was found on register r24.
found:

   sts command, r24
      
   # pop all the registers.
   popall

   # Return to the caller.
   ret 

# controlMotor label. This label will be called from the 
# .ino file and will be the "starter" function.
controlMotor:

   # Push all registers.
   pushall

   # Setup the motor.
   call setupMotor

   # Pattern match the remote command to get a code. Sets up 
   # the "command" variable.
   call remoteCommand

   # Load to command found when we traverse through the array.
   lds r22, command 

   # If the command was a '>' character, we must 
   # make the motor turn clockwise.
   cpi r22, '>'
   breq turnonclockwiseCHECKER

   # If the command was a '<' character, we must 
   # make the motor turn counterclockwise. 
   cpi r22, '<'
   breq turnoncounterclockwiseCHECKER

   # If the command was a '!' character, we must 
   # turn off the motor. 
   cpi r22, '!'
   breq turnoffmotorCHECKER

   # If the command was a 'v' character, we must 
   # turn on the led light. 
   cpi r22, 'v'
   breq turnonlightCHECKER

   # If the command was a '^' character, we must 
   # turn off the led light. 
   cpi r22, '^'
   breq turnofflightCHECKER

   # If none of the above cases match, jump to 
   # finish since an unknown upper and lower byte 
   # was entered/stored.
   jmp finish

# turnonclockwiseCHECKER label. This label will 
# basically call the turnonclockwise function.
turnonclockwiseCHECKER:
   # jmp to finish since we have nothing else to do.
   call turnonclockwise
   jmp finish
   
# turnoncounterclockwiseCHECKER label. This label will 
# basically call the turnoncounterclockwise function.
turnoncounterclockwiseCHECKER:
   call turnoncounterclockwise
   # jmp to finish since we have nothing else to do.
   jmp finish

# turnoffmotorCHECKER label. This label will 
# basically call the turnoffmotor function.
turnoffmotorCHECKER:
   call turnoffmotor
   # jmp to finish since we have nothing else to do.
   jmp finish

# turnonlightCHECKER label. This label will 
# basically call the turnonlight function.
turnonlightCHECKER:
   call turnonlight
   # jmp to finish since we have nothing else to do.
   jmp finish

# turnofflightCHECKER label. This label will 
# basically call the turnofflight function.
turnofflightCHECKER:
   call turnofflight
   # jmp to finish since we have nothing else to do.
   jmp finish
   
# finish label. This label is responsible for
# finishing the control motor protocol.
finish:
      
   # Pop off all the registers. 
   popall

   # Return to the caller.
   ret  

# turnoffmotor label. This label is responsible for 
# turning off the motor.
turnoffmotor:
   
   # Protect the register.
   push r24

   # Turn all motors off.
   ldi r24, 0b00000000
   call sendMotorByte
   
   # Every push must pop.
   pop r24
   
   # Return to the caller.
   ret
   
# turnonclockwise label. This label is responsible 
# for turning the motor clockwise. 
turnonclockwise:

   # Protect the register.
   push r24
   
   # Turn all motors to turn clockwise.
   ldi r24, 0b11011000 
   call sendMotorByte
   
   # Every push must pop.
   pop r24
   
   # Return to the caller
   ret

# turnoncounterclockwise label. This label is responsible 
# for turning the motor counterclockwise. 
turnoncounterclockwise:

   # Protect register.
   push r24
   
   # Turn all motors to turn counterclockwise.
   ldi r24, 0b00100111   
   call sendMotorByte

   # Every push must pop.
   pop r24

   # Return to the caller.
   ret

# turnonlight label. This label is responsible 
# for turning on the LED light connected to PIN5 
# on PORTC.  
turnonlight:
   
   # NOTE: PORTC, PIN5 is already 
   # in output mode since setupMotor already. 
   # made it this way.
   
   # Set PIN5 in PORTC to turn on the LED.
   sbi PORTC, 5

   # Return to the caller.
   ret

# turnofflight label. This label is responsible 
# for turning off the LED light connected to PIN5 
# on PORTC.
turnofflight:
   
   # NOTE: PORTC, PIN5 is already 
   # in output mode since setupMotor already. 
   # made it this way.

   # Clear PIN5 in PORTC to turn off the LED.
   cbi PORTC, 5

   # Return to the caller.
   ret
   
# delay1 label. This label, when called, will delay for
# 1 millisecond, or about 1 second.
delay1:
   pushall
   ldi r22, 0x01
   ldi r23, 0x00
   ldi r24, 0x00
   ldi r25, 0x00
   # Call the delay function.
   call delay
   popall

   # Return to the caller.
   ret 
      
# delayTwoSeconds label. This label, when called, will delay for
# 2000 milliseconds, or about 2 seconds.
delayTwoSeconds:
   pushall
   ldi r22, 0xD0
   ldi r23, 0x07
   ldi r24, 0x00
   ldi r25, 0x00
   # Call the delay function.
   call delay
   popall  

   # Return to the caller.
   ret 
      
# delayThreeSeconds label. This label, when called, will delay for
# 3000 milliseconds, or about 3 seconds.
delayThreeSeconds:
   pushall
   ldi r22, 0xB8
   ldi r23, 0x0B
   ldi r24, 0x00
   ldi r25, 0x00
   # Call the delay function.
   call delay
   popall 

   # Return to the caller.
   ret 

# delayFiveSeconds label. This label, when called, will delay for
# 5096 milliseconds, or about 5 seconds.
delayFiveSeconds:
   pushall     
   ldi r22, 0xe8
   ldi r23, 0x13
   ldi r24, 0x00
   ldi r25, 0x00
   # Call the delay function.
   call delay 
   popall 

   # Return to the caller.
   ret 
      
# sendOneBit label. This label is 
# responsible for the 1 bit transmission.
sendOneBit:

   # Send a 1 bit to MOTDATA of the moter byte to the shift register.
   sbi PORTB, MOTDATA
   
   # Set the data clock (MOTOCLOCK) to high for at least 
   # 1 ms.
   sbi PORTD, MOTCLOCK
   call delay1

   # Clear the motor clock signal (MOTOCLOCK) back to low.
   cbi PORTD, MOTCLOCK

   # Clear the MOTDATA bit so you're ready for the next bit.
   cbi PORTB, MOTDATA
   
   # Delay for at least 1 ms before sending the next bit.
   call delay1

   # Return to the caller.
   ret

# sendZeroBit label. This label is 
# responsible for the 0 bit transmission.
sendZeroBit:
   
   # Send a 0 bit to MOTDATA of the moter byte to the shift register.
   cbi PORTB, MOTDATA
   
   # Set the data clock (MOTOCLOCK) to high for at least 
   # 1 ms.
   sbi PORTD, MOTCLOCK
   call delay1

   # Clear the motor clock signal (MOTOCLOCK) back to low.
   cbi PORTD, MOTCLOCK

   # Clear the MOTDATA bit so you're ready for the next bit.
   cbi PORTB, MOTDATA
   
   # Delay for at least 1 ms before sending the next bit.
   call delay1

   # Return to the caller.
   ret
   
# latchData label. This label is responsible for 
# making sure that latch is enabled (one) in order to release 
# the control pattern to the motor driver chips 
latchData:
   sbi   PORTB,MOTLATCH
   call  delay1
   # Make sure PWM outputs are on
   sbi   PORTB, M1ENABLE
   sbi   PORTD, M2ENABLE
   sbi   PORTD, M3ENABLE
   sbi   PORTD, M4ENABLE

   # Return to the caller.
   ret

# latchReset label. This label is responsible for
# reseting the latch clock (MOTLATCH) by clearing the 
# corresponding bit.     
latchReset: 
   # Latch should be zero in order to send the control 
   # pattern to shift register. 
   cbi   PORTB,MOTLATCH
   call  delay1

   # Return to the caller.
   ret

# sendMotorByte label. This label is responsible for sending
# the corresponding bit sequence to the MOTDATA.
sendMotorByte: 
   # Assumes r24 has the byte we want to send.
   push  r15
   push  r16
   mov   r15, r24
   # Clear/Reset the latch (MOTLATCH).
   call  latchReset
   ldi   r16, 8
# smbloop label. This label is responsible for 
# serving as a "loop" that will loop for 
# a total of 8 times. 
smbloop:
   # Use a logical shift to store one bit 
   # at a time in the C flag in SREG. Use this 
   # to call either a zero bit or a 1 bit to MOTDATA.
   lsl   r15
   brcs  smbone
   call  sendZeroBit  
   # Jump to smbdone to check if we have looped a 
   # total of 8 times. 
   rjmp  smbdone
# smbone label. This label, when called, will 
# send a 1 bit to MOTDATA.
smbone:
   call  sendOneBit
# smbdone label. This label is responsible for 
# checking if we have looped a total of 8 times.
smbdone:

   # Decrement r16 (i.e. our "counting" register) and
   # branch if we have not yet reached 0.
   dec   r16
   brne  smbloop
      
   # Latch the data to the output by setting
   # the latch clock signal (MOTLATCH) to high.
   call  latchData
      
   # Set the PWD outputs to high. NOTE: We are using only 
   # MOTOR2. Therefore, only turn on MOTOR2 while turning off all the 
   # other motors.
   cbi PORTB, M1ENABLE
   sbi PORTD, M2ENABLE
   cbi PORTD, M3ENABLE
   cbi PORTD, M4ENABLE

   # Reset the latch clock (i.e. this is part of the protocol).
   call  latchReset

   # Every push must pop.
   pop   r16
   pop   r15

   # Return to the caller.
   ret
