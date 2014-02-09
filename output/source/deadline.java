import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class deadline extends PApplet {

int ground, num_of_mc;  // ground height, number of mindless
float large_start_time; // millis of when player becomes large
Main_creature main_creature;
Mindless_creature[] mindless_creatures;
PImage tree1, tree2, back_image;

public void setup() {
  size(1000, 480);
  frameRate(30);

  imageMode(CENTER);

  num_of_mc = 5;
  ground = 410;
  large_start_time = 0.0f;

  init_background();
  init_main_creature();
  init_mindless_creatures();
  
}

public void draw() { 
  draw_background();
  stroke(0);

  // keep track when was last time main_creature was large
  if(main_creature.am_i_large())
  {
    large_start_time = millis();
  }
  // if the player hasnt been large for 5 seconds, deer come back
  if(large_start_time != 0.0f &&
     millis() - large_start_time > 5000.0f && 
     !main_creature.am_i_large())
  {
    large_start_time = 0.0f;

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
public void draw_background()
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

public void keyPressed() {
  if(key == 'a')
    main_creature.change_speed(3.0f);
  else if(key == 'd')
    main_creature.change_speed(-3.0f);
  else if(key == 'w')
    main_creature.change_size(10.0f);
  else if(key == 's')
    main_creature.change_size(1.0f);
   
}
public void init_background()
{
  back_image = loadImage("background.jpg");
  tree1 = loadImage("tree_1.png");
  tree2 = loadImage("tree_2.png");
}

public void init_main_creature()
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

public void init_mindless_creatures()
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
class Main_creature{
	PImage[] small_sprites, big_sprites;
	int x, y, sprite_frame;
	float hspeed, hacceleration, vspeed, 
		  creature_size, big_cool_down;
	boolean is_large;

	Main_creature(int _x, int _y, PImage[] i1, PImage[] i2)
	{
		x = _x;
		y = _y;
		hspeed = 0;
		hacceleration = 0;
		vspeed = 0;
		small_sprites = i1;
		big_sprites = i2;
		creature_size = 1.0f;
		is_large = false;
		sprite_frame = 0;
		big_cool_down = 0.0f;
	}

	public void jump(float v)
	{
		vspeed = v;
	}

	public void change_acceleration(float a)
	{
		if(a * hspeed < 0.0f)
			hacceleration = a*10.0f;
		else
			hacceleration = a;
	}

	public void change_speed(float s)
	{
		hspeed = s;
	}

	public void change_hposition(int _x)
	{
		x = _x;
	}

	public void change_size(float s)
	{
		creature_size = s/1.5f;
		if(creature_size < 1.0f)
			creature_size = 1.0f;

		if(creature_size > 4.0f)
		{
			is_large = true;
			big_cool_down = millis();
		}
		else if(creature_size <= 3.5f && 
				millis() - big_cool_down > 1500.0f)
			is_large = false;
	}

	public boolean am_i_large()
	{
		return is_large;
	}

	public float get_size()
	{
		return creature_size;
	}

	public void update()
	{
		// increase acceleration
		if(abs(hspeed) < 5.0f || (hacceleration * hspeed < 0.0f))
			hspeed += hacceleration;

		// for jumping
		if (y >= 300)
			vspeed = 0;
		else
			vspeed += 5.0f;

		// no going off screen
		if((0 < x-hspeed && x-hspeed < width) && 
		   (hacceleration * hspeed >= 0.0f))
			x -= hspeed;
		if(0 < y && y < height)
			y -= vspeed;

		// change sprite frame
		if(millis() % 150.0f < 50.0f)
		{
			if(sprite_frame == 3)
				sprite_frame = 0;
			else
				sprite_frame++;
		}
	}

	public void draw(){

		pushMatrix();

		if(is_large)
			translate(x, y+20);
		else
			translate(x, y-(creature_size-1.0f)*30.0f);

		if(abs(hspeed) > 0.0f)
			scale(-1*hspeed/abs(hspeed), 1);

		if(is_large)
			image(big_sprites[sprite_frame], 0, 0);
		else
			image(small_sprites[sprite_frame], 0, 0,
				  small_sprites[sprite_frame].width*creature_size,
				  small_sprites[sprite_frame].height*creature_size);

		popMatrix();
	}
}
class Mindless_creature{
	PImage sprite;
	int x, y, dy, creature_size;
	int speed, direction;
	int[] speed_array = {0,(int)random(-5,-2),(int)random(2,5)};
	float move_frequency;
	boolean existence;
	ParticleSystem ps;

	Mindless_creature(int _x, int _y, PImage i)
	{
		x = _x;
		y = _y;
		dy = 0;
		sprite = i;
		creature_size = 50;
		speed = 0;
		direction = 1;
		move_frequency = random(800.0f,1500.0f);
		existence = true;
	}

	public void update()
	{
		// if eaten
		if(existence &&
		   main_creature.am_i_large() && 
		   x > main_creature.x - 150 && 
		   x < main_creature.x + 150)
		{
			// blood splatter
			ps = new ParticleSystem(new PVector(x,y));
			for(int i = 0; i < 200; i++)
			{
				ps.explode();
			}

			remove_existence();
			return;
		}

		// compute speed and direction
		if(large_start_time > 0.0f && 
		   abs(speed) < 6)	//run away from main
		{
			direction = (x - main_creature.x)/
					  	abs((x - main_creature.x));
			speed = (int)random(6,8)*direction;
			dy = (int)speed/2;
		}
		else if(millis()%move_frequency < 25.0f)	//wander
		{
			int idx = (int)random(0,3);
			speed = speed_array[idx];

			if(speed != 0)
				direction = speed/abs(speed);
			dy = (int)speed/2;
		}

		// walking bounce
		if(frameCount % 2 == 0)
		{
			dy *= -1;
		}
		
		// successfully ran away from main creature
		if(large_start_time > 0.0f && 
		   (-30 > x + speed || x + speed > width+30))
		{
			remove_existence();
		}

		// prevent walking out of bounds
		else if(-30 > x + speed || x + speed > width+30)
		{
			speed *= -1;
			direction *= -1;
		}

		x += speed;
	}

	public void change_x(int _x)
	{
		x = _x;
	}

	public void remove_existence()
	{
		existence = false;
	}

	public void give_existence()
	{
		existence = true;
	}

	public void draw(){
		if(ps != null)
			ps.run();

		if(!existence)
			return;

		pushMatrix();

		translate(x,y+dy);
		if(abs(speed) > 0)
			scale(direction, 1);
		
		image(sprite, 0, 0);

		popMatrix();
	}
}
/*
 * thanks to Daniel Shiffman for his example code
 */

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0,random(0.1f, 0.6f));
    float x = random(-8,8);
    float y = random(-10,2);
    velocity = new PVector(x,y);
    location = l.get();
    lifespan = 255.0f;
  }

  public void run() {
    update();
    display();
  }

  // Method to update location
  public void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0f;
  }

  // Method to display
  public void display() {
    stroke(255,0, 0, lifespan);
    fill(255, 0, 0, lifespan);
    ellipse(location.x,location.y,8,8);
  }
  
  // Is the particle still useful?
  public boolean isDead() {
    if (lifespan < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  Particle[] particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new Particle[400];
  }

  public void explode() {
    for(int i = 0; i < 400; i++)
      particles[i] = new Particle(origin);
  }

  public void run() {
    for (int i = particles.length-1; i >= 0; i--)
      particles[i].run();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "deadline" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
