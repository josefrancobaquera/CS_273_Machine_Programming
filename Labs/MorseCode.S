
# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 4 - Decoding the Morse code

# ******The Name and Prupose of the Code******
# The name of the first code is Lab4.ino and its purpose is to 
# get user input. The first user input will be used to 
# make the arduino blink "GOAGGIES" in morse code given a specific number 
# of times. The second input will be the binary string that represents
# the given morse code in 1's and 0's (i.e. 1 represents a dash 
# while a 0 will represent a dot). This code is responsible for
# calling both the decode_morse and the GoAggies functions. 

# The name of the second code is GoAggies.S. The purpose of this assembly code is to make
# the LED in the arduino blink 'GOAGGIES' in morse code. The number of times that the 
# code will blink this is dependent on user input.

# The name of the last code is MorseCode.S. The purpose of this assembly code is to decode
# a binary string (provided by the user) into its corresponding ascii value. The code uses 
# 0's to represent dots and 1's to represent dashes.

# ********Purpose of the Lab************** 
# The purpose of the first part of the lab is to learn how the push and pop assembly intructions work,
# as well as how to call a assembly function within the code. In addition, this portion of the lab 
# taught students how to use the delay function and what patameters to pass it. 

# The purpose of the second part reinforced push and pop, but emphasized greatly on how
# to use the X, Y, and Z registers. In other words, the second part of the lab emphasized 
# how to "combine" two registers in order to use them to represent 2 bytes. We do this because
# memory locations are two bytes in length while registers are only 1 byte in length. In other words,
# to access RAM, we need two bytes.   

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# February 15, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******
# The assumptions about the input are clear: The user must enter only a two digit 
# number (i.e. 00-99 ) for the first input. In addition, the user cannot enter a 
# morse code message that is longer than 99 characters. This is because 
# the message array is length 100 and the last element is reserved for the null character. 

# The first output will be the LED light in the arduino board blinking 'GOAGGIES'
# in morse code. The second output will be characters in the serial monitor 
# (i.e. A-Z and 0-9). 

# The algorithm for the decodeMorse function in the Lab4.ino 
# file is to go trough the entire string, and while the character is not a 
# space, shift the bits. We increment width everytime this if statement executes.
# If the character is a space, call the decode_morse
# with the produced bit number. After we return from the function, store
# the corresponding ascii value (if any) into an array. Restore the variables 'width'
# and 'val back' to 0. Call once more the decode_morse function after existing the for loop
# in order to take care of the last character. Since we are using a language similar to
# C, we need to add a null character at the end of the character array in order to make
# it a null-terminated string.

# The algorithm for the GoAggies.S assembly code is to call each function that corresponds to
# the appropriate sequence in 'GOAGGIES'. Each of these functions will call to its corresponding 
# dash and/or dot functions. The DASH and DOT functions exactly the same except that they 
# differ in the number of times they call the WAIT function. The WAIT function essentially makes
# the arduino "delay" for 160 milliseconds. This algorithm is somewhat "linear".

# The algorithm for the MorseCode.S is more simple: "traverse" trough the "memory array" until
# we match both variables 'width' and 'val'. If a match is found, store the corresponding ascii 
# character into the 'ascii' variable. It is important to note that the width, ascii character, and
# bit string come in a 3-touple. 
  
# ******Test Results******
# When I inputed a 01 for the first user input, the LED blinked 'GOAGGIES' one time.
# When I inputed a 03 for the first user input, the LED blinked 'GOAGGIES' three times.
# When I inputed a 00 for the first user input, the LED blinked 'GOAGGIES' zero times.
# For the second user input, I first tried to input the following sequence: '1000 100 0' 
# and the arduino printed out BD???????. To fix this, I added another call to the morsecode()
# function and a null character at the end of the array. The reason why the question marks 
# were being printed is because there was no null character in the array, so 'garbage' was being 
# printed out. I then tested the following sequence: 0111 111 000 0. The program then printed out
# JOSE, which the correct output for this specific input. 

# ******Answers to Questions******
# No questions were assigned in this assignment.

# ******Discussion: What I learned. What was easy, What was hard.******
# I learned many things during this lab. I first learned how to 
# inizialize and use registers Z, Y, and Z. In addition, I learned how
# to use these registers to access 2 byte memory locations. I learned how to use
# the '+' infront of the variables X, Y, and Z in order to "traverse" trough
# the memory locations. I also learned how to convert a character string into
# a binary string. Lastly, I learned how to use the delay function inside the
# assembly code. Everything in this lab was easy EXECPT converting a character 
# string into a binary string. I'm still a little confused as to how this algorithm
# works.

# ******************Contribution of TeamWork*******************
# This was an individual assignment, so no teamwork was used.

# *****************References*************************
# No references were used for this assignment. 

# **********************************End Of Lab Report/Header*****************************

# ******Labels******
# NonThere are several labels troughout the assembly code. Each label will be explained
# and will have a meaningful comment where it is inizalized. 

# ****Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
# There are no branches in this code. Each call and return will have a meaningful comment. 

# ******Description of Each Global Variables' Use and Purpose******
# Global Variables: 
#  - val: 'val' will have two purposes. The first purpose will be to store the number
#         the user inputed (i.e. by using accii subtraction) while its second purpose 
#         will be to use it as a way to convert the character string into a binary string. 
#  - width: 'width' will keep track of the length of each sub binary string. That is, width
#           will keep track of each binary string seperated by spaces (e.g. for the string "100 10,"
#           the width of the first number will be 3 while the width of the second number will
#           will be 2. (NOTE: We need this variable because 0b000 == 0b0 in the arduino but not 
#           for our purposes.)
#  - ascii: 'ascii' will keep track of the specific character that each space-seperated binary string
#           represents  (e.g. 1000 represents 'B' in ascii ).
#  - GoAggies: 'GoAggies' will be a global function that will blink 'GOAGGIES' in morse code using the
#              the LED in the arduino code.
#  - decode_morse: 'decode_morse' will be a global function that will decode a binary string inputted by the user
#                   into its corresponding character string. 

# Starting the data memory segment.

   .data

# Binary representation of Morse code: 0: dot; 1: dash. morse_table will represent the 2 bytes of the corresponding 
# memory address. morse_table will first point to the binary number 0b01. 
morse_table: 
   .byte 0b01, 0b1000, 0b1010, 0b100, 0b0, 0b0010, 0b110, 0b0000, 0b00, 0b0111, 0b101, 0b0100, 0b11, 0b10, 0b111, 0b0110, 0b1101, 0b010, 0b000, 0b1, 0b001, 0b0001, 0b011, 0b1001, 0b1011, 0b1100, 0b01111, 0b00111, 0b00011, 0b00001, 0b00000, 0b10000, 0b11000, 0b11100, 0b11110, 0b11111
    
# The number of binary digits in each character. morse_width will represent the 2 bytes of the corresponding 
# memory address. morse_width will first point to the decimal number 2.  
morse_width: 
   .byte 2, 4, 4, 3, 1, 4, 3, 4, 2, 4, 3, 4, 2, 2, 3, 4, 4, 3, 3, 1, 3, 4, 3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
    
# The English symbols encoded by the above Morse code. ascii_table will represent the 2 bytes of the corresponding 
# memory address. ascii_table will first point to the ascii character 'A'.  
ascii_table: 
   .byte 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'

# table_length will represent the 2 bytes of the corresponding memory address. table_length will first point to the decimal 
# number 36, which the length of the table.  
table_length:
   .byte 36

# Global variables val, ascii, and width. EACH OF THESE VARIABLES WILL BE 1 BYTE, NOT 2 BYTES. 'val' will represent the  
# actual bit sequence entered by the user. 'width' will represent the width of the bit sequence entered by the user. 'ascii'
# will represent the ascii character that the specific bit sequence and width represent. 

   .comm val, 1
   .comm width, 1
   .comm ascii, 1
   .global val, ascii, width

# Starting the program memory segment. Make the decode_morse label global so it can be called from 
# the Lab4.ino file.

    .text
    .global decode_morse

  # Creating a label called decode_morse. This label will be the original function that will be called from the
  # Lab4.ino file. This function's prupose is to decode the bit sequences inputted by the user into ascii.

decode_morse:

   # Push the registers BEFORE we insert anything to them in order to 
   # keep to safe the original values they had before the decode_morse
   # function was called.

   push R31
   push R30
   push R29
   push R28
   push R27
   push R26
   push R21
   push R20
   push R19
   push R18
   push R17

   # Initialize the high and low bytes of the memory addresses. 
    
   LDI R31, hi8(morse_table) ; initialize high byte of Z
   LDI R30, lo8(morse_table) ; initialize low byte of Z
   LDI R29, hi8(ascii_table) ; initialize high byte of Y
   LDI R28, lo8(ascii_table) ; initialize low byte of Y
   LDI R27, hi8(morse_width) ; initialize high byte of X
   LDI R26, lo8(morse_width) ; initialize low byte of X
   
   # Load two registers with the width and val values, which were entered by the user. 
   lds r20, val
   lds r21, width
   
   # Creating a label called morseTableIncrement that will allow us to "traverse" the memory array/stack. Note that the '+' character means
   # use the current value of X, THEN increment the two combined bytes by 1.  
   
morseTableIncrement:
   ld r17, X+
   ld r18, Y+
   ld r19, Z+

   # Comparing the arthmetic value of the bit sequence (ex: 0b01 equals to 1 in decimal) with r19, the register responsible for 
   # storing the two bytes of the morse_table memory address.
   cp r20, r19
   # Branch to morseTableIncrement if both the val (i.e. the bit sequence entered by the user) and r19 are not equal.   
   BRNE morseTableIncrement

   # Comparing the width of the bit sequence entered by the user with r17 (i.e. the register that stores the two bytes
   # of the morse_width memory address). We compare both the width and the morse_width bytes since 
   # two bit sequences can have the same arithmetic value (ex: The values 0b0 and 0b0000 are seen the same by the 
   # assembly, that is, both are equal to zero. However, the first one represents one dot while the second one represents 4 dots).   
   cp r21, r17
   # Branch to morseTableIncrement if both the width of the original bit sequence and r17 are not equal.  
   BRNE morseTableIncrement

   # If both the binary string and the width of a specific bit sequence matches, then there is a 
   # corresponding mapped ascii value. Store the corresponding ascii value into the variable 'ascii.' 

   sts ascii, r18

   # Every push must pop in order to conserve the original values stored in the registers. Therefore, we pop
   # the registers IN OPPOSITE ORDER that they were pushed. 

   pop R17
   pop R18
   pop R19
   pop R20
   pop R21
   pop R26
   pop R27
   pop R28
   pop R29
   pop R30
   pop R31

   # Return to the caller.
   
   RET
