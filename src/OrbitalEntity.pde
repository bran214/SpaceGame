class OrbitalEntity extends Entity
{
  float damage;
  float radius; // the distance away from the orbited entity that the object is
  float orbitalSpeed; // number of times the object orbits per second
  float orbitalPosition; // where in the orbit the object is (radians)
  Entity orbitedEntity;
  
  public OrbitalEntity(String appearanceFile, HitboxGroup hitboxGroup, float health, float damage, float radius, float orbitalSpeed, Entity orbitedEntity)
  {
    super(appearanceFile, hitboxGroup, health);
    this.damage = damage;
    this.radius = radius;
    this.orbitalSpeed = orbitalSpeed;
    orbitalPosition = 0;
    this.orbitedEntity = orbitedEntity;
  }
  
  void move()
  {
    this.move(60);
  }
  
  void move(float framerate)
  {
    if (orbitalPosition > 2 * PI)
    {
      orbitalPosition -= 2 * PI;
    }
    orbitalPosition += orbitalSpeed * PI / (framerate / 2);
    this.setPosition(orbitedEntity.getHitboxGroup().getX() + radius * cos(orbitalPosition), orbitedEntity.getHitboxGroup().getY() + radius * sin(orbitalPosition));
  }
}
