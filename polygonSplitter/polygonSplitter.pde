

class Vector2{
  float x; 
  float y;
  Vector2(float x, float y){
    this.x = x;
    this.y = y;
  }
}

ArrayList<Vector2> points; 

void setup(){
  size(640,480);
  fill(255);
  points = new ArrayList<Vector2>();
}

void draw(){
  if(mousePressed){
    points.add(new Vector2(mouseX,mouseY));
    ellipse(mouseX,mouseY,10,10);
  }
}

void keyPressed(){
  if(key == 'c'){
    background(255,255,255);
  }
  else if(key == 'a'){
    for(int i = 0; i < points.size(); i++){
      Vector2 point = points.get(i);
      ellipse(point.x,point.y,10,10);
      if(i>0){
        line(point.x,point.y,points.get(i-1).x,points.get(i-1).y);
      }
      line(points.get(points.size()-1).x,points.get(points.size()-1).y, points.get(0).x,points.get(0).y);
    }
  }
}
