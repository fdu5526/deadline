import ddf.minim.*;

multiSpriteObject mainCharacter, backgroundSprites;
nonmovingObject light, clothes, spacebarHint1, spacebarHint2, adHint;
ParticleSystem[] snowParticleSystem;
PanicWord[] panicWords;
float newPanicWordTimer;
SourceCode sourceCode;

final int ground = 691;
final float characterSpeed = 15.0;
final int panicWordLifespan = 500;
final PFont impactFont = createFont("Impact",16,true);
final PFont codeFont = createFont("Consolas",16,true);

boolean userInteracted, satDown;

Minim minim;
AudioPlayer intenseMusic, pianoMusic;

void setup() {
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

void draw() { 
  
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