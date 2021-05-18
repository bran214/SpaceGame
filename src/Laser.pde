class Laser extends Projectile
{
  public Laser(float x, float y, float health, float damage, float xSpeed, float ySpeed)
  {
    super("blank.png", new HitboxGroup(x, y, new float[] {0}, new float[] {0}, new float[] {2}, new float[] {2}), health, damage, xSpeed, ySpeed);
  }
  
  void display()
  {
    display(0, 255, 255);
  }
  
  void display(float redColor, float greenColor, float blueColor)
  {
    stroke(redColor, greenColor, blueColor);
    strokeWeight(hitboxGroup.getHitboxes()[0].getW() * 1.415);
    line(hitboxGroup.x, hitboxGroup.y, hitboxGroup.x - xSpeed, hitboxGroup.y - ySpeed);
  }
}
