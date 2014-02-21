int ground;  // ground height
MainCharacter mainCharacter;
PImage backImage;
final float characterSpeed = 10.0;

void setup() {
  size(1600, 900);
  frameRate(30);

  imageMode(CENTER);

  ground = 410;

  initBackground();
  initMainCharacter();  
}

void draw() { 
  drawBackground();
  stroke(0);
  mainCharacter.update();
  mainCharacter.draw();

}

/**
 * draws the background
 */
void drawBackground()
{
  image(backImage,width/2,height/2);
}

void keyPressed() {
  if(key == 'a')
  {
    mainCharacter.setSpeed(-1.0 * characterSpeed);
    mainCharacter.setDirection(-1.0);
  }
  else if(key == 'd')
  {
    mainCharacter.setSpeed(characterSpeed);
    mainCharacter.setDirection(1.0);
  }
}

void keyReleased() {
  if(key == 'a')
    mainCharacter.setSpeed(0.0);
  else if(key == 'd')
    mainCharacter.setSpeed(0.0);
}

