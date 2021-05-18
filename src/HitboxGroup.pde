class HitboxGroup
{
  Hitbox[] hitboxes;
  float x;
  float y;
  
  public HitboxGroup(float x, float y, float[] hitboxXRelativeToGroup, float[] hitboxYRelativeToGroup, float[] hitboxW, float[] hitboxH)
  {
    this.x = x;
    this.y = y;
    hitboxes = new Hitbox[hitboxXRelativeToGroup.length];
    for (int i = 0; i < hitboxes.length; i++)
    {
      hitboxes[i] = new Hitbox(hitboxXRelativeToGroup[i], hitboxYRelativeToGroup[i], hitboxW[i], hitboxH[i]);
    }
  }
  
  float getX()
  {
    return x;
  }
  
  float getY()
  {
    return y;
  }
  
  Hitbox[] getHitboxes()
  {
    return hitboxes;
  }
  
  void setX(float x)
  {
    this.x = x;
  }
  
  void setY(float y)
  {
    this.y = y;
  }
  
  void setPosition(float x, float y)
  {
    this.setX(x);
    this.setY(y);
  }
  
  boolean intersectsWith(HitboxGroup hitboxGroup)
  {
    boolean returnValue = false;
    OUTER_LOOP:
      for (Hitbox i : hitboxes)
      {
        for (Hitbox j : hitboxGroup.hitboxes)
        {
          if (returnValue)
          {
            break OUTER_LOOP;
          }
          returnValue = i.intersectsWithOffsetHitboxes(x, y, hitboxGroup.getX(), hitboxGroup.getY(), j);
        }
      }
    return returnValue;
  }
  
  boolean intersectsWith(Hitbox hitbox)
  {
    boolean returnValue = false;
    OUTER_LOOP:
      for (Hitbox i : hitboxes)
      {
        if (returnValue)
        {
          break OUTER_LOOP;
        }
        returnValue = i.intersectsWithOffsetHitboxes(x, y, 0, 0, hitbox);
      }
    return returnValue;
  }
}
