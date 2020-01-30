/*
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

  Cooper's Notes:
    
    This is a unified sketch product that utlizes the DHT11 master libraries, 
    the TM1637 and the Ardufruit libraries.
    
    This project reads data from the DHT11 and puts the values onto a I2C backpack 4x7 segment
    display called a TM 1637.  
    
    The program reads values from the DHT, then outputs alternating values on teh
    display for temperature and Humidity.
    
    This also prints to the default serial monitor for QA purposes   
*/

// DHT Temperature & Humidity Sensor
// Unified Sensor Library Example
// Written by Tony DiCola for Adafruit Industries
// Released under an MIT license.

// Depends on the following Arduino libraries:
// - Adafruit Unified Sensor Library: https://github.com/adafruit/Adafruit_Sensor
// - DHT Sensor Library: https://github.com/adafruit/DHT-sensor-library

// Includes needed for the project.
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <Arduino.h>

// We will not need the following header file since all the display() functions
// will be deleted.
// #include <TM1637Display.h>

// Module connection pins (Digital Pins) for TM 1637
#define CLK 9
#define DIO 8

// Define the pin connected to the DHT sensor. 
#define DHTPIN 2         

// We will only be using the DHT11 sensor.
#define DHTTYPE DHT11 // DHT 11 
// #define DHTTYPE DHT22 // DHT 22 (AM2302)
// #define DHTTYPE DHT21 // DHT 21 (AM2301)

// See guide for details on sensor wiring and usage:
//   https://learn.adafruit.com/dht/overview

DHT_Unified dht(DHTPIN, DHTTYPE);

// The amount of time (in milliseconds) between tests
#define TEST_DELAY 2000

// Make sure that the data array between the INO and AVR 
// files are shared.
extern byte data[ ];

extern "C" {

   // Make display_symbol "glued" to 
   // our INO program.
   void display_symbol();
 
} // end extern.

// Inizalize a variable that will help us delay a set amount 
// of time. 

uint32_t delayMS;

void setup() {

   // Initialize serial communications
   Serial.begin(9600); 
   
   // Initialize device.
   dht.begin();

   // Print the results given from the DHT11 thermonitor once
   // in a very elaborate table in order to demonstrate that the 
   // device is working properly. 
   Serial.println("DHTxx Unified Sensor Example");
   
   // Print temperature sensor details.
   sensor_t sensor;
   dht.temperature().getSensor(&sensor);
   Serial.println("------------------------------------");
   Serial.println("Temperature");
   Serial.print  ("Sensor:       "); Serial.println(sensor.name);
   Serial.print  ("Driver Ver:   "); Serial.println(sensor.version);
   Serial.print  ("Unique ID:    "); Serial.println(sensor.sensor_id);
   Serial.print  ("Max Value:    "); Serial.print(sensor.max_value); Serial.println(" *C");
   Serial.print  ("Min Value:    "); Serial.print(sensor.min_value); Serial.println(" *C");
   Serial.print  ("Resolution:   "); Serial.print(sensor.resolution); Serial.println(" *C");  
   Serial.println("------------------------------------");
   
   // Print humidity sensor details.
   dht.humidity().getSensor(&sensor);
   Serial.println("------------------------------------");
   Serial.println("Humidity");
   Serial.print  ("Sensor:       "); Serial.println(sensor.name);
   Serial.print  ("Driver Ver:   "); Serial.println(sensor.version);
   Serial.print  ("Unique ID:    "); Serial.println(sensor.sensor_id);
   Serial.print  ("Max Value:    "); Serial.print(sensor.max_value); Serial.println("%");
   Serial.print  ("Min Value:    "); Serial.print(sensor.min_value); Serial.println("%");
   Serial.print  ("Resolution:   "); Serial.print(sensor.resolution); Serial.println("%");  
   Serial.println("------------------------------------");
   
   // Set delay between sensor readings based on sensor details.
   delayMS = sensor.min_delay / 1000;

   // Declare the the shared variable 'data' that will be used between
   // the .ino and .S files.
   uint8_t data[4] ;
  
} // end setup function.

// loop function.
void loop() {

   // Declare variables to store the temperature and humidity.
   int t1,t2;
   int h1, h2;
  
   // Delay between measurements.
   delay(delayMS);
   
   sensors_event_t event;  

   // Read in the temperature.
   dht.temperature().getEvent(&event);
   
   if (isnan(event.temperature)) {

      // Print an error message if the temperature cannot be read.
      Serial.println("Error reading temperature!");
   
   } // end if.
   
   else {

      // Print the full, relative temperature.
      Serial.print("Temperature: ");
      Serial.print(event.temperature);
      Serial.println(" *F");

      // Get the higher integer and the lower integer. (Ex: If temperature is 89, t1 = 8 and t2 = 9).
      t1=event.temperature/10;
      t2=event.temperature;
      t2=t2%10;

      // Print the higher integer and the lower integer.
      Serial.println(t1);
      Serial.println(t2);
    
   } // end else.
  
   // Read in the humidity.
   dht.humidity().getEvent(&event);
  
   if ( isnan( event.relative_humidity ) ) {

      // Print an error message if the humidity cannot be read.
      Serial.println("Error reading humidity!");
 
   } // end if.
  
   else {

      // Print the full, relative humidity.
      Serial.print("Humidity: ");
      Serial.print(event.relative_humidity);
      Serial.println("%");

      // Get the higher integer and the lower integer. (Ex: If humidity is 50, h1 = 5 and h2 = 0).
      h1=event.relative_humidity/10;
      h2=event.relative_humidity;
      h2=h2%10;

      // Print the higher integer and the lower integer.
      Serial.println(h1);
      Serial.println(h2);
    
   } // end else.

   // The following six lines of code will display the current
   // humidity measured by the DHT11 thermometer on the 4x7 display. 
   // We cast arbitruary ascii values to integers and use those numbers
   // to "traverse" through the list. NOTE: '.' means BLANK in our case.
   // That is, the second segment will not display anything. h1 and 
   // h2 are the upper and lower integer digits that make up the humidity.
   data[0] = (int) 'H'; // Display an H in the first segment.
   data[1] = (int) '.'; // Do not display anything on the second segment.
   data[2] = h1; // Display the upper integer of the humidity on the thrid segment.
   data[3] = h2; // Display the lower integer of the humidity on the fourth segment.

   // Call the display_function that will use the values stored in the
   // data array to display the corresponding digits/letters.
   display_symbol( );

   // Delay.
   delay(TEST_DELAY);

   // The following six lines of code will display the current
   // temperature measured by the DHT11 thermometer on the 4x7 display. 
   // We cast arbitruary ascii values to integers and use those numbers
   // to "traverse" through the list. NOTE: '.' means BLANK in our case.
   // That is, the second segment will not display anything. t1 and 
   // t2 are the upper and lower integer digits that make up the temperature.
   data[0] = (int) 't'; // Display a t in the first segment.
   data[1] = (int) '.'; ; // Do not display anything on the second segment.
   data[2] = t1; // Display the upper integer of the temperature on the thrid segment.
   data[3] = t2; // Display the lower integer of the temperature on the fourth segment.

   // Call the display_function that will use the values stored in the
   // data array to display the corresponding digits/letters.
   display_symbol( );
  
   // Delay.
   delay(TEST_DELAY);

   // The following six lines of code will display 'done' 
   // on the 4x7 display. We cast arbitruary 
   // ascii values to integers and use those numbers
   // to "traverse" through the list.
   data[0] = (int) 'D'; // Display a D on the first segment.
   data[1] = (int) 'O'; // Display a 0 on the second segment.
   data[2] = (int) 'N'; // Display a N on the third segment.
   data[3] = (int) 'E'; // Display a E on the fourth segment.

   // Call the display_function that will use the values stored in the
   // data array to display the corresponding digits/letters.
   display_symbol( );
   
   // Delay.
   delay(TEST_DELAY);
  
} // end loop function.
