
/**
 * draws panic word
 */
void drawPanicWord()
{
  // set a new panic word to draw
  if(millis() - newPanicWordTimer > panicWordLifespan - 150)
  {
    showNewPanicWord();
    newPanicWordTimer = millis();
  }

  // draw all the panic words
  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i].draw();
  }
}

/**
 * change transparency of the panic words
 */
void setTransparencyPanicWord(int t)
{
  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i].setTransparency(t);
  }
}
/**
 * make a new panic word visible
 */
void showNewPanicWord()
{
  int i = (int)random(0, panicWords.length);
  while(panicWords[i].getShouldDraw())
  {
    i = (int)random(0, panicWords.length);
  }

  PanicWord p = panicWords[i];
  p.resetLifeStartMillis();
  p.setNewLocation();

}