int ground, num_of_mc;  // ground height, number of mindless
float large_start_time; // millis of when player becomes large
Main_creature main_creature;
Mindless_creature[] mindless_creatures;
PImage tree1, tree2, back_image;

void setup() {
  size(1000, 480);
  frameRate(30);

  imageMode(CENTER);

  num_of_mc = 5;
  ground = 410;
  large_start_time = 0.0;

  init_background();
  init_main_creature();
  init_mindless_creatures();
  
}

void draw() { 
  draw_background();
  stroke(0);

  // keep track when was last time main_creature was large
  if(main_creature.am_i_large())
  {
    large_start_time = millis();
  }
  // if the player hasnt been large for 5 seconds, deer come back
  if(large_start_time != 0.0 &&
     millis() - large_start_time > 5000.0 && 
     !main_creature.am_i_large())
  {
    large_start_time = 0.0;

    // deers come back and revive
    int[] possible_positions = {-20, width+20};
    for(int i = 0; i < mindless_creatures.length; i++)
    {
      int idx = (int)random(0, 2);
      mindless_creatures[i].change_x(possible_positions[idx]);
      mindless_creatures[i].give_existence();
    }
  }

  main_creature.update();
  main_creature.draw();
  // draw everything
  for(int i = 0; i < mindless_creatures.length; i++)
  {
    mindless_creatures[i].update();
    mindless_creatures[i].draw();
  }

}

/**
 * draws the background
 */
void draw_background()
{
  image(back_image,width/2,height/2);

  image(tree1, 700, ground - 125);
  image(tree2, 50, ground - 125);
  pushMatrix();
  translate(200, ground - 125);
  scale(-1,1);
  image(tree1, 0, 0);
  popMatrix();

}

void keyPressed() {
  if(key == 'a')
    main_creature.change_speed(3.0);
  else if(key == 'd')
    main_creature.change_speed(-3.0);
  else if(key == 'w')
    main_creature.change_size(10.0);
  else if(key == 's')
    main_creature.change_size(1.0);
   
}
