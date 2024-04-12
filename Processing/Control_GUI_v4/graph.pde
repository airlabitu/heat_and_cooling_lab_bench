class Graph{
  
  int x, y, w, h;
  int graph_area_x, graph_area_y, graph_area_w, graph_area_h;
  int left_info_area_x, left_info_area_y, left_info_area_w, left_info_area_h;
  int right_info_area_x, right_info_area_y, right_info_area_w, right_info_area_h;
  int bottom_info_area_x, bottom_info_area_y, bottom_info_area_w, bottom_info_area_h;
  
  int x_spacing = 2;
  int y_spacing = 2;
  
  FloatList data_temp;
  FloatList data_voltage;
  
  int data_max_size;
  
  int min_voltage = 0;
  int max_voltage = 12;
  
  int min_temp = -15;
  int max_temp = 45;
  
  //int margin = 10;
  
  color voltage_color = color(#74B3F5);
  color temp_color = color(255, 255, 0);
  
  int rec_button_x, rec_button_y;//, rec_button_w, rec_button_h;
  int rec_button_w;
  int rec_text_size = 18;
  String rec_button_text = "REC";
  boolean rec_button_state = false;
  color rec_on = color(255,0,0);
  color rec_off = color(120,0,0);
  StringList recordings;
  long rec_timer;
  int rec_timer_interval = 50;
  
  int left_info_text_size = 18;
  
  String name = "graph x";
  
  Graph(int x_, int y_, int w_, int h_){
    data_voltage = new FloatList();
    data_temp = new FloatList();
    
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    left_info_area_x = x;
    left_info_area_y = y;
    left_info_area_w = int(w * 0.1); // 10% of total width
    
    graph_area_x = left_info_area_x + left_info_area_w;
    graph_area_y = y;
    graph_area_w = int(w * 0.75); // 75% of total width
    graph_area_h = int(h * 0.9); // 90% of total height
    
    left_info_area_h = graph_area_h; // 90% same as graph window 
    right_info_area_h = graph_area_h; // 90% same as graph window
    
    right_info_area_x = left_info_area_x + left_info_area_w + graph_area_w;
    right_info_area_y = y;
    right_info_area_w = int(w * 0.15); //left_info_area_w; // 15% of total width
    
    bottom_info_area_x = graph_area_x; // same as graph area x
    bottom_info_area_y = graph_area_y + graph_area_h; // below graph area
    bottom_info_area_w = graph_area_w; // same as graph area width
    bottom_info_area_h = h - graph_area_h; // remaining space below graph area
    
    data_max_size = graph_area_w / x_spacing;
    println("data_max_size", data_max_size);
    
    rec_button_x = int(right_info_area_x+right_info_area_w/2);
    rec_button_y = int(right_info_area_y+right_info_area_h*0.25);
    textSize(rec_text_size);
    rec_button_w = int(textWidth(rec_button_text)*1.4);
    //rec_button_w = int(right_info_area_w*0.8);
    //rec_button_h = int(right_info_area_h*0.05);
    recordings = new StringList();
  }
  
  void drawInfo(){
    textSize(left_info_text_size);
    float index_y_scalar = textAscent()*0.9;
    float index_x_offset [] = {textWidth("-10"), textWidth("-5"), textWidth("5"), textWidth("40")};
    int stroke_w = 8;
    int index_x_move = 10;
    stroke(255);
    line(graph_area_x, graph_area_y, graph_area_x, graph_area_y + graph_area_h);
    line(graph_area_x, graph_area_y+graph_area_h, graph_area_x+graph_area_w, graph_area_y + graph_area_h);
    
    // voltage graph index info
    for (int v = min_voltage; v <= max_voltage; v+=1){
      fill(voltage_color);
      stroke(voltage_color);
      float x = left_info_area_x+left_info_area_w-35; // x representing drawing origien (line right side)
      float y = map(v, min_voltage, max_voltage, left_info_area_y+left_info_area_h, left_info_area_y); // y representing draweing height for line   
      line(x, y, x-stroke_w, y);
      if (v%2==0){
        x -= index_x_move; // move x to represent index numbers
        y += index_y_scalar/2; // move to represent drawing height for index numbers
        if (v < 10) text(v, x-index_x_offset[2],y);
        else text(v, x-index_x_offset[3],y);
      }
    }
    
    // temp graph index info
    for (int t = min_temp; t <= max_temp; t+=5){
      fill(temp_color);
      stroke(temp_color);
      float x = left_info_area_x+left_info_area_w;
      float y = map(t, min_temp, max_temp, left_info_area_y+left_info_area_h, left_info_area_y);
      line(x, y, x-stroke_w, y);
      if (t%10 == 0){
        x -= index_x_move; // move x to represent index numbers
        y += index_y_scalar/2; // move to represent drawing height for index numbers
        if (t < -9) text(t, x-index_x_offset[0],y);
        else if (t < 0) text(t, x-index_x_offset[1],y);
        else if (t < 10) text(t, x-index_x_offset[2],y);
        else text(t, x-index_x_offset[3],y);
      }
    }
    
    
    textSize(rec_text_size);
    fill(voltage_color);
    if (data_voltage.size() > 0) text("vol: " + nf(data_voltage.get(data_voltage.size()-1), 0, 2), right_info_area_x+right_info_area_w*0.1, right_info_area_y+right_info_area_h*0.05);
    fill(temp_color);
    if (data_temp.size() > 0) text("temp: " + nf(data_temp.get(data_temp.size()-1), 0, 2), right_info_area_x+right_info_area_w*0.1, right_info_area_y+right_info_area_h*0.12);
    
    fill(255);
    textSize(left_info_text_size);
    textAlign(CENTER, CENTER);
    text(name, bottom_info_area_x + bottom_info_area_w/2, bottom_info_area_y + bottom_info_area_h/2);
    textAlign(CORNER);
  }
  
  void testDraw(){
    rectMode(CORNER);
    noFill();
    
    stroke(255, 0, 0);
    rect(x,y,w,h); // outer border
    
    stroke(255, 255, 0);
    rect(left_info_area_x,left_info_area_y,left_info_area_w,left_info_area_h); // left info border
    
    stroke(0, 255, 255);
    rect(right_info_area_x,right_info_area_y,right_info_area_w,right_info_area_h); // left info border
    
    stroke(0, 0, 255);
    rect(graph_area_x,graph_area_y,graph_area_w,graph_area_h); // left info border
    
    stroke(0, 255, 0);
    rect(bottom_info_area_x,bottom_info_area_y,bottom_info_area_w,bottom_info_area_h); // left info border
  }
  
  void addVoltageData(float value_){
    if (data_voltage.size() > data_max_size) data_voltage.remove(0);
    data_voltage.append(value_);
    
  }
  
  void addTempData(float value_){
    if (data_temp.size() > data_max_size) data_temp.remove(0);
    data_temp.append(value_);
    
  }
  
  float getNewestTemp(){
    if (data_temp.size() > 0) return data_temp.get(data_temp.size()-1);
    else return -999;
  }
  float getNewestVoltage(){
    if (data_voltage.size() > 0) return data_voltage.get(data_voltage.size()-1);
    else return -999;
  }
  
  void drawGraph(){
    drawInfo();
    plotGraph(data_voltage, voltage_color, min_voltage, max_voltage);
    plotGraph(data_temp, temp_color, min_temp, max_temp);
    // record button
    if (rec_button_state) fill(rec_on);
    else fill(rec_off);
    
    textSize(rec_text_size);
    
    float h = (textAscent()+textDescent())*2; // just an estimate 200% text height
    float x = rec_button_x;
    float y = rec_button_y;
    
    rectMode(CENTER);
    noStroke();
    circle(rec_button_x, rec_button_y, rec_button_w);
    if (rec_button_state) fill(255);
    else fill(130);
    textAlign(CENTER, CENTER);
    text(rec_button_text, rec_button_x, rec_button_y);
    textAlign(CORNER);
    
  }
  
  void plotGraph(FloatList data, color c, int min, int max){
    stroke(c);
    for (int i = data.size()-1; i > 0; i--){
      if (i < data.size()-1) {
        if ((graph_area_x+graph_area_w-(i+1)*x_spacing) > graph_area_x) {
          int x1, y1, x2, y2;
          x1 = graph_area_x+graph_area_w-(i+1)*x_spacing;
          y1 = int(map(data.get(i+1), min, max, graph_area_y+graph_area_h, graph_area_y));   
          x2 = graph_area_x+graph_area_w-(i)*x_spacing;
          y2 = int(map(data.get(i), min, max, graph_area_y+graph_area_h, graph_area_y));
          line(x1,y1,x2,y2);
        }
      }    
    }  
  }
}
