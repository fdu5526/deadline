class multiSpriteObject{
	PImage[] spritesArray;
	int x, y, spriteFrame;
	float hspeed, direction;

	multiSpriteObject(int _x, int _y, PImage[] _sprites)
	{
		x = _x;
		y = _y;
		spritesArray = _sprites;
		spriteFrame = 0;
		hspeed = 0.0;
		direction = 1.0;
	}

	void setHspeed(float s)
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

	int getFrame()
	{
		return spriteFrame;
	}

	void update()
	{
		x += hspeed;
	}

	int getX()
	{
		return x;
	}

	float getHspeed()
	{
		return hspeed;
	}

	void draw(){
		pushMatrix();
		translate(x + (spritesArray[spriteFrame].width / 2.0), 
				  y - (spritesArray[spriteFrame].height / 2.0));
		scale(direction, 1.0);
		image(spritesArray[spriteFrame], 0, 0);
		popMatrix();
	}
}
