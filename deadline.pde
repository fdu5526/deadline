multiSpriteObject mainCharacter, backgroundSprites;
nonmovingObject light, clothes;
int ground;
final float characterSpeed = 30.0;
boolean inzone;

void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);

  ground = 691;
  inzone = false;

  initBackground();
  initNonmovableObjects();
  initMainCharacter();  
}

void draw() { 
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

void keyPressed() {
  if(key == 'a')
  {
    mainCharacter.setHspeed(-1.0 * characterSpeed);
    mainCharacter.setDirection(-1.0);
  }
  else if(key == 'd')
  {
    mainCharacter.setHspeed(characterSpeed);
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