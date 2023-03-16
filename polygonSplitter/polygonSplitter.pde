

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
  float a1 = 0;
  float b1 = 0;
  float c1 = 0;
  float slope2 = 0;
  float intercept2 = 0;
  float a2 = 0;
  float b2 = 0;
  float c2 = 0;
  
  if(direction.x != 0)
  {
     slope1 = direction.y/direction.x;
     intercept1 = start1.y-(slope1*start1.x);
     
     a1 = -slope1;
     b1 = 1;
     c1 = intercept1;
  }
  else
  {
    a1 = 1;
    b1 = 0;
    c1 = start1.x;
  }
  
  if(end2.x-start2.x != 0)
  {
   slope2 = (end2.y-start2.y)/(end2.x-start2.x);
   intercept2 = start2.y-(slope2*start2.x);
   
   a2 = -slope2;
   b2 = 1;
   c2 = intercept2;
  }
  else
  {
    a2 = 1;
    b2 = 0;
    c2 = start2.x;
  }

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

float distanceBetween(Vector2 a, Vector2 b){
  float dx = abs(a.x-b.x);
  float dy = abs(a.y-b.y);
  float distance = sqrt((dx*dx)+(dy*dy));
  return distance;
}

Vector2 nearestIntersection(Vector2 point, ArrayList<Vector2> intersections){
  
  if(intersections.size() <= 0)
  {
    return point;
  }
  Vector2 nearest = intersections.get(0);
  
  for(int i = 1; i < intersections.size(); i++)
  {
    Vector2 intersection = intersections.get(i);
    float distance = distanceBetween(point,intersection);
    if(distance < distanceBetween(point,nearest))
    {
      nearest = intersection;
    }
  }
  return nearest;
}

void setup(){
  size(640,480);
  fill(255);
  textSize(20);
  background(255,255,255);
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
      fill(168, 86, 50);
      text(i,startpoint.x-10,startpoint.y-10);
      fill(255);
      if(i < points.size()-1)
      {
        line(startpoint.x,startpoint.y,points.get(i+1).x,points.get(i+1).y);
      }
    }
    line(points.get(points.size()-1).x,points.get(points.size()-1).y, points.get(0).x,points.get(0).y);
  }
  else if(key=='s')
  {
    for(int i = 0; i < points.size(); i++)
    {
      Vector2 startpoint = points.get(i);
      fill(255);
      ellipse(startpoint.x,startpoint.y,10,10);
      Vector2 endpoint;
      fill(0);
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
      Vector2 closest = nearestIntersection(endpoint,intersections);
      if(intersections.size()%2!=0)
      {
        line(endpoint.x,endpoint.y,closest.x,closest.y);
        fill(255);
        ellipse(closest.x,closest.y,10,10);
        fill(0);
      }
      println("line ", i+1," has ", intersections.size(), " intersections." );
    }
    line(points.get(points.size()-1).x,points.get(points.size()-1).y, points.get(0).x,points.get(0).y);
    fill(255);
  }
}
