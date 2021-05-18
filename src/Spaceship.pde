class Spaceship extends Entity
{
  float maximumHealth;
  Timer immunity;
  Hitbox bounds;
  
  public Spaceship(String appearanceFile, HitboxGroup hitboxGroup, float health, float maximumHealth)
  {
    super(appearanceFile, hitboxGroup, health);
    this.maximumHealth = maximumHealth;
    immunity = new Timer(1);
  }
  
  void display(float minimumShieldRadius, float maximumShieldRadius, float shieldRedValue, float shieldGreenValue, float shieldBlueValue)
  {
    imageMode(CENTER);
    image(appearance, hitboxGroup.getX(), hitboxGroup.getY());
    displayShield(minimumShieldRadius, maximumShieldRadius, shieldRedValue, shieldGreenValue, shieldBlueValue);
  }
  
  void displayShield(float minimumRadius, float maximumRadius, float redValue, float greenValue, float blueValue)
  {
    if (this.isImmune())
    {
      noFill();
      strokeWeight((maximumRadius - minimumRadius) / 10);
      for (int i = 0; i < 10; i++)
      {
        stroke(redValue, greenValue, blueValue, i * 25);
        circle(hitboxGroup.x, hitboxGroup.y, minimumRadius + i * (maximumRadius - minimumRadius) / 10);
      }
    }
  }
  
  
  // returns true if the spaceship has been moved to its desired location
  // else it moves the spaceship to its desired location at a certain speed
  boolean moved(float x, float y, float speed)
  {
    if (!(x >= this.hitboxGroup.x - speed && x <= this.hitboxGroup.x + speed && y >= this.hitboxGroup.y - speed && y <= this.hitboxGroup.y + speed))
    {
      this.move(((x - this.hitboxGroup.x) / dist(x, y, this.hitboxGroup.x, this.hitboxGroup.y)) * speed, ((y - this.hitboxGroup.y) / dist(x, y, this.hitboxGroup.x, this.hitboxGroup.y)) * speed);
      return false;
    }
    else
    {
      this.setPosition(x, y);
      return true;
    }
  }
  
  void updateImmunity()
  {
    immunity.increaseElapsed();
  }
  
  void updateImmunity(float framerate)
  {
    immunity.increaseElapsed(framerate);
  }
  
  void setImmune()
  {
    this.setImmune(1000);
  }
  
  void setImmune(float time)
  {
    immunity = new Timer(time);
  }
  
  boolean isImmune()
  {
    return !immunity.isDone();
  }
}
