class BackgroundStar
{
  float x;
  float y;
  float ySpeed;
  float radius;
  float brightness;
  
  public BackgroundStar()
  {
    this(-301, -300);
  }
  
  public BackgroundStar(float minimumYPosition, float maximumYPosition)
  {
    this(random(width), random(minimumYPosition, maximumYPosition), random(5, 15), random(1, 3), random(0, 255));
  }
  
  public BackgroundStar(float x, float y, float ySpeed, float radius, float brightness)
  {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.ySpeed = ySpeed;
    this.brightness = brightness;
  }

  void display()
  {
    noStroke();
    fill(brightness);
    circle(x, y, radius);
  }

  void move()
  {
    this.y += ySpeed;
  }
  
  boolean isInBounds(Hitbox bounds)
  {
    return (x + radius > bounds.x - bounds.w / 2 && x - radius < bounds.x + bounds.w / 2 && y + radius > bounds.y - bounds.h / 2 && y - radius < bounds.y + bounds.h / 2);
  }
}
