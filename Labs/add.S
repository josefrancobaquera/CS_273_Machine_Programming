
# *********************************************************************************************

# ******The Name and Prupose of the Code******
# The name of the code is add.S and its purpose
# is to serve as the assembly code for Lab2.ino. 
# The assembly code will use the values the 
# user inputed and perform the following 
# equation calculation: x3 = 2 * (x1 + 1) + (x2 - 1) + (x3 - 3).
# In addition, whenver the 'addition' function is called, 
# the LED within the arduino will also turn on.

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# January 31, 2018

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******
# The algorithm is simple. Declare three variables, one 
# for each user input, and make them global. Then
# declare the addition label, and also make it global.
# Load 0b00100000 to r18, then output it to the adresses 0x04, then 0x05 (this
# will turn on the LED). Load the contents of variables x1, x2, and x3 
# (which were the values that the user inputted) into registers r18, 
# r17, and r19, respectively. Load the integers -1, 1, and -3 into
# registers r21, r22, and r23, respectively. Add registers r18 and r21, then add
# registers r18 with istelf in order to simulate multiplication by two. Then add r19 and
# r22, then r20 and r22. We then add all the operands together by adding registers
# r18 and 19, then r18 and r20. The final answer is located in r18, so the last important
# step is to store it back to variable address x3. (Basically, the algorithm here is
# to perform one calculation at a times since the number of registers is 
# finite and limited. Return to the caller. There was no output 
# for the code per say but the contents of address x3 were changed to the final answer 
# to the calulation. We assume that the all three inputs are two digit integers (i.e. the only
# accetable numbers that the user can input ranges from 01 to 99). 

# ******Test Results******
# Here was some of the test results.
#    Three 2 digits inputted          Output:
#    10, 10, 10                       38
#    09, 12, 13                       41
#    21, 23, 95                       158
# Note: No bugs were found while testing these user inputs.
# All outputs matched the predicted results.

# ******Answers to Questions if Applicable******
# No questions were provided to answer.

# ******What I learned. What was easy, What was hard.******
# I learned how to turn on the LED light located in PORTB. I
# also learned how to use the add, ldi, lds, .data, .text, .comm,
# sts, and ret commands. In addition, I learned how to use addition 
# as a way to avoid multiplication. Everything was easy except turning
# on the LED since it was confusing that we start counting bits at 0,
# not 1. 

# **********************************************************************************

# ******Description of Each Global Variables' Use and Purpose******
# Global Variables: 
#  - x1: This will keep track of the address of the first decimal number 
#        inputted by the user. We will use it compute arithmetic calulations. 
#  - x2: This will keep track of the address of the second decimal number 
#        inputted by the user. We will use it compute arithmetic calulations.
#  - x3: This will keep track of the address of the third decimal number 
#        inputted by the user. We will use it compute arithmetic calulations. 

# ******Labels******
#  - addition: This label will allow the assembly language to calulate arthinmetic and
#              turn on the LED light whenever the function is called.  

# ******Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
# No branch, jump, or call were used in this code. 'ret' returns to the caller.

# Here are the three global variables. x1 will be the address of the first decimal
# number inputted by the user, x2 will be the address of the second decimal inputted by 
# the user, and x3 will be the address of the second decimal inputted by the user. 
    
    .data
    .comm x1,1
    .global x1
    .comm x2,1
    .global x2
    .comm x3,1
    .global x3

#
# Program code (addition function)
#
    .text
    .global addition

# This is the addition label, which will allow the assembly language to calulate 
# arthinmetic and turn on the LED light whenever the function is called. 
    
addition:

   # The following lines of code
   # will allow us to turn on the LED light whenever
   # the addition function is called. 
   
   # First we need to output a 1 in the bit 5 position on I/O 
   # address 0x04, which is the adress that sets the data direction attributes for PORTB.
   
   ldi r18, 0b00100000
   out 0x04, r18

   # Then we have to output a 1 in the bit 5 position in the
   # on I/0 address 0x05, which is the data access adress of PORTB.

   ldi r18, 0b00100000
   out 0x05, r18

   # Load registers with the contents of locations x1, x2, and x3. 
   
   lds  r18, x1
   lds  r19, x2
   lds  r20, x3

   # Load the required decimal numbers that are needed to compute
   # the required calculation.

   ldi  r21, 1
   ldi  r22, -1
   ldi  r23, -3

   # This will essentially add the first decimal number inputted by the 
   # user with one. Then we will add the result with itself in order to
   # 'mimic' multiplication by 2.

   add  r18, r21
   add  r18, r18

   # This will assentially add the second decimal number inputted by the 
   # user with -1.
   
   add  r19, r22

   # This will assentially add the third decimal number inputted by the 
   # user with -3.
   
   add  r20, r23

   # Add both results previously calulated with the contents of r18.

   add  r18, r19
   add  r18, r20

   # Change the contents of address x3 by copying to it the contents of r18.

   sts  x3, r18
  
   # Return to the caller after all arthimetic calulations are completed.
   
   ret   
