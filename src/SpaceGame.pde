Player player;
Enemy enemy;
boolean inGame;
float startScreen;

void setup()
{
  noCursor();
  fullScreen();
  frameRate(60);
  player = new Player();
  enemy = new Enemy();
  player.enemy = enemy;
  enemy.player = player;
  inGame = false;
  startScreen = -200;
}

void draw()
{
  background(0); //<>//
  if (inGame)
  {
    enemy.updateAll();
    player.updateAll();
    enemy.displayAll();
    player.displayAll();
    if (player.points < Player.MAX_POINTS)
      enemy.genericRockDensity = 1 + int(player.points / 170);
    else
      enemy.genericRockDensity = 0;
  }
  else
  {
    startScreen();
  }
}

void startScreen()
{
  strokeWeight(10);
  for (int i = 0; i < 10; i++)
  {
    stroke(0, 255, 255, i * 25.5);
    line(startScreen + i * 10, 0, startScreen + i * 10, height);
  }
  for (int i = 0; i < 10; i++)
  {
    stroke(0, 255, 255, 255 - (i * 25.5));
    line(startScreen + 100 + i * 10, 0, startScreen + 100 + i * 10, height);
  }
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(30);
  text("Brandon's Space Game\n", width / 2, height / 2);
  textSize(15);
  text("Press any key or click the mouse to start.", width / 2, height / 2 + 40);
  if (keyPressed || mousePressed)
  {
    inGame = true;
  }
  startScreen += 5;
  if (startScreen > width)
    startScreen = -200;
}

void keyPressed()
{
  if (key == ESC)
  {
    key = 0;
  }
}
