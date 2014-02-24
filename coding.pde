class SourceCode{
	String code;
	int index;

	SourceCode(String s)
	{
		code = s;
		index = 0;
	}

	void increaseIndex()
	{
		if(index < code.length())
			index++;
	}
	void draw()
	{
		fill(0, 255, 0);
		textFont(codeFont, 20);

		String sub = code.substring(0, index);
		int linenumber = sub.length() - 
						 sub.replace("\n", "").length();
		if(linenumber > 20)
			text(sub, width/4 + 20, 
				 20 - (linenumber - 20)*26);
		else
			text(sub, width/4 + 20, 
			 20);
	}
}


void drawSourceCode()
{
	fill(0, 200);
    rect(width/4, 0, 2*width/4, height);

    sourceCode.draw();
}