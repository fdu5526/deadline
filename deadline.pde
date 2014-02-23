multiSpriteObject mainCharacter, backgroundSprites;
nonmovingObject light, clothes;
final int ground = 691;
final float characterSpeed = 30.0;
boolean inzone;
ParticleSystem[] snowParticleSystem;


void setup() {
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

void draw() { 
  
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

void drawBackground()
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

void updateBackground()
{

  // keep particle system running
  for(int i = 0; i < snowParticleSystem.length; i++)
  {
    snowParticleSystem[i].addParticle();
    snowParticleSystem[i].run();
  }

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
}

/**
 * for updating the scale of sprites
 */
void updateScale()
{
  switch(backgroundSprites.getFrame()) {
    
    case 3:
      mainCharacter.setSpriteScale(0.75);
      mainCharacter.setY(ground + 76);

      for(int i = 0; i < snowParticleSystem.length; i++)
        snowParticleSystem[i].setParticleWidth(7.5);
      break;
    case 4:
      mainCharacter.setSpriteScale(0.55);
      mainCharacter.setY(ground + 103);

      for(int i = 0; i < snowParticleSystem.length; i++)
        snowParticleSystem[i].setParticleWidth(5.5);
      break;
    case 5:
      mainCharacter.setSpriteScale(0.3);
      mainCharacter.setY(ground + 129);

      for(int i = 0; i < snowParticleSystem.length; i++)
        snowParticleSystem[i].setParticleWidth(6.0);
      break;

    default:
      mainCharacter.setSpriteScale(1.0);
      mainCharacter.setY(ground);

      for(int i = 0; i < snowParticleSystem.length; i++)
        snowParticleSystem[i].setParticleWidth(10.0);
  }
}