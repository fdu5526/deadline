import ddf.minim.*;

multiSpriteObject mainCharacter, backgroundSprites;
nonmovingObject light, clothes;
ParticleSystem[] snowParticleSystem;
PanicWord[] panicWords;
float newPanicWordTimer;

final int ground = 691;
final float characterSpeed = 30.0;
final int panicWordLifespan = 500;

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
  initNonmovableObjects();
  initParticleSystem();
  initMainCharacter();

  intenseMusic.play();
}

void draw() { 
  
  drawBackground();

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

  mainCharacter.draw();

  if(satDown)
  {
    drawSourceCode();
  }

  updateBackground();
}