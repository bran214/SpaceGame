class Hitbox
{
  float x;
  float y;
  float w;
  float h;
  
  public Hitbox(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  float getX()
  {
    return x;
  }
  
  float getY()
  {
    return y;
  }
  
  float getW()
  {
    return w;
  }
  
  float getH()
  {
    return h;
  }
  
  boolean intersectsWith(Hitbox hitbox)
  {
    return (this.x - this.w / 2 < hitbox.x + hitbox.w / 2 && this.x + this.w / 2 > hitbox.x - hitbox.w / 2 && this.y - this.h / 2 < hitbox.y + hitbox.h / 2 && this.y + this.h / 2 > hitbox.y - hitbox.h / 2);
  }
  
  boolean intersectsWithOffsetHitboxes(float x1Offset, float y1Offset, float x2Offset, float y2Offset, Hitbox secondHitbox)
  {
    return (x1Offset + this.x - this.w / 2 <  x2Offset + secondHitbox.x + secondHitbox.w / 2 && x1Offset + this.x + this.w / 2 > x2Offset + secondHitbox.x - secondHitbox.w / 2 && y1Offset + this.y - this.h / 2 < y2Offset + secondHitbox.y + secondHitbox.h / 2 &&  y1Offset + this.y + this.h / 2 > y2Offset + secondHitbox.y - secondHitbox.h / 2);
  }
}
