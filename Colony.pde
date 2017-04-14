class Colony {

/* The Colony class does the following:
*  1) Starts a colony by spawning a given number of cells (using DNA from the genepool) in a predetermined spawn-pattern //<>// //<>//
*  2) Runs the colony
*/

  // VARIABLES
  ArrayList<Cell> population;    // An arraylist for all the cells //<>// //<>//
  
  PVector vel;
  PVector pos;
  PVector origin;
  
  float a;

  float w = width * 0.001;  // For convinience
  float c = w * 30; // Scaling factor

  // CONSTRUCTOR: Create a 'Colony' object containing an initial population of cells
  Colony() {
    population = new ArrayList<Cell>();
    

    if (gs.patternSelector == 1) {random_pattern();}
    else
    if (gs.patternSelector == 0) {center_pattern();}
    else
    if (gs.patternSelector == 2) {cartesian_pattern();}
    else
    if (gs.patternSelector == 3) {cartesian_pattern_alt();}
    
    else {phyllotaxic_pattern();}
  }

// 0) Spawn cells in a random pattern
void random_pattern() {
  // Here is the code which fills the 'cells' arraylist with cells at random positions
  for (int n = 0; n <= gs.seeds; n++) {
    pos = new PVector(random(gs.widthUsed)+gs.borderWidth, random(gs.heightUsed)+gs.borderHeight); // random position
    origin = new PVector (gs.orx, gs.ory);
    PVector vel = PVector.sub(origin, pos); // Static velocity vector pointing from cell position to the arbitrary 'origin'
    vel.normalize();
    //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')

    DNA dna = gpl.genepool.get(int(random(gs.numStrains+6))); // Get's a random strain of dna from the genepool
    //DNA dna = gpl.genepool.get(0);                            // Get's a specific strain of dna from the genepool
    dna.genes[0] = n; //n is transferred to gene 0
    
    for (int s = 0; s < gs.strainSize; s ++) {
      population.add(new Cell(pos, vel, dna));
    }
  }
}

// 1) Spawn cells at the center of the screen
void center_pattern() {
  // Here is the code which fills the 'cells' arraylist with cells at the center of the screen
  for (int n = 0; n <= gs.seeds; n++) {
    pos = new PVector(width*0.5, height*0.5); // random position
    
    vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
    origin = new PVector (gs.orx, gs.ory);
    //PVector vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
    //vel.normalize();
    //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')

    DNA dna = gpl.genepool.get(int(random(gs.numStrains))); // Get's a random strain of dna from the genepool
    //DNA dna = gpl.genepool.get(0);                            // Get's a specific strain of dna from the genepool
    dna.genes[0] = n; //n is transferred to gene 28
    
    for (int s = 0; s < gs.strainSize; s ++) {
      population.add(new Cell(pos, vel, dna));
    }
  }
}

// 2) Spawn cells in a cartesian grid pattern
void cartesian_pattern() {
  //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell

  // Here is the code which fills the 'cells' arraylist with cells at given positions
  int n = 0;
  for (int r = 0; r <= gs.rows; r++) {      
    //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
    //a = map(r, 0, gs.rows, 0, TWO_PI);
    //vel = PVector.fromAngle(0).mult(1);
    
    for (int c = 0; c <= gs.cols; c++) {
      //DNA dna = gpl.genepool.get(int(random(gs.numStrains))); // Get's a random strain of dna from the genepool
      DNA dna = gpl.genepool.get(0);                        // Get's a specific strain of dna from the genepool
      //dna.genes[0] = n; //n is transferred to gene 0
      n ++;
      float xpos = (gs.widthUsed * map (c, 0, gs.cols, 0, 1)) + gs.borderWidth;
      float ypos = (gs.heightUsed * map (r, 0, gs.rows, 0, 1)) + gs.borderHeight;
      pos = new PVector(xpos, ypos);
      
      origin = new PVector (gs.orx, gs.ory);

      //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
      vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
      vel = new PVector(1,0);
      vel.normalize();
      //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')

      for (int s = 0; s < gs.strainSize; s ++) {
        //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
        //if ( random(1) > 0.2) {population.add(new Cell(pos, vel, dna));
        population.add(new Cell(pos, vel, dna));
      }
    }
  }
}

// 3) Spawn cells in a cartesian grid pattern with alternating strains
void cartesian_pattern_alt() {
  //vel = PVector.random2D();   // Initial velocity vector is random & identical for each cell

  // Here is the code which fills the 'cells' arraylist with cells at given positions
  int n = 0;
  for (int r = 0; r <= gs.rows; r++) {      
    //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
    //a = map(r, 0, gs.rows, 0, TWO_PI);
    //vel = PVector.fromAngle(0).mult(1);
    
    for (int c = 0; c <= gs.cols; c++) {
      //int str = ((r + c) % int(random(1,gpl.genepool.size()))) + 0;
      int str = ((r + c) % 2) + int(random(7));
      DNA dna = gpl.genepool.get(str); // Get's the appropriate strain of dna from the genepool
      //DNA dna = gpl.genepool.get(0);                        // Get's a specific strain of dna from the genepool
      //dna.genes[0] = n; //n is transferred to gene 0
      n ++;
      float xpos = (gs.widthUsed * map (c, 0, gs.cols, 0, 1)) + gs.borderWidth;
      float ypos = (gs.heightUsed * map (r, 0, gs.rows, 0, 1)) + gs.borderHeight;
      pos = new PVector(xpos, ypos);
      
      origin = new PVector (gs.orx, gs.ory);

      //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
      vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
      vel.normalize();
      //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')

      for (int s = 0; s < gs.strainSize; s ++) {
        //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
        //if ( random(1) > 0.2) {population.add(new Cell(pos, vel, dna));
        population.add(new Cell(pos, vel, dna));
      }
    }
  }
}

// 4) Spawn cells in a phyllotaxic spiral pattern
void phyllotaxic_pattern() {
  // Here is the code which fills the 'cells' arraylist with cells at given positions
  for (int n = 0; n <= gs.seeds; n++) {
    
    // Simple Phyllotaxis formula:
    float a = n * radians(137.5);
    float r = c * sqrt(n);   
    float xpos = r * cos(a) + gs.widthUsed * 0.5 + gs.borderWidth;
    float ypos = r * sin(a) + gs.heightUsed * 0.5 + gs.borderHeight;
    pos = new PVector(xpos, ypos);
    
    
    origin = new PVector (gs.orx, gs.ory);
    PVector vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
    vel.normalize();
    //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')
    int str = ((n) % 2) + 3;
    //DNA dna = gpl.genepool.get(int(random(gs.numStrains+3))); // Get's a random strain of dna from the genepool
    DNA dna = gpl.genepool.get(str); // Get's a random strain of dna from the genepool
    //DNA dna = gpl.genepool.get(0); // Get's a specific strain of dna from the genepool
    
    dna.genes[0] = n; //n is transferred to gene 0
    
    for (int s = 0; s < gs.strainSize; s ++) {
      population.add(new Cell(pos, vel, dna));
    }
   c *= 1.0015;
   //c += width * 0.00003;
  }
}



// Spawn a new cell
  void spawn(PVector pos, PVector vel, DNA dna_) {
    population.add(new Cell(pos, vel, dna_));
  }

// Run the colony
  void run() {
    if (gs.debug) {colonyDebugger();}
    for (int i = population.size()-1; i >= 0; i--) {  // Iterate backwards through the ArrayList because we are removing items
      Cell c = population.get(i);                     // Get one cell at a time
      c.run();                                   // Run the cell (grow, move, spawn, check position vs boundaries etc.)
      if (c.dead()) {population.remove(i);}           // If the cell has died, remove it from the array

      // Iteration to check collision between current cell(i) and the rest
      if (population.size() <= gs.populationMaxSize && c.fertile) {         // Don't check for collisons if there are too many cells (wait until some die off)
        for (int others = i-1; others >= 0; others--) {         // Since main iteration (i) goes backwards, this one needs to too
          Cell other = population.get(others);                       // Get the other cells, one by one
          if (other.fertile) { c.checkCollision(other); }       // Only check for collisions when both cells are fertile
        }
      }
    }
  }


  void colonyDebugger() {  // Displays some values as text at the top left corner (for debug only)
    noStroke();
    fill(0);
    rect(0,0,250,40);
    fill(360);
    textSize(16);
    text("frames" + frameCount + " Nr. cells: " + population.size() + " MaxLimit:" + gs.populationMaxSize + " Pattern:" + gs.patternSelector, 10, 18);
  }

}