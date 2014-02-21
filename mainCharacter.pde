class MainCharacter{
	PImage[] spritesArray;
	int x, y, spriteFrame;
	float hspeed, direction;

	MainCharacter(int _x, int _y, PImage[] _sprites)
	{
		x = _x;
		y = _y;
		spritesArray = _sprites;
		spriteFrame = 0;
		hspeed = 0.0;
		direction = 1.0;
	}

	void setSpeed(float s)
	{
		hspeed = s;
	}

	void setDirection(float d)
	{
		direction = d;
	}

	void setFrame(int f)
	{
		if(0 <= f && f < spritesArray.length)
			spriteFrame = f;
	}

	void update()
	{
		// no going off screen
		if((0 < x-hspeed && x-hspeed < width))
			x += hspeed;
	}

	void draw(){
		pushMatrix();
		translate(x, y);
		scale(direction, 1.0);
		image(spritesArray[spriteFrame], 0, 0);
		popMatrix();
	}
}
