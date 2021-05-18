class Explosion
{
  PImage[] explosions = new PImage[60];
  
  public Explosion()
  {
    for (int i = 0; i < 60; i++)
    {
      explosions[i] = loadImage("Explosion_00" + i + ".png");
    }
  }
  
  PImage getExplosion(int explosionFrame)
  {
    return explosions[explosionFrame];
  }
}
