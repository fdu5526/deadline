
void keyPressed() {

  if(key == ' ')
  {
    userInteracted = true;
  }
  else if(satDown)
  {
    sourceCode.increaseIndex();
  }
  else if(key == 'a')
  { 
    mainCharacter.setHspeed(-1.0 * characterSpeed);
    mainCharacter.setDirection(-1.0);
  }
  else if(key == 'd')
  {
    mainCharacter.setHspeed(characterSpeed);
    mainCharacter.setDirection(1.0);  
  }
}

void keyReleased() {
  if(key == 'a')
    mainCharacter.setHspeed(0.0);
  else if(key == 'd')
    mainCharacter.setHspeed(0.0);
  userInteracted = false;
}