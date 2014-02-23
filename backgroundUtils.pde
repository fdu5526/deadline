
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