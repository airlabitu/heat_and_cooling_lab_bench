
int w = 600;
int h = 300;

void plotGraph(IntList data, int x, int y, int xSpacing, int ySpacing){
  stroke(255,0,0);
  for (int i = data.size()-1; i > 0; i--){
    if (i < data.size()-1) {
      int x1, y1, x2, y2;
      x1 = x+w-(i+1)*xSpacing;
      y1 = y+h-data.get(i+1)*ySpacing;
      x2 = x+w-(i)*xSpacing;
      y2 = y+h-data.get(i)*ySpacing;
      line(x1,y1,x2,y2);
      
    }
    //ellipse(x+w-i*xSpacing, y+h-min(data.get(i)*ySpacing, h), 10, 10);
    
    
  }  
}
