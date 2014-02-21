void initBackground()
{
  PImage[] sprites = new PImage[3];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("background"+(i+1)+".jpg");
  }
  backgroundSprites = new multiSpriteObject(0, height, sprites);
}

void initNonmovableObjects()
{
  light = new nonmovingObject(677, 474, loadImage("light.png"));
  clothes = new nonmovingObject(980, 552, loadImage("clothes.png"));
}

void initMainCharacter()
{
  PImage[] sprites = new PImage[3];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("main_"+(i+1)+".png");
  }
  mainCharacter = new multiSpriteObject(width/3, ground, sprites);
}