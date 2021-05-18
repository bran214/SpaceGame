class Entity
{
  PImage appearance;
  HitboxGroup hitboxGroup;
  Timer internalClock;
  float health;
  
  public Entity(String appearanceFile, HitboxGroup hitboxGroup, float health)
  {
    appearance = loadImage(appearanceFile);
    this.hitboxGroup = hitboxGroup;
    internalClock = new Timer();
    this.health = health;
  }
  
  HitboxGroup getHitboxGroup()
  {
    return hitboxGroup;
  }
  
  float getX()
  {
    return hitboxGroup.getX();
  }
  
  float getY()
  {
    return hitboxGroup.getY();
  }
  
  Timer getClock()
  {
    return internalClock;
  }
  
  void display()
  {
    imageMode(CENTER);
    image(appearance, hitboxGroup.getX(), hitboxGroup.getY());
  }
  
  void display(int imageWidth, int imageHeight)
  {
    imageMode(CENTER);
    image(appearance, hitboxGroup.getX(), hitboxGroup.getY(), imageWidth, imageHeight);
  }
  
  void move(float xChange, float yChange)
  {
    hitboxGroup.setPosition(hitboxGroup.getX() + xChange, hitboxGroup.getY() + yChange);
  }
  
  void updateClock()
  {
    internalClock.increaseElapsed();
  }
  
  void updateClock(float framerate)
  {
    internalClock.increaseElapsed(framerate);
  }
  
  void setPosition(float x, float y)
  {
    hitboxGroup.setPosition(x, y);
  }
  
  void increaseHealth(float healthChange)
  {
    health += healthChange;
  }
  
  void decreaseHealth(float damage)
  {
    health -= damage;
  }
}
