class Cell {

  //  Objects
  DNA dna;         // DNA

  // BOOLEAN
  boolean fertile;
  boolean stripe;

  // GROWTH AND REPRODUCTION
  int age;       // Age (nr. of frames since birth)
  int lifespan;
  float fertility; // Condition for becoming fertile
  float maturity;
  float spawnLimit;

  // SIZE AND SHAPE
  float radius_start;
  float radius_end;
  float r;         // Radius
  float flatness; // To make flatter ellipses (1 = circle)
  float flatness_start;  
  float flatness_end;
  float growth;    // Radius grows by this amount per frame
  float drawStep;  // To enable spacing of the drawn object (ellipse)
  float drawStepN;
  float stripeStep;// Countdown to toggle between stripe and !stripe
  float stripeSize;
  float stripeRatio;
  float size; // A value between 0-1 indicating how large the cell is proportional to it's limits

  // MOVEMENT
  PVector position; // cell's current position
  PVector home;     // cell's initial position
  PVector toHome;   // from current to initial (=sub(home, position) )
  PVector origin;   // arbitrary origin (e.g. center of screen)
  PVector toOrigin; // from current to initial (=sub(origin, position) )
  PVector velocityRef;
  PVector velocityLinear;
  PVector velocityNoise;
  PVector velocity;
  
  float vFactor;
  
  float noisePercent;
  float noisePercent_start;
  float noisePercent_end;
  float noise_vMax;   // multiplication factor for velocity
  float noise_xoff;   // x offset
  float noise_yoff;   // y offset
  float noise_step;   // step size
  
  
  float twist;
  float twist_start;
  float twist_end;
  
  float range;      // How far is the cell from it's home position?
  float remoteness; // How close is the cell to it's maximum range?
  float oDist;      // How far is the cell from the arbitrary origin?
  
  float directionDiff; // The difference (in radians) between the current and the initial velocity heading. Range 0-PI

  // FILL COLOUR
  color fillColor;   // For HSB you need Hue to be the heading of a PVector
  float fill_H_start;
  float fill_H_end;
  float fill_S_start;
  float fill_S_end;
  float fill_B_start;
  float fill_B_end;
  float fill_A_start;
  float fill_A_end;

  // STROKE COLOUR
  color strokeColor; // For HSB you need Hue to be the heading of a PVector
  float stroke_H_start;
  float stroke_H_end;
  float stroke_S_start;
  float stroke_S_end;
  float stroke_B_start;
  float stroke_B_end;
  float stroke_A_start;
  float stroke_A_end;
  
  // PIXEL COLOR = color of pixel in source image at cell's current location
  color pixelColor;
  
  // STRAIN
  int id;

  // **************************************************CONSTRUCTOR********************************************************
  // CONSTRUCTOR: create a 'cell' object
  Cell (PVector pos, PVector vel, DNA dna_) {
  // OBJECTS
  dna = dna_;

  
  // BOOLEAN
  fertile = false; // A new cell always starts off infertile
  stripe = false; // A new cell always starts off displaying it's normal colour 

  // id
  id = int(dna.genes[0]);

  // POSITION & MOVEMENT
  position = pos.copy();                // cell has current position
  home = pos.copy();                    // home = initial position
  origin = new PVector(gs.orx, gs.ory); //arbitrary origin
  
  toHome = PVector.sub(home, position); // static vector pointing from cell to home
  range = toHome.mag(); // range is how far the cell is from home at any time
  
  toOrigin = PVector.sub(origin, position); // static vector pointing from cell to origin
  oDist = toOrigin.mag(); // distance from pos to origin
  
  velocityLinear = vel.copy(); //cell has unique basic velocity component
  velocityRef = vel.copy(); //keep a copy of the inital velocity for reference
  
  vFactor = dna.genes[29] * 0.01;
  
  twist_start = dna.genes[21] * 0.01; // twist_start screw amount
  twist_end = dna.genes[22] * 0.01; // twist_end screw amount
  noise_vMax = dna.genes[25]; // Maximum magnitude in velocity components generated by noise
  noise_step = dna.genes[26] * 0.001; //Step-size for noise
  noisePercent_start = dna.genes[23] * 0.01; // How much influence on velocity does Perlin noise have? (initial value)
  noisePercent_end = dna.genes[24] * 0.01; // How much influence on velocity does Perlin noise have? (final value)
  //noise_xoff = dna.genes[27] + dna.genes[0]; //Seed for noiseX
  noise_xoff = map(runCycle, 1, maxCycles, 1, 2); //Seed for noiseX
  //noise_yoff = dna.genes[28]; //Seed for noise
  noise_yoff = map (dna.genes[0], 0, gpl.genepool.size(), 1, 1000); //Strain ID is seed for noiseY
  
  // GROWTH AND REPRODUCTION
  age = 0; // Age is 'number of frames since birth'. A new cell always starts with age = 0. From age comes maturity
  lifespan = int(dna.genes[31] * width * 0.001);
  fertility = dna.genes[29] * 0.01; // How soon will the cell become fertile?
  maturity = map(age, 0, lifespan, 1, 0);
  spawnLimit = dna.genes[30]; // Max. number of spawns

  // SIZE AND SHAPE
  radius_start = dna.genes[17] * width * 0.001;
  radius_end = radius_start * dna.genes[18] * 0.01;
  r = radius_start; // Initial value for radius
  flatness_start = dna.genes[19] * 0.01; // To make circles into ellipses
  flatness_end = dna.genes[20] * 0.01; // To make circles into ellipses
  flatness = map(maturity, 1, 0, flatness_start, flatness_end);
  growth = (radius_start-radius_end)/lifespan; // Should work for both large>small and small>large
  drawStep = 1;
  drawStepN = 1;
  stripeStep = dna.genes[32];
  stripeSize = dna.genes[32] * width * 0.001;
  stripeRatio = dna.genes[33];

  // COLOUR
  fill_H_start = dna.genes[1];
  fill_H_end = dna.genes[2];
  fill_S_start = dna.genes[3];
  fill_S_end = dna.genes[4];
  fill_B_start = dna.genes[5];
  fill_B_end = dna.genes[6];
  fill_A_start = dna.genes[7];
  fill_A_end = dna.genes[8];
  fillColor = color(fill_H_start, fill_S_start, fill_B_start, fill_A_start); // Initial color is set

  stroke_H_start = dna.genes[9];
  stroke_H_end = dna.genes[10];
  stroke_S_start = dna.genes[11];
  stroke_S_end = dna.genes[12];
  stroke_B_start = dna.genes[13];
  stroke_B_end = dna.genes[14];
  stroke_A_start = dna.genes[15];
  stroke_A_end = dna.genes[16];
  strokeColor = color(stroke_H_start, stroke_S_start, stroke_B_start, stroke_A_start); // Initial color is set
  
  cartesianMods(); // Modulate some properties in a way that is appropriate to a cartesian spawn pattern
  //coralMods(); // Modulate some properties in a way that is similar to batch-144.8g (tragedy of the corals)
  
  cellDNALogger(); //Print the DNA for this cell
  }

  void cartesianMods() {
  // MODULATED BY POSITION
  //radius_start *= map(oDist, 0, width, 0.5, 1);
  //flatness_start *= map(oDist, 0, width, 0.4, 1.0);
  //lifespan *= map(oDist, 0, width, 0.7, 5);
  //noisePercent_start *= map(oDist, 0, width, 0.7, 0.5);
  //twist_start *= map(oDist, 0, width, 0.3, 0.5);
  //fill_H_end = (gs.bkg_H + map(oDist, 0, width, 40, 0));
  //fill_S_start *= map(position.x, 0, width, 1, 0);
  //fill_S_start *= map(oDist, 0, width, 0, 0);
  //fill_S_end *= map(position.x, 0, width, 1, 0);
  //fill_S_end *= map(oDist, 0, width, 0, 0);
  //fill_B_end = map(oDist, 0, width*0.5, 250, 48);
  //fill_B_start *= map(oDist, 0, width, 1, 0);
  //fill_B_start *= map(position.x, 0, width, 1, 0);
  //fill_B_end *= map(oDist, 0, width, 0.7, 0.2);
  //stripeSize *= map(oDist, 0, width, 1.0, 0.6);
  //stripeRatio = map(oDist, 0, width, 0.3, 0.7);
  
  // MODULATED BY POSITION (Cartesian/Random)
  //lifespan = width * 0.001 * map(oDist, 0, width*0.7, 18, 12);

  //twist_start = map(oDist, 0, width, 0, 15);
  //fill_B_end = dna.genes[5] * map(oDist, 0, width*0.7, 0.7, 1);
  //fill_A_start = map(oDist, 0, width*0.7, 255, 20);
  
  // MODULATED BY INDEX NUMBER
  //stripeSize = map(id, 0, gs.seeds, 60, 10);
  lifespan = int(map(id, 0, gs.numStrains, 5, 500));
  radius_start = width * 0.001 * map(id, 0, gs.numStrains, 20, 40);
  r = radius_start;
  radius_end = radius_start * map(id, 0, gs.numStrains, 0.2, 0.05);
  //flatness_start = map(id, 0, gs.rows * gs.cols, 1, 1.5);
  //lifespan = width * .001 * map(id, 0, gs.seeds, 1, 500);
  twist_start = map(id, 0, gs.numStrains, 0, 3);
  //fill_H_start =  map(id, 0, gs.numStrains, 0, 360);
  //fill_H_end =  fill_H_start;
  }
  
  void coralMods() {
    // MODULATED BY POSITION
    //radius_start *= map(oDist, 0, width, 1, 0.2);
    //radius_start = map(oDist, 0, width * 0.5, 60, 30) * width * 0.001;
    lifespan = int(map(oDist, 0, width * 0.5, 100, 400) * width * 0.001);
    noisePercent_start = map(oDist, 0, width * 0.5, 1, 0);
    noisePercent_end = map(oDist, 0, width * 0.5, 0, 1);
    
    //stroke_H_start = map(oDist, 0, width * 0.5, 0, 360);
    //stroke_H_end = map(oDist, 0, width * 0.5, 0, 360);
    
    //fill_H_end = (gs.bkg_H + map(oDist, 0, width, 30, 0));
    //fill_B_start = map(position.x, 0, width, 128, 48);
    //fill_B_end = map(oDist, 0, width, 200, 255);
    //fill_B_end = fill_B_start * map(oDist, 0, width, 1, 2);
    //fill_S_start = map(position.x, 0, width, 255, 0);
    //fill_S_end = map(position.x, 0, width, 30, 0);
    //fill_S_start = map(oDist, 0, width, 255, 0);
    //fill_S_end = map(oDist, 0, width, 30, 0);
    //fill_S_end = fill_S_start * map(oDist, 0, width, 0.8, 0.6);
    //twist_start = map(oDist, 0, width, 0, 20) * 0.01;
    twist_end = map(oDist, 0, width * 0.5, 250, 0) * 0.01;
    
  }

  void run() {
    live();
    updateVelocity();
    //updateVelocityByHue();
    updatePosition();
    updateSize();
    updateShape();
    updateFertility();
    updateFillColorBySize();
    updateStrokeColorBySize();
    //updateFillColorByDirection();
    //updateStrokeColorByDirection();
    //updateFillColorByPosition();
    //updateStrokeColorByPosition();
    if (stripe) {updateStripes();}
    display();
    //displayRect();
    //displayText();
    if (gs.debug) {cellDebugger();}
  }

  void live() {
    age ++;
    maturity = map(age, 0, lifespan, 1, 0);
    drawStep --;
    float drawStepStart = map(gs.stepSize, 0, 100, 0 , (r *2 + growth));
    if (drawStep < 0) {drawStep = drawStepStart;}
    drawStepN--;
    float drawStepNStart = map(gs.stepSizeN, 0, 100, 0 , r *2);
    if (drawStepN < 0) {drawStepN = drawStepNStart;} // Stripe follows Nucleus Step interval
    stripeStep--;
    float stripeStepStart = map(stripeSize, 0, 100 * width * 0.001, 0, r*2);
    if (stripe) {stripeStepStart *= stripeRatio;} else {stripeStepStart *= (1-stripeRatio);}
    if (stripeStep < 0) {stripeStep = stripeStepStart; stripe = !stripe;}
  }

  void updateVelocity() {
    //Update Perlin noise vector 
    float vx = map(noise(noise_xoff),0,1,-noise_vMax,noise_vMax);
    float vy = map(noise(noise_yoff),0,1,-noise_vMax,noise_vMax);
    velocityNoise = new PVector(vx,vy);
    noise_xoff += noise_step;
    noise_yoff += noise_step;
    
    //Update noisePercent
    noisePercent = map(maturity, 1, 0, noisePercent_start, noisePercent_end);
    
    //Update twistAngle
    twist = radians(map(maturity, 1, 0, twist_start, twist_end));
    
    //Interpolate between the linear and noise vectors
    velocity = PVector.lerp(velocityLinear.rotate(twist), velocityNoise, noisePercent); //<>// //<>// //<>//
    velocity.normalize(); // TEST. To see how this looks, velocity only contributes direction, is always a unit vector.
    
    //Rotate the resulting vector by the current twist angle
    
    //float twistAngle = map(maturity, 0, 1, 0, twist);
    //velocity.mult(vFactor);
    //velocity.rotate(twist);
    
    directionDiff = PVector.angleBetween(velocityRef, velocity); // Float in range 0-PI
  }
  
  void updateVelocityByHue() {
    velocity = PVector.fromAngle(radians(hue(pixelColor)));
    twist = TWO_PI * map(maturity, 0, 1, twist_start, twist_end);
    float twistAngle = map(maturity, 0, 1, 0, twist);
    //velocity.mult(vFactor);
    velocity.rotate(twistAngle);
    directionDiff = PVector.angleBetween(velocityRef, velocity); // Float in range 0-PI
  }
  
  
  void updatePosition() { //Update parameters linked to the position
    position.add(velocity); //<>// //<>// //<>//
    
    //pixelColor = colony.pixelColour(position);
    
    toHome = PVector.sub(home, position); // static vector pointing from cell to home
    range = toHome.mag(); // range is how far the cell is from home at any time
    
    toOrigin = PVector.sub(origin, position); // static vector pointing from cell to origin
    oDist = toOrigin.mag(); // distance from pos to origin
    
    remoteness = map(range, 0, lifespan, 0, 1); // remoteness is a value between 0-1.
    //remoteness = sq(map(range, 0, lifespan, 0, 1)); // remoteness is a value between 0-1.
    //remoteness = sq(map(oDist, 0, lifespan, 0, 1)); // remoteness is a value between 0-1.
    
    //maturity = map(range, 0, lifespan, 1, 0); // maturity is a value between 0-1.
    //maturity = map(age, 0, lifespan, 1, 0); // maturity is a value between 0-1.
  }

  void updateSize() {
    // I should introduce an selector-toggle here!
    PVector center = new PVector(width/2, height/2);
    PVector distFromCenter = PVector.sub(center, position); // static vector to get distance between the cell & the center of the canvas
    float distMag = distFromCenter.mag();                         // calculate magnitude of the vector pointing to the center
    //stroke(0,255);
    //r = map(remoteness, 0, 1, radius_start, radius_end);
    //r = map(directionDiff, 0, PI, radius_start, radius_end);
    //r = map(hue(pixelColor), 360, 0, radius_start, radius_end); // Size from pixel brightness
    r = map(age, 0, lifespan, radius_start, radius_end);
    //r = ((sin(map(distMag, 0, 500, 0, PI)))+0)*radius_start;
    //r = (((sin(map(remoteness, 0, 1, 0, PI*0.5)))+0)*radius_start) + radius_end;
    //r = (((sin(map(age, 0, lifespan, 0, PI)))+0)*radius_start) + radius_end;
    //r -= growth;
    //size = map(r, radius_start, radius_end, 0, 1); // size indicates how large the cell is in proportion to it's limits
    size = map(age, 0, lifespan, 0, 1); // HACK!!!!
    
  }

  void updateFertility() {
    if (maturity <= fertility) {fertile = true; } else {fertile = false; }
    if (spawnLimit == 0) {fertility = 0;} // Once spawnLimit has counted down to zero, the cell will spawn no more
  }

  void updateShape() {
  flatness = map(maturity, 1, 0, flatness_start, flatness_end);
  }

  void updateFillColorBySize() {
    // START > END
    float fill_H = map(size, 0, 1, fill_H_start, fill_H_end) % 360;
    float fill_S = map(size, 0, 1, fill_S_start, fill_S_end);
    float fill_B = map(size, 0, 1, fill_B_start, fill_B_end);
    float fill_A = map(size, 0, 1, fill_A_start, fill_A_end);
    fillColor = color(fill_H, fill_S, fill_B, fill_A); //fill colour is updated with new values
  }
  
  void updateStrokeColorBySize() {
    // START > END
    float stroke_H = map(size, 0, 1, stroke_H_start, stroke_H_end) % 360;
    float stroke_S = map(size, 0, 1, stroke_S_start, stroke_S_end);
    float stroke_B = map(size, 0, 1, stroke_B_start, stroke_B_end);
    float stroke_A = map(size, 0, 1, stroke_A_start, stroke_A_end);    
    strokeColor = color(stroke_H, stroke_S, stroke_B, stroke_A); //stroke colour is updated with new values
  }

  void updateFillColorByDirection() {
    float fill_H = map(directionDiff, 0, PI, fill_H_start, fill_H_end) % 360;
    float fill_S = map(directionDiff, 0, PI, fill_S_start, fill_S_end);
    float fill_B = map(directionDiff, 0, PI, fill_B_start, fill_B_end);
    float fill_A = map(size, 0, 1, fill_A_start, fill_A_end);
    fillColor = color(fill_H, fill_S, fill_B, fill_A); //fill colour is updated with new values
  }
  
  void updateStrokeColorByDirection() {
    float stroke_H = map(directionDiff, 0, PI, stroke_H_start, stroke_H_end) % 360;
    float stroke_S = map(directionDiff, 0, PI, stroke_S_start, stroke_S_end);
    float stroke_B = map(directionDiff, 0, PI, stroke_B_start, stroke_B_end);
    float stroke_A = map(size, 0, 1, stroke_A_start, stroke_A_end);
    strokeColor = color(stroke_H, stroke_S, stroke_B, stroke_A); //stroke colour is updated with new values
  }
  
  void updateFillColorByPosition() {
  //fillColor = colony.pixelColour(position);
  //float fill_H = hue(pixelColor);
  //float fill_S = saturation(pixelColor);
  //float fill_B = brightness(pixelColor);
  //float fill_A = alpha(fillColor); // alpha from pixelColor is not used as it is always 100%
  fillColor = color(hue(fillColor), saturation(fillColor), brightness(pixelColor), alpha(fillColor)); //fill colour is updated with new values
  //fillColor = pixelColor;
  }
  
  void updateStrokeColorByPosition() {
    strokeColor = color(hue(pixelColor), saturation(pixelColor), brightness(pixelColor), alpha(strokeColor));
    //strokeColor = pixelColor;
  }

  void updateStripes() {
    //fillColor = color(34, 255, 255, 255); // RED
    //fillColor = strokeColor;
    //fillColor = color(0, 0, 0, 255); // BLACK
    //fillColor = gs.bkgColor; // Background
    fillColor = color(0, 0, 255); // WHITE
    //strokeColor = color(0, 0, 0);  
  }

  void display() {
    strokeWeight(1);
    //stroke(hue(strokeColor), saturation(strokeColor), brightness(strokeColor), stroke_A);
    //fill(hue(fillColor), saturation(fillColor), brightness(fillColor), fill_A);
    fill(fillColor);
    stroke(strokeColor);
    //println("A:" + age + " Lifesp:" + lifespan + " Fill H:" + hue(fillColor) + " S:" + saturation(fillColor) + " B:" + brightness(fillColor) + " Stroke H:" + hue(strokeColor) + " S:" + saturation(strokeColor) + " B:" + brightness(strokeColor)); 
    
    float x_scaled = map (position.x, 0, width, width * gs.borderWidth, width * (1-gs.borderWidth));
    float y_scaled = map (position.y, 0, height, height * gs.borderHeight, height * (1-gs.borderHeight));

    float angle = velocity.heading();
    pushMatrix();
    translate(x_scaled, y_scaled);
    //line(0, 0, velocityRef.x*100, velocityRef.y*100); // DEBUG
    //line(0, 0, velocity.x*100, velocity.y*100); // DEBUG
    rotate(angle);
    if (!gs.stepped) {
      ellipse(0, 0, r, r * flatness);
      if (gs.nucleus && drawStepN < 1) {
        if (fertile) {
        fill(gs.nucleusColorF); ellipse(0, 0, radius_end/2, radius_end/2 * flatness);
        popMatrix(); //A
        //line(position.x, position.y, home.x, home.y);
        }
        else {fill(gs.nucleusColorU); ellipse(0, 0, radius_end/2, radius_end/2 * flatness); popMatrix();} //B
      }
      else {popMatrix();} //C
    }
    else if (drawStep < 1) { // stepped=true, step-counter is active for cell, draw only when counter=0
      ellipse(0, 0, r, r*flatness);
      if (gs.nucleus && drawStepN < 1) { // Nucleus is always drawn when cell is drawn (no step-counter for nucleus)
        if (fertile) {
          fill(gs.nucleusColorF); ellipse(0, 0, radius_end/2, radius_end/2 * flatness);
          popMatrix(); //D
          //line(position.x, position.y, home.x, home.y);
        }
        else {fill(gs.nucleusColorU); ellipse(0, 0, radius_end/2, radius_end/2 * flatness); popMatrix();} //E
      }
      else {popMatrix();} //F
    }
   else {popMatrix();} //G
  }

void displayRect() {
    strokeWeight(1);
    stroke(strokeColor);
    fill(fillColor);
    
    //println("A:" + age + " Lifesp:" + lifespan + " Death" + int(dead()) + " Fill H:" + hue(fillColor) + " S:" + saturation(fillColor) + " B:" + brightness(fillColor) + " Stroke H:" + hue(strokeColor) + " S:" + saturation(strokeColor) + " B:" + brightness(strokeColor));
    
    float x_scaled = map (position.x, 0, width, width * gs.borderWidth, width * (1-gs.borderWidth));
    float y_scaled = map (position.y, 0, height, height * gs.borderHeight, height * (1-gs.borderHeight));

    float angle = velocity.heading();
    pushMatrix();
    translate(x_scaled, y_scaled);
    //rotate(angle);
    if (!gs.stepped) {
      rect(0, 0, r, r * flatness);
      if (gs.nucleus && drawStepN < 1) {
        if (fertile) {
        fill(gs.nucleusColorF); rect(0, 0, radius_end/2, radius_end/2 * flatness);
        popMatrix(); //A
        //line(position.x, position.y, home.x, home.y);
        }
        else {fill(gs.nucleusColorU); rect(0, 0, radius_end/2, radius_end/2 * flatness); popMatrix();} //B
      }
      else {popMatrix();} //C
    }
    else if (drawStep < 1) { // stepped=true, step-counter is active for cell, draw only when counter=0
      rect(0, 0, r, r*flatness);
      if (gs.nucleus && drawStepN < 1) { // Nucleus is always drawn when cell is drawn (no step-counter for nucleus)
        if (fertile) {
          fill(gs.nucleusColorF); rect(0, 0, radius_end/2, radius_end/2 * flatness);
          popMatrix(); //D
          //line(position.x, position.y, home.x, home.y);
        }
        else {fill(gs.nucleusColorU); rect(0, 0, radius_end/2, radius_end/2 * flatness); popMatrix();} //E
      }
      else {popMatrix();} //F
    }
   else {popMatrix();} //G
  }

//void displayText() {
//    textSize(r*0.5);
//    strokeWeight(1);
//    stroke(strokeColor);
//    fill(fillColor);

//    float angle = velocity.heading();
//    pushMatrix();
//    translate(position.x,position.y);
//    rotate(angle);
//    String word = gs.words.get(id);
//    text(word, 0, 0);
    
//   popMatrix();
//  }



  void checkCollision(Cell other) {       // Method receives a Cell object 'other' to get the required info about the collidee
      PVector distVect = PVector.sub(other.position, position); // Static vector to get distance between the cell & other
      float distMag = distVect.mag();       // calculate magnitude of the vector separating the balls
      if (distMag < (r + other.r)) { conception(other, distVect);} // Spawn a new cell
  }

  void conception(Cell other, PVector distVect) {
    // Decrease spawn counters.
    spawnLimit --;
    other.spawnLimit --; //<>// //<>// //<>// //<>//

    // Calculate velocity vector for spawn as being centered between parent cell & other
    PVector spawnVel = velocity.copy(); // Create spawnVel as a copy of parent cell's velocity vector
    spawnVel.add(other.velocity);       // Add dad's velocity
    spawnVel.normalize();               // Normalize to leave just the direction and magnitude of 1 (will be multiplied later)

    // Combine the DNA of the parent cells
    DNA childDNA = dna.combine(other.dna);

    // Calculate new fill colour for child (a 50/50 blend of each parent cells)
    color childFillColor = lerpColor(fillColor, other.fillColor, 0.5);

    // Calculate new stroke colour for child (a 50/50 blend of each parent cells)
    color childStrokeColor = lerpColor(strokeColor, other.strokeColor, 0.5);

    // Genes for color require special treatment as I want childColor to be a 50/50 blend of parents colors
    // I will therefore overwrite color genes with reverse-engineered values after lerping:
    //childDNA.genes[1] = hue(childFillColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[3] = saturation(childFillColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[5] = brightness(childFillColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[9] = hue(childStrokeColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[11] = saturation(childStrokeColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[13] = brightness(childStrokeColor); // Get the  lerped hue value and map it back to gene-range

    childDNA.genes[17] = (r + other.r) *0.5; // Child radius_start is set at average of parents current radii

    colony.spawn(position, spawnVel, childDNA);

    //Reduce fertility for parent cells by squaring them
    fertility *= fertility;
    fertile = false;
    other.fertility *= other.fertility;
    other.fertile = false;
  }

  // Death
  boolean dead() {
    if (age >= lifespan) {return true;} // Death by old age (regardless of size, which may remain constant)
    if (r < radius_end) {return true;} // Death by too little radius
    //if (r > (width*0.1)) {return true;} // Death by too much radius
    if (spawnLimit <= 0) {return true;} // Death by too much babies
    //if (position.x > width + r * flatness_start || position.x < -r * flatness_start || position.y > height + r * flatness_start || position.y < -r * flatness_start) {return true;} // Death if move beyond canvas boundary
    //if (position.x > width || position.x < 0 || position.y > height || position.y < 0) {return true;} // Death if move beyond border
    else { return false; }
    //return false; // Use to disable death
  }

  void cellDebugger() { // For debug only
    int rowHeight = 12;
    fill(120, 0, 128);
    textSize(rowHeight);
    text("id:" + id, position.x, position.y + rowHeight * 0);
    //text("r:" + r, position.x, position.y + rowHeight * 5);
    //text("pos:" + position.x + "," + position.y, position.x, position.y + rowHeight * 0);
    //text("stripeStep:" + stripeStep, position.x, position.y + rowHeight * 8);
    //text("Stripe:" + stripe, position.x, position.y + rowHeight * 6);
    text("range:" + int(range), position.x, position.y + rowHeight * 6);
    //text("fill_B_start:" + fill_B_start, position.x, position.y + rowHeight * 1);
    //text("fill_B_end:" + fill_B_end, position.x, position.y + rowHeight * 2);
    //text("radius_start:" + radius_start, position.x, position.y + rowHeight * 1);
    //text("radius_end:" + radius_end, position.x, position.y + rowHeight * 2);
    //text("fill_H:" + hue(fillColor), position.x, position.y + rowHeight * 1);
    //text("fill_S:" + saturation(fillColor), position.x, position.y + rowHeight * 2);
    //text("fill_B:" + brightness(fillColor), position.x, position.y + rowHeight * 3);
    //text("fill_A:" + alpha(fillColor), position.x, position.y + rowHeight * 4);
    //text("stroke_H:" + hue(strokeColor), position.x, position.y + rowHeight * 1);
    //text("stroke_S:" + saturation(strokeColor), position.x, position.y + rowHeight * 2);
    //text("stroke_B:" + brightness(strokeColor), position.x, position.y + rowHeight * 3);
    //text("stroke_A:" + alpha(strokeColor), position.x, position.y + rowHeight * 4);
    //text("growth:" + growth, position.x, position.y + rowHeight * 5);
    text("lifespan:" + lifespan, position.x, position.y + rowHeight * 1);
    text("age:" + age, position.x, position.y + rowHeight * 2);
    text("maturity:" + maturity, position.x, position.y + rowHeight * 3);
    //text("fertile:" + fertile, position.x, position.y + rowHeight * 2);
    //text("fertility:" + fertility, position.x, position.y + rowHeight * 3);
    //text("spawnLimit:" + spawnLimit, position.x, position.y + rowHeight * 4);
    text("vel.x:" + velocity.x, position.x, position.y + rowHeight * 4);
    text("vel.x:" + velocity.y, position.x, position.y + rowHeight * 5);
    //text("dirDiff:" + directionDiff, position.x, position.y + rowHeight * 2);
    //text("twist_Start:" + twist_start, position.x, position.y + rowHeight * 2);
    //text("twist_End:" + twist_end, position.x, position.y + rowHeight * 3);
    //text("twist:" + twist, position.x, position.y + rowHeight * 4);
    //text("oDist:" + oDist, position.x, position.y + rowHeight * 2);
    //text("noise%:" + noisePercent, position.x, position.y + rowHeight * 3);
    //text("noise%S:" + noisePercent_start, position.x, position.y + rowHeight * 4);
    //text("noise%E:" + noisePercent_end, position.x, position.y + rowHeight * 5);
  }
  
  void cellDNALogger() {
    if (gs.debug) {
        for (int i = 0; i < dna.genes.length; i++) {
          float value = dna.genes[i];
          output.println("Gene:" + i + ": has value " + value);
        }
    }
  }

}