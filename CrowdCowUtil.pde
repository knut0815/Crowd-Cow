void setup()
{
  // Init canvas
  frame.setTitle("Cow Controls");
  //size(761, 532);
  size(800, 531);
  ellipseMode(CENTER);
  rectMode(CENTER);
  
  // Init PixelPusher-related vars
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();
  
  // Other
  segments = new ArrayList<Segment>();
  cowMap = loadImage("map.jpg");
  cowMovie = new Movie(this, "animation.mov");
  cowMovie.loop();
}

void draw() 
{
  background(75);
  
  if (displayMap)
    image(cowMap, 0, 0);
  if (displayVideo)
    image(cowMovie, 0, 0);
    
  if (testObserver.hasStrips) 
  {
    registry.startPushing();
    registry.setExtraDelay(0);
    registry.setAutoThrottle(false);
    registry.setAntiLog(true);  
    strips = registry.getStrips();
    numStrips = strips.size();
    
    if (numStrips == 0) 
    {
      println("No strips detected - exiting.");
      return;
    }
    
    // Wait until numStripsExpected strips are found...
    if(!segmentsLoaded && numStrips >= numStripsExpected)
    {
      segmentsLoaded = true;
      int stripLengthInPixels = 400;
      int yBetweenStrips = 24;
      int manualOffsetX = 265;
      int manualOffsetY = 120;
      for (Strip strip: strips)
      {
        println("Strip #: " + strip.getStripNumber());
        if (strip.getStripNumber() < numStripsExpected) 
        {
          segments.add(new Segment(
                          10 + manualOffsetX,                                                     // startX
                          yBetweenStrips * lightStrandCounter + yBetweenStrips + manualOffsetY,   // startY
                          stripLengthInPixels + manualOffsetX,                                    // stopX
                          yBetweenStrips * lightStrandCounter + yBetweenStrips + manualOffsetY,   // stopY
                          strip,                                                                  // strip
                          lightStrandCounter,                                                     // id
                          numLEDsPerStripExpected,                                                // pixelCount
                          0));                                                                    // pixelOffset
          ++lightStrandCounter;
        }
      }
    }
    
    // Here, we actually sample the underlying image
    for (Segment seg : segments) 
    {
      if (seg.strip != null) seg.samplePixels();
    }
    
  }
  
  if (displaySegments) 
  {
    drawDebug();
  }
}

void drawDebug()
{
  for (Segment seg : segments) 
      seg.draw();
  text(displayText, 10, height - 10);
}

void mousePressed() 
{
  PVector mouse = new PVector(mouseX, mouseY);
  selectedPoint = null; 
  for (Segment seg : segments) 
  { 
    for (int i = 0; i < seg.samplePositions.size(); ++i) 
    {
      if (seg.samplePositions.get(i).dist(mouse) < 12) 
      {
        displayText = "Selecting Strip #" + seg.id + ", Pixel #" + i;
        selectedPoint = seg.samplePositions.get(i);
        break; 
      } 
    }
  }
}

void mouseDragged() 
{
  if (selectedPoint != null) 
  {
    selectedPoint.x = mouseX;
    selectedPoint.y = mouseY;
  }
}

void keyPressed() 
{
  // For implementation details, see "Utils.pde"
  if (key == CODED)
  {
    switch (keyCode) 
    {
      case LEFT:
        moveAllSegments(10, Direction.M_LEFT);
        break;
      case RIGHT:
        moveAllSegments(10, Direction.M_RIGHT);
        break;
      case UP:
        moveAllSegments(10, Direction.M_UP);
        break;
      case DOWN:
        moveAllSegments(10, Direction.M_DOWN);
        break;
      default:
        break;  
    }
  }
  else {
    switch (key)
    {
      case 'u':
      case 'U':
        saveFrame("frame-###.tif");  
        break;
      case 's':
      case 'S':
        saveToJSON();
        break;
      case 'l':
      case 'L':
        loadFromJSON();
        break;
      case 'c':
      case 'C':
        clearPixels();
        break;
      case 'd':
      case 'D':
        displaySegments = !displaySegments;
        break;
      case 'm':
      case 'M':
        displayMap = !displayMap;
        displayVideo = !displayVideo;
        break;
      default:
        break;
    }
  }
}