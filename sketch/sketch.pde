QuadWarper qwarper;
PVector[] testPoints;

void setup () {
  size(800, 800);
  qwarper = new QuadWarper(width, height);
  testPoints = new PVector[30];
  for (int i = 0; i < testPoints.length; i++) {
    testPoints[i] = new PVector(random(width), random(height));
  }
}

void draw () {
  background(0);
  qwarper.draw();

  for (PVector p : testPoints) {
    PVector qw = qwarper.warp(p);

    noStroke();
    fill(255);
    ellipse(qw.x, qw.y, 20, 20);

    stroke(255);
    line(qw.x, qw.y, p.x, p.y);
  }
}

void keyPressed () {
  switch (key) {
    case 'r' : qwarper.reset(); break;
    case 'R' : setup(); break;
  }
}