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
final int ground = 691;
final float characterSpeed = 30.0f;
boolean inzone;
ParticleSystem[] snowParticleSystem;


public void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);
  noStroke();

  inzone = false;

  initBackground();
  initNonmovableObjects();
  initParticleSystem();
  initMainCharacter();  
}

public void draw() { 
  
  drawBackground();

  // hit left of background
  if(mainCharacter.getX()+mainCharacter.getHspeed() < 10)
  {
    boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() + 1);
    if(succ)
    {
      mainCharacter.setX(width - 50);
      updateScale();
    }
  }
  // hit right of background
  else if(width-50 < mainCharacter.getX()+mainCharacter.getHspeed())
  {
    boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() - 1);
    if(succ)
    {
      mainCharacter.setX(10);
      updateScale();
    }
  }
  // normal movement
  else
    mainCharacter.update();

  mainCharacter.draw();

  updateBackground();
}

public void keyPressed() {
  if(key == 'a')
  {
    mainCharacter.setHspeed(-1.0f * characterSpeed * 
                            mainCharacter.getSpriteScale());
    mainCharacter.setDirection(-1.0f);
  }
  else if(key == 'd')
  {
    mainCharacter.setHspeed(characterSpeed * 
                            mainCharacter.getSpriteScale());
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

      // for light
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

      for(int i = 0; i < snowParticleSystem.length; i++)
      {
        snowParticleSystem[i].setShouldDraw(false);
      }

      break;
    case 1:

      // for clothes
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

      for(int i = 0; i < snowParticleSystem.length; i++)
      {
        snowParticleSystem[i].setShouldDraw(false);
      }

      break;
    case 2: case 3:
      for(int i = 0; i < snowParticleSystem.length; i++)
      {
        snowParticleSystem[i].setShouldDraw(true);
      }
    default:
      break;
  }

  // keep particle system running
  for(int i = 0; i < snowParticleSystem.length; i++)
  {
    snowParticleSystem[i].addParticle();
    snowParticleSystem[i].run();
  }
}

/**
 * for updating the scale of sprites
 */
public void updateScale()
{
  print(".");
  float mainScale = 1.0f;
  float snowWidth = 10.0f;
  int extraGround = 0;

  switch(backgroundSprites.getFrame()) {
    case 3:
      mainScale = 0.75f;
      extraGround = 76;
      snowWidth = 7.5f;
      break;

    case 4:
      mainScale = 0.55f;
      extraGround = 103;
      snowWidth = 7.0f;
      break;

    case 5:
      mainScale = 0.3f;
      extraGround = 129;
      snowWidth = 6.0f;
      break;

    default:
      break;
  }

  mainCharacter.setSpriteScale(mainScale);
  mainCharacter.setY(ground + extraGround);

  for(int i = 0; i < snowParticleSystem.length; i++)
  {
    snowParticleSystem[i].setParticleWidth(snowWidth);
  }
}
public void initBackground()
{
  PImage[] sprites = new PImage[6];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("background"+(i)+".jpg");
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

public void initParticleSystem()
{
  snowParticleSystem = new ParticleSystem[4];
  for(int i = 0; i < snowParticleSystem.length; i++)
    snowParticleSystem[i] = new ParticleSystem(
                              new PVector(i*width/(snowParticleSystem.length - 1), -150), 10.0f, false);
}
class multiSpriteObject{
	PImage[] spritesArray;
	int x, y, spriteFrame;
	float hspeed, direction;
	float spriteScale;
	boolean canMove;

	multiSpriteObject(int _x, int _y, PImage[] _sprites)
	{
		x = _x;
		y = _y;
		spritesArray = _sprites;
		spriteFrame = 0;
		hspeed = 0.0f;
		direction = 1.0f;
		spriteScale = 1.0f;
		canMove = true;
	}

	public void setHspeed(float s)
	{
		hspeed = s;
	}

	public void setX(int _x)
	{
		x = _x;
	}

	public void setY(int _y)
	{
		y = _y;
	}

	public void setDirection(float d)
	{
		direction = d;
	}

	public void setSpriteScale(float s)
	{
		spriteScale = s;
	}

	public float getSpriteScale()
	{
		return spriteScale;
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

	public int getX()
	{
		return x;
	}

	public float getHspeed()
	{
		return hspeed;
	}

	public boolean getCanMove()
	{
		return canMove;
	}

	public void setCanMove(boolean b)
	{
		canMove = b;
	}

	public void update()
	{
		if(canMove)
			x += hspeed;
	}
	
	public void draw(){
		pushMatrix();
		translate(x + (spritesArray[spriteFrame].width * spriteScale / 2.0f), 
				  y - (spritesArray[spriteFrame].height * spriteScale / 2.0f));
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
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan, particleWidth;

  Particle(PVector l, float s) {
    acceleration = new PVector(0,0.05f);
    velocity = new PVector(random(-5,5),0.5f);
    location = l.get();
    particleWidth = s;
    lifespan = 255.0f;
  }

  public void run() {
    update();
    display();
  }

  public void setParticleWidth(float w)
  {
    particleWidth = w;
  }

  // Method to update location
  public void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0f;
  }

  // Method to display
  public void display() {
    fill(255, lifespan);

    ellipse(location.x,location.y,
            particleWidth, particleWidth);
  }
  
  // Is the particle still useful?
  public boolean isDead() {
    if (lifespan < 0.0f || location.y > mainCharacter.y) {
      return true;
    } else {
      return false;
    }
  }
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float particleWidth;
  boolean shouldDraw;

  ParticleSystem(PVector location, float s, boolean b) {
    origin = location.get();
    particles = new ArrayList<Particle>();
    particleWidth = s;
    shouldDraw = b;
  }

  public void addParticle() {
    particles.add(new Particle(origin, particleWidth));
  }

  public void setShouldDraw(boolean b)
  {
    shouldDraw = b;
  }

  public void setParticleWidth(float s)
  {
    particleWidth = s;
  }


  public void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setParticleWidth(particleWidth);

      p.update();
      if(shouldDraw)
        p.display();

      if (p.isDead()) {
        particles.remove(i);
      }
    }
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
