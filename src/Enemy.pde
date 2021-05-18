class Enemy
{
  Player player;
  Hitbox bounds;
  Spaceship spaceship;
  Spaceship playerSpaceshipTracker;
  ArrayList<Laser> firedProjectiles = new ArrayList<Laser>();
  ArrayList<OrbitalEntity> evilOrbs = new ArrayList<OrbitalEntity>();
  ArrayList<HealingOrb> healingOrbs = new ArrayList<HealingOrb>();
  int currentAttackPattern;
  Timer attackPatternTimer;
  boolean attackPrepared;
  ArrayList<GenericRock> genericRocks = new ArrayList<GenericRock>();
  int genericRockDensity;
  Explosion explosion;
  int explosionFrame = 0;
  ArrayList<BackgroundStar> backgroundStars = new ArrayList<BackgroundStar>();
  final static float SPACESHIP_HEALTH = 10000;
  final static float LASER_DAMAGE = 20;
  
  public Enemy()
  {
    bounds = new Hitbox(width / 2, height / 2, width, height + 600);
    spaceship = new Spaceship("EvilSpaceship.png", new HitboxGroup(width / 2, -2000, new float[] {0, 0, 0, 0, 0}, new float[] {40, 0, 10, 9, 76}, new float[] {16, 330, 240, 132, 42}, new float[] {296, 22, 52, 133, 174}), SPACESHIP_HEALTH, SPACESHIP_HEALTH);
    playerSpaceshipTracker = new Spaceship("blank.png", new HitboxGroup(mouseX, height / 6, new float[] {0}, new float[] {0}, new float[] {0}, new float[] {0}), 1, 1);
    currentAttackPattern = 0;
    genericRockDensity = 0;
    explosion = new Explosion();
    for (int i = 0; i < 1000; i++)
    {
      backgroundStars.add(i, new BackgroundStar(-height, height));
    }
    attackPatternTimer = new Timer(-1);
  }
  
  void updateAll()
  {
    if (spaceship.health > 0)
    {
      if (player.points > Player.MAX_POINTS)
      {
        updateSpaceship();
      }
      updateFiredProjectiles();
      updateEvilOrbs();
      updateHealingOrbs();
      updateGenericRocks();
    }
    updateBackgroundStars();
  }
  
  void updateSpaceship()
  {
    if (spaceship.hitboxGroup.y > -10)
    {
      if (attackPatternTimer.isDone())
      {
        currentAttackPattern = (int) random(5);
        attackPrepared = false;
      }
      switch (currentAttackPattern)
      {
        case 0:
          attackPattern0();
          break;
        case 1:
          attackPattern1();
          break;
        case 2:
          attackPattern2();
          break;
        case 3:
          attackPattern3();
          break;
        case 4:
          attackPattern4();
          postAttackPattern4();
      }
      spaceship.updateClock();
      spaceship.updateImmunity();
      if (currentAttackPattern == 4)
        spaceship.setImmune();
    }
    else
    {
      player.spaceship.health = player.spaceship.maximumHealth;
      spaceship.moved(width / 2, height / 6, 10);
    }
  }
  
  void updateFiredProjectiles()
  {
    for (int i = firedProjectiles.size() - 1; i >= 0; i--)
    {
      firedProjectiles.get(i).updateClock();
      firedProjectiles.get(i).move();
      if (!player.spaceship.isImmune() && firedProjectiles.get(i).getHitboxGroup().intersectsWith(player.spaceship.getHitboxGroup()))
      {
        player.spaceship.decreaseHealth(firedProjectiles.get(i).damage);
        player.spaceship.setImmune();
        firedProjectiles.get(i).decreaseHealth(player.spaceship.health);
      }
      if (firedProjectiles.get(i).getClock().isDone() || !firedProjectiles.get(i).isInBounds(bounds) || firedProjectiles.get(i).health <= 0)
      {
        firedProjectiles.remove(i);
      }
    }
  }
  
  void updateEvilOrbs()
  {
    for (int i = evilOrbs.size() - 1; i >= 0; i--)
    {
      evilOrbs.get(i).updateClock();
      evilOrbs.get(i).move();
      if (!player.spaceship.isImmune() && evilOrbs.get(i).getHitboxGroup().intersectsWith(player.spaceship.getHitboxGroup()))
      {
        player.spaceship.decreaseHealth(evilOrbs.get(i).damage);
        player.spaceship.setImmune();
        evilOrbs.get(i).orbitalSpeed *= -1;
      }
      if (evilOrbs.get(i).health <= 0)
      {
        evilOrbs.remove(i);
      }
    }
  }
  
  void updateHealingOrbs()
  {
    for (int i = healingOrbs.size() - 1; i >= 0; i--)
    {
      healingOrbs.get(i).move();
      healingOrbs.get(i).updateClock();
      if (healingOrbs.get(i).heal())
      {
        healingOrbs.remove(i);
      }
    }
  }
  
  void updateGenericRocks()
  {
    while (genericRocks.size() < genericRockDensity)
    {
      genericRocks.add(genericRocks.size(), new GenericRock(this));
    }
    for (int i = genericRocks.size() - 1; i >= 0; i--)
    {
      genericRocks.get(i).updateClock();
      genericRocks.get(i).move();
      genericRocks.get(i).damage();
      if (!genericRocks.get(i).isInBounds(bounds))
      {
        genericRocks.remove(i);
        continue;
      }
      if (genericRocks.get(i).health <= 0)
      {
        player.points += random(1.5, 2.5);
        if (genericRocks.get(i).isDoneExploding())
        {
          genericRocks.remove(i);
        }
      }
    }
  }
  
  void updateBackgroundStars()
  {
    for (int i = backgroundStars.size() - 1; i >= 0; i--)
    {
      backgroundStars.get(i).move();
      if (!backgroundStars.get(i).isInBounds(bounds))
      {
        backgroundStars.remove(i);
        backgroundStars.add(i, new BackgroundStar());
      }
    }
  }
  
  void displayAll()
  {
    displayBackgroundStars();
    if (spaceship.health > 0)
    {
      displayFiredProjectiles();
      displayEvilOrbs();
      displayHealingOrbs();
      displayGenericRocks();
      if (player.points > Player.MAX_POINTS)
        displayHealthBar();
      if (currentAttackPattern != 4)
        spaceship.display(350, 417);
    }
    else // if spaceship health is <= 0
    {
      if (explosionFrame < 60)
      {
        image(explosion.getExplosion(explosionFrame), spaceship.hitboxGroup.x, spaceship.hitboxGroup.y, width / 4, width / 4);
      }
      else
      {
        fill(255, 255, 255, explosionFrame - 60);
        textSize(35);
        textAlign(CENTER, CENTER);
        text("You Win!", width / 2, height / 2);
        if (explosionFrame > 315)
        {
          fill(255, 255, 255, (explosionFrame - 315) * 2);
          textSize(15);
          text("Press any key to exit.", width / 2, height / 2 + 35);
          if (keyPressed)
            exit();
        }
      }
      explosionFrame++;
    }
  }
  
  void displayFiredProjectiles()
  {
    for (int i = firedProjectiles.size() - 1; i >= 0; i--)
    {
      firedProjectiles.get(i).display(255, 0, 0);
    }
  }
  
  void displayEvilOrbs()
  {
    for (int i = evilOrbs.size() - 1; i >= 0; i--)
    {
      evilOrbs.get(i).display();
    }
  }
  
  void displayHealingOrbs()
  {
    for (int i = healingOrbs.size() - 1; i >= 0; i--)
    {
      healingOrbs.get(i).display();
    }
  }
  
  void displayGenericRocks()
  {
    for (int i = genericRocks.size() - 1; i >=0; i--)
    {
      genericRocks.get(i).display();
    }
  }
  
  void displayBackgroundStars()
  {
    for (int i = backgroundStars.size() - 1; i >= 0; i--)
    {
      backgroundStars.get(i).display();
    }
  }
  
  void displayHealthBar()
  {
    noStroke();
    rectMode(CORNER);
    fill(0, 0, 0, 128);
    rect(width * (spaceship.health / spaceship.maximumHealth), 0, width - (width * (spaceship.health / spaceship.maximumHealth)), height / 64);
    fill(255, 0, 0, 128);
    rect(0, 0, width * (spaceship.health / spaceship.maximumHealth), height / 64);
  }
  
  float targetXVelocity(float x1, float y1, float x2, float y2, float speed)
  {
    return (x2 - x1) / dist(x1, y1, x2, y2) * speed;
  }
  
  float targetYVelocity(float x1, float y1, float x2, float y2, float speed)
  {
    return (y2 - y1) / dist(x1, y1, x2, y2) * speed;
  }
  
  float[][] attackLocations()
  {
    return new float[][] {{spaceship.hitboxGroup.x - 155, spaceship.hitboxGroup.y + 80}, {spaceship.hitboxGroup.x - 100, spaceship.hitboxGroup.y + 80}, {spaceship.hitboxGroup.x - 50, spaceship.hitboxGroup.y + 140}, {spaceship.hitboxGroup.x + 50, spaceship.hitboxGroup.y + 140}, {spaceship.hitboxGroup.x + 100, spaceship.hitboxGroup.y + 80}, {spaceship.hitboxGroup.x + 155, spaceship.hitboxGroup.y + 80}};
  }
  
  void attackPattern0()
  {
    if (spaceship.moved(width / 2, height / 6, 5))
    {
      if (round(spaceship.internalClock.getElapsed() * 60 / 1000) % 60 <= 30 && round(spaceship.internalClock.getElapsed() * 60 / 1000) % 6 == 0)
      {
        for (int i = 0; i < attackLocations().length; i++)
        {
          firedProjectiles.add(firedProjectiles.size(), new Laser(attackLocations()[i][0], attackLocations()[i][1], 1, LASER_DAMAGE * 0.75, targetXVelocity(attackLocations()[i][0], attackLocations()[i][1], playerSpaceshipTracker.hitboxGroup.x, playerSpaceshipTracker.hitboxGroup.y, 10), targetYVelocity(attackLocations()[i][0], attackLocations()[i][1], playerSpaceshipTracker.hitboxGroup.x, playerSpaceshipTracker.hitboxGroup.y, 10)));
        }
      }
      attackPatternTimer.increaseElapsed();
    }
    else
    {
      strokeWeight(2);
      stroke(255, 0, 0);
      for (int i = 0; i < attackLocations().length; i++)
      {
        line(attackLocations()[i][0], attackLocations()[i][1], 2 * player.spaceship.hitboxGroup.x - attackLocations()[i][0], 2 * player.spaceship.hitboxGroup.y - attackLocations()[i][1]);
      }
      attackPatternTimer = new Timer(15000);
    }
    playerSpaceshipTracker.moved(player.spaceship.hitboxGroup.x, player.spaceship.hitboxGroup.y, 25);
  }
  
  void attackPattern1()
  {
    if (spaceship.moved(width / 2, height / 10, 1))
    {
      if (round(attackPatternTimer.getElapsed() * 60 / 1000) % 1 == 0)
      {
        for (int i = 0; i < attackLocations().length; i++)
        {
          firedProjectiles.add(firedProjectiles.size(), new Laser(attackLocations()[i][0], attackLocations()[i][1], 1, LASER_DAMAGE * 2, random(-100, 100), random(100, 120)));
        }
      }
      attackPatternTimer.increaseElapsed();
    }
    else
    {
      strokeWeight(2);
      stroke(255, 0, 0);
      for (int i = 0; i < attackLocations().length; i++)
      {
        line(attackLocations()[i][0], attackLocations()[i][1], i * width / 6 + width / 12, height);
      }
      attackPatternTimer = new Timer(5000);
    }
  }
  
  void attackPattern2()
  {
    if (!attackPrepared)
    {
      attackPatternTimer = new Timer(10000);
      attackPrepared = true;
    }
    spaceship.moved(player.spaceship.hitboxGroup.x, height / 6, 10);
    if (round(spaceship.internalClock.getElapsed() * 60 / 1000) % 30 == 0)
    {
      for (int i = 0; i < attackLocations().length; i++)
      {
        firedProjectiles.add(firedProjectiles.size(), new Laser(attackLocations()[i][0], attackLocations()[i][1], 1, LASER_DAMAGE, random(-0.5, 0.5), 10));
      }
    }
    attackPatternTimer.increaseElapsed();
  }
  
  void preAttackPattern3()
  {
    attackPatternTimer = new Timer(0);
    if (spaceship.moved(147, height / 8, 20))
    {
      attackPrepared = true;
    }
  }
  
  void attackPattern3()
  {
    if (!attackPrepared)
    {
      preAttackPattern3();
    }
    else
    {
      if (spaceship.moved(width - 147, height / 8, 1))
        attackPatternTimer = new Timer(-1);
      else
      {
        if (round(spaceship.internalClock.getElapsed() * 60 / 1000) % 60 <= 30 && round(spaceship.internalClock.getElapsed() * 60 / 1000) % 10 == 0)
        {
          for (int i = 0; i < attackLocations().length; i++)
          {
            firedProjectiles.add(firedProjectiles.size(), new Laser(attackLocations()[i][0], attackLocations()[i][1], 1, LASER_DAMAGE, random(-10, 10), random(5, 10)));
          }
        }
      }
    }
  }
  
  void attackPattern4()
  {
    if (spaceship.moved(width / 2, height / 2, 10))
    {
      for (int i = evilOrbs.size() - 1; i >= 0; i--)
      {
        if (round(spaceship.internalClock.getElapsed() * 60 / 1000) % 20 == 0 && random(100) < 0.5)
        {
          float xRand = random(-500, 10);
          float yRand = random(-500, 10);
          firedProjectiles.add(firedProjectiles.size(), new Laser(evilOrbs.get(i).hitboxGroup.x, evilOrbs.get(i).hitboxGroup.y, 1, LASER_DAMAGE / 4, targetXVelocity(evilOrbs.get(i).hitboxGroup.x, evilOrbs.get(i).hitboxGroup.y, player.spaceship.hitboxGroup.x + xRand, player.spaceship.hitboxGroup.y + yRand, 10), targetYVelocity(evilOrbs.get(i).hitboxGroup.x, evilOrbs.get(i).hitboxGroup.y, player.spaceship.hitboxGroup.x + xRand, player.spaceship.hitboxGroup.y + yRand, 10)));
        }
      }
      if (evilOrbs.size() < 666)
      {
        evilOrbs.add(evilOrbs.size(), new OrbitalEntity("EvilOrb.png", new HitboxGroup(0, 0, new float[] {0}, new float[] {0}, new float[] {50 / 1.414}, new float[] {50 / 1.414}), 50, 50, 800, 0.25, spaceship));
      }
      attackPatternTimer.increaseElapsed();
    }
    else
    {
      attackPatternTimer = new Timer(20000);
    }
  }
  
  void postAttackPattern4()
  {
    if (attackPatternTimer.isDone())
    {
      for (int i = evilOrbs.size() - 1; i >= 0; i--)
      {
        healingOrbs.add(healingOrbs.size(), new HealingOrb(spaceship, evilOrbs.get(i).hitboxGroup.x, evilOrbs.get(i).hitboxGroup.y, 1));
        evilOrbs.remove(i);
      }
    }
  }
}
