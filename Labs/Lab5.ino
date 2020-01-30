/*
 ******************************Lab Report/Header************************************

 Lab Number and Title: Lab Number 5 -- Multiplexing 

 ******The Name and Prupose of the Code******
 The name of the first code is Lab5.ino and its purpose is to 
 first setup PORTB and PORTD as outputs. It will then 
 call a function called do_avr_version() an infinitely
 number of times. This function will then call the display_segment( )
 function ten times, with each time changing the global variables 'segment'
 and 'digit'. 

 The name of the second code is Lab5.S and it has several 
 purposes. The first purpose is to set PORTB and PORTD as output modes. 
 The second purpose is to use the values of 'segment' and 'digit'(set 
 by Lab5.ino) to display the correct digit in the correct segment. For example, if 
 segment = 0 and digit = 9, the function display_segment will display
 the digit 9 in segment 0. 

 ********Purpose of the Lab************** 

 The purpose of the lab is to implement multiplexing, which is the process of using 
 "the same set of operations to different components by selecting the address of the 
 sub-component and then issueing the same commands to that sub-component." In other words, 
 the puspose of this lab is similar to that of Lab4 since it we will use the X, Y, and Z 
 registers to traverse the list. We do this because memory locations are two 
 bytes in length while registers are only 1 byte in length.In addition, this lab 
 reinforced the idea of pushing and poping registers.

 ******Author's Name****** 
 Jose Franco Baquera

 ******Date****** 
 February 26, 2018

 ******************Description of the Solution************** 
 The description of the solution can be found in the next section.  

 ******A Description of the Algorithm Used Which Includes****** 
 ******Input, Output, and Assumptions About the Input******

 The assumptions about the input are clear: 'segment' can only be a number between 0
 and 4. In addition, digit can only be a number between 0 and 9. In addition, we assume
 that the setup_ports function is called before the display_segment function.  

 The output will depend on the particular values assigned to 'segment' and 'digit.' The current
 output is display a 0 in segment 0, a 1 in segment 1, a 2 in segment 2, a 3 in segment 3, 
 a 4 in segment 0, a 5 in segment 1, a 6 in segment 2, a 7 in segment 3, a 8 in segment 0, and 
 a 9 in segment 1. 

 The algorithm for the do_avr_version() function in the file Lab5.ino 
 is to have a loop set the shared variable values of 'segment' and 'digit'
 and call the the display_segment a total of 9 times for each loop iteration.

 There is no real algorithm for the setup_ports function in Lab5.S. We are just setting 
 the data directories.  

 The algorithm for the display_segment is to use the X, Y, and, Z registers as a way 
 to traverse trough the segment_table, portb_table, and portd_table arrays. We first set the 
 corresponding segment using the shared, global variable'segment'. In essense, I used 
 a "while" loop that will check if 'segment' is zero. While its not zero, traverse, trough the
 display_segment array, decrement segment, then check if segment is zero. If it is zero, we exit
 the "loop" and output the appriopriate PORTB. We then have to find the correct digit to display.
 To do this, a simliar algorithm was implemented in the sense that we use a while loop that will check if 
 the shared global variable 'digit'. Use this 'while' loop to traverse through BOTH memory arrays 
 of portb_table label and portb_table label.
   
 ******Test Results******
 The 4x7 segment displayed the correct sequence of digits in the correct segment sequence. That
 is, a 0 in segment 0, a 1 in segment 1, a 2 in segment 2, a 3 in segment 3, 
 a 4 in segment 0, a 5 in segment 1, a 6 in segment 2, a 7 in segment 3, a 8 in segment 0, and 
 a 9 in segment 1. Whenever I changed all segment's and digit's in Lab5.S to 1, 
 the digit 1 flashed 10 times in segment 1, which is what we expected. 

 ******Answers to Questions******
 No questions were assigned in this assignment.

 ******Discussion: What I learned. What was easy, What was hard.******
 I learned many things during this lab. I first learned how to 
 inizialize and use registers Z, Y, and Z. In addition, I learned how
 to use these registers to access 2 byte memory locations. I learned how to use
 the '+' infront of the variables X, Y, and Z in order to "traverse" trough
 the memory locations. In addition, I learned how to use the 
 sbi and cbi commands to clear specific bits. This will come particularly
 helpful since we do not need an OUT to use the sbi and cbi instructions.
 I personally thought that traversing the the lists were easy. I also thought that
 setting the data directives was easy. In contrast, I thought that using the
 sbi and cbi commands were a little confusing at first. 

 ******************Contribution of TeamWork*******************
 This was an individual assignment, so no teamwork was used.

 *****************References*************************
 No references were used for this assignment. 

 **********************************End Of Lab Report/Header*****************************
*/

// Extern certain variables to make them global. 

extern byte segment;
extern byte digit;

// Extern the setup_ports( ) and display_segment functions 
// in order to make them global. 

extern "C" {

   void setup_ports( );
   void display_segment( );
   
} // end extern.

// The setup routine runs once when you press reset.

void setup( ) {                

  // Setup PORTB and PORTD as outputs.
  
  Serial.begin(9600);
  
  setup_ports( ); 
 
} // end setup function.

// The loop routine runs over and over again foreve.
void loop() {

  // Call the equivalent AVR equivalent function that will turn 
  // on the segements.
  do_avr_version();

} // end loop function.

void do_avr_version() {

  // Display the digit zero in the 0 segment.
  segment = 0;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 0;
  display_segment( );
  delay( 1000 );

  // Display the digit one in the 1 segment.
  segment = 1;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 1;
  display_segment( );
  delay( 1000 );

  // Display the digit two in the 2 segment.
  segment = 2;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 2;
  display_segment( );
  delay( 1000 );

  // Display the digit three in the 3 segment.
  segment = 3;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 3;
  display_segment( );
  delay( 1000 );

  //Display the digit four in the 0 segment.
  segment = 0;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 4;
  display_segment( );
  delay( 1000 );

  //  Display the digit five in the 1 segment.
  segment = 1;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 5;
  display_segment( );
  delay( 1000 );

  // Display the digit six in the 2 segment.
  segment = 2;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 6;
  display_segment( );
  delay( 1000 );

  // Display the digit seven in the 3 segment.
  segment = 3;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 7;
  display_segment( );
  delay( 1000 );

  // Display the digit eight in the 0 segment. 
  segment = 0;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 8;
  display_segment( );
  delay( 1000 );

  // Display the digit nine in the 1 segment.
  segment = 1;
  // NOTE: No select_segment( ) function will NOT be used since the display_segment( ) will
  // take care of setting the appropriate segment.
  digit = 9;
  display_segment( );
  delay( 1000 );
  
} // end do_avr_version function.
