import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

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
nonmovingObject light, clothes, spacebarHint1, spacebarHint2, adHint;
ParticleSystem[] snowParticleSystem;
PanicWord[] panicWords;
float newPanicWordTimer;
SourceCode sourceCode;

final int ground = 691;
final float characterSpeed = 15.0f;
final int panicWordLifespan = 500;
final PFont impactFont = createFont("Impact",16,true);
final PFont codeFont = createFont("Consolas",16,true);

boolean userInteracted, satDown;

Minim minim;
AudioPlayer intenseMusic, pianoMusic;

public void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);
  noStroke();

  userInteracted = false;
  satDown = false;

  initBackground();
  initMusicFile();
  initPanicWords();
  initSourceCode();
  initNonmovableObjects();
  initParticleSystem();
  initMainCharacter();

  intenseMusic.play();
}

public void draw() { 
  
  drawBackground();

  // loop music
  if(!(intenseMusic.isPlaying()))
    intenseMusic.rewind();
  if(!(pianoMusic.isPlaying()))
    pianoMusic.rewind();

  // hit left of background
  if(mainCharacter.getX()+mainCharacter.getHspeed() < 10)
  {
    if(mainCharacter.getFrame() != 2 &&
      backgroundSprites.getFrame() == 1){}
    else
    {
      boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() + 1);
      if(succ)
      {
        mainCharacter.setX(width - 50);
        switchBackground();
      }
    }
  }
  // hit right of background
  else if(width-50 < mainCharacter.getX()+mainCharacter.getHspeed())
  {
    boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() - 1);
    if(succ)
    {
      mainCharacter.setX(10);
      switchBackground();
    }
  }
  // normal movement
  else
    mainCharacter.update();

  // draws the main character
  mainCharacter.draw();

  // only draw source code if we are sitting down
  if(satDown)
  {
    drawSourceCode();
  }

  // update states of everything in background
  updateBackground();
}
class PanicWord{
	String word;
	int x, y, fontSize;
	int r, g, b, t;
	boolean shouldDraw;
	float lifeStartMillis;

	PanicWord(String _s)
	{
		t = 255;
		setNewLocation();
		word = _s;
		shouldDraw = false;
	}

	public boolean getShouldDraw()
	{
		return shouldDraw;
	}

	public void setNewLocation()
	{
		x = (int)random(-10, width - 800);
		y = (int)random(0, height - 10);
		fontSize = (int)random(75, 175);
		r = (int)random(175, 255);
		g = (int)random(175, 255);
		b = (int)random(175, 255);
	}

	public void setTransparency(int i)
	{
		t = i;
	}

	public void resetLifeStartMillis()
	{
		lifeStartMillis = millis();
	}

	public void draw(){
		if(!(millis() - lifeStartMillis <= panicWordLifespan*2))
			return;

		textFont(impactFont, fontSize);
		fill(r,g,b, t);
		text(word, x, y);
	}
}

/**
 * draw each background specific objects
 */
public void drawBackground()
{
  backgroundSprites.draw();
  switch(backgroundSprites.getFrame()){
    case 0:
      drawPanicWord();
      light.draw();
      spacebarHint1.draw();
      adHint.draw();
      break;
    case 1:
      drawPanicWord();
      clothes.draw();
      spacebarHint2.draw();
      break;
    case 2:
      drawPanicWord();
    default:
      break;
  }
}

/**
 * determine what to draw, 
 * depending on which scene we are on
 */
public void updateBackground()
{

  switch(backgroundSprites.getFrame()){
    case 0:

      // for light
      if(mainCharacter.getX() <= light.getX() + 200 && 
         light.getX() <= mainCharacter.getX())
      {
        if(userInteracted)
        {
          if(mainCharacter.getFrame() == 0 || 
             mainCharacter.getFrame() == 2)
          {
            mainCharacter.setFrame(mainCharacter.getFrame() + 1);
            mainCharacter.setX(787);
            mainCharacter.setHspeed(0.0f);
            mainCharacter.setDirection(1.0f);

            light.setShouldDraw(true);
            satDown = true;
          }
          else
          {
            mainCharacter.setFrame(mainCharacter.getFrame() - 1);
            light.setShouldDraw(false);
            satDown = false;
          }

          userInteracted = false;
        }
      }
      else
      {
        light.setShouldDraw(false);
      }

      for(int i = 0; i < snowParticleSystem.length; i++)
      {
        snowParticleSystem[i].setShouldDraw(false);
      }

      break;
    case 1:

      // for clothes
      if(mainCharacter.getX() <= clothes.getX() + 120 && 
         clothes.getX() - 120 <= mainCharacter.getX())
        {

          if(mainCharacter.getFrame() == 0 && userInteracted)
          {
            clothes.setShouldDraw(false);
            mainCharacter.setFrame(2);
          }
          else if(userInteracted)
          {
            clothes.setShouldDraw(true);
            mainCharacter.setFrame(0); 
          }
          userInteracted = false;
        }


      for(int i = 0; i < snowParticleSystem.length; i++)
      {
        snowParticleSystem[i].setShouldDraw(false);
      }

      break;
    case 2: case 3: case 4: case 5: case 6:

      for(int i = 0; i < snowParticleSystem.length; i++)
      {
        snowParticleSystem[i].setShouldDraw(true);
      }
      break;

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
public void switchBackground()
{
  float mainScale = 1.0f;
  float snowWidth = 10.0f;
  int extraGround = 0;

  switch(backgroundSprites.getFrame()) {
    case 0:
      intenseMusic.play();
      intenseMusic.setGain(0);
      pianoMusic.pause();
      setTransparencyPanicWord(200);
      break;

    case 1:
      intenseMusic.play();
      intenseMusic.setGain(-5);
      pianoMusic.pause();
      setTransparencyPanicWord(100);
      break;

    case 2:
      intenseMusic.play();
      intenseMusic.setGain(-20);
      setTransparencyPanicWord(20);
      break;

    case 3:
      pianoMusic.pause();
      intenseMusic.pause();
      break;

    case 4:
      pianoMusic.play();
      pianoMusic.setGain(-8);
      intenseMusic.pause();

      mainScale = 0.75f;
      extraGround = 76;
      snowWidth = 7.5f;
      break;

    case 5:
      pianoMusic.play();
      pianoMusic.setGain(-5);
      intenseMusic.pause();

      mainScale = 0.55f;
      extraGround = 103;
      snowWidth = 7.0f;
      break;

    case 6:
      pianoMusic.play();
      pianoMusic.setGain(0);
      intenseMusic.pause();

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
class SourceCode{
	String code;
	int index;

	SourceCode(String s)
	{
		code = s;
		index = 0;
	}

	public void increaseIndex()
	{
		if(index < code.length())
			index++;
	}
	public void draw()
	{
		fill(255);
		textFont(codeFont, 20);

		String sub = code.substring(0, index);
		int linenumber = sub.length() - 
						 sub.replace("\n", "").length();
		if(linenumber > 20)
			text(sub, width/4 + 20, 
				 20 - (linenumber - 20)*26);
		else
			text(sub, width/4 + 20, 
			 20);
	}
}


public void drawSourceCode()
{
	fill(0, 200);
    rect(width/4, 0, 2*width/4, height);

    sourceCode.draw();
}

public void keyPressed() {
  if(key == 'a')
  {
    if(satDown)
    {
      sourceCode.increaseIndex();
    }
    else
    {
      mainCharacter.setHspeed(-1.0f * characterSpeed * 
                              mainCharacter.getSpriteScale());
      mainCharacter.setDirection(-1.0f);
    }
  }
  else if(key == 'd')
  {
    if(satDown)
    {
      sourceCode.increaseIndex();
    }
    else
    {
      mainCharacter.setHspeed(characterSpeed * 
                              mainCharacter.getSpriteScale());
      mainCharacter.setDirection(1.0f);
    }
  }
  else if(key == ' ')
  {
      userInteracted = true;
  }
}

public void keyReleased() {
  if(key == 'a')
    mainCharacter.setHspeed(0.0f);
  else if(key == 'd')
    mainCharacter.setHspeed(0.0f);
  userInteracted = false;
}

public void initBackground()
{
  PImage[] sprites = new PImage[7];

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
  spacebarHint1 = new nonmovingObject(743, 291, loadImage("spacebar.png"));
  spacebarHint2 = new nonmovingObject(865, 111, loadImage("spacebar.png"));
  adHint = new nonmovingObject(width/6, 291, loadImage("adbutton.png"));
}

public void initMainCharacter()
{
  PImage[] sprites = new PImage[4];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("main_"+(i)+".png");
  }
  mainCharacter = new multiSpriteObject(width/6, ground, sprites);
}

public void initParticleSystem()
{
  snowParticleSystem = new ParticleSystem[4];
  for(int i = 0; i < snowParticleSystem.length; i++)
    snowParticleSystem[i] = new ParticleSystem(
                              new PVector(i*width/(snowParticleSystem.length - 1), -150), 10.0f, false);
}

public void initMusicFile()
{
  minim = new Minim (this);
  pianoMusic   = minim.loadFile ("GymnopedieNo1.mp3");
  intenseMusic = minim.loadFile ("In a Heartbeat.mp3");
}

public void initPanicWords()
{
  newPanicWordTimer = millis();

  String[] panicStrings = {"OH NO", "GO GO GO", "DEADLINE LOOMS",
                           "GPA GOING DOWN", "NO SLEEP TONIGHT",
                           "I'M GOING TO FAIL", "WORK WORK WORK",
                           "DON'T SLACK OFF", "NO TIME LEFT",
                           "DON'T SOCIALIZE", "NO TIME FOR FUN",
                           "RUNNING OUT OF TIME", "SUFFER SUFFER SUFFER",
                           "GOING TO BE LATE", "CAN'T PASS"};
  panicWords = new PanicWord[panicStrings.length];

  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i] = new PanicWord(panicStrings[i]);
  }
}

public void initSourceCode()
{
  String codeString = "";
  try {
        BufferedReader br = createReader("deadline.java");
        StringBuilder sb = new StringBuilder();
        String line = br.readLine();

        while (line != null) {
            sb.append(line + "\n");
            line = br.readLine();
        }
        codeString = sb.toString();
    }
    catch (IOException e){}
    sourceCode = new SourceCode(codeString);
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
	float lifeStartMillis;
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

/**
 * draws panic word
 */
public void drawPanicWord()
{
  // set a new panic word to draw
  if(millis() - newPanicWordTimer > panicWordLifespan - 150)
  {
    showNewPanicWord();
    newPanicWordTimer = millis();
  }

  // draw all the panic words
  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i].draw();
  }
}

/**
 * change transparency of the panic words
 */
public void setTransparencyPanicWord(int t)
{
  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i].setTransparency(t);
  }
}
/**
 * make a new panic word visible
 */
public void showNewPanicWord()
{
  int i = (int)random(0, panicWords.length);
  while(panicWords[i].getShouldDraw())
  {
    i = (int)random(0, panicWords.length);
  }

  PanicWord p = panicWords[i];
  p.resetLifeStartMillis();
  p.setNewLocation();

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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "deadline" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
