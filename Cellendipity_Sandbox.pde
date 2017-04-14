/*
* Cellendipity_Sandbox
*
* Is a generic 'multi-cellular playset'
*  - consisting of well-organized, easy-to-understand functional-modules
*  - for easy prototyping & documentation of exploratory art-experiments
*  RB 09.apr.2017
*
* Development Goals:
*
*  d) Introduce a smart way of saving frames for gifs (configurable frame interval and intelligent file numbering)
*  e) Learn how to build a 'library' of predefined DNA objects (presets) that are loaded into fixed positions in the strains arraylist
*  g) Introduce a new spawn-pattern of concentric rings
*  h) Fix better naming for output files, it's a MESS!
*    1) When done, fix path & naming of genepool_output.csv (it should not be in data)
*    2) Remove DNA logging to settings.txt, it isn't needed there any more
*  i) Cell style could be a variant of it's DNA, based on a single DNA (e.g. striped/stepped/nucleus) EXPLORE
*  j) Nucleus should be moved to the DNA
*    1) Nucleus colour might need to be hard-coded, to avoid yet more DNA. or?
*    2) Same goes for stripe colour
*  k) Populate the library with some 'favourite' cell genotypes from older sketches
*  l) Try to recreate the twitter/tumblrbot classic styles?
*
*/

Colony colony;        // A Colony object called 'colony'
Global_settings gs;   // A Global_settings object called 'gs'
Genepool gpl;          // A Genepool object called 'gpl'

int runCycle = 1;
int maxCycles = 20;
//int maxFrames = int(random(1300,1600));
int maxFrames = 5000;
int frameCounter = maxFrames;
String versionName = "sandbox";
String batchName = "batch-155.0";
String outputName = nf(runCycle, 3);
String pathName;
String screendumpPath; // Name & location of saved output (final image)
String framedumpPath; // Name & location of saved output (individual frames)
PrintWriter output;

void setup() {
  //frameRate(10);
  colorMode(HSB, 360, 255, 255, 255);
  //blendMode(DIFFERENCE);
  rectMode(RADIUS);
  ellipseMode(RADIUS);
  smooth();
  //size(200, 200);
  //size(500, 500);
  //size(1000, 1000);
  //size(1500, 1500);
  //size(2000, 2000);
  size(4000, 4000);
  //size(6000, 6000);
  //size(8000, 8000);
  pathName = "../../output/" + versionName + "/" + batchName + "/" + String.valueOf(width) + "x" + String.valueOf(width) + "/"; //local
  //pathName = "D:/output/" + versionName + "/" + String.valueOf(width) + "x" + String.valueOf(width) + "/" + batchName + "/"; //USB
  screendumpPath = pathName + versionName + "." + outputName + ".png";
  //screendumpPath = "../output.png";
  framedumpPath = pathName + "/frames/";
  output = createWriter(pathName + versionName + "." + outputName +"_settings.txt");
  
  startSettingsFile();
  gs = new Global_settings();
  gpl = new Genepool();
  colony = new Colony();
  background(gs.bkgColor);
  //background (0,0,0,0);
  //background (0,0,255); //white
  if (gs.debug) {frameRate(5);}
}

void draw() {
  if (gs.debug) {background(gs.bkgColor);}
  //background(gs.bkgColor);
  colony.run();
  String frameName = nf(frameCount, 5);
  //saveFrame(framedumpPath + frameName + ".jpg");
  if (colony.population.size() == 0 || frameCounter < 0 ) {manageColony();}
  frameCounter --;
}

void manageColony() {
    saveFrame(screendumpPath);
    output.println("Total frames: " + (maxFrames - frameCounter));
    output.flush();
    output.close();
    //exit();
    colony.population.clear();
    frameCounter = maxFrames;
    runCycle ++;
    if (runCycle > maxCycles) {exit();}
    outputName = nf(runCycle, 3);
    screendumpPath = pathName + versionName + "." + outputName + ".png";
    output = createWriter(pathName + versionName + "." + outputName +"_settings.txt");
    background(gs.bkgColor);
    //background (0,0,0,0);
    //background (0,0,255); //white
    startSettingsFile();
    gs = new Global_settings();
    gpl = new Genepool();
    colony = new Colony();
}

void startSettingsFile() {
int d = day();    // Values from 1 - 31
int m = month();  // Values from 1 - 12
int y = year();   // 2003, 2004, 2005, etc.
int h = hour();
int min = minute();
int sec = second();

output.println(outputName);
output.println(y + "" + m + "" + d + "-" + h + "" + min + "" + sec + "-" +versionName + "-" + width + "x" + height);
output.println(screendumpPath);
}