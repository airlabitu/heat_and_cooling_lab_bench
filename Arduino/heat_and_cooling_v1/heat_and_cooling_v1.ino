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

void loop() {
  // Side A
  pot_a_value = analogRead(pot_a_pin); // reads the sensor (knop)
  analogWrite(enA, map(pot_a_value, 0, 1023, 0, PWM_5V)); // updates the heat output - mapped to PWM interval (5v)
  sensorA.requestTemperatures();
  temp_a_value = sensorA.getTempCByIndex(0);

  // Side B
  pot_b_value = 1023-analogRead(pot_b_pin); // reads the sensor (knop), and reverse direction for equal interaction on the box
  analogWrite(enB, map(pot_b_value, 0, 1023, 0, PWM_12V)); // updates teh heat output - mapped to PWM interval (12v)
  sensorB.requestTemperatures();
  temp_b_value = sensorB.getTempCByIndex(0);


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
  //delay(1000);
}
