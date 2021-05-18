class GenericRock extends Projectile
{
  Enemy enemy;
  int explosionFrame;
  
  public GenericRock(Enemy enemy)
  {
    super("blank.png", new HitboxGroup(random(width), -300, new float[] {-11, 1}, new float[] {7, 19}, new float[] {66, 82}, new float[] {46, 41}), 100, 10, 0, random(5, 10));
    int rand = (int) random(4);
    appearance = loadImage("Rock" + rand + ".png");
    if (rand == 0)
      damage = 20;
    this.enemy = enemy;
    explosionFrame = -1;
  }
  
  void display()
  {
    if (explosionFrame == -1)
    {
      imageMode(CENTER);
      image(appearance, hitboxGroup.getX(), hitboxGroup.getY());
    }
  }
  
  void damage()
  {
    if (!enemy.player.spaceship.isImmune())
    {
      if (this.hitboxGroup.intersectsWith(enemy.player.spaceship.getHitboxGroup()))
      {
        enemy.player.spaceship.decreaseHealth(damage);
        enemy.player.spaceship.setImmune();
        this.ySpeed *= -1;
      }
    }
  }
  
  boolean isDoneExploding()
  {
    explosionFrame++;
    hitboxGroup = new HitboxGroup(hitboxGroup.x, hitboxGroup.y, new float[] {-hitboxGroup.x}, new float[] {-hitboxGroup.y - 300}, new float[] {2}, new float[] {2});
    if (explosionFrame >= 60)
    {
      return true;
    }
    else
    {
      imageMode(CENTER);
      image(enemy.explosion.getExplosion(explosionFrame), hitboxGroup.getX(), hitboxGroup.getY(), 300, 300);
      return false;
    }
  }
}
