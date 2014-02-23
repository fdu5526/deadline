class multiSpriteObject{
	PImage[] spritesArray;
	int x, y, spriteFrame;
	float hspeed, direction;
	float spriteScale;
	boolean canMove;

	multiSpriteObject(int _x, int _y, PImage[] _sprites)
	{
		x = _x;
		y = _y;
		spritesArray = _sprites;
		spriteFrame = 0;
		hspeed = 0.0;
		direction = 1.0;
		spriteScale = 1.0;
		canMove = true;
	}

	void setHspeed(float s)
	{
		hspeed = s;
	}

	void setX(int _x)
	{
		x = _x;
	}

	void setY(int _y)
	{
		y = _y;
	}

	void setDirection(float d)
	{
		direction = d;
	}

	void setSpriteScale(float s)
	{
		spriteScale = s;
	}

	float getSpriteScale()
	{
		return spriteScale;
	}

	boolean setFrame(int f)
	{
		if(0 <= f && f < spritesArray.length)
		{
			spriteFrame = f;
			return true;
		}
		else
			return false;
	}

	int getFrame()
	{
		return spriteFrame;
	}

	int getX()
	{
		return x;
	}

	float getHspeed()
	{
		return hspeed;
	}

	boolean getCanMove()
	{
		return canMove;
	}

	void setCanMove(boolean b)
	{
		canMove = b;
	}

	void update()
	{
		if(canMove)
			x += hspeed;
	}
	
	void draw(){
		pushMatrix();
		translate(x + (spritesArray[spriteFrame].width * spriteScale / 2.0), 
				  y - (spritesArray[spriteFrame].height * spriteScale / 2.0));
		scale(direction * spriteScale, spriteScale);
		image(spritesArray[spriteFrame], 0, 0);
		popMatrix();
	}
}
