
void keyPressed() {
  if(key == 'a')
  {
    if(satDown)
    {
      sourceCode.increaseIndex();
    }
    else
    {
      mainCharacter.setHspeed(-1.0 * characterSpeed * 
                              mainCharacter.getSpriteScale());
      mainCharacter.setDirection(-1.0);
    }
  }
  else if(key == 'd')
  {
    if(satDown)
    {
      sourceCode.increaseIndex();
    }
    else
    {
      mainCharacter.setHspeed(characterSpeed * 
                              mainCharacter.getSpriteScale());
      mainCharacter.setDirection(1.0);
    }
  }
  else if(key == ' ')
  {
      userInteracted = true;
  }
}

void keyReleased() {
  if(key == 'a')
    mainCharacter.setHspeed(0.0);
  else if(key == 'd')
    mainCharacter.setHspeed(0.0);
  userInteracted = false;
}