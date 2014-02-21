class nonmovingObject{
	PImage sprite;
	int x, y;

	nonmovingObject(int _x, int _y, PImage _sprite)
	{
		x = _x;
		y = _y;
		sprite = _sprite;
	}

	void draw(){
		pushMatrix();
		translate(x - (sprite.width / 2.0), 
				  y - (sprite.height / 2.0));
		image(sprite, 0, 0);
		popMatrix();
	}
}
