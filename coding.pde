class SourceCode{
	String code;
	int index;

	SourceCode(string s, int i)
	{
		code = s;
		index = i;
	}

	void draw()
	{
		
	}
}


void drawSourceCode()
{
	fill(0, 200);
    rect(width/4, 0, 2*width/4, height);
}