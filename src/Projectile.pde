class Projectile extends Entity
{
  float damage;
  float xSpeed;
  float ySpeed;
  
  public Projectile(String appearanceFile, HitboxGroup hitboxGroup, float health, float damage, float xSpeed, float ySpeed)
  {
    super(appearanceFile, hitboxGroup, health);
    this.damage = damage;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
  
  void move()
  {
    this.move(xSpeed, ySpeed);
  }
  
  boolean isInBounds(Hitbox bounds)
  {
    return this.hitboxGroup.intersectsWith(bounds);
  }
}
