class Cell {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float maxspeed;    // Maximum speed
  float size;
    
  Cell(float x, float y) {
    acceleration = new PVector(0, 0);
  
    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    maxspeed = 2;
    size = random(50,200);
  }

  void run(ArrayList<Cell> cells) {
    flock(cells);
    update();
  }

  void flock(ArrayList<Cell> cells) {
    PVector sep = separate(cells);   // Separation
    //PVector coh = cohesion(cells);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1);
    //coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    //applyForce(coh);
  }
  
  PVector separate(final ArrayList<Cell> cells) {
    float desiredseparation = size;//200.0f;

    ArrayList<Cell> walls = new ArrayList<Cell>();

    
    PVector force = new PVector(0,0);
    for (Cell other : cells) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        force.add(diff);
        //count++;            // Keep track of how many
      }
    }
    
        
    // Floor and ceiling
    walls.add(new Cell(position.x, height));
    walls.add(new Cell(position.x, 0));
    // Left and right walls
    walls.add(new Cell(0, position.y));
    walls.add(new Cell(width, position.y));
    
    for (Cell other : walls) {
      float d = PVector.dist(position, other.position);
      //if ((d > 0) && (d < desiredseparation)) {
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(position, other.position);
      diff.normalize();
      diff.div(d/5);        // Weight by distance
      force.add(diff);
      //count++;            // Keep track of how many
     // }
    }
    
    return force;
  }
  
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    
    velocity.mult(0.9); // Environment tends to stillness
    
    position.add(velocity);
    
    if (position.x < 0) position.x = 5;
    if (position.y < 0) position.y = 5;
    if (position.y > height) position.y = height-5;
    if (position.x > width) position.x = width-5;
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void render() {
    circle(position.x, position.y, 5);
  }
  
  void pull(PVector target, float mag) {
    // Attract cell to target with force of magnitude mag
    PVector direction = PVector.sub(target, position);
    direction.normalize();
    direction.mult(mag);
    direction.div(PVector.dist(position, target));
    applyForce(direction);
    
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
}
