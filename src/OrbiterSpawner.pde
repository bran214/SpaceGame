class OrbiterSpawner extends Projectile
{
  Player player;
  
  public OrbiterSpawner(Player player)
  {
    this(player, random(width), -300);
  }
  
  public OrbiterSpawner(Player player, float x, float y)
  {
    super("Orbiter.png", new HitboxGroup(x, y, new float[] {0}, new float[] {0}, new float[] {1}, new float[] {1}), 1, 0, 0, 2);
    this.player = player;
  }
}
