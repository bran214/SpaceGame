class Orbiters
{
  Player player;
  int numberOfSlots;
  OrbitalEntity tracker;
  OrbitalEntity[] orbiters;
  boolean[] slotInUse;
  Timer[] immunities;
  final static float HEALTH = 50;
  
  public Orbiters(Player player, int numberOfSlots)
  {
    this.player = player;
    this.numberOfSlots = numberOfSlots;
    tracker = new OrbitalEntity("blank.png", new HitboxGroup(0, 0, new float[] {0}, new float[] {0}, new float[] {1}, new float[] {1}), HEALTH, 50, 100, 0.25, player.spaceship);
    orbiters = new OrbitalEntity[numberOfSlots];
    slotInUse = new boolean[numberOfSlots];
    immunities = new Timer[numberOfSlots];
    for (int i = 0; i < numberOfSlots; i++)
    {
      orbiters[i] = new OrbitalEntity("Orbiter.png", new HitboxGroup(0, 0, new float[] {0, 0}, new float[] {0, 0}, new float[] {46, 3}, new float[] {26, 50}), HEALTH, 50, 100, 0.25, player.spaceship);
      slotInUse[i] = false;
      immunities[i] = new Timer(1);
    }
  }
  
  void update()
  {
    this.update(60);
  }
  
  void update(float framerate)
  {
    tracker.move(framerate);
    for (int i = orbiters.length - 1; i >= 0; i--)
    {
      if (slotInUse[i])
      {
        orbiters[i].move();
        immunities[i].increaseElapsed();
        for (int j = enemy.genericRocks.size() - 1; j >= 0; j--)
        {
          if (immunities[i].isDone() && orbiters[i].getHitboxGroup().intersectsWith(enemy.genericRocks.get(j).getHitboxGroup()) && enemy.genericRocks.get(j).health > 0)
          {
            enemy.genericRocks.get(j).decreaseHealth(orbiters[i].damage);
            orbiters[i].decreaseHealth(enemy.genericRocks.get(j).damage);
            immunities[i] = new Timer(1000);
          }
        }
        for (int j = enemy.firedProjectiles.size() - 1; j >= 0; j--)
        {
          if (immunities[i].isDone() && orbiters[i].getHitboxGroup().intersectsWith(enemy.firedProjectiles.get(j).getHitboxGroup()))
          {
            enemy.firedProjectiles.get(j).decreaseHealth(orbiters[i].damage);
            orbiters[i].decreaseHealth(enemy.firedProjectiles.get(j).damage);
            immunities[i] = new Timer(1000);
          }
        }
        for (int j = enemy.evilOrbs.size() - 1; j >= 0; j--)
        {
          if (immunities[i].isDone() && orbiters[i].getHitboxGroup().intersectsWith(enemy.evilOrbs.get(j).getHitboxGroup()))
          {
            enemy.evilOrbs.get(j).decreaseHealth(orbiters[i].damage);
            orbiters[i].decreaseHealth(enemy.evilOrbs.get(j).damage);
            immunities[i] = new Timer(1000);
          }
        }
        if (player.spaceship.health <= 0 || orbiters[i].health <= 0)
        {
          spawnHealingOrb(i);
        }
      }
    }
  }
  
  void display()
  {
    for (int i = orbiters.length - 1; i >= 0; i--)
    {
      if (slotInUse[i])
      {
        orbiters[i].display();
      }
    }
    this.displayHealthBar();
    this.displayShield(55, 75, 0, 255, 255);
  }
  
  void displayHealthBar()
  {
    rectMode(CORNER);
    strokeWeight(1);
    for (int i = 0; i < orbiters.length; i++)
    {
      if (slotInUse[i])
      {
        noStroke();
        fill(0, 255, 255, 128);
        rect(width * i / numberOfSlots, height * 62 / 64, width / numberOfSlots * (orbiters[i].health / HEALTH), height / 64);
      }
      stroke(255);
      noFill();
      rect(width * i / numberOfSlots, height * 62 / 64, width / numberOfSlots * HEALTH, height / 64);
    }
  }
  
  void displayShield(float minimumRadius, float maximumRadius, float redValue, float greenValue, float blueValue)
  {
    for (int i = 0; i < orbiters.length; i++)
    {
      if (!immunities[i].isDone() && slotInUse[i])
      {
        for (int j = 0; j < 10; j++)
        {
          noFill();
          strokeWeight((maximumRadius - minimumRadius) / 10);
          stroke(redValue, greenValue, blueValue, j * 25);
          circle(orbiters[i].hitboxGroup.x, orbiters[i].hitboxGroup.y, minimumRadius + j * (maximumRadius - minimumRadius) / 10);
        }
      }
    }
  }
  
  boolean slotsFull()
  {
    return (activeSlots() == numberOfSlots);
  }
  
  int activeSlots()
  {
    int activeSlots = 0;
    for (int i = slotInUse.length - 1; i >= 0; i--)
    {
      if (slotInUse[i])
      {
        activeSlots++;
      }
    }
    return activeSlots;
  }
  
  void spawnOrbiter()
  {
    for (int i = 0; i < orbiters.length; i++)
    {
      if (!slotInUse[i])
      {
        orbiters[i].health = HEALTH;
        slotInUse[i] = true;
        immunities[i] = new Timer(1000);
        break;
      }
    }
    resetOrbitersPosition();
  }
  
  void killOrbiter(int index)
  {
    slotInUse[index] = false;
    resetOrbitersPosition();
  }
  
  void resetOrbitersPosition()
  {
    int slotCounter = 0;
    for (int i = 0; i < orbiters.length; i++)
    {
      if (slotInUse[i])
      {
        slotCounter++;
        orbiters[i].orbitalPosition = slotCounter * 2 * PI / activeSlots() + tracker.orbitalPosition;
      }
    }
  }
  
  void fireWeapon()
  {
    for (int i = orbiters.length - 1; i >= 0; i--)
    {
      if (slotInUse[i])
      {
        player.firedProjectiles.add(player.firedProjectiles.size(), new Laser(orbiters[i].getHitboxGroup().getX(), orbiters[i].getHitboxGroup().getY(), 1, 5, 0, -10));
      }
    }
  }
  
  void spawnHealingOrb()
  {
    int lowestHealthIndex = 0;
    for (int i = 0; i < orbiters.length; i++)
    {
      if (slotInUse[i])
      {
        lowestHealthIndex = i;
        break;
      }
    }
    for (int i = 0; i < orbiters.length; i++)
    {
      if (orbiters[i].health < orbiters[lowestHealthIndex].health && slotInUse[i])
        lowestHealthIndex = i;
    }
    spawnHealingOrb(lowestHealthIndex);
  }
  
  void spawnHealingOrb(int index)
  {
    if (slotInUse[index])
    {
      player.healingOrbs.add(player.healingOrbs.size(), new HealingOrb(player.spaceship, orbiters[index].getHitboxGroup().getX(), orbiters[index].getHitboxGroup().getY()));
      killOrbiter(index);
    }
    player.healingOrbCooldown = new Timer(500);
  }
}
