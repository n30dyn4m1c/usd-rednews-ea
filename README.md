# 🛎️ USD Red News Reminder EA

An MQL5 Expert Advisor for MetaTrader 5 that scans **today and tomorrow’s** US economic calendar and sends reminders for **high-impact USD news events** (a.k.a. “red news”) every 30 minutes.

---

## 🧰 Tech Stack

- **Platform**: MetaTrader 5  
- **Language**: MQL5  
- **Calendar**: Built-in economic calendar  
- **Alerts**: Terminal pop-ups & log  

---

## 🚀 Key Features

- ✅ Hourly scan of USD events for **next 2 days**  
- ✅ Filters **only high-impact (red)** events  
- ✅ Tracks new events; auto-removes expired ones  
- ✅ Reminders every X minutes (`ReminderIntervalMinutes`)  
- ✅ Configurable `DaysAhead` and reminder interval  

---

## 📊 Reminder Logic

1. Every hour: call `CalendarValueHistory()` from `today` to `DaysAhead`  
2. Filter events where `currency == "USD"` and `importance == HIGH`  
3. Add unseen events to a `tracked` array  
4. On each tick:  
   - Remove past events  
   - If time since `lastAlert` ≥ `ReminderIntervalMinutes`, send `Alert()` & update `lastAlert`

---

## 🗂 Included File

| File                       | Description                                |
|----------------------------|--------------------------------------------|
| `USDRedNewsReminder.mq5`   | EA source code for USD red news alerts     |

---

## 🛠️ Setup Instructions

1. Copy `USDRedNewsReminder.mq5` → `MQL5/Experts` folder  
2. Open MetaEditor and compile  
3. In MT5 Navigator, drag EA onto any chart (including BTC or weekend charts)  
4. Enable **Algo Trading**  

---

## ⏰ When to Run

Attach to any chart, any time. EA runs continuously, scanning every hour and alerting as needed.

---

## 🎯 Future Improvements

- Push/email/mobile alerts  
- Configurable event keywords or filters  
- Log alerts to a CSV file  
- On-chart status dashboard  

---

## 📝 License & Acknowledgments

- © 2025 **Neo Malesa** · [@n30dyn4m1c on X](https://www.x.com/n30dyn4m1c)  
- Built with 💗 for automated economic event awareness in trading  
