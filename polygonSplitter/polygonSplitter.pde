class Vector2{
  float x; 
  float y;
  Vector2(float x, float y){
    this.x = x;
    this.y = y;
  }
}

class StandardLine{
  float a;
  float b;
  float c;
  StandardLine(float a, float b, float c){
    this.a = a;
    this.b = b;
    this.c = c;
  }
  Vector2 intersectStandardLine(StandardLine line){
    Vector2 point = new Vector2(0,0);
    float determinant = (this.a*line.b)-(line.a*this.b);
    if(determinant == 0)
    {
      return new Vector2(Float.NaN, Float.NaN);
    }
    point.x = ((this.c*line.b)-(line.c*this.b))/determinant;
    point.y = ((this.a*line.c)-(line.a*this.c))/determinant;
    
    return point;
  }
}

interface ILine{
  StandardLine standardize();
  boolean possibleIntersection(Vector2 point);
}

class Ray implements ILine{
  Vector2 start;
  Vector2 direction;
  Ray(Vector2 start, Vector2 direction){
    this.start = start;
    this.direction = direction;
  }
  StandardLine standardize(){
    float a, b, c;
    if(direction.x != 0)
    {
       float slope = direction.y/direction.x;
       float intercept = start.y-(slope*start.x);
       
       a = -slope;
       b = 1;
       c = intercept;
    }
    else
    {
      a = 1;
      b = 0;
      c = start.x;
    }
    return new StandardLine(a,b,c);
  }
  boolean possibleIntersection(Vector2 point){
    if((direction.x > 0 && point.x > start.x)||(direction.x < 0 && point.x < start.x))
    {
      if((direction.y > 0 && point.y > start.y)||(direction.y < 0 && point.y < start.y))
      {
        return true;
      }
    }
    return false;
  }
}

class Line implements ILine{
  Vector2 start;
  Vector2 end;
  
  Line(Vector2 start, Vector2 end){
    this.start = start;
    this.end = end;
  }
  StandardLine standardize(){
    float a, b, c;
    if(end.x-start.x != 0)
    {
     float slope = (end.y-start.y)/(end.x-start.x);
     float intercept = start.y-(slope*start.x);
    
     a = -slope;
     b = 1;
     c = intercept;
    }
    else
    {
      a = 1;
      b = 0;
      c = start.x;
    }
    return new StandardLine(a,b,c);
  }
  
  boolean possibleIntersection(Vector2 point){
    var maxX = max(start.x,end.x);
    var minX = min(start.x,end.x);
    var maxY = max(start.y,end.y);
    var minY = min(start.y,end.y);
    if(point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY){
      return true;
    }
    return false;
  }
  
  void draw()
  {
    line(start.x,start.y,end.x,end.y);
  }
    // continue adding functions, line against line collision (then add them to the ray class)
}

ArrayList<Vector2> points; 



//based off of pseudo code from here: https://www.geeksforgeeks.org/program-for-point-of-intersection-of-two-lines/
Vector2 findIntersection(ILine line1, ILine line2){ 
  StandardLine sLine1 = line1.standardize();
  StandardLine sLine2 = line2.standardize();
  
  Vector2 point = sLine1.intersectStandardLine(sLine2);
  
  if(line1.possibleIntersection(point) && line2.possibleIntersection(point)){
     return point;
  }
  
  return new Vector2(Float.NaN, Float.NaN);
  
}

ArrayList<Vector2> countIntersections(ArrayList<ILine> linelist, ILine intersector){
  
  ArrayList<Vector2> intersections = new ArrayList<Vector2>();
  
  for(int y = 0; y < linelist.size(); y++)
    {
      Vector2 intersection = findIntersection(intersector,linelist.get(y));
      
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

ArrayList<Line> pointsToLines(ArrayList<Vector2> pointlist){
  ArrayList<Line> linelist = new ArrayList<Line>();
  for(int i = 0; i < pointlist.size(); i++){
    Line newLine = new Line(new Vector2(0,0),new Vector2(0,0));
    if (i < pointlist.size()-1){
       newLine = new Line(pointlist.get(i),pointlist.get(i+1));
    }
    else
    {
      newLine = new Line(pointlist.get(i),pointlist.get(0));
    }
    linelist.add(newLine);
  }
  return linelist;
}

ArrayList <Line> lines;
ArrayList <Line> cutLines;
void setup(){
  size(640,480);
  fill(255);
  textSize(20);
  background(255,255,255);
  points = new ArrayList<Vector2>();
  lines = new ArrayList<Line>();
  cutLines = new ArrayList<Line>();
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
    lines = pointsToLines(points);
    for(int i = 0; i < lines.size(); i++)
    {
      Line line = lines.get(i);
      line.draw();
      
      fill(255);
      ellipse(line.start.x,line.start.y,10,10);
      ellipse(line.end.x,line.end.y,10,10);
      fill(168, 86, 50);
      text(i+1,line.start.x-10,line.start.y-10);
    }
    fill(255);
  }
  else if(key=='s')
  {
    for(int i = 0; i < lines.size(); i++)
    {
      Line line  = lines.get(i);
      fill(255);
      ellipse(line.start.x,line.start.y,10,10);
      fill(0);
      
      Vector2 direction = new Vector2(line.end.x-line.start.x, line.end.y-line.start.y);
      ILine intersector = new Ray(line.end,direction);
      
      ArrayList<Vector2> intersections = countIntersections(new ArrayList<ILine>(lines), intersector); 
      intersections.addAll(countIntersections(new ArrayList<ILine>(cutLines), intersector));
      Vector2 closest = nearestIntersection(line.end,intersections);
      if(intersections.size()%2!=0)
      {
        cutLines.add(new Line(line.end,closest));
        line(line.end.x,line.end.y,closest.x,closest.y);
        fill(255);
        ellipse(closest.x,closest.y,10,10);
        fill(0);
      }
      println("line ", i+1," has ", intersections.size(), " intersections." );
    }
    fill(255);
  }
}
