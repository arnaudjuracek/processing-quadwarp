public class QuadWarper {
  private final float hoverTriggerDistanceSq = sq(50);

  public int width, height;
  public PVector[] vertices;

  QuadWarper (int width, int height) {
    this.width = width;
    this.height = height;

    this.reset();
  }

  public void reset () {
    this.vertices = new PVector[] {
      new PVector(10, 10), // top left
      new PVector(width - 10, 10), // top right
      new PVector(width - 10, height - 10), // bottom right
      new PVector(10, height - 10), // bottom left
    };
  }

  // -------------------------------------------------------------------------

  public PVector warp (float x, float y) { return this.warp(new PVector(x, y)); }
  public PVector warp (PVector p) {
    float t = map(p.x, 0, this.width, this.vertices[0].x, this.vertices[1].x);
    float b = map(p.x, 0, this.width, this.vertices[3].x, this.vertices[2].x);
    float l = map(p.y, 0, this.height, this.vertices[0].y, this.vertices[3].y);
    float r = map(p.y, 0, this.height, this.vertices[1].y, this.vertices[2].y);

    // interpolation
    float x = lerp(t, b, p.y / this.height);
    float y = lerp(l, r, p.x / this.width);

    return new PVector(x, y);
  }

  // -------------------------------------------------------------------------

  public void draw () {
    pushStyle();
      noFill();
      stroke(255);
      beginShape();
      for (PVector v : this.vertices) vertex(v.x, v.y);
      endShape(CLOSE);

      drawHandles();
    popStyle();
  }

  public void drawHandles () {
    for (int i = 0; i < this.vertices.length; i++) {
      PVector handle = this.vertices[i];
      boolean isHover = isHover(handle);

      int diameter = isHover ? 20 : 10;
      noStroke();
      fill(isHover ? color(200, 0, 100) : 255);
      ellipse(handle.x, handle.y, diameter, diameter);

      if (isHover && mousePressed) dragHandle(handle);
    }
  }

  public void dragHandle (PVector handle) {
    handle.x = mouseX;
    handle.y = mouseY;
  }

  // -------------------------------------------------------------------------

  private int getHoveredHandleIndex () {
    for (int i = 0; i < this.vertices.length; i++) {
      if (isHover(this.vertices[i])) return i;
    }

    return -1;
  }

  private boolean isHover (PVector handle) { return distanceSq(handle, mouseX, mouseY) <= this.hoverTriggerDistanceSq; }

  private float distanceSq(PVector a, int x, int y) { return (x - a.x) * (x - a.x) + (y - a.y) * (y - a.y); }
  private float distanceSq(PVector a, PVector b) { return (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y); }

}