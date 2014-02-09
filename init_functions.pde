void init_background()
{
  back_image = loadImage("background.jpg");
  tree1 = loadImage("tree_1.png");
  tree2 = loadImage("tree_2.png");
}

void init_main_creature()
{
  PImage[] main_small_sprites = new PImage[4];
  PImage[] main_big_sprites = new PImage[4];

  for(int i = 0; i < main_small_sprites.length; i++)
  {
    main_small_sprites[i] = loadImage("main_"+(i+1)+".png");
    main_big_sprites[i] = loadImage("main_big_"+(i+1)+".png");
  }
  main_creature = new Main_creature(width/2, ground-30, main_small_sprites, main_big_sprites);
}

void init_mindless_creatures()
{
  PImage mindless_creature = loadImage("mindless_creature.png");
  mindless_creatures = new Mindless_creature[num_of_mc];

  for(int i = 0; i < mindless_creatures.length; i++)
  {
    mindless_creatures[i] = new Mindless_creature
                            (width/2 + (int)random(-300, 300),
                             ground-20, mindless_creature);
  }
  
}
