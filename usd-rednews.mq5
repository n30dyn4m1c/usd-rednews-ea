//+------------------------------------------------------------------+
//|                                           USDRedNewsReminder.mq5 |
//|                                                       Neo Malesa |
//|                                     https://www.x.com/n30dyn4m1c |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Neo Malesa"
#property link      "https://www.x.com/n30dyn4m1c"
#property version   "1.10"
#property strict

// Inputs
input int ReminderIntervalMinutes = 30; // Alert when event is within this many minutes
input int DaysAhead              = 2;   // Scan today + next (DaysAhead-1) days

// Track events by ID to avoid name/time duplicates
struct TrackedEvent
{
  long     event_id;
  datetime time_gmt;     // Calendar times are UTC
  string   name;
  int      importance;   // CALENDAR_IMPORTANCE_*
  bool     alerted;      // Alert fired already?
};

TrackedEvent tracked[];      // Dynamic list of upcoming tracked events (USD, High)
datetime     lastScanGMT=0;  // Last scan timestamp (UTC)

// Utility: find index by event_id
int FindTrackedIndexById(const long id)
{
  for(int i=0;i<ArraySize(tracked);i++)
    if(tracked[i].event_id==id) return i;
  return -1;
}

// Initialize: set a 60s timer so EA works even without ticks
int OnInit()
{
  ArrayResize(tracked,0);
  EventSetTimer(60); // fire OnTimer every 60 seconds
  Print("USD Red News Reminder EA initialized.");
  return(INIT_SUCCEEDED);
}

// Deinitialize: kill timer and log remaining events
void OnDeinit(const int reason)
{
  EventKillTimer();
  Print("USD Red News Reminder EA deinitialized. Remaining tracked events:");
  for(int i=0;i<ArraySize(tracked);i++)
    Print("Remaining: ",tracked[i].name," at ",
          TimeToString(tracked[i].time_gmt,TIME_DATE|TIME_MINUTES)," (UTC)");
  ArrayResize(tracked,0);
}

// Main timer: scan calendar hourly; alert when inside window once
void OnTimer()
{
  datetime now_gmt = TimeGMT();

  // Scan no more than hourly
  if(now_gmt - lastScanGMT >= 3600)
  {
    lastScanGMT = now_gmt;

    // Compute UTC day window [00:00 today, 00:00 + DaysAhead)
    datetime dayStartUTC = StringToTime(TimeToString(now_gmt, TIME_DATE)); // 00:00 UTC today
    datetime dayEndUTC   = dayStartUTC + 86400*DaysAhead;

    // Pull calendar values; we’ll filter for USD and future times
    MqlCalendarValue vals[];
    int total = CalendarValueHistory(vals, dayStartUTC, dayEndUTC, NULL, NULL);
    if(total<0)
      Print("CalendarValueHistory error: ",GetLastError());

    for(int i=0;i<total;i++)
    {
      // Only future events in window
      if(vals[i].time <= now_gmt) continue;

      // Fetch event meta
      MqlCalendarEvent ev;
      if(!CalendarEventById(vals[i].event_id, ev)) continue;

      // Filter: USD currency and High importance (strict “red” news)
      if(StringCompare(vals[i].currency,"USD")!=0) continue;
      if(ev.importance != CALENDAR_IMPORTANCE_HIGH) continue;

      // De-dup by event_id
      if(FindTrackedIndexById(vals[i].event_id) != -1) continue;

      // Add new tracked event
      int n = ArraySize(tracked);
      ArrayResize(tracked, n+1);
      tracked[n].event_id   = vals[i].event_id;
      tracked[n].time_gmt   = vals[i].time;  // already UTC
      tracked[n].name       = ev.name;
      tracked[n].importance = ev.importance;
      tracked[n].alerted    = false;
    }
  }

  // Process alerts and prune past events
  for(int k=ArraySize(tracked)-1; k>=0; k--)
  {
    datetime et = tracked[k].time_gmt;

    // Remove if event time passed
    if(et <= now_gmt)
    {
      ArrayRemove(tracked, k);
      continue;
    }

    // Alert once when within reminder window: 0 < (et - now) <= ReminderIntervalMinutes*60
    int secs_to_event = int(et - now_gmt);
    int window_secs   = ReminderIntervalMinutes * 60;

    if(!tracked[k].alerted && secs_to_event > 0 && secs_to_event <= window_secs)
    {
      // Format both UTC and local server time for clarity
      string whenUTC   = TimeToString(et, TIME_DATE|TIME_MINUTES) + " UTC";
      string whenLocal = TimeToString( (et - now_gmt) + TimeCurrent(), TIME_DATE|TIME_MINUTES) + " (Server)";

      string msg = StringFormat("USD RED NEWS in ≤ %d min: %s at %s [%s]",
                                ReminderIntervalMinutes,
                                tracked[k].name,
                                whenUTC, whenLocal);

      Alert(msg);
      Print(msg);
      tracked[k].alerted = true; // prevent repeats
    }
  }
}
