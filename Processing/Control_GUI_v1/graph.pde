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
  
  int min_temp = -10;
  int max_temp = 40;
  
  int margin = 10;
  
  
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
    graph_area_w = int(w * 0.8); // 80% of total width
    graph_area_h = int(h * 0.9); // 90% of total height
    
    left_info_area_h = graph_area_h; // 90% same as graph window 
    right_info_area_h = graph_area_h; // 90% same as graph window
    
    right_info_area_x = left_info_area_x + left_info_area_w + graph_area_w;
    right_info_area_y = y;
    right_info_area_w = left_info_area_w; // 10% same as left side
    
    bottom_info_area_x = graph_area_x; // same as graph area x
    bottom_info_area_y = graph_area_y + graph_area_h; // below graph area
    bottom_info_area_w = graph_area_w; // same as graph area width
    bottom_info_area_h = h - graph_area_h; // remaining space below graph area
    
    data_max_size = graph_area_w / x_spacing;
    println("data_max_size", data_max_size);
    
  }
  
  void drawInfo(){
    for (int v = min_voltage; v <= max_voltage; v++){
      fill(255,0,0);
      text(v, left_info_area_x+left_info_area_w*0.2, map(v, min_voltage, max_voltage, left_info_area_y+left_info_area_h, left_info_area_y));
    }
    for (int t = min_temp; t <= max_temp; t+=2){
      fill(0,255,0);
      text(t, left_info_area_x+left_info_area_w*0.7, map(t, min_temp, max_temp, left_info_area_y+left_info_area_h, left_info_area_y));
    } 
  }
  
  void testDraw(){
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
  
  void drawGraph(){
    plotGraph(data_voltage, color(255,0,0), min_voltage, max_voltage);
    plotGraph(data_temp, color(0,255,0), min_temp, max_temp);
    drawInfo();
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
