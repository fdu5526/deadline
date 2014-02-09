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
		move_frequency = random(800.0,1500.0);
		existence = true;
	}

	void update()
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
		if(large_start_time > 0.0 && 
		   abs(speed) < 6)	//run away from main
		{
			direction = (x - main_creature.x)/
					  	abs((x - main_creature.x));
			speed = (int)random(6,8)*direction;
			dy = (int)speed/2;
		}
		else if(millis()%move_frequency < 25.0)	//wander
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
		if(large_start_time > 0.0 && 
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

	void change_x(int _x)
	{
		x = _x;
	}

	void remove_existence()
	{
		existence = false;
	}

	void give_existence()
	{
		existence = true;
	}

	void draw(){
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