import controlP5.*;

ControlP5 cp5;
PFont font;


void setupGUI(){
  font = createFont("arial",10);
  smooth();
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("voltage_side_a")
     .setPosition(640,20)
     .setSize(40,20)
     .setFont(font)
     .setCaptionLabel("voltage")
     .setColor(color(255))
     ;
  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("gui_control_a")
     .setPosition(610, 20)
     .setSize(20,20)
     .setFont(font)
     .setCaptionLabel("")
     .setValue(false)
     ;
  
  cp5.addTextfield("voltage_side_b")
     .setPosition(1390,20)
     .setSize(40,20)
     .setFont(font)
     .setCaptionLabel("voltage")
     .setColor(color(255))
     ;
  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("gui_control_b")
     .setPosition(1360, 20)
     .setSize(20,20)
     .setFont(font)
     .setCaptionLabel("")
     .setValue(false)
     ;
  
}


void gui_control_a(boolean theFlag) {
  if (theFlag) {
    myPort.write("99c1w"); // send update to arduino - enable serial control
    cp5.get(Textfield.class,"voltage_side_a").setLock(false);
    cp5.get(Textfield.class,"voltage_side_a").setColorForeground(color(0,0,255));
    cp5.get(Textfield.class,"voltage_side_a").setColorBackground(color(0,0,100));
    cp5.get(Textfield.class,"voltage_side_a").setColorLabel(color(255));
    cp5.get(Textfield.class,"voltage_side_a").setColorValue(color(255));
  }
  else {
    myPort.write("99c0w"); // send update to arduino - disable serial control
    cp5.get(Textfield.class,"voltage_side_a").setLock(true);
    cp5.get(Textfield.class,"voltage_side_a").setColorForeground(color(100));
    cp5.get(Textfield.class,"voltage_side_a").setColorBackground(color(20));
    cp5.get(Textfield.class,"voltage_side_a").setColorLabel(color(100));
    cp5.get(Textfield.class,"voltage_side_a").setColorValue(color(100));
  }
}

void gui_control_b(boolean theFlag) {
  if (theFlag) {
    myPort.write("100c1w"); // send update to arduino - enable serial control
    cp5.get(Textfield.class,"voltage_side_b").setLock(false);
    cp5.get(Textfield.class,"voltage_side_b").setColorForeground(color(0,0,255));
    cp5.get(Textfield.class,"voltage_side_b").setColorBackground(color(0,0,100));
    cp5.get(Textfield.class,"voltage_side_b").setColorLabel(color(255));
    cp5.get(Textfield.class,"voltage_side_b").setColorValue(color(255));
  }
  else {
    myPort.write("100c0w"); // send update to arduino - disable serial control
    cp5.get(Textfield.class,"voltage_side_b").setLock(true);
    cp5.get(Textfield.class,"voltage_side_b").setColorForeground(color(100));
    cp5.get(Textfield.class,"voltage_side_b").setColorBackground(color(20));
    cp5.get(Textfield.class,"voltage_side_b").setColorLabel(color(100));
    cp5.get(Textfield.class,"voltage_side_b").setColorValue(color(100));
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    if (theEvent.getName().equals("voltage_side_a")){ // side A
      float data = float(theEvent.getStringValue());
      if (!Float.isNaN(data)){
        println("data side a is float", data, "send to Arduino");
        int mapped_data = int(constrain(map(data, 0, 5, 0, 5000), 0, 5000)); // mapped to 0-5000 range, and constrained to same range 
        println(mapped_data);
        myPort.write("1c"+mapped_data+"w"); // send data to arduino here
      }
    }
    else if (theEvent.getName().equals("voltage_side_b")){ // side B
      float data = float(theEvent.getStringValue());
      if (!Float.isNaN(data)){
        println("data side b is float", data, "send to Arduino");
        int mapped_data = int(constrain(map(data, 0, 5, 0, 5000), 0, 5000)); // mapped to 0-5000 range, and constrained to same range 
        println(mapped_data);
        myPort.write("3c"+mapped_data+"w"); // send data to arduino here
      }
    }
  }
}
