
# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 6 -- TM1637 I2C 

# ******The Name and Prupose of the Code******

# The name of the first code is Lab6.ino and its purpose is to 
# read in both the humidity and temperature of the envrionment using 
# the DHT11 thermometer. This code is also responsible for displaying
# the temperature and humidity in the serial monitor right before calling
# the assembly function display_symbol. 

# The name of the second code is Lab6.S and 
# its purpose is to "traverse" through the shared 'data' array
# and use the values stored in here to display 
# the corresponding digits/letters on the 4x7 segment display.
# To accomplish this, we must use two other arrays filled with fixed
# values and traverse through them as we traverse through the 
# 'data' array. 

# ********Purpose of the Lab************** 

# The purpose of the lab is to learn how to replace the interaction with the I2X 7 segment
# display with AVR assembly code (that is, replace the C code with assembly code). In addition, 
# the purpose of this lab was to also learn how to use the X, Y, and Z 
# registers to traverse through a memory array. We do this because memory addresses are two 
# bytes in size while registers are only 1 byte in size. Lastly, this lab also reinforced
# the idea of how to shift a binary string and how to use this shift with the BRCC assembly 
# instruction to get one bit from the string at a time. 

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# March 5, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******

# The input is simply 4 numbers, all stored in the 'data' array.

# The assumptions about the input are clear: The 'display' array will have four elements and
# each element will be one of the following numbers: 72, 46, 116, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 68, 79, 78, 69.
# Besides the numbers 0 - 9, the other 7 digits were choosen arbitrarily and are used to 
# represent a 'd', 'o', 'n', 'e', 't', or 'H'. We assume that no other numbers besides the 
# 17 above will be stored in the 'data' array.  

# The output will depend on the particular values assigned to the four elements in the 'data' array.
# The first element in the array will be stored in the first segment, the second element in the 
# array will be stored in the second segment, and so forth. If a 72 is stored as one of the elements
# in the array, then an 'H' will be displayed on the 4x7 display segment. If a 46 is stored as one of the elements
# in the array, then an NOTHING will be displayed on the particular segment (i.e. blank). If a 
# If a 0 is stored as one of the elements in the array, then an '0' will be displayed on the 4x7 display segment.
# This pattern continues for all of the 17 numbers above. A complete list of what numbers will display what
# can be found in the display_table declaration below.

# Only two functions were created for this assignment in the assembly file: sendByte and encodeDigit. The others were already 
# provided to us. 

# The algorithm for the sendByte function is simple: use the logical shift right instruction 
# to shift the binary string stored in R20 a total of 8 times. For each time, if the
# carry flag is 0, call the zeroBit function, else call the oneBit. In essense, this algorithm 
# will send the total 8 bits to the 4x7 segment display, one by one. 

# The algorithm for the encodeDigit function was a little more complicated. First, look at the first 
# element in the 'data' array, then traverse through the display_table until a match is found 
# between the 'data' array and the display_table array. If is important to note that while we
# traverse through the display_table array, we also traverse through the byte_table array. If a match
# is found, store the corresponding value in the byte_table into R20 and call the senByte function (i.e.
# this will be the binary string that will be sent to the 4x7 segment display). Re-declare the registers
# so we point to the BEGINNING of the the display_table and byte_table and repeat the entire process 
# again. In essence, we will do this algorithm a total of 4 times since the 'data' array also 
# has 4 elements.   
   
# ******Test Results******
# The 4x7 segment displayed the correct sequence of digits/letters in the correct segment sequence. 
# To check that the program is actually working, I looked at the serial monitor and tracked
# the humidity and temperature read in form the DH11 thermonitor. When the serial monitor displayed
# a humidity of 45% and a temperature 89.0*F, the 4x7 segment display the following three 
# cases with each case lasting about a second: "H 45", "t 89", "d0nE". Note: The space also 
# takes a place on the segment display. Whenever the DH11 reads a different temperature and humidity,
# the correct digits are displayed on the 4x7 segment display. 

# ******Answers to Questions******
# No questions were assigned in this assignment.

# ******Discussion: What I learned. What was easy, What was hard.******
# I learned many things during this lab. I first learned how to 
# inizialize and use registers X, Y, and Z in a nested loop manner. In other words, 
# I learned how to loop through two arrays at a time while looking for a "key,"
# then making the registers point to the beginning of the array so I can loop 
# again to look for a different or same key (again, this lab was basically using two nested
# loops). I also learned how to use the lsr assembly instruction to shift a binary string
# while using the BRCC command to "see" one bit at a time. Personally, I thought that the 
# shifting of bits was really easy and straightfoward. However, I did find that the implementation 
# of the two nested loops was extremly difficult since it was hard to visualize what we needed
# to code. 

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
#  - display_symbol: 'display_symbol' will be the function resposible for "starting" the process 
#                     of sending the corresponding bits to the TM1637 I2C.
#  - data: 'data' will basically be a 4 element array that will store a number (i.e. this will be done in the Lab6.ino file). We
#           will use the values stored in this array to traverse through the list until we find a match.
# NOTE: sendBrightness, stopBit, and startBit are functions made global by the original .S file provided for 
# us. However, we do not use these functions inside the Lab6.ino file. sendBritness takes care of the 
# 4x7 segment display's brightness while startBit and stopBit takes care of when the 
# segment display will know when to "start" and when to "end" while sending bits. 

# I2C interface is wired to Arduino PORTB bits
# 4 and 5, with 4 being data and 5 being clock,
# so these symbols give us the values needed

   .set PORTB,0x05
   .set DDIRB,0x04
   .set SDA,0 ;; digital pin 8 
   .set SCL,1 ;; digital pin 9 
#
# I2C addresses of the components:
#  7-segment LED: 0x40
#   Position: 0xC0 + 4 bytes
#   Brightness: 0x8a
#  
#  We will be using pull up resistors which means that we have opposite logic about
#  When the value we set is the opposite that is being read by the display
#  This code is based heavily off of the TM1637Display.cpp code found on Github

# Starting the data memory segment.
 
   .data
   .comm data, 4
   .global data  
   .size display_table, 17
   .size byte_table, 17

# display_table will keep track of the corresponding numbers that represent the what are stored.
display_table: # 'H', '.', 't', '0' '1', '2', '3', '4', '5', '6', '7', '8', '9', 'D', 'O', 'N', 'E'    
   .byte 72, 46, 116, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 68, 79, 78, 69 
   
# byte_table will keep track of the corresponding binary numbers that represent the digits/letters.
byte_table: # H, BLANK, t, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, d, o, n, e
   .byte 0b01110110, 0b00000000, 0b01111000, 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111, 0b01011110, 0b00111111, 0b01010100, 0b01111001
   
# external symbol (delay function)
   .extern delay

# Starting the program memory segment. 

   # Make display_symbol global so it can be called from Lab6.ino file.
   .text
   .global display_symbol
   .global sendBrightness
   .global stopBit
   .global startBit

# display_symbol label. This label is the "starting point" of all other function calls. 
display_symbol: 

   # Set the port to the correct IO direction.
   call setupport 

   # Send 7SEG address 
   call sendAddress 

   # Send instruction for each segment.
   call sendPos

   # Set brightness.
   call sendBrightness 

   # All done, return to main program!
   ret 
      
# setuppot label. This label is responsible for setting up the port for TM1637.
setupport: 
      
   # Set pins to input mode.
   cbi   DDIRB,SDA
   cbi   DDIRB,SCL
   cbi   PORTB, SDA
   cbi   PORTB, SCL ;; this means data and clock are high

   # Call the delay function.
   call  delay1 ; wait to make sure PORTB ready

   # Return to the caller.      
   ret 
       
# delay1 label. This label is reponsible for delaying for 1 millisecond.
delay1:

   # Push the registers BEFORE we insert anything to them in order to 
   # keep to safe the original values they had before the sendByte
   # function was called. We do this because the delay function
   # modifies the registers we are using to traverse through the 
   # data array.
   
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

   # Load certain bits on these registers to delay a certain amount of time (milliseconds).   
   ldi  r22, 1
   ldi  r23, 0
   ldi  r24, 0
   ldi  r25, 0

   # Call the delay function.
   call delay
      
   # Every push must pop in order to conserve the original values stored in the registers. Therefore, we pop
   # the registers IN OPPOSITE ORDER that they were pushed.   
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

   # Return to the caller.
   ret

# startBit label. This label is reponsible for the I2C startbit. That is, a high-to-low transition on SDA while clock is high.
startBit:

   sbi   DDIRB,SDA ; set data bit high, maklng data line go low
   call  delay1 ; leave clock high long enough

   # Return to the caller.
   ret

# stopBit label. This label is reponsible for the I2C stopit. That is, a low-to-high transition on SDA while clock is high.
stopBit:

   sbi   DDIRB,SDA ;
   call delay1
   cbi   PORTB,SCL ; set clock high
   cbi   DDIRB, SCL ;  when we turn off one we have to take care of direction
   call  delay1 ; leave clock high long enough
   cbi   PORTB,SDA ; bring up SDA while clock is high
   cbi   DDIRB, SDA ; when we clear port we set input mode
   call  delay1 ; keep clock high for a while

   # Return to the caller.
   ret

# oneBit label. This label is reponsible for the I2C 1 bit transmission. That is, SDA high while clock is high.
oneBit:

   sbi   DDIRB,SCL ; clock goes down due to pull-up 
   call delay1
   cbi   PORTB,SDA ; A clear writes a 1 to the device
   cbi   DDIRB, SDA
   call  delay1 ; leave clock high long enough
   cbi   PORTB,SCL ; finally bring clock low
   cbi   DDIRB, SCL
   call  delay1 ; leave clock low for long enough

   # Return to the caller.
   ret

# zeroBit label. This label is reponsible for the I2C 0 bit transmission. That is, SDA low while clock is high. 
zeroBit:

   sbi   DDIRB,SCL ; clock goes down due to pull-up 
   call delay1
   sbi   DDIRB,SDA ; A clear writes a 1 to the device
   call  delay1 ; leave clock high long enough
   cbi   PORTB,SCL ; finally bring clock low
   cbi   DDIRB, SCL
   call  delay1 ; leave clock low for long enough
   
   # Return to the caller.
   ret

# ack label. This label is reponsible for processing the "acknolwedgment" phase of the data transmission. 
ack:  

   sbi DDIRB, SCL
   cbi PORTB, SDA
   cbi DDIRB, SDA
   call delay1
   cbi PORTB, SCL
   cbi DDIRB, SCL
   call delay1

   sbis PORTB, SDA ;; skip if we have a 0 in this slot as per the arduino code
   sbi DDIRB, SDA
   call delay1
      
   sbi DDIRB, SCL
   call delay1

   # Return to the caller.
   ret

# sendAddress label. This label is reponsible for sending the correct address
# into the 4x7 display segment. 
sendAddress:

   # Push R20 since we want the value to stay unchanged after this function returns.
   push R20

   # Load the corresponding position address into R20.
   ldi R20, 0x40

   # Call startBit to "inizalize" the procedure. Send this byte to the TM1637 display.
   call  startBit  
   call sendByte

   # Call stopbit in order to "end" the procedure.
   call  stopBit

   # Every push must have a pop.
   pop R20

   # Return to the caller.
   ret

# sendPos label. This label is reponsible for sending the correct position, which, 
# in this case is 0xC0.
sendPos:

   # Push R20 since we want the value to stay unchanged after this function returns. 
   push R20

   # Load the corresponding position address into R20.
   ldi R20, 0xC0

   # Call startBit to "inizalize" the procedure. Send this byte to the TM1637 display.
   call startBit
   call sendByte
   
   # Call encodDigit, which will be responsible for displaying the correct digit/letter.
   call encodeDigit

   # Call stopbit in order to "end" the procedure.
   call stopBit

   # Every push must have a pop.
   pop R20

   # Return to the caller.
   ret
   
# encondeDigit label. This label will be responsible for "displaying" the corresponding 
# digit and/or letter on the 4x7 display.  
encodeDigit:

   # Push the registers BEFORE we insert anything to them in order to 
   # keep to safe the original values they had before the sendByte
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
   
   # Use register X for data.  
   ldi R27, hi8(data) ; initialize high byte of X
   ldi R26, lo8(data) ; initialize low byte of X

   # Use register Y for display_table. 
   ldi R29, hi8(display_table) ; initialize high byte of Y
   ldi R28, lo8(display_table) ; initialize low byte of Y

   # Use register Z for byte_table. 
   ldi R31, hi8(byte_table) ; initialize high byte of Z
   ldi R30, lo8(byte_table) ; initialize low byte of Z

   # Load R21 with 4 since we need to traverse through the 
   # data array a total of 4 times.
   ldi R21, 4

# posouterloop label. This label is responsible for traverse trough the data array. 
posouterloop:

   # Load the X register into R17. Place a '+' next to the X since we will 
   # traverse through the list.
   ld R17, X+

# posinnerloop label. This label will be responsible for  traversing through 
# the display_table and byte_table arrays.
posinnerloop:

   # Load the Y register into R18. Place a '+' next to the Y since we will 
   # traverse through the list. Load the Z register into R19. Place a '+' next to 
   # the Z since we will traverse through the list
   ld R18, Y+
   ld R19, Z+ 
   # Compare R17 (data array) with R18(display_table).
   cp R17, R18

   # If R17 and R18 hold the same value (i.e. data array == display_table), a match was
   # found, so no branching is necessary. If they are not equal, branch back to posinnerloop
   # in order to traverse thorough registers Y and Z one more time. 
   BRNE posinnerloop

   # Copy the contents of R19 to R20.
   mov R20, R19

   # Call sendByte in order to send the corresponding byte in R20.   
   call sendByte
  
   # Reinitialize the high and low bytes of display_table in order to allow us to "traverse" 
   # through the list again
   ldi R29, hi8(display_table) 
   ldi R28, lo8(display_table) 

   # Reinitialize the high and low bytes of byte_table in order to allow us to "traverse" 
   # through the list again
   ldi R31, hi8(byte_table) 
   ldi R30, lo8(byte_table) 

   # Decrement R21 and compare it to 0.
   dec R21
   cpi R21, 0

   # If R21 is 0, branch into posouterloop in order to traverse one step foward in "data."
   brne posouterloop

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
   ret

# sendBrightness label. This label is responsible for sending the
# appropriate "brightness" to the TM1637Display.
sendBrightness:

   # Push R20 in order to "save" its information before we call senByte.
   push R20

   # Load the arbitrary britness to R20, then call startBit, sendByte, 
   # and stopBit, all in this order. 
   ldi R20, 0x89
   call  startBit
   call sendByte
   call stopBit

   # Eery push needs a pop, so pop in reverse order.
   pop R20
   
   # Return to the caller.
   ret

# show_one_symbol label. NOTE: This label will not 
# be called and was provided for us to test our code. 
# show_one_symbol: 

   # ********NOTE********: This function was never called. We used it 
   # to test our assembly language. 
   # call  oneBit
   # call  zeroBit
   # call  zeroBit
   # call  zeroBit
   # call  oneBit
   # call  zeroBit
   # call  oneBit
   # call  zeroBit
   # call  ack      
   # ret

# sendByte label. A simple routine which assumes R20 has the Byte in question.
#  We loop through the bits of the R20 (this makes R20 not usable)
#  and sends the appropriate zero or one bit.We send by least 
# significant bit. We then send an ACK at the end
sendByte:

   # Push the registers BEFORE we insert anything to them in order to 
   # keep to safe the original values they had before the sendByte
   # function was called.

   push R20
   push R21

   # Load register R21 with 8 since we want to send a total of 8 bits.
   ldi R21, 8

# sendloop label. This label will allow us to "shift the bits" to the left for the 8 bits 
# inside R20. We will essentially shift the bits 8 times.
sendloop:
   lsr R20
   # Branch to sendZero if the carry flag is cleared, otherwise 
   # call oneBit. 
   brcc sendZero

   call oneBit
   # Since we already sent the required one bit, 
   # jump to skip so we do not send a zero bit.
   jmp skip

# sendZero label. This label is reponsible for calling 
# the zeroBit function only ONCE.
sendZero:
   call zeroBit

# skip label. This label is reponsible for skipping 
# the call to the zeroBit function.
skip:
   # Decrement R21 and compare the number inside R21 with 0. 
   dec R21
   cpi 21, 0
   # If R21 does not contain 0, branch to sendloop. If it equals
   # 0, skip the branch. This essentially will allow us to 
   # send a total of 8 bits. 
   brne sendloop

   # Call the acknowledgement function in order to make tell the TM1637
   # that information was sent. 
   call ack

   # Every push must pop in order to conserve the original values stored in the registers. Therefore, we pop
   # the registers IN OPPOSITE ORDER that they were pushed. 
   
   pop R21
   pop R20

   # Return to the caller. 
   ret

