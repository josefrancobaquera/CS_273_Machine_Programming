
# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 5 -- Multiplexing 

# ******The Name and Prupose of the Code******
# The name of the first code is Lab5.ino and its purpose is to 
# first setup PORTB and PORTD as outputs. It will then 
# call a function called do_avr_version() an infinitely
# number of times. This function will then call the display_segment( )
# function ten times, with each time changing the global variables 'segment'
# and 'digit'. 

# The name of the second code is Lab5.S and it has several 
# purposes. The first purpose is to set PORTB and PORTD as output modes. 
# The second purpose is to use the values of 'segment' and 'digit'(set 
# by Lab5.ino) to display the correct digit in the correct segment. For example, if 
# segment = 0 and digit = 9, the function display_segment will display
# the digit 9 in segment 0. 

# ********Purpose of the Lab************** 

# The purpose of the lab is to implement multiplexing, which is the process of using 
# "the same set of operations to different components by selecting the address of the 
# sub-component and then issueing the same commands to that sub-component." In other words, 
# the puspose of this lab is similar to that of Lab4 since it we will use the X, Y, and Z 
# registers to traverse the list. We do this because memory locations are two 
# bytes in length while registers are only 1 byte in length.In addition, this lab 
# reinforced the idea of pushing and poping registers.

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# February 26, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******

# The assumptions about the input are clear: 'segment' can only be a number between 0
# and 4. In addition, digit can only be a number between 0 and 9. In addition, we assume
# that the setup_ports function is called before the display_segment function.  

# The output will depend on the particular values assigned to 'segment' and 'digit.' The current
# output is display a 0 in segment 0, a 1 in segment 1, a 2 in segment 2, a 3 in segment 3, 
# a 4 in segment 0, a 5 in segment 1, a 6 in segment 2, a 7 in segment 3, a 8 in segment 0, and 
# a 9 in segment 1. 

# The algorithm for the do_avr_version() function in the file Lab5.ino 
# is to have a loop set the shared variable values of 'segment' and 'digit'
# and call the the display_segment a total of 9 times for each loop iteration.

# There is no real algorithm for the setup_ports function in Lab5.S. We are just setting 
# the data directories.  

# The algorithm for the display_segment is to use the X, Y, and, Z registers as a way 
# to traverse trough the segment_table, portb_table, and portd_table arrays. We first set the 
# corresponding segment using the shared, global variable'segment'. In essense, I used 
# a "while" loop that will check if 'segment' is zero. While its not zero, traverse, trough the
# display_segment array, decrement segment, then check if segment is zero. If it is zero, we exit
# the "loop" and output the appriopriate PORTB. We then have to find the correct digit to display.
# To do this, a simliar algorithm was implemented in the sense that we use a while loop that will check if 
# the shared global variable 'digit'. Use this 'while' loop to traverse through BOTH memory arrays 
# of portb_table label and portb_table label.
   
# ******Test Results******
# The 4x7 segment displayed the correct sequence of digits in the correct segment sequence. That
# is, a 0 in segment 0, a 1 in segment 1, a 2 in segment 2, a 3 in segment 3, 
# a 4 in segment 0, a 5 in segment 1, a 6 in segment 2, a 7 in segment 3, a 8 in segment 0, and 
# a 9 in segment 1. Whenever I changed all segment's and digit's in Lab5.S to 1, 
# the digit 1 flashed 10 times in segment 1, which is what we expected. 

# ******Answers to Questions******
# No questions were assigned in this assignment.

# ******Discussion: What I learned. What was easy, What was hard.******
# I learned many things during this lab. I first learned how to 
# inizialize and use registers Z, Y, and Z. In addition, I learned how
# to use these registers to access 2 byte memory locations. I learned how to use
# the '+' infront of the variables X, Y, and Z in order to "traverse" trough
# the memory locations. In addition, I learned how to use the 
# sbi and cbi commands to clear specific bits. This will come particularly
# helpful since we do not need an OUT to use the sbi and cbi instructions. 
# I personally thought that traversing the the lists were easy. I also thought that
# setting the data directives was easy. In contrast, I thought that using the
# sbi and cbi commands were a little confusing at first. 

# ******************Contribution of TeamWork*******************
# This was an individual assignment, so no teamwork was used.

# *****************References*************************
# No references were used for this assignment. 

# **********************************End Of Lab Report/Header*****************************

# ******Labels******
# There are several labels troughout the assembly code. Each label will be explained
# and will have a meaningful comment where it is inizalized. 

# ****Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
# Every branch, jump, and call will have a meaningful message whenever they
# are used. 

# ******Description of Each Global Variables' Use and Purpose******
# Global Variables: 
#  - setup_ports: 'setup_ports' will be the function resposible for setting PORTB and PORTD as outputs.
#  - display_segment: 'display_segment" will be the function responsible for setting the correct
#         segement and digit to be displayed. In other words, this function will have TWO purposes.  
#  - segment : 'segment' will keep track of the segment location that we want the digit to be displayed. 
#           For example, if segment = 0, then the digit will be displayed on the first segment.
#  - digit : 'digit' will keep track of the digit that we want to display. For example, if digit = 8, then
#           the AVR will display the digit 8 into the corresponding segment in the 4x7 segment display.  

# Starting the program memory segment. 

# Starting the data memory segment.

   .data

   # segment_table will be 4 bytes in size while portb_table and portd_table will be 
   # both 10 bytes in size.
   
   .size segment_table, 4
   .size portb_table, 10
   .size portd_table, 10

# segment_table label. This label will keep track of what pins/sockets go with certain segments. That is, pin 9 = segment 0, pin 10 = segment 1, 
# pin 11 = segment 2, pin 12 = segment 3. All of these are in PORTB  
segment_table:  
    .byte 0b00000010, 0b00000100, 0b00001000, 0b00010000 

# portb_table label. This label will keep track of the list of binary sequences for setting PORTB.    
portb_table: 
    .byte 1, 1, 0, 0, 0, 0, 0, 1, 0, 0

# portd_table label. This label will keep track of the list of binary sequences for setting PORTD. 
portd_table: 
   .byte 0b00000011, 0b11100111, 0b10010011, 0b11000011, 0b01100111, 0b01001011, 0b00001011, 0b11100011, 0b00000011, 0b01000011

   #'segment' is the common name fot the segment while 'digit' is the common name for the digit.
   # Make them global so they can be used outside this file. 

   .comm segment, 1 
   .comm digit, 1 
   .global segment, digit
   # Make a static variable named PORTB in order to make sbi and cbi clearer.  
   .equ PORTB, 0x05
 
# Starting the program memory segment. 

# Make the setup_port and display_segment labels global so it can be called from 
# the Lab5.ino file. 

   .text 
   .global setup_ports
   .global display_segment

# setup_ports label. This label will be responsible for setting the data direction of 
# port B and port D. (i.e. DDRB and DDRD). 
setup_ports:
  
  # Push the registers BEFORE we insert anything to them in order to 
  # keep to safe the original values they had before the setup_ports
  # function was called.
  
  push r17
  push r18

  # We must first set the data direction of pins 2 - 7, which are part of 
  # port d. NOTE: 1 means output while 0 means input. 
  
  ldi r17, 0b11111100
  out 0x0A, r17

  # We must first set the data direction of pins 8 - 12, which are part of 
  # port b. NOTE: 1 means output while 0 means input. 

  ldi r18, 0b00011111
  out 0x04, r18

  # Every push must pop in order to conserve the original values stored in the registers. Therefore, we pop
  # the registers IN OPPOSITE ORDER that they were pushed. 

  pop r18
  pop r17
  
  # Return to the caller. 
  ret

# display_segment label. This label will be responsible for display the correct digit
# in the correct segment by using the 'segment' and 'digit' global variables.
display_segment:

   # Push the registers BEFORE we insert anything to them in order to 
   # keep to safe the original values they had before the display_segment
   # function was called.

   push R31
   push R30
   push R29
   push R28
   push R27
   push R26
   push R20
   push R19
   push R18
   push R17
 
   # Initialize the high and low bytes of the memory addresses. 

   # Use register Z for portb_table.   
   ldi R31, hi8(portb_table) ; initialize high byte of Z
   ldi R30, lo8(portb_table) ; initialize low byte of Z

   # Use register Y for portd_table.   
   ldi R29, hi8(portd_table) ; initialize high byte of Y
   ldi R28, lo8(portd_table) ; initialize low byte of Y

   # Use register X for segment_table.   
   ldi R27, hi8(segment_table) ; initialize high byte of X
   ldi R26, lo8(segment_table) ; initialize low byte of X

   # Use two trivial registers that will store the values of 'digit' and'segment'
   # set by the Lab5.ino file.
   lds R20, digit
   lds R21, segment

# segment_increment label. This label will, in essence, help us "traverse" through the "array" 
# of values segment_table.. 
segment_increment:
   # Load R17 with register X.
   ld R17, X+
   # Compare R21 with zero. If its zero, branch into segment_found.
   cpi R21, 0
   # Branch into segment_found if R21 is equal to zero.
   BREQ segment_found
   # Decrement R21.
   dec R21
   # Jump back to the beginning of the "loop" (i.e. back to label segment_increment). 
   jmp segment_increment

# segment_found label. This label will be responsible for choosing the correct segment to display
# the digit.
segment_found:
   out 0x05, R17

# digit_increment label. This label is reponsible for "traversing" the "array" of values
# in portb_table and portd_table. 
digit_increment:

   # Load R19 and R20 with the Z and Y registers.
   ld R19, Z+ 
   ld R18, Y+

   # Compare R20 (i.e. digit) to zero. If its zero, branch into digit found. Else decrement
   # R20 and jump into this "loop" again.      
   cpi R20, 0
   # Branch into digit_found if R20 iszero.
   BREQ digit_found
   # Decrement R20.
   dec R20
   # Jump back to the beginning of the "loop" (i.e. back to label digit_increment). 
   jmp digit_increment

# digit_found label. If R20 becomes zero, that means that a digit was found.
digit_found:
   # Display the corresponding digit on the corresponsing segment.
   out 0x0B, R18

   # We will now use a compare to check if we need to clear or set the last bit on PORTB.
   cpi R19, 0
   # If we need to turn this "middle" segment in the digit, branch into the
   # turn_offfunction. Else, continue to the turn_on function.
   breq turn_off

# Author NOTE:'sbi PORTB, 0' sets the last bit to 1 and 'cbi PORTB, 0' sets the last bit to 0

# turn_on label. This label will be responsible for setting the last bit 
# of PORTB to 1. 
turn_on:
   sbi PORTB, 0
   # No more actions are needed, so jump to end_checking. 
   jmp end_checking

# turn_off label. This label will be reponsible for clearing the last bit of PORTB.
turn_off:
   # Clear the last bit of PORTB. 
   cbi PORTB, 0
  
# end_checking label. This will be used as a "dummy." That is, if jumped into, no more actions
# will be taken (except poping the registers). In other words, if jumped into this label, the
# function display_segment will return after the registers are poped.   
end_checking:

   # Every push must pop in order to conserve the original values stored in the registers. Therefore, we pop
   # the registers IN OPPOSITE ORDER that they were pushed. 

   pop R17
   pop R18
   pop R19
   pop R20
   pop R26
   pop R27
   pop R28
   pop R29
   pop R30
   pop R31
   
   # Return to the caller.
   ret
