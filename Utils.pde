void saveToJSON()
{
  println("Saving JSON file..."); 
  JSONArray parent = new JSONArray();
  
  for (int i = 0; i < segments.size (); ++i) 
  { 
    Segment seg = segments.get(i);
    
    JSONObject segObject = new JSONObject();  
    segObject.setInt("id", seg.id);
    
    JSONArray positions = new JSONArray();
    for (int j = 0; j < segments.get(i).samplePositions.size(); ++j) 
    {
      JSONObject pointObject = new JSONObject();
      pointObject.setInt("index", j);
      pointObject.setFloat("posX", segments.get(i).samplePositions.get(j).x);
      pointObject.setFloat("posY", segments.get(i).samplePositions.get(j).y);
      positions.setJSONObject(j, pointObject);
    }
    segObject.setJSONArray("positions", positions);
    parent.setJSONObject(i, segObject);
  }
  if (parent != null) 
  {
    println("File successfully saved at data/data.json.");
    saveJSONArray(parent, "data/data.json");
  } 
  else 
  {
    println("Failed to save. Error with segment objects.");
  }
}

void loadFromJSON()
{
  println("Clearing the current ArrayList of segment objects...");
  segments = new ArrayList<Segment>();
  
  println("Loading JSON file..."); 
  JSONArray values = loadJSONArray("data.json");
  
  if (values != null && values.size() <= numStripsExpected) 
  {
    for (int i = 0; i < values.size (); i++) 
    {
      JSONObject segObject = values.getJSONObject(i);  
      int id = segObject.getInt("id");
      
      JSONArray positions = segObject.getJSONArray("positions");
      ArrayList<PVector> samplePositions = new ArrayList<PVector>();
 
      for (int j = 0; j < positions.size(); ++j)
      {
        JSONObject pointObject = positions.getJSONObject(j);
        int ledNumber = pointObject.getInt("index");
        float posX = pointObject.getFloat("posX");
        float posY = pointObject.getFloat("posY");
        samplePositions.add(new PVector(posX, posY));
      }
      segments.add(new Segment(samplePositions, null, id));
    }
  } 
  else 
  {
    println("Failed to load. File should be stored at data/data.json.");
  }  
}

void clearPixels() 
{
  println("Clearing all PixelPusher strands...");
  for (Strip strip : strips) 
  {
    for (int i = 0; i < strip.getLength (); i++) 
    {
      strip.setPixel(#000000, i);
    }
  }
}

public enum Direction {
  M_UP,
  M_DOWN,
  M_LEFT,
  M_RIGHT
}

void moveAllSegments(int amt, Direction dir)
{
  int xIncr = 0;
  int yIncr = 0;
  switch (dir)
  {
    case M_UP:
      yIncr = -1;
      break;
    case M_DOWN:
      yIncr = 1;
      break;
    case M_LEFT:
      xIncr = -1;
      break;
    case M_RIGHT:
      xIncr = 1;
      break;
    default:
      break;
  }
  xIncr *= amt;
  yIncr *= amt;
  
  for (Segment seg : segments)
  {
    for (PVector pos : seg.samplePositions) 
    {
      pos.x += xIncr;
      pos.y += yIncr;
    }
  }
}

void initTestSegments()
{
  for (int i = 0; i < numStripsExpected; ++i)
  {
    segments.add(new Segment(
          10,                     // startX
          20 * i + 20,            // startY
          200,                    // stopX
          20 * i + 20,            // stopY
          null,                   // strip
          lightStrandCounter,     // id
          10,                     // pixelCount
          0));                    // pixelOffset
     ++lightStrandCounter;
  }
}

void movieEvent(Movie m) 
{
  m.read();
}