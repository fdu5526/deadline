void initBackground()
{
  PImage[] sprites = new PImage[7];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("background"+(i)+".jpg");
  }
  backgroundSprites = new multiSpriteObject(0, height, sprites);
}

void initNonmovableObjects()
{
  light = new nonmovingObject(677, 474, loadImage("light.png"));
  clothes = new nonmovingObject(980, 552, loadImage("clothes.png"));
}

void initMainCharacter()
{
  PImage[] sprites = new PImage[4];

  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage("main_"+(i)+".png");
  }
  mainCharacter = new multiSpriteObject(width/3, ground, sprites);
}

void initParticleSystem()
{
  snowParticleSystem = new ParticleSystem[4];
  for(int i = 0; i < snowParticleSystem.length; i++)
    snowParticleSystem[i] = new ParticleSystem(
                              new PVector(i*width/(snowParticleSystem.length - 1), -150), 10.0, false);
}

void initMusicFile()
{
  minim = new Minim (this);
  pianoMusic   = minim.loadFile ("GymnopedieNo1.mp3");
  intenseMusic = minim.loadFile ("In a Heartbeat.mp3");
}

void initPanicWords()
{
  newPanicWordTimer = millis();

  String[] panicStrings = {"OH NO", "GO GO GO", "DEADLINE LOOMS",
                           "GPA GOING DOWN", "NO SLEEP TONIGHT",
                           "I'M GOING TO FAIL", "WORK WORK WORK",
                           "DON'T SLACK OFF", "NO TIME LEFT",
                           "DON'T SOCIALIZE", "NO TIME FOR FUN",
                           "RUNNING OUT OF TIME", "SUFFER SUFFER SUFFER",
                           "GOING TO BE LATE", "CAN'T PASS"};
  panicWords = new PanicWord[panicStrings.length];

  for(int i = 0; i < panicWords.length; i++)
  {
    panicWords[i] = new PanicWord(panicStrings[i]);
  }
}

void initSourceCode()
{
  String codeString = "";
  try {
        BufferedReader br = createReader("deadline.java");
        StringBuilder sb = new StringBuilder();
        String line = br.readLine();

        while (line != null) {
            sb.append(line + "\n");
            line = br.readLine();
        }
        codeString = sb.toString();
    }
    catch (IOException e){}


    sourceCode = new SourceCode(codeString);


}