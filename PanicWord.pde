class PanicWord{
	String word;
	int x, y, fontSize;
	int r, g, b, t;
	boolean shouldDraw;
	float lifeStartMillis;

	PanicWord(String _s)
	{
		t = 255;
		setNewLocation();
		word = _s;
		shouldDraw = false;
	}

	boolean getShouldDraw()
	{
		return shouldDraw;
	}

	void setNewLocation()
	{
		x = (int)random(-10, width - 800);
		y = (int)random(0, height - 10);
		fontSize = (int)random(75, 175);
		r = (int)random(175, 255);
		g = (int)random(175, 255);
		b = (int)random(175, 255);
	}

	void setTransparency(int i)
	{
		t = i;
	}

	void resetLifeStartMillis()
	{
		lifeStartMillis = millis();
	}

	void draw(){
		if(!(millis() - lifeStartMillis <= panicWordLifespan*2))
			return;

		textFont(impactFont, fontSize);
		fill(r,g,b, t);
		text(word, x, y);
	}
}
