class HealingOrb extends Projectile
{
  Spaceship target;
  final static int DEFAULT_HEALING_AMOUNT = 50;
    
  public HealingOrb(Spaceship target)
  {
    this(target, random(width), -300);
  }
  
  public HealingOrb(Spaceship target, float x, float y)
  {
    this(target, x, y, DEFAULT_HEALING_AMOUNT);
  }
  
  public HealingOrb(Spaceship target, float x, float y, int healingAmount)
  {
    super("HealingOrb.png", new HitboxGroup(x, y, new float[] {0}, new float[] {0}, new float[] {50}, new float[] {50}), 1, -healingAmount, 0, 0);
    this.target = target;
  }
  
  void move()
  {
    // change healing orb's speed to reach where the spaceship is
    xSpeed = (target.getHitboxGroup().getX() - hitboxGroup.x) / 50;
    ySpeed = (target.getHitboxGroup().getY() - hitboxGroup.y) / 50;
    super.move();
  }
  
  boolean heal()
  {
    if (this.hitboxGroup.intersectsWith(target.getHitboxGroup()))
    {
      target.increaseHealth(-damage);
      if (target.health > target.maximumHealth)
      {
        target.health = target.maximumHealth;
      }
      return true;
    }
    return false;
  }
}
