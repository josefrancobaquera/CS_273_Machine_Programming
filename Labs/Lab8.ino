/*
# ******************************Lab Report/Header************************************

# Lab Number and Title: Lab Number 8 -- Motor Controller with Remote Control 

# ******The Name and Prupose of the Code******
# The name of the first code is Lab8.ino and it has several purposes.
# Its first purpose is to enable the IR pin connected to PB2 or digital pin 10.
# The code will then call the function called "control" 
# in the assembly file. Its last purpose is to get the input 
# from the remote controller (using the IR receiver) and storing 
# the two low bytes in a shared array called "remotecommand." Once 
# these two bytes are found, it will then call the controlMotor function 
# found in the assembly file and then it will print out a meaningful message if
# the new command was different from the previous one. This "get remote 
# input and call the controlMotor function" is called indefinetly. 

# The name of the second code is Lab8.S and it also has several 
# and important purposes. Its first pupose is to implement 
# the control function which will turn the motor in one direction 
# for 3 seconds, then stop it for 2 seconds, turn it the opposite 
# direction for 2 seconds again, stop the motor, then turn on the
# LED for 3 seconds, then turn it off. This process will repeat three times.
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

# ********Purpose of the Lab************** 
# The purpose of the lab is to implement assembly code that 
# sucessfully traverses through three arrays to match the two 
# bytes found in the .ino file. In other words, this lab reinforced 
# the idea that we sometimes need two arrays to traverse and match 
# two bytes because registers can only store at most one byte. 
# In addition, the lab indirectly forced students to do a little 
# bit of "trial and error" as well as "science" since the two 
# bytes of the remote controller were not given to us; we had to 
# find them ourselves by printing the remoteCommand array. 
# The last purpose of the lab was to teach us how to follow the motor shield 
# protocol in the correct manner. 

# ******Author's Name****** 
# Jose Franco Baquera

# ******Date****** 
# April 12, 2018

# ******************Description of the Solution************** 
# The description of the solution can be found in the next section.  

# ******A Description of the Algorithm Used Which Includes****** 
# ******Input, Output, and Assumptions About the Input******

# The input is a botton pressed by the user from the remote control.
# This botton is represented as two bytes by the IR receiver. We assume
# that the user pressed one of the 5 allowed bottons. If the user 
# inputted another botton other than one of these 5, nothing 
# will happen (i.e. the hardware will still be the "same" ).

# The output will be the equivalent command in both 
# the hardware and the Serial monitor. For example, if 
# the user pressed the pause botton, the routine will print the 
# message "Stopping motor!!" and will stop the motor. If the user
# pressed the volume up botton, the ruotine will print "Turn on LED!!" 
# and will turn on the connected LED. If the user pressed the 
# foward botton the routine will print "Moving motor in clockwise direction!!"
# and will turn the motor in the clockwise direction, .... and so forth. 
# Each of the corresponding outputs was given to us in the assignment. 

# Again, the assumptions about the input is that the user pressed 
# one of the 5 acceptable buttons. 

# The algorithm for control is the follwoing: push all registers,
# call the appropriate routine (i.e. make the motor rotate in one direction
# for three seconds, stop for two seconds, rotate the motor in opposite direction
# for three seconds, stop, turn on the LED for three seconds, then turn it off)
# three times by using a register to "count" the number of times we called 
# the routine. Once we call the routines three times, pop off all the 
# registers and return to the caller.
 
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

# ******Test Results******
# Whenever I pressed the volume up botton, the LED 
# was turned on and the message "Turn on LED!!" was 
# displayed. When I pressed the volume down botton, 
# the LED light was truned off and the message "Turn off LED!!"
# was displayed. When I pressed the other three button, the correct
# message and output occured. When I pressed the 0 botton, 
# the message "unknown command" was printed and nothing more occured. 

# ******Answers to Questions******
# This assignment had no question to answer.

# ******Discussion: What I learned. What was easy, What was hard.******
# For this lab I learned how to turn on (in both directions) the motor
# as well as how to turn it off. I also learned how to print out the
# corresponding bytes that were received by the IR receiver when 
# the user pressed a botton. Lasty, I learned how to connect user 
# input from the remote control to the connect motor and LED.

# I personally thought that the lab as a whole was easy and straightfoward
# since the only thing twe did was writing and reading from memory and comparing
# registers. In addition, we had already done something similar on Lab6 
# when we sent one bit at a time. I thought that figuring out which byte was the low
# and which one was the high was also a little difficult, but some trial and error
# helped me figured it out. 

# ******************Contribution of TeamWork*******************
# This was an individual assignment, so no teamwork was used.

# *****************References*************************
# No references were used for this assignment. 

# **********************************End Of Lab Report/Header*****************************

*/

// Library for remote sensing.
#include <IRremote.h> 
// PB2 or Digital pin 10 used for remote sensing.
int receiver = 10;
// Create instance of 'irrecv'. 
IRrecv irrecv(receiver);  
// Create instance of 'decode_results'.
decode_results results;   

/*
 * The signal received from the remote is a 24 bit value and thus needs to be stored as an integer that is 4 bytes (32 bits),
 * however, since our AVR likes bytes more than int we will convert 'int' to 'byte[4]'. Also, only the last 2 bytes are important for 
 * us and ** don't forget that we working on a little endian system **.
*/

// The array we would be sharing with AVR.
extern byte remotecommand[]; 
// Used for int to byte conversion.
unsigned char * onechar; 
// Used for int to byte conversion.
int remotevalue; 
// Used to return the command for the respective remote signal.
extern byte command; 
// If the current command is equivalent to the last command, do nothing!
byte lastcommand; 

// Extern the functions we will need.
extern "C" {
  void control();
  void controlMotor();
} // end extern.

// setup function.
void setup() {
  // Begin serial communication.
  Serial.begin(9600); 
  // Enable the IR pin connected to PB2 or digital pin 10.
  irrecv.enableIRIn(); 
  // Call the control function ONCE. NOTE: The control function has a loop
  // that will turn on/off the LED and motor a total of THREE TIMES.
  // Dr. Cooper told us to include this "loop" of three times. 
  control();
} // end steup function. 

// This loop reads from the IR receiver and places the byte codes generated by the receiver.
// There are unique pairs of bytes for each button pressed.
// The goal is to determine the byte pairs for the keys we want to use and then
// to have AVR run the specific subcommands and provide back via the "command" shared variable
// what was selected so that we can put something to the Serial screen

// loop function.
void loop() {
  lastcommand = command;

  // Use an if statement that will check if we received an IR signal.
  if ( irrecv.decode(&results) ) {
    Serial.println( "Signal received!" );
    remotevalue = results.value;

    // Use a for loop that will retrive only the last 2 bytes.
    for(size_t i=0; i<2; i++) {
      
      // Convert the base address of integer 'remotevalue' to an unsigned char address.
      onechar = (unsigned char *)(&remotevalue); 
      // Add the offset to get the respective byte.
      onechar = onechar + i; 
      // Store the byte into 'remotecommand'.
      remotecommand[i] = *onechar; 
      
    } // end for.

    // To avoid signal interference.
    delay(1000); 
    // Receive the next value.
    irrecv.resume();
    
  } // end if.
  
  // The following three lines of commented code were used to 
  // find the high and low bytes of the specific bottons on the
  // remote control.

  // Serial.println( remotecommand[0], HEX );
  // Serial.println( remotecommand[1], HEX );
  // delay(1000);
  
   controlMotor(); 
   
   // This will make sure that the same command is not printed multiple times as the 
   // 'results' remembers the last signal until it receives a new one
   if( lastcommand != command )  {
     
      switch( (char) command ) {

      // Print a meaningful message in the Serial Port monitor
      // depending on the corresponding button that was pushed 
      // on the remote controller.  
      case '>':
        Serial.println("Moving motor in clockwise direction!!");
        break;
      case '<':
       Serial.println("Moving motor in counter clockwise direction!!");
        break;
      case '!':
        Serial.println("Stopping motor!!");
        break;
      case '^':
        Serial.println("Turn off LED!!");
        break; 
      case 'v':
       Serial.println("Turn on LED!!");
        break;
      default:
         Serial.println("Unknown Command");
         
      } // end switch
      
   } // end if.
   
} // end loop function..
