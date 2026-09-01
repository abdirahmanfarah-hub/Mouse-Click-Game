// 24796328
// Abdirahman Farah
defender player;
goal theGoal;

final int START_ENEMIES = 5;

final color BG = color(25);
final color TEXTC = color(255);

// ---- goal constants ----
final color GOALCOLOR = color(0, 200, 0);
final int GOALR = 18;

// ---- defender constants (your style) ----
final color DEFENDERBODY = color(0, 255, 0);

final int DEFENDERLEFT = -1;
final int DEFENDERRIGHT = 1;

final int DEFENDERWIDTH = 50;
final int DEFENDERHEIGHT = 25;

// ---- enemy constants ----
final color ENEMYCOLOR = color(220, 60, 60);
final float ENEMYR = 14;
final float ENEMYSPEED = 1.6;

ArrayList<enemy> enemies = new ArrayList<enemy>();

int score = 0;
boolean gameOver = false;

void setup() {
  size(800, 600);

  // goal is not on the edge
  theGoal = new goal(int(width * 0.75), int(height * 0.5), GOALR);

  player = new defender(width/2, height - 60);

  for (int i = 0; i < START_ENEMIES; i++) {
    enemies.add(spawnEnemy());
  }
}

void draw() {
  background(BG);

  theGoal.Draw();

  // score
  fill(TEXTC);
  text("Score: " + score, 10, 20);

  // defender
  player.Draw();

  if (gameOver) {
    textSize(32);
    text("GAME OVER", width/2 - 100, height/2);
    textSize(12);
    return;
  }

  // enemies move towards goal
  for (int i = enemies.size() - 1; i >= 0; i--) {
    enemy e = enemies.get(i);

    e.MoveTowards(theGoal.x, theGoal.y);
    e.Draw();

    if (e.HitGoal(theGoal)) {
      gameOver = true;
    }
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') player.Move(DEFENDERLEFT);
  if (key == 'd' || key == 'D') player.Move(DEFENDERRIGHT);
}

void mousePressed() {
  if (gameOver) return;

  // click to remove 1 enemy (respawn 1)
  for (int i = enemies.size() - 1; i >= 0; i--) {
    enemy e = enemies.get(i);

    if (e.IsClicked(mouseX, mouseY)) {
      enemies.remove(i);
      score++;

      enemies.add(spawnEnemy()); // respawn
      break;
    }
  }
}

enemy spawnEnemy() {
  float x = 40; // spawn from left
  float y = random(40, height - 120);
  return new enemy(x, y);
}

// ---------------- CLASSES ----------------

class goal {
  int x;
  int y;
  int r;

  goal(int x, int y, int r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }

  void Draw() {
    noStroke();
    fill(GOALCOLOR);
    ellipse(x, y, r*2, r*2);
  }
}

class enemy {
  float x;
  float y;
  float speed = ENEMYSPEED;

  enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void MoveTowards(float tx, float ty) {
    float dx = tx - x;
    float dy = ty - y;
    float d = sqrt(dx*dx + dy*dy);
    if (d == 0) return;

    x = x + (dx / d) * speed;
    y = y + (dy / d) * speed;
  }

  void Draw() {
    noStroke();
    fill(ENEMYCOLOR);
    ellipse(x, y, ENEMYR*2, ENEMYR*2);
  }

  boolean IsClicked(float mx, float my) {
    return dist(mx, my, x, y) <= ENEMYR;
  }

  boolean HitGoal(goal g) {
    return dist(x, y, g.x, g.y) <= (ENEMYR + g.r);
  }
}

class defender {
  int x;
  int y;
  int Xspeed = 5;

  defender(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void Move(int direction) {
    x = x + (Xspeed * direction);

    // keep on screen
    if (x < DEFENDERWIDTH/2) x = DEFENDERWIDTH/2;
    if (x > width - DEFENDERWIDTH/2) x = width - DEFENDERWIDTH/2;
  }

  void Draw() {
    rectMode(CENTER);
    fill(DEFENDERBODY);

    rect(x, y, DEFENDERWIDTH, DEFENDERHEIGHT);                 
    rect(x, y, DEFENDERHEIGHT, DEFENDERWIDTH/2, DEFENDERHEIGHT/2);
  }

  int GetBulletSpeed() {
    return (y - DEFENDERHEIGHT);
  }
}
