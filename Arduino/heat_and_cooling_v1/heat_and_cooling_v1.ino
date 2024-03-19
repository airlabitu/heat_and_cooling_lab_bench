#include <OneWire.h>
#include <DallasTemperature.h>

// potentiometer pins
#define pot_a_pin A3
#define pot_b_pin A2

// temp sensor pins
#define temp_a_pin A5
#define temp_b_pin A4

// potentiometer input
int pot_a_value;
int pot_b_value;

// voltage output (PWM)
int voltage_output_a;
int voltage_output_b;

// temp sensor value
int temp_a_value;
int temp_b_value;

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
  voltage_output_a = map(pot_a_value, 0, 1023, 0, 102); // translates from sensor scale (0-1023) to heat output scale (0-102) [0 - 4.95 V]
  analogWrite(enA, voltage_output_a); // updates the heat output
  sensorA.requestTemperatures();
  temp_a_value = int(sensorA.getTempCByIndex(0));

  // Side B
  pot_b_value = 1023-analogRead(pot_b_pin); // reads the sensor (knop), and reverse direction for equal interaction on the box
  voltage_output_b = map(pot_b_value, 0, 1023, 0, 255);
  analogWrite(enB, voltage_output_b);
  sensorB.requestTemperatures();
  temp_b_value = int(sensorB.getTempCByIndex(0));


  // Voltage output side A
  Serial.print(1); // channel
  Serial.print('c');
  Serial.print(voltage_output_a); // value
  Serial.print('w'); 
  delay(10);
  // Temperature sensor side A
  if (temp_a_value != -127){ // skip sending if no sensor is connected (-127)
    Serial.print(2); // channel
    Serial.print('c');
    Serial.print(temp_a_value); // value
    Serial.print('w');
    delay(10);
  }
  
  // Voltage output side B
  Serial.print(3); // channel
  Serial.print('c');
  Serial.print(voltage_output_b); // value
  Serial.print('w'); 
  delay(10);
  // Temperature sensor side B
  if (temp_b_value != -127){ // skip sending if no sensor is connected (-127)
    Serial.print(4); // channel
    Serial.print('c');
    Serial.print(temp_b_value); // value
    Serial.print('w');
    delay(10);
  }
  //delay(1000);
}
