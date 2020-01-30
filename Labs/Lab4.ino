
// ******************************Lab Report/Header************************************

// Lab Number and Title: Lab Number 4 - Decoding the Morse code

// ******The Name and Prupose of the Code******
// The name of the first code is Lab4.ino and its purpose is to 
// get user input. The first user input will be used to 
// make the arduino blink "GOAGGIES" in morse code given a specific number 
// of times. The second input will be the binary string that represents
// the given morse code in 1's and 0's (i.e. 1 represents a dash 
// while a 0 will represent a dot). This code is responsible for
// calling both the decode_morse and the GoAggies functions. 

// The name of the second code is GoAggies.S. The purpose of this assembly code is to make
// the LED in the arduino blink 'GOAGGIES' in morse code. The number of times that the 
// code will blink this is dependent on user input.

// The name of the last code is MorseCode.S. The purpose of this assembly code is to decode
// a binary string (provided by the user) into its corresponding ascii value. The code uses 
// 0's to represent dots and 1's to represent dashes.

// ********Purpose of the Lab************** 
// The purpose of the first part of the lab is to learn how the push and pop assembly intructions work,
// as well as how to call a assembly function within the code. In addition, this portion of the lab 
// taught students how to use the delay function and what patameters to pass it. 

// The purpose of the second part reinforced push and pop, but emphasized greatly on how
// to use the X, Y, and Z registers. In other words, the second part of the lab emphasized 
// how to "combine" two registers in order to use them to represent 2 bytes. We do this because
// memory locations are two bytes in length while registers are only 1 byte in length. In other words,
// to access RAM, we need two bytes.   

// ******Author's Name****** 
// Jose Franco Baquera

// ******Date****** 
// February 15, 2018

// ******************Description of the Solution************** 
// The description of the solution can be found in the next section.  

// ******A Description of the Algorithm Used Which Includes****** 
// ******Input, Output, and Assumptions About the Input******
// The assumptions about the input are clear: The user must enter only a two digit 
// number (i.e. 00-99 ) for the first input. In addition, the user cannot enter a 
// morse code message that is longer than 99 characters. This is because 
// the message array is length 100 and the last element is reserved for the null character. 

// The first output will be the LED light in the arduino board blinking 'GOAGGIES'
// in morse code. The second output will be characters in the serial monitor 
// (i.e. A-Z and 0-9). 

// The algorithm for the decodeMorse function in the Lab4.ino 
// file is to go trough the entire string, and while the character is not a 
// space, shift the bits. We increment width everytime this if statement executes.
// If the character is a space, call the decode_morse
// with the produced bit number. After we return from the function, store
// the corresponding ascii value (if any) into an array. Restore the variables 'width'
// and 'val back' to 0. Call once more the decode_morse function after existing the for loop
// in order to take care of the last character. Since we are using a language similar to
// C, we need to add a null character at the end of the character array in order to make
// it a null-terminated string.

// The algorithm for the GoAggies.S assembly code is to call each function that corresponds to
// the appropriate sequence in 'GOAGGIES'. Each of these functions will call to its corresponding 
// dash and/or dot functions. The DASH and DOT functions exactly the same except that they 
// differ in the number of times they call the WAIT function. The WAIT function essentially makes
// the arduino "delay" for 160 milliseconds. This algorithm is somewhat "linear".

// The algorithm for the MorseCode.S is more simple: "traverse" trough the "memory array" until
// we match both variables 'width' and 'val'. If a match is found, store the corresponding ascii 
// character into the 'ascii' variable. It is important to note that the width, ascii character, and
// bit string come in a 3-touple. 
  
// ******Test Results******
// When I inputed a 01 for the first user input, the LED blinked 'GOAGGIES' one time.
// When I inputed a 03 for the first user input, the LED blinked 'GOAGGIES' three times.
// When I inputed a 00 for the first user input, the LED blinked 'GOAGGIES' zero times.
// For the second user input, I first tried to input the following sequence: '1000 100 0' 
// and the arduino printed out BD???????. To fix this, I added another call to the morsecode()
// function and a null character at the end of the array. The reason why the question marks 
// were being printed is because there was no null character in the array, so 'garbage' was being 
// printed out. I then tested the following sequence: 0111 111 000 0. The program then printed out
// JOSE, which the correct output for this specific input. 

// ******Answers to Questions******
// No questions were assigned in this assignment.

// ******Discussion: What I learned. What was easy, What was hard.******
// I learned many things during this lab. I first learned how to 
// inizialize and use registers Z, Y, and Z. In addition, I learned how
// to use these registers to access 2 byte memory locations. I learned how to use
// the '+' infront of the variables X, Y, and Z in order to "traverse" trough
// the memory locations. I also learned how to convert a character string into
// a binary string. Lastly, I learned how to use the delay function inside the
// assembly code. Everything in this lab was easy EXECPT converting a character 
// string into a binary string. I'm still a little confused as to how this algorithm
// works.

// ******************Contribution of TeamWork*******************
// This was an individual assignment, so no teamwork was used.

// *****************References*************************
// No references were used for this assignment. 

// **********************************End Of Lab Report/Header*****************************

// ******Labels******
// NonThere are several labels troughout the assembly code. Each label will be explained
// and will have a meaningful comment where it is inizalized. 

// ****Every Branch, Jump, Call and Return Must Have a Meaningful Comment.******
// There are no branches in this code. Each call and return will have a meaningful comment. 

// ******Description of Each Global Variables' Use and Purpose******
// Global Variables: 
//  - val: 'val' will have two purposes. The first purpose will be to store the number
//         the user inputed (i.e. by using accii subtraction) while its second purpose 
//         will be to use it as a way to convert the character string into a binary string. 
//  - width: 'width' will keep track of the length of each sub binary string. That is, width
//           will keep track of each binary string seperated by spaces (e.g. for the string "100 10,"
//           the width of the first number will be 3 while the width of the second number will
//           will be 2. (NOTE: We need this variable because 0b000 == 0b0 in the arduino but not 
//           for our purposes.)
//  - ascii: 'ascii' will keep track of the specific character that each space-seperated binary string
//           represents  (e.g. 1000 represents 'B' in ascii ).
//  - GoAggies: 'GoAggies' will be a global function that will blink 'GOAGGIES' in morse code using the
//              the LED in the arduino code.
//  - decode_morse: 'decode_morse' will be a global function that will decode a binary string inputted by the user
//                   into its corresponding character string. 
 
extern byte val;
extern byte width;
extern byte ascii;

extern "C" { 
  
  void decode_morse();
  
  void GoAggies();

} 

// read2DigitValue() function is used to read a 2-digit decimal value from user.

byte read2DigitValue( ) {
  
  byte inch; 
  
  int val;
  
  Serial.println( "Enter a 2-digit decimal value:" );
  
  while ( !Serial.available( ) ) 
  
    delay(100);
  
  inch = Serial.read();
  
  val = (inch - '0') * 10;
  
  while (!Serial.available( ) ) 
  
     delay(100);
  
  inch = Serial.read();
  
  val += (inch - '0');
  
  Serial.print( "The value entered is " );
  
  Serial.println( val, DEC );
  
  return (byte) val;
  
} // end read2DigitValue function.

void flashGoAggies( ) {

  // First turn off the LED light to make the dashes and dots more
  // clearer. 
  
  pinMode( 13, OUTPUT);
  
  digitalWrite( 13, LOW);
  
  // You will call the GoAggies() function from assembly file GoAggies.S
  
  byte number = read2DigitValue();
  
  while ( number > 0 ){
    
    GoAggies();
    
    number--;
  
  }// end while
 
} // end flashGoAggies function.

void decodeMorse( const String & string, char message[ ] ) {
  
   width = 0;
  
   val = 0;

   int i;
   
   int x = 0;

   // The user inputed originally a character string. For this portion of the function, 
   // we have to convert the user input into corresponding binary strings, with each string seperated 
   // by a space. We need to use a for loop that will traverse trough the entire list
   // and produce independent binary strings that are seperated by spaces. 

   for ( i = 0; i < string.length( ); i++ ) {

       // If it the character is not a chracter, do the following.

       if ( string[ i ] != ' ' ) {

          // Shift the bits.

          val = val * 2;

          if ( string[ i ] == '1' ) {

             // This means 'or' and does NOT mean increment.

             val = val + 1;
            
          } // end if.

          // Increment width.

          width ++;
        
       } // end if.

       else {

          decode_morse( );

          // Store the ascii variable into the array.

          message[ x ] = ascii;

          // Restore the variables val and width.

          val = 0;

          width = 0;

          x++;
                  
       } // end else.
    
   } // end for.

   // Get the last character in the array.

   if ( width > 0 ) {

      decode_morse( );

      message [ x ] = ascii;

      // Restore the variables val and width.

      val = 0;

      width = 0;

      x++;
    
   } // end if.

   // Make the last character in the array a null character.

   message [ x ] = '\0';

} // end decodeMorse function.

// decodeMorse function.

void decodeMorse() {
  
  Serial.println( "Input a Morse code string (separate the code for characters by a space):" );

  while ( !Serial.available( ) ) 
    
    delay(100);
  
  String string = Serial.readString( );

  Serial.print( "The Morse code string is: " );
  
  Serial.println( string );
 
  char message[ 100 ];

  decodeMorse(string, message );

  // NOTE: The strlen function returns the length of the string.

  if( strlen( message ) > 0 ) {
    
    Serial.print("The decoded message is: ");
    
    Serial.println( message );
    
   } // end if.
    
   else {
      
      Serial.print( "Failure in decoding the input Morse code.\n" );
      
   } // end else.

} // end decodeMorse function.

// setup function.

void setup() {
  
  // Initialize serial communications.
  
  Serial.begin(9600);

  // Call the flashGoAggies function to make the LED flash 'GOAGGIES' in morse code.

  flashGoAggies();

  // Call the decodeMorse function to decode the user inputted string. 

  decodeMorse();
  
} // end setup.

// loop function.

void loop() {
  
  delay( 20000 ); // 20,000 millisecs == 20 seconds
  
  Serial.println("*");
  
} // end loop.
