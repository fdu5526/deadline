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
		creature_size = 1.0;
		is_large = false;
		sprite_frame = 0;
		big_cool_down = 0.0;
	}

	void jump(float v)
	{
		vspeed = v;
	}

	void change_acceleration(float a)
	{
		if(a * hspeed < 0.0)
			hacceleration = a*10.0;
		else
			hacceleration = a;
	}

	void change_speed(float s)
	{
		hspeed = s;
	}

	void change_hposition(int _x)
	{
		x = _x;
	}

	void change_size(float s)
	{
		creature_size = s/1.5;
		if(creature_size < 1.0)
			creature_size = 1.0;

		if(creature_size > 4.0)
		{
			is_large = true;
			big_cool_down = millis();
		}
		else if(creature_size <= 3.5 && 
				millis() - big_cool_down > 1500.0)
			is_large = false;
	}

	boolean am_i_large()
	{
		return is_large;
	}

	float get_size()
	{
		return creature_size;
	}

	void update()
	{
		// increase acceleration
		if(abs(hspeed) < 5.0 || (hacceleration * hspeed < 0.0))
			hspeed += hacceleration;

		// for jumping
		if (y >= 300)
			vspeed = 0;
		else
			vspeed += 5.0;

		// no going off screen
		if((0 < x-hspeed && x-hspeed < width) && 
		   (hacceleration * hspeed >= 0.0))
			x -= hspeed;
		if(0 < y && y < height)
			y -= vspeed;

		// change sprite frame
		if(millis() % 150.0 < 50.0)
		{
			if(sprite_frame == 3)
				sprite_frame = 0;
			else
				sprite_frame++;
		}
	}

	void draw(){

		pushMatrix();

		if(is_large)
			translate(x, y+20);
		else
			translate(x, y-(creature_size-1.0)*30.0);

		if(abs(hspeed) > 0.0)
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
