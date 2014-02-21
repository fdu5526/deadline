void initBackground()
{
  backImage = loadImage("background1.jpg");
}

void initMainCharacter()
{
  PImage[] sprites = new PImage[3];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("main_"+(i+1)+".png");
  }
  mainCharacter = new MainCharacter(width/3, ground, sprites);
}