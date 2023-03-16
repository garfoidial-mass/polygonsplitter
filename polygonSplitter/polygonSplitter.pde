

class Vector2{
  float x; 
  float y;
  Vector2(float x, float y){
    this.x = x;
    this.y = y;
  }
}

ArrayList<Vector2> points; 

//based off of math from here: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_line_equations
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
  }
  else
  {
  }
  
  if(end2.x-start2.x != 0)
  {
   slope2 = (end2.y-start2.y)/(end2.x-start2.x);
   intercept2 = start2.y-(slope2*start2.x);
  }
  else
  {
    
  }
  point.x = (intercept2-intercept1)/(slope1-slope2);
  point.y = slope1*((intercept2-intercept1)/(slope1-slope2))+intercept1;
  
  var maxX = max(start2.x,end2.x);
  var minX = min(start2.x,end2.x);
  var maxY = max(start2.y,end2.y);
  var minY = min(start2.y,end2.y);
  
  if(point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY)
  {
    if((direction.x > 0 && point.x > start1.x)||(direction.x < 0 && point.x < start1.x)||(direction.x == 0 && point.x == start1.x))
    {
      if((direction.y > 0 && point.y > start1.y)||(direction.y < 0 && point.y < start1.y)||(direction.y == 0 && point.y == start1.y))
      {
        return point;
      }
    }
  }
  
  return new Vector2(Float.NaN, Float.NaN);
  
}

ArrayList<Vector2> countIntersections(ArrayList<Vector2> pointlist,Vector2 raystart, Vector2 raydir){
  
  ArrayList<Vector2> intersections = new ArrayList<Vector2>();
  
  for(int y = 0; y < pointlist.size(); y++)
    {
      Vector2 startpoint2 = pointlist.get(y);
      Vector2 endpoint2;
      if(y < pointlist.size()-1)
      {
        endpoint2 = pointlist.get(y+1);
      }
      else
      {
        endpoint2 = pointlist.get(0);
      }
      Vector2 intersection = findIntersection(raystart,raydir,startpoint2,endpoint2);
      
      if(!Float.isNaN(intersection.x) && !Float.isNaN(intersection.y))
      {
        intersections.add(intersection);
      }
    }
    
  return intersections;
}

void setup(){
  size(640,480);
  fill(255);
  points = new ArrayList<Vector2>();
}

void draw(){
}

void mouseClicked(){
  points.add(new Vector2(mouseX,mouseY));
  ellipse(mouseX,mouseY,10,10);
}

void keyPressed(){
  if(key == 'c'){
    background(255,255,255);
  }
  else if(key == 'a'){
    for(int i = 0; i < points.size(); i++)
    {
      Vector2 startpoint = points.get(i);
      ellipse(startpoint.x,startpoint.y,10,10);
      Vector2 endpoint;
      if(i < points.size()-1)
      {
        line(startpoint.x,startpoint.y,points.get(i+1).x,points.get(i+1).y);
        endpoint = points.get(i+1);
      }
      else
      {
        endpoint = points.get(0);
      }
      
      Vector2 direction = new Vector2(endpoint.x-startpoint.x, endpoint.y-startpoint.y);
      
      ArrayList<Vector2> intersections = countIntersections(points, endpoint,direction);
      println("line ", i+1," has ", intersections.size(), " intersections." );
    }
  }
  line(points.get(points.size()-1).x,points.get(points.size()-1).y, points.get(0).x,points.get(0).y);
}
