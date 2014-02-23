class nonmovingObject{
	PImage sprite;
	int x, y;
	float lifeStartMillis;
	boolean shouldDraw;

	nonmovingObject(int _x, int _y, PImage _sprite)
	{
		x = _x;
		y = _y;
		sprite = _sprite;
		shouldDraw = true;
	}

	void setShouldDraw(boolean b)
	{
		shouldDraw = b;
	}

	int getX()
	{
		return x;
	}

	void draw(){
		if(!shouldDraw)
			return;

		pushMatrix();
		translate(x + (sprite.width / 2.0), 
				  y - (sprite.height / 2.0));
		image(sprite, 0, 0);
		popMatrix();
	}
}
