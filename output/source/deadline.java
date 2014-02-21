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

multiSpriteObject mainCharacter, backgroundSprites;
nonmovingObject light, clothes;
int ground;
final float characterSpeed = 30.0f;
boolean inzone;

public void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);

  ground = 691;
  inzone = false;

  initBackground();
  initNonmovableObjects();
  initMainCharacter();  
}

public void draw() { 
  stroke(0);
  
  updateBackground();
  drawBackground();

  // hit left of background
  if(mainCharacter.getX()+mainCharacter.getHspeed() < 10)
  {
    boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() + 1);
    if(succ)
      mainCharacter.setX(width - 50);
  }
  // hit right of background
  else if(width-50 < mainCharacter.getX()+mainCharacter.getHspeed())
  {
    boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() - 1);
    if(succ)
      mainCharacter.setX(10);
  }
  // normal movement
  else
    mainCharacter.update();

  mainCharacter.draw();
}

public void keyPressed() {
  if(key == 'a')
  {
    mainCharacter.setHspeed(-1.0f * characterSpeed);
    mainCharacter.setDirection(-1.0f);
  }
  else if(key == 'd')
  {
    mainCharacter.setHspeed(characterSpeed);
    mainCharacter.setDirection(1.0f);
  }
}

public void keyReleased() {
  if(key == 'a')
    mainCharacter.setHspeed(0.0f);
  else if(key == 'd')
    mainCharacter.setHspeed(0.0f);
}

public void drawBackground()
{
  backgroundSprites.draw();
  switch(backgroundSprites.getFrame()){
    case 0:
      light.draw();
      break;
    case 1:
      clothes.draw();
    default:
      break;
  }
}

public void updateBackground()
{
  switch(backgroundSprites.getFrame()){
    case 0:
      if(mainCharacter.getX() <= light.getX() + 200 && 
         light.getX() <= mainCharacter.getX())
      {
        light.setShouldDraw(true);
        inzone = true;
      }
      else
      {
        light.setShouldDraw(false);
        inzone = false;
      }
      break;
    case 1:
      if(mainCharacter.getX() <= clothes.getX() + 50 && 
         clothes.getX() - 50 <= mainCharacter.getX())
        {
          if(inzone)
            break;

          if(mainCharacter.getFrame() == 0)
          {
            clothes.setShouldDraw(false);
            mainCharacter.setFrame(2);
          }
          else
          {
            clothes.setShouldDraw(true);
            mainCharacter.setFrame(0); 
          }
          inzone = true;
        }
      else
        inzone = false;
      break;
    default:
      break;
  }
}
public void initBackground()
{
  PImage[] sprites = new PImage[3];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("background"+(i+1)+".jpg");
  }
  backgroundSprites = new multiSpriteObject(0, height, sprites);
}

public void initNonmovableObjects()
{
  light = new nonmovingObject(677, 474, loadImage("light.png"));
  clothes = new nonmovingObject(980, 552, loadImage("clothes.png"));
}

public void initMainCharacter()
{
  PImage[] sprites = new PImage[3];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("main_"+(i+1)+".png");
  }
  mainCharacter = new multiSpriteObject(width/3, ground, sprites);
}
class multiSpriteObject{
	PImage[] spritesArray;
	int x, y, spriteFrame;
	float hspeed, direction;
	float spriteScale;

	multiSpriteObject(int _x, int _y, PImage[] _sprites)
	{
		x = _x;
		y = _y;
		spritesArray = _sprites;
		spriteFrame = 0;
		hspeed = 0.0f;
		direction = 1.0f;
		spriteScale = 1.0f;
	}

	public void setHspeed(float s)
	{
		hspeed = s;
	}

	public void setX(int _x)
	{
		x = _x;
	}

	public void setDirection(float d)
	{
		direction = d;
	}

	public void setSpriteScale(float s)
	{
		spriteScale = s;
	}

	public boolean setFrame(int f)
	{
		if(0 <= f && f < spritesArray.length)
		{
			spriteFrame = f;
			return true;
		}
		else
			return false;
	}

	public int getFrame()
	{
		return spriteFrame;
	}

	public void update()
	{
		x += hspeed;
	}

	public int getX()
	{
		return x;
	}

	public float getHspeed()
	{
		return hspeed;
	}

	public void draw(){
		pushMatrix();
		translate(x + (spritesArray[spriteFrame].width / 2.0f), 
				  y - (spritesArray[spriteFrame].height / 2.0f));
		scale(direction * spriteScale, spriteScale);
		image(spritesArray[spriteFrame], 0, 0);
		popMatrix();
	}
}
class nonmovingObject{
	PImage sprite;
	int x, y;
	boolean shouldDraw;

	nonmovingObject(int _x, int _y, PImage _sprite)
	{
		x = _x;
		y = _y;
		sprite = _sprite;
		shouldDraw = true;
	}

	public void setShouldDraw(boolean b)
	{
		shouldDraw = b;
	}

	public int getX()
	{
		return x;
	}

	public void draw(){
		if(!shouldDraw)
			return;

		pushMatrix();
		translate(x + (sprite.width / 2.0f), 
				  y - (sprite.height / 2.0f));
		image(sprite, 0, 0);
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
