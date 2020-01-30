
# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 3: Nonlinear Program Execution and Body Bat Monitor

# ******The Name and Prupose of the Code******
# The name of the code is FatMonitor.S and its purpose
# is to serve as the assembly code for Lab3.ino. 
# The assembly code will use the values the 
# user inputed and deteremine the user's gender, age, and 
# body fat by using several branch statements. 
# If the user is considered 'low', the blue LED light will blink.
# If the user is considered 'normal', the green LED light will blink. 
# If the user is considered 'high', the red LED light will blink.
# Lastly, if the the user is considered 'very high', all three
# LED lights will stay on without blinking. It is important to note
# that only hexadecimal numbers are inputted by the user.

# ********Purpose of the Lab************** 
# The purpose of the lab was to use nonlinear program execution
# to blink the blue, green, or red LED lights individually, as well as all three at the 
# same time with no blinking. The blinking of the lights should be directly 
# related to the three hexidecimal numbers inputted by the user.  

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# February 7, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******
# There is no "input" in the sense that there is no assembly code 
# with the 'IN' instruction. However, the user will input 
# three hexadecimal numbers. The first hexadecimal number will 
# represent the user's gender, the second hexadecimal number will represent 
# the user's age, and the last hexadecimal number inputted will represent
# the user's body fat. The output in this code will be to memory address 0x04, which 
# is the memory address of DDRB and memory address 0x05, which the memory address of 
# PORTB. If the user is considered low, we will outpuy the bit sequence 0b00100000, 
# which is the sequence for PORTB 5/Scoket 13/Blue LED. If the user is considered normal, we will 
# output the bit sequence 0b00010000, which is the sequence for PORTB 4/Scoket 12/Green LED. 
# If the user is considered high, we will output the bit sequence 0b00000001, which is
# the sequence for PORTB 0/Scoket 8/Red LED. If the user is considered very high, we will 
# output the bit sequence 0b00110001, which is the sequence for PORTB 0, 4, 5/Scokets 8, 
# 12, 13/All Three Colors. We assume that the user inputted valid hexadecimal values. If the user did input
# an invalid number (e.g. an age smaller than 20), error cases exist in the code that will 
# terminate the program.The algorithm is simple: compare the values inputted by the 
# user with the fixed values given in the problem. For this code, I used only the
# 'CPI' assembly instruction since we are comparing registers with numbers, not registers
  
# ******Test Results******
# Here was some of the test results.
# When we inputted 0x01, 0x3E, and 0x24 (in this order), the red LED light blinked.
# This is the output we expected. When we inputted 0x02, 0x3B, and 0x08 (in this order), 
# the blue LED light blinked. This is the output we expected. When we inputted 0x01, 
# 0x2A, and 0x66 (in this order), all three LED lights turned on without blinking.This is the 
# output we expected. When we inputted 0x01, 0x13, and 0x14 (in this order), none of the LED
# lights turned on or blinked. This is the output we expected since 0x19 is not a valid age range.   
# While testing these and other inputs, several bugs were found in my code. For example, 
# there were times when all lights would turn on instead of blinking only a certain LED. This was
# my code had wrong limits and branches (e.g. I thought that BRLO stood for "branch if same or higher"
# instead of "branch if lower"). In additition, my LEDs sometimes blinked too faint, 
# which was because I sent the incorrect bit string to the I/O address of PORTB.   

# ******Answer to Question******

# Gender      Hex      Age      Hex      Body Fat     Hex      Light

# F           0x01     42       0x2A     32           0x20     Green Blinking
# M           0x02     25       0x19     48           0x30     All Lights (No Blinking)
# F           0x01     30       0x1E     21           0x15     Green Blinking
# M           0x02     23       0x17     17           0x11     Green Blinking

# ******Discussion: What I learned. What was easy, What was hard.******
# Essentially, this lab taught me how to use assembly language, inlcuding how 
# to load numberical values directly into registers (ldi), how to load the contents
# of a memory location into registers (lds), how to store the contents of a register
# into a memory address (sts), how to compare a register with a immidiate value (cpi), how
# to jump to any given label (jmp), and how to branch into a specific label after we
# use the 'cpi' instruction (brlo, brsh, breq, etc.). I also learned how specific sockets 
# in the arduino board are connected with certain I/O ports in PORTB. Lastly, I learned how
# to setup my LED lights with the breadboard and the arduino. Personally, I thought
# that using the conditional assembly intruction 'cpi' was the easiest part of the lab
# since we could compare registers directly with a number. I also thought that setting up
# the LED lights with the arduino and breadboard was pretty easy. The part of the lab 
# that I found extremly difficult was how to use branch and jump statements correctly. 
# In addition, whenever my code got too long, compiling errors became promident since
# the lines of code between branches and certain labels were a lot. Fixing these errors by
# using more trivial labels and jump statements became extremly tedious. 

# ******************Contribution of TeamWork*******************
# This was an individual assignment, so no teamwork was used.

# *****************References*************************
# No references were used for this assignment. 

# **********************************End Of Lab Report/Header*****************************

# ******Labels******
# There are several labels troughout the assembly code. Each label will be explained
# and will have a meaningful comment where it is inizalized. 

# ****Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
# All branches, jumps, and calls will have a meaningful comment.

# ******Description of Each Global Variables' Use and Purpose******
# Global Variables: 
#  - gender: This will be the memory address that refers to the first hexidecimal 
#         number inputted by the user. We will use this address to copy its contents
#         into a R18 and compare it to certain values. 
#  - age: This will be the memory address that refers to the second hexidecimal 
#         number inputted by the user. We will use this address to copy its contents
#         into a R19 and compare it to certain values.
#  - fat: This will be the memory address that refers to the third hexidecimal 
#         number inputted by the user. We will use this address to copy its contents
#         into a R20 and compare it to certain values.
#  - lightup: This function will be global since it will be called outside 
#         this file. 

# Here are the three global variables. gender will be the address of the first hexadecimal
# number inputted by the user, age will be the address of the second hexadecimal number inputted by 
# the user, and fat will be the address of the thrid hexadecimal number inputted by the user.

  .data
  .comm gender, 1
  .global gender
  .comm age, 1
  .global age
  .comm fat, 1
  .global fat

  .text
  .global lightup

# lightup label. This is the function
# that will be called by Lab3.ino to
# check the gender, age, and body that 
# the user inputed and turn on the corresponding 
# LED lights. 

lightup: 

  lds r18, gender
  lds r19, age
  lds r20, fat

  # Load a register that will be responsable for turn on the LED lights.

  ldi r21, 0b00000000

  # First make sure that all the LED's are originally off.

  # NOTE: 0x04 is the I/O address of DDRB and 0x05 is the 
  # I/O address of PORTB.

  out 0x04, r21   
  out 0x05, r21  

  # First check if the user is a male or a female. 
  # A female is hexidecimal 0x01 while a male is 
  # hexidecimal 0x02

  # Figuring out the gender that user inputted. If 
  # it equal to 0x01, the user is a female, 
  # so branch into the female function. If the user
  # inputted 0x02, then his gender is male, so branch 
  # into the female function. If the user inputted 
  # anything else, return to the calling function. 

  cpi r18, 0x01

  # Branch to female function.
  breq female
  
  cpi r18, 0x02
  
  # Branch to male function.
  breq male

  # Return if the user inputted anything else (i.e. an "error").
  ret

# female label. This will execute if the user inputed
# 0x01 as its gender (i.e. female).

female:

  # Compare the age inputed by the user.

  # If the user inputed an age lower than 20, return to the caller.
  # Otherwise branch to continueOne In order to keep the program running.
  cpi r19, 20
  brsh continueOne
  jmp error

# continueOne label. This label will allow us to continue
# the program. This is required since the error function
# is too way down the code.

continueOne:

  # If the user inputed an age lower than 40, branch into youngFemale.
  cpi r19, 40
  brlo youngFemale

  # If the user inputed an age lower than 60, branch into middleFemale.
  cpi r19, 60
  brlo middleFemale

  # If the user inputed an age lower than 80, branch into olderFemale.
  cpi r19, 80
  brlo olderFemale

  # If the user inputed any other age, return to the caller.
  ret

# male label. This will execute if the user inputed
# 0x02 as its gender (i.e. male).
  
male:

  # Compare the age inputed by the user.

  # If the user inputed an age lower than 20, return to the caller.
  cpi r19, 20
  brsh continueTwo
  jmp error

# continueTwo label. This label will allow us to continue
# the program. This is required since the error function
# is too way down the code.

continueTwo:

  # If the user inputed an age lower than 40, branch into youngMale.
  cpi r19, 40
  brlo youngMale

  # If the user inputed an age lower than 60, branch into middleMale.
  cpi r19, 60
  brlo middleMale

  # If the user inputed an age lower than 80, branch into olderMale.
  cpi r19, 80
  brlo olderMale

  # If the user inputed any other age, return to the caller.
  ret

# youngFemale label. This label will take care of
# females ages between 20 and 39 (inclusive).

youngFemale:

  # We need to compare the body fat that the user inputed.

  # If the female inputed a body fat of lower than 21, then she
  # is "low." Branch into the low function that will make the 
  # blue LED blink.
  cpi r20, 21 
  brlo low

  # If the female inputed a body fat of lower than 33, then she
  # is "normal." Branch into the normal function that will make the 
  # green LED blink.
  cpi r20, 33 
  brsh continueThree
  jmp normal

# continueThree label. This label will allow us to continue
# the program. This is required since the normal function
# is too way down the code.

continueThree:

  # If the female inputed a body fat of lower than 39, then she
  # is "high." Branch into the high function that will make the 
  # red LED blink.
  cpi r20, 39 
  brsh continueFour
  jmp high

# continueFour label. This label will allow us to continue
# the program. This is required since the high function
# is too way down the code.

continueFour:

  # If the the female entered anything else, jump into
  # the veryHigh function.
  jmp veryHigh

# middleFemale label. This label will take care of
# females ages between 40 and 59 (inclusive).
  
middleFemale:

  # We need to compare the body fat that the user inputed.

  # If the female inputed a body fat of lower than 23, then she
  # is "low." Branch into the low function that will make the 
  # blue LED blink.
  cpi r20, 23 
  brlo low

  # If the female inputed a body fat of lower than 34, then she
  # is "normal." Branch into the normal function that will make the 
  # green LED blink.
  cpi r20, 34 
  brsh continueFive
  jmp normal

# continueFive label. This label will allow us to continue
# the program. This is required since the normal function
# is too way down the code.

continueFive:

  # If the female inputed a body fat of lower than 40, then she
  # is "high." Branch into the high function that will make the 
  # red LED blink.
  cpi r20, 40 
  brsh continueSix
  jmp high

# continueSix label. This label will allow us to continue
# the program. This is required since the high function
# is too way down the code.

continueSix:

   # If the the female entered anything else, jump into
   # the veryHigh function.
   jmp veryHigh

# olderFemale label. This label will take care of
# females ages between 60 and 70 (inclusive).

olderFemale:

   # We need to compare the body fat that the user inputed.

   # If the female inputed a body fat of lower than 24, then she
   # is "low." Branch into the low function that will make the 
   # blue LED blink.
   cpi r20, 24 
   brlo low

   # If the female inputed a body fat of lower than 36, then she
   # is "normal." Branch into the normal function that will make the 
   # green LED blink.
   cpi r20, 36  
   brsh continueTen
   jmp normal

# continueTen label. This label will allow us to continue
# the program. This is required since the normal function
# is too way down the code.

continueTen:

   # If the female inputed a body fat of lower than 42, then she
   # is "high." Branch into the high function that will make the 
   # red LED blink.
   cpi r20, 42 
   brsh continueSeven
   jmp high

# continueSeven label. This label will allow us to continue
# the program. This is required since the high function
# is too way down the code.

continueSeven:

   # If the the female entered anything else, jump into
   # the veryHigh function.
   jmp veryHigh

# youngMale label. This label will take care of
# males ages between 20 and 39 (inclusive).

youngMale:

   # We need to compare the body fat that the user inputed.
   
   # If the male inputed a body fat of lower than 8, then he
   # is "low." Branch into the low function that will make the 
   # blue LED blink.
   cpi r20, 8 
   brlo low

   # If the male inputed a body fat of lower than 20, then he
   # is "normal." Branch into the normal function that will make the 
   # green LED blink.
   cpi r20, 20 
   brlo normal

   # If the male inputed a body fat of lower than 25, then he
   # is "high." Branch into the high function that will make the 
   # red LED blink.
   cpi r20, 25 
   brsh continueEight
   jmp high

# continueEight label. This label will allow us to continue
# the program. This is required since the high function
# is too way down the code.

continueEight:

   # If the the male entered anything else, jump into
   # the veryHigh function.
   jmp veryHigh
   
# middleMale label. This label will take care of
# males ages between 40 and 59 (inclusive).

middleMale:
   
   # We need to compare the body fat that the user inputed.
   
   # If the male inputed a body fat of lower than 11, then he
   # is "low." Branch into the low function that will make the 
   # blue LED blink.
   cpi r20, 11 
   brlo low

   # If the male inputed a body fat of lower than 22, then he
   # is "normal." Branch into the normal function that will make the 
   # green LED blink.
   cpi r20, 22 
   brlo normal

   # If the male inputed a body fat of lower than 28, then he
   # is "high." Branch into the high function that will make the 
   # red LED blink.
   cpi r20, 28
   brsh continueNine
   jmp high

# continueNine label. This label will allow us to continue
# the program. This is required since the high function
# is too way down the code.

continueNine:

   # If the the male entered anything else, jump into
   # the veryHigh function.
   jmp veryHigh

# olderMale label. This label will take care of
# males ages between 60 and 70 (inclusive).

olderMale:

   # We need to compare the body fat that the user inputed.
   
   # If the male inputed a body fat of lower than 13, then he
   # is "low." Branch into the low function that will make the 
   # blue LED blink.
   cpi r20, 13 
   brlo low

   # If the male inputed a body fat of lower than 25, then he
   # is "normal." Branch into the normal function that will make the 
   # green LED blink.
   cpi r20, 25 
   brlo normal

   # If the male inputed a body fat of lower than 30, then he
   # is "high." Branch into the high function that will make the 
   # red LED blink.
   cpi r20, 30
   brlo high

   # If the the male entered anything else, jump into
   # the veryHigh function.
   jmp veryHigh

# low label. This function will make the blue LED light 
# flash, indicating that the user is low in body fat. 

low:

  # Turn on the LED.

  ldi r17, 0b00100000
  out 0x04, r17
  ldi r16, 50

# allOne label. This label is trivial and is used for 
# making the LED light blink.
  
allOne:

  # Turn on the LED light.

  ldi r17, 0b00100000
  out 0x05, r17
  ldi r18, 0xff

# dl1 label. This label is trivial and is used for 
# making the LED light blink.
  
dl1:  

  ldi r19, 0xff

# dl2 label. This label is trivial and is used for 
# making the LED light blink.
  
dl2:

  # Do not do anything for 4 lines of instructions.
  
  nop
  nop
  nop
  nop
  dec r19
  brne dl2
  dec r18
  brne dl1

  # Turn off the LED light.
  
  ldi r17, 0b00000000
  out 0x05, r17
  ldi r18, 0xff

# dl3 label. This label is trivial and is used for 
# making the LED light blink.
  
dl3:  

  ldi r19, 0xff

# dl4 label. This label is trivial and is used for 
# making the LED light blink.
  
dl4: 

  # Do not do anything for 4 lines of instructions. 

  nop
  nop
  nop
  nop
  dec r19
  brne dl4
  dec r18
  brne dl3
  dec r16

  # Branch into allOne to make the light blink one more time. 
  
  brne allOne

  # Return to the caller.
      
  ret
  
# normal label. This function will make the green LED light 
# flash, indicating that the user is normal in body fat. 
      
normal:

  ldi r17, 0b00010000
  out 0x04, r17
  ldi r16, 50

# allTwo label. This label is trivial and is used for 
# making the LED light blink.
  
allTwo: 

  # Turn on the LED.

  ldi r17, 0b00010000
  out 0x05, r17
  ldi r18, 0xff

# dl5 label. This label is trivial and is used for 
# making the LED light blink.
  
dl5:  

  ldi r19, 0xff

# dl6 label. This label is trivial and is used for 
# making the LED light blink.

dl6:  

  nop
  nop
  nop
  nop
  dec r19
  brne dl6
  dec r18
  brne dl5

  # Turn off the LED.
  
  ldi r17, 0b00000000
  out 0x05, r17
  ldi r18, 0xff

# dl7 label. This label is trivial and is used for 
# making the LED light blink.
  
dl7:  

  ldi r19, 0xff

# dl8 label. This label is trivial and is used for 
# making the LED light blink.
  
dl8:  

  nop
  nop
  nop
  nop
  dec r19
  brne dl8
  dec r18
  brne dl7
  dec r16

  # Branch into allTwo to make the light blink one more time
  
  brne allTwo

  # Return to the caller.
      
  ret

# high label. This function will make the red LED light 
# flash, indicating that the user is high in body fat.

high: 

  # Turn on the LED.

  ldi r17, 0b00000001
  out 0x04, r17
  ldi r16, 50

# allThree label. This label is trivial and is used for 
# making the LED light blink.
  
allThree: 

  # Turn on the LED.

  ldi r17, 0b00000001
  out 0x05, r17
  ldi r18, 0xff

# dl9 label. This label is trivial and is used for 
# making the LED light blink.
  
dl9:  

  ldi r19, 0xff

# dl10 label. This label is trivial and is used for 
# making the LED light blink.

dl10:  

  # Do not do anything for 4 lines of instructions.

  nop
  nop
  nop
  nop
  dec r19
  brne dl10
  dec r18
  brne dl9

  # Turn off the LED light.
  
  ldi r17, 0b00000000
  out 0x05, r17
  ldi r18, 0xff

# dl11 label. This label is trivial and is used for 
# making the LED light blink.
  
dl11:  

  ldi r19, 0xff

# dl12 label. This label is trivial and is used for 
# making the LED light blink.
  
dl12: 

  # Do not do anything for 4 lines of instructions.

  nop
  nop
  nop
  nop
  dec r19
  brne dl12
  dec r18
  brne dl11
  dec r16

  # Branch into allThree to make the light blink one more time
  
  brne allThree

  # Return to the caller.
      
  ret

# veryHigh label. If the individual has very high body fat, light up 
# all three LED's without blinking. They should stay 
# lit even after the program ends. 

veryHigh:

  ldi  r18, 0b00110001
  out  0x04, r18   ; 0x04 is I/O address of DDRB
  out  0x05, r18   ; 0x05 is I/O address of PORTB
      
# Error label will take care of the program if the user inputted an invalid hexidecimal number. 

error:

   # Return to the caller.
  
  ret 
