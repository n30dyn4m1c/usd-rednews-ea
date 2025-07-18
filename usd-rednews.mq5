//+------------------------------------------------------------------+
//|                                           USDRedNewsReminder.mq5 |
//|                                                       Neo Malesa |
//|                                     https://www.x.com/n30dyn4m1c |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Neo Malesa"
#property link      "https://www.x.com/n30dyn4m1c"
#property version   "1.06"
#property strict

input int ReminderIntervalMinutes = 30;
input int DaysAhead = 2; // Scan for USD news events today and tomorrow

struct TrackedEvent
{
   datetime time;
   string   name;
   int      importance;
   datetime lastAlert;
};

TrackedEvent tracked[];
datetime     lastScan=0;

int OnInit()
{
   ArrayResize(tracked, 0);
   Print("USD Red News Reminder EA Initialized.");
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   Print("USD Red News Reminder EA Deinitialized. Remaining tracked events:");
   for (int i = 0; i < ArraySize(tracked); i++)
   {
      Print("Remaining Event: ", tracked[i].name, " at ", TimeToString(tracked[i].time, TIME_DATE | TIME_MINUTES));
   }
   ArrayResize(tracked, 0);
}

void OnTick()
{
   datetime now = TimeTradeServer();

   if (now - lastScan >= 3600)
   {
      lastScan = now;
      datetime dayStart = StringToTime(TimeToString(now, TIME_DATE));
      datetime dayEnd = dayStart + 86400 * DaysAhead;

      MqlCalendarValue vals[];
      int total = CalendarValueHistory(vals, dayStart, dayEnd, NULL, "USD");

      for (int i = 0; i < total; i++)
      {
         datetime et = vals[i].time;
         if (et <= now) continue;

         MqlCalendarEvent ev;
         if (!CalendarEventById(vals[i].event_id, ev)) continue;

         int imp = ev.importance;
         if (imp != CALENDAR_IMPORTANCE_HIGH) continue; // strict red news only

         bool found = false;
         for (int j = 0; j < ArraySize(tracked); j++)
         {
            if (tracked[j].time == et && tracked[j].name == ev.name)
            {
               found = true;
               break;
            }
         }
         if (!found)
         {
            int newSize = ArraySize(tracked) + 1;
            ArrayResize(tracked, newSize);

            TrackedEvent t;
            t.time = et;
            t.name = ev.name;
            t.importance = imp;
            t.lastAlert = 0;

            tracked[newSize - 1] = t;
         }
      }
   }

   for (int k = ArraySize(tracked) - 1; k >= 0; k--)
   {
      datetime et = tracked[k].time;
      if (et <= now)
      {
         ArrayRemove(tracked, k);
         continue;
      }

      if (now - tracked[k].lastAlert >= ReminderIntervalMinutes * 60)
      {
         string dayStr = TimeToString(et, TIME_DATE | TIME_MINUTES);
         string msg = "🔴 USD Event: " + tracked[k].name + " on " + dayStr;
         Alert(msg);
         Print(msg);
         tracked[k].lastAlert = now;
      }
   }
}
