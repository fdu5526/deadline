import ddf.minim.*;

multiSpriteObject mainCharacter, backgroundSprites;
nonmovingObject light, clothes;
final int ground = 691;
final float characterSpeed = 30.0;
final int panicWordLifespan = 500;
boolean inzone;
ParticleSystem[] snowParticleSystem;
PanicWord[] panicWords;
float newPanicWordTimer;

Minim minim;
AudioPlayer intenseMusic, pianoMusic;

void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);
  noStroke();

  inzone = false;

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
    boolean succ = backgroundSprites.setFrame(backgroundSprites.getFrame() + 1);
    if(succ)
    {
      mainCharacter.setX(width - 50);
      switchBackground();
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

  updateBackground();
}

void keyPressed() {
  if(key == 'a')
  {
    mainCharacter.setHspeed(-1.0 * characterSpeed * 
                            mainCharacter.getSpriteScale());
    mainCharacter.setDirection(-1.0);
  }
  else if(key == 'd')
  {
    mainCharacter.setHspeed(characterSpeed * 
                            mainCharacter.getSpriteScale());
    mainCharacter.setDirection(1.0);
  }
}

void keyReleased() {
  if(key == 'a')
    mainCharacter.setHspeed(0.0);
  else if(key == 'd')
    mainCharacter.setHspeed(0.0);
}

/**
 * draw each background specific objects
 */
void drawBackground()
{
  backgroundSprites.draw();
  switch(backgroundSprites.getFrame()){
    case 0:
      light.draw();
      drawPanicWord();
      break;
    case 1:
      clothes.draw();
      drawPanicWord();
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
void updateBackground()
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
    case 3: case 4: case 5: case 6:

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
void switchBackground()
{
  float mainScale = 1.0;
  float snowWidth = 10.0;
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

      mainScale = 0.75;
      extraGround = 76;
      snowWidth = 7.5;
      break;

    case 5:
      pianoMusic.play();
      pianoMusic.setGain(-5);
      intenseMusic.pause();

      mainScale = 0.55;
      extraGround = 103;
      snowWidth = 7.0;
      break;

    case 6:
      pianoMusic.play();
      pianoMusic.setGain(0);
      intenseMusic.pause();

      mainScale = 0.3;
      extraGround = 129;
      snowWidth = 6.0;
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

/**
 * draws panic word
 */
void drawPanicWord()
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
void setTransparencyPanicWord(int t)
{
  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i].setTransparency(t);
  }
}
/**
 * make a new panic word visible
 */
void showNewPanicWord()
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