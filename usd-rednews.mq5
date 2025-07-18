//+------------------------------------------------------------------+
//|                                              USDNewsReminder.mq5 |
//|                                                       Neo Malesa |
//|                                     https://www.x.com/n30dyn4m1c |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Neo Malesa"
#property link      "https://www.x.com/n30dyn4m1c"
#property version   "1.02"
#property strict

input int ReminderIntervalMinutes = 30;

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
   Print("USD News Reminder EA Deinitialized. Remaining tracked events:");
   for (int i = 0; i < ArraySize(tracked); i++)
   {
      Print("Remaining Event: ", tracked[i].name, " at ", TimeToString(tracked[i].time, TIME_MINUTES));
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
      datetime dayEnd = dayStart + 86400;

      MqlCalendarValue vals[];
      int total = CalendarValueHistory(vals, dayStart, dayEnd, NULL, "USD");

      for (int i = 0; i < total; i++)
      {
         datetime et = vals[i].time;
         if (et <= now) continue;

         MqlCalendarEvent ev;
         if (!CalendarEventById(vals[i].event_id, ev)) continue;

         int imp = ev.importance;
         if (imp == CALENDAR_IMPORTANCE_HIGH)
         {
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
               TrackedEvent t = {et, ev.name, imp, 0};
               ArrayInsert(tracked, t, ArraySize(tracked));
            }
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
         string msg = "🔴 USD Event: " + tracked[k].name + " at " + TimeToString(et, TIME_MINUTES);
         Alert(msg);
         Print(msg);
         tracked[k].lastAlert = now;
      }
   }
}
