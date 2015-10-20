class TestObserver implements Observer 
{
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) 
  {
    println("Registry changed.");
    if (updatedDevice != null) 
      println("Device change: " + updatedDevice);
    this.hasStrips = true;
  }
}

private void prepareExitHandler () 
{
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() 
  {
    public void run () 
    {
      System.out.println("Shutdown hook running");
      List<Strip> strips = registry.getStrips();
      for (Strip strip : strips) 
      {
        for (int i = 0; i < strip.getLength(); i++)
          strip.setPixel(#000000, i);
      }
      for (int i = 0; i < 100000; i++)
        Thread.yield();
    }
  }
  ));
}