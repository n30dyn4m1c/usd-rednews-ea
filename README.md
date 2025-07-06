💵⏰ USD News & Holiday Reminder EA

An MQL5 Expert Advisor for MetaTrader 5 that scans today’s US economic calendar and sends reminders for USD high-impact (“red”) and holiday (“gray”) events every 30 minutes.

🧰 Tech Stack

Platform:     MetaTrader 5  
Language:     MQL5  
Alert System: Terminal pop-ups & log  
Calendar:     MT5 built-in economic calendar  

🚀 Key Features

✅ Hourly scan for today’s USD events  
✅ Filters high-impact (red) & none/holiday (gray)  
✅ Tracks new events; auto-removes past ones  
✅ Reminders every 30 min until each event  
✅ Configurable reminder interval  

📊 Reminder Logic

1. Once per hour call CalendarValueHistory for today  
2. Filter where currency=="USD" and importance==HIGH or NONE  
3. Add unseen events to tracked list  
4. On each tick remove past events; if ≥ReminderIntervalMinutes since lastAlert, send Alert and update lastAlert  

🗂 Included Files
File	Description
USDNewsReminder.mq5	EA source code

🛠️ Setup Instructions

1. Copy USDNewsReminder.mq5 → MQL5/Experts folder  
2. Open MetaEditor; compile the EA  
3. In MT5 Navigator, drag EA onto any chart  
4. Enable Algo Trading  

⏰ When to Run

Attach at any time; EA runs continuously (24/5).  
Hourly scans and per-tick reminders keep you informed.  

🎯 Future Improvements

– Push/email/mobile notifications  
– Filter by event type (e.g., “FOMC”)  
– Persist tracked list across restarts  
– User interface panel for status  

📝 License & Acknowledgments

© 2025 Neo Malesa · @n30dyn4m1c on X  
Built with MT5 CalendarValueHistory; inspired by ForexFactory red/gray folder concept  
