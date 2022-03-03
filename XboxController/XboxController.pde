import net.java.games.input.*;
import processing.sound.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

ControlIO control;

ControlDevice device;

ControlButton addButton;
ControlButton resetButton;
ControlHat hat;
ControlSlider sliderXL, sliderXR, sliderYL, sliderYR;

float spring = 1;
float friction = -0.5;
int FADEMAX = 50;
int NBJOYSTICK = 2;
float facteurFreq = 20;

int addcounter = NBJOYSTICK;
//Ball balls[] = new Ball[NBJOYSTICK];
ArrayList<Ball> balls = new ArrayList<Ball>();
color back = color(64, 218, 255); //variables for the 2 colors

float value;
boolean pressedAdd, pressedReset;

void setup() {
  size(800, 600);
  
  pressedAdd = false;
  pressedReset = false;
  control = ControlIO.getInstance(this);
  device = control.getMatchedDevice("XBoxOne");
  if (device == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  addButton = device.getButton("ADD");
  resetButton = device.getButton("DEL");
  hat = device.getHat("pov");
  sliderXL = device.getSlider("XPOSL");
  sliderYL = device.getSlider("YPOSL");
  sliderXR = device.getSlider("XPOSR");
  sliderYR = device.getSlider("YPOSR");
  println("setup complete");
  //arduino = new Arduino(this, Arduino.list()[1], 57600); //sets up arduino
   /* for(int i = 0; i<=16; i++)
  {
    arduino.pinMode(i, Arduino.INPUT);//setup pins to be input (A0 =0?)
  }*/
  
  for (int i = 0; i < NBJOYSTICK; i++) {
    balls.add(new Ball(this,random(width), random(height), random(30, 70), i, balls));
  }
    background(back);
}

void reset()
{
    size(800, 600);
    pressedAdd = false;
    for (Ball stop : balls) 
    {
      stop.stopsounds();
    }
    balls.clear();
    for (int i = 0; i < NBJOYSTICK; i++) 
    {
      balls.add(new Ball(this,random(width), random(height), random(30, 70), i, balls));
    }
    background(back);
    addcounter = NBJOYSTICK;
}

void getUserInput()
{
  sliderXL = device.getSlider("XPOSL");
  sliderYL = device.getSlider("YPOSL");
  sliderXR = device.getSlider("XPOSR");
  sliderYR = device.getSlider("YPOSR");
}


void draw() 
{
  background(back); 
  getUserInput();
  if (addButton.pressed() && !pressedAdd)
  {
    println("adding");
    balls.add(new Ball(this,random(width), random(height), random(30, 70), addcounter, balls));
    addcounter++;
    pressedAdd = true;
  }
  if (!addButton.pressed())
  {
    pressedAdd = false;
  }
  if (resetButton.pressed() && !pressedReset)
  {
    reset();
    pressedReset = true;
  }
  if (!resetButton.pressed())
  {
    pressedReset = false;
  }
  for (int i = 0; i<NBJOYSTICK; i++)
  {
      if(i==1)
        balls.get(i).move(sliderXL.getValue(),sliderYL.getValue());
      else
        balls.get(i).move(sliderXR.getValue(),sliderYR.getValue());
      balls.get(i).collide();
      balls.get(i).display(); 
  }
  for (int i = NBJOYSTICK; i<addcounter; i++)
  {
      balls.get(i).dontmove();
      balls.get(i).collide();
      balls.get(i).display();      
  }
}



class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  int r,g,b;
  ArrayList<Ball> others;
  float fade;
  SinOsc sine;
  
  Ball(PApplet papp, float xin, float yin, float din, int idin, ArrayList<Ball> oin) {
    x = xin;
    y = yin;
    fade = 0;
    diameter = din;
    id = idin;
    others = oin;
    r = int(random(0,255));
    g = int(random(0,255));
    b = int(random(0,255));
    sine = new SinOsc(papp);
    sine.play();
    sine.amp(0);
  } 
 void collide() {
    for (int i = id + 1; i < addcounter; i++) {
      float dx = others.get(i).x - x;
      float dy = others.get(i).y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others.get(i).diameter/2 + diameter/2;
      if (distance < minDist) { 
        fade = FADEMAX;
        sine.amp(1);        
        sine.freq(fade*facteurFreq*(r/255));
        Ball otherOne = others.get(i);
        otherOne.fade = FADEMAX;
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others.get(i).x) * spring;
        float ay = (targetY - others.get(i).y) * spring;
        vx -= ax;
        vy -= ay;
        others.get(i).vx += ax;
        others.get(i).vy += ay;
      }
    }   
  }
  
void move(float fx, float fy) {
    vy += map(fy, -1.0, 1.0, -0.5, 0.5);
    vx += map(fx, -1.0, 1.0, -0.5, 0.5);
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
void dontmove() {
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }

  void display() {
    noStroke();
    fill(r*fade/FADEMAX,g*fade/FADEMAX, b*fade/FADEMAX, (fade/FADEMAX)*255);
    ellipse(x,y, diameter+fade, diameter+fade);
    fade*=.9;
    sine.freq(fade*facteurFreq*((float(r)/255.0)+(float(g)/255.0)+(float(b)/255.0)));
    fill(r,g,b);
    ellipse(x, y, diameter, diameter);
  }
  void stopsounds()
  {
    sine.stop();
  }
  
}

void keyPressed()
{
  if(key=='a')
  {
    balls.add(new Ball(this,random(width), random(height), random(30, 70), addcounter, balls));
    addcounter++;
  }
  if(key=='r')
  {
    reset();
  }
}
