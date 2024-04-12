boolean serial_sending_a;
boolean serial_sending_b;


void keyReleased(){
  if (key == 'a') {
    serial_sending_a = !serial_sending_a;
    if (serial_sending_a) myPort.write("99c1w");
    else myPort.write("99c0w");
  }
  if (key == 'b') {
    serial_sending_b = !serial_sending_b;
    if (serial_sending_b) myPort.write("100c1w");
    else myPort.write("100c0w");
  }
  if (key == '1' && serial_sending_a) {
    float vol = map(mouseX, 0, width, 0, 5);
    int mapped_vol = int(map(vol, 0, 5, 0, 5000));
    println(vol, mapped_vol, "1c"+mapped_vol+"w");
    myPort.write("1c"+mapped_vol+"w");
  }
  if (key == '2' && serial_sending_b) {
    float vol = map(mouseX, 0, width, 0, 12);
    int mapped_vol = int(map(vol, 0, 12, 0, 5000));
    println(vol, mapped_vol, "3c"+mapped_vol+"w");
    myPort.write("3c"+mapped_vol+"w");
  }
}
