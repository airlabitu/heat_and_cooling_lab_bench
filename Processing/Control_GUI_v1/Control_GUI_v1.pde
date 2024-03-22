import processing.serial.*;

Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive

// Serial protocol variables
int value = 0;
int channel;

boolean ready = false;

Graph side_a;
Graph side_b;


void setup() {
  size(1200, 800);
  // print the serial list with indexes
  for (int i = 0; i < Serial.list().length; i++) {
    println(i, Serial.list()[i]);
    if (Serial.list()[i].indexOf("/dev/tty.usbmodem") != -1) {
      myPort = new Serial(this, Serial.list()[i], 9600); // setup the serial connection
      println("Serial connection:", Serial.list()[i], myPort);
    }
  }
  side_a = new Graph(100, 50, 500, 300);
  side_b = new Graph(100, 400, 500, 300);
  side_a.max_voltage = 5; // side A is set up to 0-5v in the Arduino code
}

void draw() {
  background(255);
  if (ready) {
    side_a.testDraw();
    side_a.drawGraph();
    side_b.testDraw();
    side_b.drawGraph();
  }
}

// event function called by processing when receiving new serial data
void serialEvent(Serial myPort) {
  if (millis() > 1000){
    // read a byte from the serial port:
    int inByte = myPort.read();
    
    if ((inByte>='0') && (inByte<='9')) {
      value = 10*value + inByte - '0';
    } else {
      if (inByte=='c') channel = value;
      else if (inByte=='w') {
        if (channel == 1) side_a.addVoltageData(map(value, 0, 102, 0, 5)); // input scale (pwm) 0-102 output scale (voltage) 0-5
        else if (channel == 2) side_a.addTempData(map(value, 0, 5000, -10, 40));
        else if (channel == 3) side_b.addVoltageData(map(value, 0, 255, 0, 12)); // input scale (pwm) 0-255 output scale (voltage) 0-12
        else if (channel == 4) side_b.addTempData(map(value, 0, 5000, -10, 40));
      }
      value = 0;
    }
    ready = true;
  }
}
