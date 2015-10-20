class Segment 
{
  PVector sampleStart;
  PVector sampleStop;
  ArrayList<PVector> samplePositions;
  Strip strip;
  int pixelOffset =   0;
  int pixelCount =    0;
  int id;
  color drawColor;
  int drawRadius =    14;
  
  Segment(float startX, 
          float startY, 
          float stopX, 
          float stopY, 
          Strip strip, 
          int id, 
          int pixelCount, 
          int pixelOffset) 
  {
    this.sampleStart =       new PVector(startX, startY);
    this.sampleStop =        new PVector(stopX, stopY);
    this.strip =             strip;
    this.id =                id;
    this.pixelCount =        pixelCount;
    this.pixelOffset =       pixelOffset;
    this.samplePositions =   new ArrayList<PVector>();
    
    float xStep = abs(stopX - startX) / this.pixelCount;
    float yStep = abs(stopY - startY) / this.pixelCount;

    this.samplePositions.add(this.sampleStart);
    for (int i = 1; i < (this.pixelCount - 1); ++i)
    {
      this.samplePositions.add(new PVector(this.sampleStart.x + (xStep * i), this.sampleStart.y + (yStep * i)));
    }
    this.samplePositions.add(this.sampleStop);
    
    // Choose a draw color
    drawColor = color(random(255), random(255), random(255));
  }
  
  Segment(ArrayList<PVector> positions, Strip strip, int id) 
  {
    // We use this constructor when loading from a JSON file
    this.samplePositions = positions;  
    this.sampleStart =     this.samplePositions.get(0);
    this.sampleStop =      this.samplePositions.get(this.samplePositions.size()-1);
    this.strip =           strip;
    this.id =              id;
    this.pixelCount =      this.samplePositions.size();
    this.pixelOffset =     0;
    
    // Choose a draw color
    drawColor = color(random(255), random(255), random(255));
  }
  
  public void draw() 
  {
    // Draw a dot for each sample position and a series of line segments connecting the dots
    stroke(255);
    fill(this.drawColor);
    ellipse(this.sampleStart.x, this.sampleStart.y, drawRadius, drawRadius);
    for (int i = 1; i < this.samplePositions.size() - 1; ++i)
    {
      line(this.samplePositions.get(i-1).x,
           this.samplePositions.get(i-1).y,
           this.samplePositions.get(i).x,
           this.samplePositions.get(i).y);
      ellipse(this.samplePositions.get(i).x, this.samplePositions.get(i).y, drawRadius, drawRadius);
    }
  } 
  
  public void samplePixels() 
  {
    int i = 0;
    for (PVector pos : this.samplePositions) 
    {
      color sampleColor = get((int)pos.x, (int)pos.y);
      int a = (sampleColor >> 24) & 0xFF;
      int r = (sampleColor >> 16) & 0xFF;                          // Faster way of getting red(argb)
      int g = (sampleColor >> 8) & 0xFF;                           // Faster way of getting green(argb)
      int b = sampleColor & 0xFF;                                  // Faster way of getting blue(argb)
      color switchedColor = color(r, b, g);
      this.strip.setPixel(switchedColor, i + this.pixelOffset);
      ++i;
    }
  }
}