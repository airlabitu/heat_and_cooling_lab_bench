#include <OneWire.h>
#include <DallasTemperature.h>

// potentiometer pins
#define pot_a_pin A3
#define pot_b_pin A2

// temp sensor pins
#define temp_a_pin A5
#define temp_b_pin A4

#define PWM_5V 102 // 102 corrosponds to 5v 
#define PWM_12V 255 // 255 (max) corrosponds to 12v

// potentiometer input
int pot_a_value;
int pot_b_value;

// temp sensor value
float temp_a_value;
float temp_b_value;

// H-bridge A connections
int enA = 9;
int in1 = 8;
int in2 = 7;
// H-bridge B connections
int enB = 3;
int in3 = 5;
int in4 = 4;

// temp sensor library definitions
OneWire oneWireA (temp_a_pin);
OneWire oneWireB (temp_b_pin);
DallasTemperature sensorA(&oneWireA);
DallasTemperature sensorB(&oneWireB);

bool side_a_input_over_serial = false; // if TRUE, it takes voltage input over serial. If FALSE it takes voltage input via potentiometers
bool side_b_input_over_serial = false; // if TRUE, it takes voltage input over serial. If FALSE it takes voltage input via potentiometers

void setup() {
  Serial.begin(9600);
  pinMode(pot_a_pin, INPUT);
  pinMode(pot_b_pin, INPUT);

  // Turn off motors - Initial state
  pinMode(enA, OUTPUT);
	pinMode(enB, OUTPUT);
	pinMode(in1, OUTPUT);
	pinMode(in2, OUTPUT);
	pinMode(in3, OUTPUT);
	pinMode(in4, OUTPUT);

  // Turn on motors - Initial state
	digitalWrite(in1, HIGH);
	digitalWrite(in2, LOW);
	digitalWrite(in3, HIGH);
	digitalWrite(in4, LOW);
}

int value = 0;
int channel;

void loop() {

  int c;

  if (Serial.available()){
    c = Serial.read();
    if ((c>='0') && (c<='9')) {
      value = 10*value + c - '0';
    } else {
      if (c=='c') channel = value;
      else if (c=='w') {
        if (channel == 99 && (value == 0 || value == 1)){
          side_a_input_over_serial = value;
          Serial.println();
          Serial.print("side a input over serial ");
          Serial.println(side_a_input_over_serial);
        }
        else if (channel == 100 && (value == 0 || value == 1)){
          side_b_input_over_serial = value;
          Serial.println();
          Serial.print("side b input over serial ");
          Serial.println(side_b_input_over_serial);
        }
        else if (channel == 1){ // side a pot serial data received
          pot_a_value = constrain(value, 0, 5000);  // get rid of illigal values // comes in as values between 0-5000 to accomondate decimal numbers
          pot_a_value = map(pot_a_value, 0, 5000, 0, 1023); // remap to potentiometer scale
          analogWrite(enA, map(pot_a_value, 0, 1023, 0, PWM_5V)); // updates the heat output - mapped to PWM interval (5v)
        }
        else if (channel == 3){ // side b pot serial data received
          pot_b_value = constrain(value, 0, 5000); // get rid of illigal values // comes in as values between 0-5000 to accomondate decimal numbers
          pot_b_value = map(pot_b_value, 0, 5000, 0, 1023); // remap to potentiometer scale
          analogWrite(enB, map(pot_b_value, 0, 1023, 0, PWM_12V)); // updates the heat output - mapped to PWM interval (12v)
        }
      }
      value = 0;
    }
  }

  // Side A
  int temp; // DUMMY
  if (!side_a_input_over_serial){
  temp = int(random(-60,70)); // DUMMY
  pot_a_value = constrain(pot_a_value + temp, 0, 1023); // DUMMY
  //pot_a_value = analogRead(pot_a_pin); // reads the sensor (knop)
  //analogWrite(enA, map(pot_a_value, 0, 1023, 0, PWM_5V)); // updates the heat output - mapped to PWM interval (5v)
  }
  
  /*
  sensorA.requestTemperatures();
  temp_a_value = sensorA.getTempCByIndex(0);
  */
  temp = int(random(-2,3)); // DUMMY
  temp_a_value = constrain(temp_a_value + temp, -10, 40); // DUMMY


  // Side B
  if (!side_b_input_over_serial){
  temp = int(random(-60,70)); // DUMMY
  pot_b_value = constrain(pot_b_value + temp, 0, 1023); // DUMMY
  //pot_b_value = 1023-analogRead(pot_b_pin); // reads the sensor (knop), and reverse direction for equal interaction on the box
  //analogWrite(enB, map(pot_b_value, 0, 1023, 0, PWM_12V)); // updates teh heat output - mapped to PWM interval (12v)
  }
  /*
  sensorB.requestTemperatures();
  temp_b_value = sensorB.getTempCByIndex(0);
  */
  temp = int(random(-2,3)); // DUMMY
  temp_b_value = constrain(temp_b_value + temp, -10, 40); // DUMMY



  // Voltage output side A
  Serial.print(1); // channel
  Serial.print('c');
  Serial.print(map(pot_a_value, 0, 1023, 0, PWM_5V)); // pot sensor value mapped to voltage (scale 0-5 volt) 
  Serial.print('w'); 
  delay(10);
  // Temperature sensor side A
  if (temp_a_value != -127){ // skip sending if no sensor is connected (-127)
    Serial.print(2); // channel
    Serial.print('c');
    Serial.print(int((constrain(temp_a_value, -10, 40)+10)*100)); // temp value // mapped to range 0-5000 - used in Processing as map(data, 0, 5000, -10, -40) 
    Serial.print('w');
    delay(10);
  }
  
  // Voltage output side B
  Serial.print(3); // channel
  Serial.print('c');
  Serial.print(map(pot_b_value, 0, 1023, 0, PWM_12V)); // pot sensor value mapped to voltage (scale 0-12 volt) 
  Serial.print('w'); 
  delay(10);
  // Temperature sensor side B
  if (temp_b_value != -127){ // skip sending if no sensor is connected (-127)
    Serial.print(4); // channel
    Serial.print('c');
    Serial.print(int((constrain(temp_b_value, -10, 40)+10)*100)); // temp value // mapped to range 0-5000 - used in Processing as map(data, 0, 5000, -10, -40)  
    Serial.print('w');
    delay(10);
  }
}
