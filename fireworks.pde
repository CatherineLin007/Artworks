/**
Click for fireworks!
*/
ArrayList<Burst> bursts;
ArrayList<ArrayList<Particle>> firepoints;
boolean notClicked = true;
int textFrameCount = 0;

void setup() {
  size(1100, 650);
  bursts = new ArrayList();
  fill(0);
  PFont f = createFont("Arial",30,true);
  textFont(f, 30);
  
}

void draw() {
  noStroke();
  fill(0);
  // transparent black background
  
  if(!notClicked){
    double alph = (textFrameCount % 200 / 100.0);
    //println(alph);
    fill((int)(255 * (alph < 1 ? alph : 2 - alph)));
    text("Click me!", 40, 610);
    textFrameCount++;
  }
  else{
    fill(255);
    text("Click me!", 490, 360);
  }
  fill(0, 45);
  rect(0, 0, width, height);

  for (int i = bursts.size() - 1; i >= 0; i--) {
    Burst b = bursts.get(i);
    if (b.update()) bursts.remove(i);
  }
  
}


void mousePressed() {
  if(notClicked) notClicked = false;
  for(int i=0; i < int(random(3, 8)); i++){
    bursts.add(new Burst(int(random(200, 900)),int(random(100, 300)), int(random(50, 200))));
  }
  
  
}
class Burst{
  float gravity;
  ArrayList<Particle> particles;

  Burst(float x, float y, int n){
    particles = new ArrayList();
    gravity = 0.3;
    color c = color(random(100, 255), random(100, 255), random(100, 255));

    for (int i = 0; i < n; i++){        
      float vx = random(-10, 10);
      float vy = random(0, 10);
      float v1y = random(10, 15);
      if (random(1) < 0.8)
        vy *= -1.5;
      particles.add(new Particle(x, y, vx, vy, v1y, c));
    }
  }
  
  // returns true if a burst has no more particles left
  boolean update(){
    for (int i = particles.size() - 1; i >= 0; i--){
      Particle p = particles.get(i);
      if(p.isPhase2){
        p.accelerate(gravity);
        if (p.update2()) particles.remove(i);
      }
      else{
        p.update1();
      }
    }    
    return particles.size() == 0;
  }
}

class Particle {
  float x, y;
  float vx, vy, v1y, oy;
  color c;
  int life;
  boolean isPhase2;

  Particle(float x, float y, float vx, float vy, float v1y, color c) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.v1y = v1y;
    this.c = c;
    this.life = 50;
    this.oy = 800;
    this.isPhase2 = false;
  }

  void accelerate(float a) {
    vy += a;
  }
  
  void update1(){
    float py = oy;
    oy -= v1y;
    stroke(c); 
    line(x, py, x, oy);
    //println(oy);
    if(oy < y){
      this.isPhase2 = true;
    }
  }
  // returns true if a particle is out of screen
  boolean update2() {
    float px = x;
    float py = y;
    x += vx;
    y += vy;
    life -= 1;
    this.c = color(red(c), green(c), blue(c), int(life/50.0*255+40));
    
    stroke(c); 
    line(px, py, x, y);
    // no need to check for y < 0 because vy is always positive
    return y > height || x < 0 || x > width || life == 0;
  }
}



