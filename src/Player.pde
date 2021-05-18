class Player
{
  Enemy enemy;
  Hitbox screenSize;
  Hitbox bounds;
  Spaceship spaceship;
  ArrayList<Laser> firedProjectiles = new ArrayList<Laser>();
  ArrayList<OrbiterSpawner> orbiterSpawners = new ArrayList<OrbiterSpawner>();
  Orbiters orbiters;
  ArrayList<HealingOrb> healingOrbs = new ArrayList<HealingOrb>();
  Timer healingOrbCooldown;
  float points;
  final static float MAX_POINTS = 10000;
  final static float HEALTH = 200;
  int gameOverFrame;
  
  public Player()
  {
    screenSize = new Hitbox(width / 2, height / 2, width, height);
    bounds = new Hitbox(width / 2, height / 2, width, height + 600);
    spaceship = new Spaceship("Spaceship.png", new HitboxGroup(mouseX, height * 5 / 6, new float[] {0, 0, 0}, new float[] {12, 6, 28}, new float[] {37, 13, 54}, new float[] {59, 79, 15}), HEALTH / 2, HEALTH);
    orbiters = new Orbiters(this, 6);
    healingOrbCooldown = new Timer(1);
    points = 0;
    gameOverFrame = 0;
  }
  
  void updateAll()
  {
    this.updateAll(60);
    points += random(0.2);
  }
  
  void updateAll(float framerate)
  {
    if (spaceship.health > 0) {
      if (random(100) < 0.03 && orbiters.activeSlots() + orbiterSpawners.size() < orbiters.numberOfSlots)
      {
        orbiterSpawners.add(orbiterSpawners.size(), new OrbiterSpawner(this));
      }
    }
    updateSpaceship();
    if (mousePressed && spaceship.health > 0)
    {
      if (mouseButton == LEFT)
      {
        this.fireBasicWeapon();
      }
      if (mouseButton == RIGHT)
      {
        if (player.healingOrbCooldown.isDone())
        {
          this.orbiters.spawnHealingOrb();
        }
      }
      if (mouseButton == CENTER) {
        orbiters.spawnOrbiter();
      }
    }
    updateFiredProjectiles();
    updateOrbiterSpawners();
    orbiters.update(framerate);
    updateHealingOrbs();
  }
  
  void updateSpaceship()
  {
    spaceship.setPosition(mouseX, height * 5 / 6);
    spaceship.updateClock();
    if (spaceship.isImmune())
    {
      spaceship.updateImmunity();
    }
  }
  
  void updateFiredProjectiles()
  {
    for (int i = firedProjectiles.size() - 1; i >= 0; i--)
    {
      firedProjectiles.get(i).updateClock();
      firedProjectiles.get(i).move();
      for (int j = enemy.genericRocks.size() - 1; j >= 0; j--)
      {
        if (firedProjectiles.get(i).getHitboxGroup().intersectsWith(enemy.genericRocks.get(j).getHitboxGroup()) && enemy.genericRocks.get(j).health > 0)
        {
          enemy.genericRocks.get(j).decreaseHealth(firedProjectiles.get(i).damage);
          firedProjectiles.get(i).decreaseHealth(enemy.genericRocks.get(j).health);
        }
      }
      if (!enemy.spaceship.isImmune() && firedProjectiles.get(i).getHitboxGroup().intersectsWith(enemy.spaceship.getHitboxGroup()))
      {
        enemy.spaceship.decreaseHealth(firedProjectiles.get(i).damage);
        firedProjectiles.get(i).decreaseHealth(enemy.spaceship.health);
      }
      if (firedProjectiles.get(i).getClock().isDone() || !firedProjectiles.get(i).isInBounds(screenSize) || firedProjectiles.get(i).health <= 0)
      {
        firedProjectiles.remove(i);
      }
    }
  }
  
  void updateOrbiterSpawners()
  {
    for (int i = orbiterSpawners.size() - 1; i >= 0; i--)
    {
      orbiterSpawners.get(i).move();
      orbiterSpawners.get(i).updateClock();
      if (dist(orbiterSpawners.get(i).hitboxGroup.x, orbiterSpawners.get(i).hitboxGroup.y, spaceship.hitboxGroup.x, spaceship.hitboxGroup.y) < 100)
      {
        orbiterSpawners.remove(i);
        orbiters.spawnOrbiter();
        continue;
      }
      if (!orbiterSpawners.get(i).isInBounds(bounds))
      {
        orbiterSpawners.remove(i);
      }
    }
  }
  
  void updateHealingOrbs()
  {
    this.updateHealingOrbs(60);
  }
  
  void updateHealingOrbs(float framerate)
  {
    for (int i = healingOrbs.size() - 1; i >= 0; i--)
    {
      healingOrbs.get(i).move();
      healingOrbs.get(i).updateClock();
      if (healingOrbs.get(i).heal())
      {
        edgeTint(0, 255, 0);
        healingOrbs.remove(i);
      }
    }
    healingOrbCooldown.increaseElapsed(framerate);
  }
  
  void displayAll()
  {
    if (spaceship.isImmune() && spaceship.immunity.getElapsed() / 3 < 255)
    {
      edgeTint(255 - spaceship.immunity.getElapsed() / 3, 0, 0);
    }
    displayFiredProjectiles();
    displayOrbiterSpawners();
    orbiters.display();
    displayHealingOrbs();
    displayHealthBar();
    displayProgressBar();
    if (spaceship.health > 0)
    {
      spaceship.display(120, 140, 0, 255, 255);
      gameOverFrame = 0;
    }
    else
      gameOver();
  }
  
  void displayFiredProjectiles()
  {
    for (int i = firedProjectiles.size() - 1; i >= 0; i--)
    {
      firedProjectiles.get(i).display();
    }
  }
  
  void displayOrbiterSpawners()
  {
    for (int i = orbiterSpawners.size() - 1; i >= 0; i--)
    {
      orbiterSpawners.get(i).display();
    }
  }
  
  void displayHealingOrbs()
  {
    for (int i = healingOrbs.size() - 1; i >= 0; i--)
    {
      healingOrbs.get(i).display();
    }
  }
  
  void displayHealthBar()
  {
    textAlign(BOTTOM, LEFT);
    textSize(10);
    noStroke();
    rectMode(CORNER);
    fill(255, 0, 0, 128);
    rect(width * (spaceship.health / spaceship.maximumHealth), height * 63 / 64, width - (width * (spaceship.health / spaceship.maximumHealth)), height / 64);
    fill(0, 255, 0, 128);
    rect(0, height * 63 / 64, width * (spaceship.health / spaceship.maximumHealth), height / 64);
    fill(255);
    text(spaceship.health, 0, height - 7.5);
  }
  
  void displayProgressBar()
  {
    if (points < MAX_POINTS)
    {
      fill(255);
      //textAlign(TOP, LEFT);
      //textSize(10);
      //text(points, 0, 10);
      rect(0, 0, width * (points / MAX_POINTS), 1);
    }
  }
  
  void fireBasicWeapon()
  {
    this.fireBasicWeapon(60);
  }
  
  void fireBasicWeapon(float framerate)
  {
    if (round(spaceship.internalClock.getElapsed() * framerate / 1000) % 6 == 0)
    {
      firedProjectiles.add(firedProjectiles.size(), new Laser(spaceship.hitboxGroup.x - 18, spaceship.hitboxGroup.y - 15, 1, 10, 0, -10));
      firedProjectiles.add(firedProjectiles.size(), new Laser(spaceship.hitboxGroup.x + 18, spaceship.hitboxGroup.y - 15, 1, 10, 0, -10));
      orbiters.fireWeapon();
    }
  }
  
  void edgeTint(float color1, float color2, float color3)
  {
    strokeWeight(5);
    for (int i = 0; i < 10; i++)
    {
      stroke(color1, color2, color3, 255 - (i * 25));
      line(0, i * 5, width, i * 5);
      line(0, height - i * 5, width, height - i * 5);
      line(i * 5, 0, i * 5, height);
      line(width - i * 5, 0, width - i * 5, height);
    }
  }
  
  void moveSpaceship(float x, float y, int speed)
  {
    if (!(x >= spaceship.hitboxGroup.x - speed && x <= spaceship.hitboxGroup.x + speed && y >= spaceship.hitboxGroup.y - speed && y <= spaceship.hitboxGroup.y + speed))
    {
      spaceship.move(((x - spaceship.hitboxGroup.x) / dist(x, y, spaceship.hitboxGroup.x, spaceship.hitboxGroup.y)) * speed, ((y - spaceship.hitboxGroup.y) / dist(x, y, spaceship.hitboxGroup.x, spaceship.hitboxGroup.y)) * speed);
    }
    else
    {
      spaceship.setPosition(x, y);
    }
  }
  
  void gameOver()
  {
    firedProjectiles.clear();
    noStroke();
    fill(0, 0, 0, gameOverFrame);
    rectMode(CORNERS);
    rect(0, 0, width, height);
    if (gameOverFrame < 60)
      image(enemy.explosion.getExplosion(gameOverFrame), spaceship.hitboxGroup.x, spaceship.hitboxGroup.y, width / 5, width / 5);
    fill(255, 255, 255, gameOverFrame);
    textSize(35);
    textAlign(CENTER, CENTER);
    text("Game Over", width / 2, height / 2);
    if (gameOverFrame > 255)
    {
      fill(255, 255, 255, (gameOverFrame - 255) * 2);
      textSize(15);
      text("Press any key to exit.", width / 2, height / 2 + 35);
      if (keyPressed)
      {
        exit();
      }
    }
    gameOverFrame++;
  }
}
