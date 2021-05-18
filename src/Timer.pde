class Timer
{
  float elapsed; // time elasped in milliseconds
  float totalTime; // the time in milliseconds that the timer is counting toward
  
  public Timer() 
  {
  }
  
  public Timer(float totalTime)
  {
    this.totalTime = totalTime;
  }
  
  float getElapsed()
  {
    return elapsed;
  }
  
  float getTotalTime()
  {
    return totalTime;
  }
  
  boolean isDone()
  {
    return totalTime != 0 && elapsed >= totalTime;
  }
  
  // method to increase elasped time, assuming the frame rate is 60
  void increaseElapsed()
  {
    this.increaseElapsed(60);
  }
  
  // method to increase elasped time depending on the frame rate
  void increaseElapsed(float framerate)
  {
    if (totalTime > 0)
      elapsed += 1000 / framerate;
    else if (round(elapsed) == 1000)
      elapsed = 1000 / framerate;
    else
      elapsed += 1000 / framerate;
  }
}
