import processing.serial.*;
import java.time.LocalDateTime;


Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive

// Serial protocol variables
int value = 0;
int channel;

boolean ready = false;

Graph side_a;
Graph side_b;


void setup() {
  size(1500, 800);
  // print the serial list with indexes
  for (int i = 0; i < Serial.list().length; i++) {
    println(i, Serial.list()[i]);
    if (Serial.list()[i].indexOf("/dev/tty.usbmodem") != -1) {
      myPort = new Serial(this, Serial.list()[i], 9600); // setup the serial connection
      println("Serial connection:", Serial.list()[i], myPort);
    }
  }
  side_a = new Graph(50, 50, 650, 700);
  side_b = new Graph(800, 50, 650, 700);
  side_a.max_voltage = 6; // side A is set up to 0-5v in the Arduino code
  
  side_a.name = "side a";
  side_b.name = "side b";
  
  resetRecording(side_a);
  resetRecording(side_b);
  
  setupGUI();

}

void draw() {
  background(0);
  if (ready) {
    //side_a.testDraw();
    side_a.drawGraph();
    //side_b.testDraw();
    side_b.drawGraph();
  }
  
  recordingHandler();
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

void mouseClicked(){
  println(mouseX, mouseY);
  if (dist(mouseX, mouseY, side_a.rec_button_x, side_a.rec_button_y) < side_a.rec_button_w/2) { // we are inside sidd_a record button
    side_a.rec_button_state = !side_a.rec_button_state;
    if (!side_a.rec_button_state) { // the button was just turned off, time to save data from recording StringList, then empty the list
      println();
      // debug printing
      for (int i = 0; i < side_a.recordings.size(); i++){
        println(side_a.recordings.get(i));
      }
      saveStrings(getTimestamp()+"_-_side_a_recordings_.txt", side_a.recordings.toArray());
      resetRecording(side_a);
      // 1 create text file
      // 2 empty recording array
    }
  }
  else if (dist(mouseX, mouseY, side_b.rec_button_x, side_b.rec_button_y) < side_b.rec_button_w/2) {
    side_b.rec_button_state = !side_b.rec_button_state;
    if (!side_b.rec_button_state) { // the button was just turned off, time to save data from recording StringList, then empty the list
      println();
      // debug printing
      for (int i = 0; i < side_b.recordings.size(); i++){
        println(side_b.recordings.get(i));
      }
      saveStrings(getTimestamp()+"_-_side_b_recordings_.txt", side_b.recordings.toArray());
      resetRecording(side_b);
      // 1 create text file
      // 2 empty recording array
    }
  }
  
}

void resetRecording(Graph g){
  g.recordings.clear();
  g.recordings.append("SIDE: A");
  g.recordings.append("FORMAT:timestamp,temp,voltage");
}

void recordingHandler(){
  long curr_millis = millis();
  if (side_a.rec_button_state && curr_millis > side_a.rec_timer + side_a.rec_timer_interval){
    side_a.rec_timer = curr_millis;
    side_a.recordings.append(LocalDateTime.now()+","+side_a.getNewestTemp()+","+side_a.getNewestVoltage());
  }
  curr_millis = millis();
  if (side_b.rec_button_state && curr_millis > side_b.rec_timer + side_b.rec_timer_interval){
    side_b.rec_timer = curr_millis;
    side_b.recordings.append(LocalDateTime.now()+","+side_b.getNewestTemp()+","+side_b.getNewestVoltage());
  }
}

String getTimestamp(){
  LocalDateTime t = LocalDateTime.now();
  return t.getYear()+"-"+nf(t.getMonthValue(), 2, 0)+"-"+nf(t.getDayOfMonth(), 2, 0)+"_"+nf(t.getHour(), 2, 0)+"-"+nf(t.getMinute(), 2, 0)+"-"+nf(t.getSecond(), 2, 0)+"-"+nf(int(t.getNano()/1000000000.0*100),3);
}
