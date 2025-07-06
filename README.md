# 🛎️ USD News & Holiday Reminder EA

An MQL5 Expert Advisor for MetaTrader 5 that scans today’s US economic calendar and sends reminders for USD high-impact (“red”) and holiday (“gray”) events every 30 minutes.

---

## 🧰 Tech Stack

- **Platform**: MetaTrader 5  
- **Language**: MQL5  
- **Calendar**: Built-in economic calendar  
- **Alerts**: Terminal pop-ups & log  

---

## 🚀 Key Features

- ✅ Hourly scan of today’s USD events  
- ✅ Filters high-impact (red) & holiday (gray) events  
- ✅ Tracks new events; auto-removes past ones  
- ✅ Reminders every 30 minutes until each event  
- ✅ Configurable `ReminderIntervalMinutes`  

---

## 📊 Reminder Logic

1. Once per hour call `CalendarValueHistory` for today  
2. Filter where `currency=="USD"` and `importance==HIGH` or `NONE`  
3. Add unseen events to a `tracked` array  
4. On each tick remove past events; if ≥ `ReminderIntervalMinutes` since last alert, send Alert & update timestamp  

---

## 🗂 Included File

| File                       | Description                         |
|----------------------------|-------------------------------------|
| `USDNewsReminder.mq5`      | EA source code for USD calendar alerts |

---

## 🛠️ Setup Instructions

1. Copy `USDNewsReminder.mq5` → `MQL5/Experts` folder  
2. Open MetaEditor and compile  
3. In MT5 Navigator drag EA onto any chart  
4. Enable **Algo Trading**  

---

## ⏰ When to Run

Attach at any time; EA runs continuously (24/5), scanning hourly and alerting per tick.

---

## 🎯 Future Improvements

- Push/email/mobile notifications  
- Persist tracked list across MT5 restarts  
- Filter by event keywords or sources  
- On-chart status panel  

---

## 📝 License & Acknowledgments

- © 2025 **Neo Malesa** · [@n30dyn4m1c on X](https://www.x.com/n30dyn4m1c)  
- Built with 💗 for automated desktop trading  
  
