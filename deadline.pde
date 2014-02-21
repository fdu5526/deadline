int ground;  // ground height
multiSpriteObject mainCharacter, backgroundSprites;
final float characterSpeed = 10.0;

void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);

  ground = 691;

  initBackground();
  initMainCharacter();  
}

void draw() { 
  stroke(0);
  
  backgroundSprites.draw();

  // hit left of background
  if(mainCharacter.getX()+mainCharacter.getHspeed() < 10)
    backgroundSprites.setFrame(backgroundSprites.getFrame() + 1);
  // hit right of background
  else if(width-50 < mainCharacter.getX()+mainCharacter.getHspeed())
    backgroundSprites.setFrame(backgroundSprites.getFrame() - 1);
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

