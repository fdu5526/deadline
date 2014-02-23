
/**
 * draw each background specific objects
 */
void drawBackground()
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
void updateBackground()
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
            mainCharacter.setHspeed(0.0);
            mainCharacter.setDirection(1.0);

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