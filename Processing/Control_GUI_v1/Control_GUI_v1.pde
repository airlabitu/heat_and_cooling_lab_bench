import processing.serial.*;

Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive

IntList voltage_output_a;
IntList temp_a;
IntList voltage_output_b;
IntList temp_b;

int lists_size = 10;

// Serial protocol variables
int value = 0;
int channel;


void setup() {
  size(1200, 700);
  // print the serial list with indexes
  for (int i = 0; i < Serial.list().length; i++) {
    println(i, Serial.list()[i]);
    if (Serial.list()[i].indexOf("/dev/tty.usbmodem") != -1) {
      myPort = new Serial(this, Serial.list()[i], 9600); // setup the serial connection
      println("Serial connection:", Serial.list()[i], myPort);
    }
  }
  voltage_output_a = new IntList();
  temp_a = new IntList();
  voltage_output_b = new IntList();
  temp_b = new IntList();
}

void draw() {
  println("VO_A: ", voltage_output_a);
  println("T_A: ", temp_a);
  println("VO_B: ", voltage_output_b);
  println("T_B: ", temp_b);
  println();
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
        
        if (channel == 1) {
          if (voltage_output_a.size() > lists_size) voltage_output_a.remove(0);
          voltage_output_a.append(value);
        }
        if (channel == 2) {
          if (temp_a.size() > lists_size) temp_a.remove(0);
          temp_a.append(value);
        }
        if (channel == 3) {
          if (voltage_output_b.size() > lists_size) voltage_output_b.remove(0);
          voltage_output_b.append(value);
        }
        if (channel == 4) {
          if (temp_b.size() > lists_size) temp_b.remove(0);
          temp_b.append(value);
        }
        
      }
      value = 0;
    }
  }
}