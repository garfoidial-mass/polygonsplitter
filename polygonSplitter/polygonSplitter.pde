

class Vector2{
  float x; 
  float y;
  Vector2(float x, float y){
    this.x = x;
    this.y = y;
  }
}

ArrayList<Vector2> points; 

//based off of pseudo code from here: https://www.geeksforgeeks.org/program-for-point-of-intersection-of-two-lines/
Vector2 findIntersection(Vector2 start1, Vector2 direction, Vector2 start2, Vector2 end2){ 
  Vector2 point = new Vector2(0,0);
  
  float slope1 = 0;
  float intercept1 = 0;
  float slope2 = 0;
  float intercept2 = 0;
  if(direction.x != 0)
  {
     slope1 = direction.y/direction.x;
     intercept1 = start1.y-(slope1*start1.x);
    //add code for handling vertical lines here (hi future self and mr. D :3)
  }
  
  if(end2.x-start2.x != 0)
  {
     slope2 = (end2.y-start2.y)/(end2.x-start2.x);
     intercept2 = start2.y-(slope2*start2.x);
    //add code for handling vertical lines here (hi future self and mr. D :3)
  }



  float a1 = -slope1;
  float b1 = 1;
  float c1 = intercept1;

  float a2 = -slope2;
  float b2 = 1;
  float c2 = intercept2;

  float determinant = (a1*b2)-(a2*b1);
  if(determinant == 0)
  {
    return new Vector2(Float.NaN, Float.NaN);
  }
  point.x = ((c1*b2)-(c2*b1))/determinant;
  point.y = ((a1*c2)-(a2*c1))/determinant;
  
  var maxX = max(start2.x,end2.x);
  var minX = min(start2.x,end2.x);
  var maxY = max(start2.y,end2.y);
  var minY = min(start2.y,end2.y);
  
  if(point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY)
  {
    if((direction.x > 0 && point.x > start1.x)||(direction.x < 0 && point.x < start1.x))
    {
          if((direction.y > 0 && point.y > start1.y)||(direction.y < 0 && point.y < start1.y))
          {
            if(direction.y == 0 && point.y == start1.y)
            {
              return point;
            }
          }
    }
  }
  
  return new Vector2(Float.NaN, Float.NaN);
  
}

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
