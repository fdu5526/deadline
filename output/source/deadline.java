import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class deadline extends PApplet {

int ground;  // ground height
MainCharacter mainCharacter;
PImage backImage;
final float characterSpeed = 10.0f;

public void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);

  ground = 410;

  initBackground();
  initMainCharacter();  
}

public void draw() { 
  drawBackground();
  stroke(0);
  mainCharacter.update();
  mainCharacter.draw();

}

/**
 * draws the background
 */
public void drawBackground()
{
  image(backImage,width/2,height/2);
}

public void keyPressed() {
  if(key == 'a')
  {
    mainCharacter.setSpeed(-1.0f * characterSpeed);
    mainCharacter.setDirection(-1.0f);
  }
  else if(key == 'd')
  {
    mainCharacter.setSpeed(characterSpeed);
    mainCharacter.setDirection(-1.0f);
  }
}

public void keyReleased() {
  if(key == 'a')
    mainCharacter.setSpeed(0.0f);
  else if(key == 'd')
    mainCharacter.setSpeed(0.0f);
}

public void initBackground()
{
  backImage = loadImage("background1.jpg");
}

public void initMainCharacter()
{
  PImage[] sprites = new PImage[3];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("main_"+(i+1)+".png");
  }
  mainCharacter = new MainCharacter(width/3, ground, sprites);
}
class MainCharacter{
	PImage[] spritesArray;
	int x, y, spriteFrame;
	float hspeed, direction;

	MainCharacter(int _x, int _y, PImage[] _sprites)
	{
		x = _x;
		y = _y;
		spritesArray = _sprites;
		spriteFrame = 0;
		hspeed = 0.0f;
		direction = 1.0f;
	}

	public void setSpeed(float s)
	{
		hspeed = s;
	}

	public void setDirection(float d)
	{
		direction = d;
	}

	public void setFrame(int f)
	{
		if(0 <= f && f < spritesArray.length)
			spriteFrame = f;
	}

	public void update()
	{
		// no going off screen
		if((0 < x-hspeed && x-hspeed < width))
			x += hspeed;
	}

	public void draw(){
		pushMatrix();
		translate(x, y);
		scale(direction, 1.0f);

		image(spritesArray[spriteFrame], 0, 0);
		popMatrix();
	}
}
/*
 * thanks to Daniel Shiffman for his example code
 */

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0,random(0.1f, 0.6f));
    float x = random(-8,8);
    float y = random(-10,2);
    velocity = new PVector(x,y);
    location = l.get();
    lifespan = 255.0f;
  }

  public void run() {
    update();
    display();
  }

  // Method to update location
  public void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0f;
  }

  // Method to display
  public void display() {
    stroke(255,0, 0, lifespan);
    fill(255, 0, 0, lifespan);
    ellipse(location.x,location.y,8,8);
  }
  
  // Is the particle still useful?
  public boolean isDead() {
    if (lifespan < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  Particle[] particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new Particle[400];
  }

  public void explode() {
    for(int i = 0; i < 400; i++)
      particles[i] = new Particle(origin);
  }

  public void run() {
    for (int i = particles.length-1; i >= 0; i--)
      particles[i].run();
  }
}
public float sign(float f)
{
	if(f < 0.0f)
		return -1.0f;
	else
		return 1.0f;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "deadline" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
