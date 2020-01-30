
# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 7 -- Analog to Digital Conversion 

# ******The Name and Prupose of the Code******
# The name of the first code is Lab7.ino and its purpose is to 
# first initialize DIDR0 and ADCSRA by calling
# the initAD( ) function (only once). In addition, Lab7.ino
# will print out the amount of "light" the photoresisters are 
# receiving an infinite number of times through the serial port 
# monitor by calling the readAD( ) function. NOTE: The .ino 
# file will send a paramter to the AVR that will represent the "socket"
# the photoresister is connected to in the A/D interface. The purpose of the 
# Lab7.S file is to implement the initAD and readAD functions.
# In essence, these functions are reponsible for initialization
# an reading in a value (i.e. analog to digital convertion). 

# ********Purpose of the Lab************** 
# The purpose of the lab is to implement assembly code that 
# sucessfully converts an analog input into a digital value.
# If done correctly, we will be able to use this convertion
# to sucessfully print out (in HEX) the light that the photoresistors 
# reading. The lab also reinforces the idea of using parameter passing
# and returning values between the .ino and .S files.  

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# March 29, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******

# There is no input from the user per say but the .ino file will 
# send a value to the .S (in the form of a parameter) 
# when the readAD function is called. For example, in our .ino 
# file we will call the function like this "readAD( 2 );" because we 
# will connect the photoresister to socket A2 of the A/D interface. 
# The paramater, therefore, represents the A/D socket which we want 
# to use. The other "input" we will be using is the light of the 
# current environment which the photoresistor is found.

# The output will be the amount of "light" that the photoresistors
# are reading in. This output will be in a form of 1 byte, hexadecimal
# number. The lower the hexadecimal number the lower the "light"
# (i.e. 0x00 represents total darkeness) while the higher the 
# hexadecimal number the higher the "light" (i.e. 0xFF represents
# the "highest" light).

# The assumptions of this input "parameter" is that it will be
# a number between 0 and 7 since these represent the pin number.
# The assumption about this parameter can also be that it si 
# a number between 0 and 5 (i.e. the ANALOG sockets only range from 
# A0 - A5). ULtimately, we assume that the photoresisters are plugged 
# in into the corresponding socket that maps to this parameter value.

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
# Whenever the program was uploaded into the ARDUINO environment, 
# it started printing out in the Serial monitor a series of 
# hexadecimal values ranging from 0x00 to 0xF6. Whenever we placed 
# a flashlight close to the photoresister, a larger hexadecimal number 
# was printed. Whenever we tried enclosing the photoresister 
# with out hands (i.e. making it dark), the Serial monitor began 
# printing a lower hexadeimal number.  

# ******Answers to Questions******

# 1)  What was the lowest value you saw from the photoresistor?
# Answer: The lowest value I saw from the photoresistor was 0 (i.e. 0x00).

# 2)  What was the highest value you saw from the photoresistor?
# Answer: The highest value I saw from the photoresistor was F6 (i.e. 0xF6).

# 3)  Our A/D conversion mechanism has the ability to create 1024 distinct values, why did your output not have 1024 values?
# Answer: The reason why my output did not have 1024 values is because we set 
# it up so when we fetch the result from ADCH, we only fetch the "high" byte (i.e. a total of 8 bits)
# and we ignore ADCL, which includes the 2 least significant bits for the 10 bit digit value. In other
# words, we ignore the other 2 least significant bits stored in ADCL. Our A/D conversion mechanism 
# returns 10 bits (this is were the number 1024 comes from since 2^10 = 1024), but since we ignore the two 
# least significant bits, we actually only have 2^8 = 256 values. 

# ******Discussion: What I learned. What was easy, What was hard.******
# I learned how to use DIDR0, ADCSRA, ADMUX, and ADCH to sucessfully
# convert a analog input into digital. I also learned that this conversion 
# takes time, so we need a loop that will wait until the conversion is done.
# Lastly, I learned how to use parameter passing and returning a value
# between .ino and .S files. For example, for this lab, r24 was the register
# that stored the parameter passed in the .ino file.

# I personally thought that the lab as a whole was easy and straightfoward
# since the only thing twe did was writing and reading from memory.
# The only part of the lab that was hard was learning which assembly command to use
# when we want to know when a specific bit in a byte is cleared. Other
# than that, this lab was pretty easy.

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

   # In DIDR0, set ADC[0-5]D all to 1 to turn off digital input buffers. This will make 
   # all pins at PORTC "analog." If we want to make certain ports in C as "digital,"
   # we would need to place a 0 into the corresponding bit. (Ex: 0b00111110 would make
   # sockets A5-A1 analog while socket A0 digital).
   ldi r17, 0b00111111
   sts DIDR0, r17

   # In ADCSRA we initialize ADEN to 1 (turn on A/D), ADPS2-0 to 111 (divide system 
   # clock by 128), and the rest bits to 0.
   ldi r18, 0b10000111
   sts ADCSRA, r18
   
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
