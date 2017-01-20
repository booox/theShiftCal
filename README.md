# README
This a  calendar exporter prototype transferring the shifts of groups of workers into individual ics events with time zone support.

The employer enter the string of workers' name (here: slack ids) into the weekly table of working shifts.

Then every workersjust need to enter their own ids, and get an overview of their shifts everyweek and download the events into their calendars with time zone support.


prototype APP: http://shfitcal.heroku.com, used for shift assignments of teaching assisanants at fullstack course.


## simulation http push of Jinshuju

1. Start your rails server
2. key in your command line like this :

```
curl -X POST http://localhost:3000/api/v1/events -H "Content-Type:application/json" --data '{
  "form": "0IISoJ",
  "form_name": "全栈营线上助教排班系统",
  "entry": {
    "serial_number": 123,
    "field_9": "尼克",
    "field_25": "bboyceo_is_nic",
    "field_18": [
      "周四 18:00-20:00",
      "周五（除夕） 22:00-24:00",
      "周一 22:00-24:00",
      "周六 20:00-22:00",
      "周六 16:00-18:00",
      "周一 20:00-22:00",
      "周三 14:00-16:00"
    ],
    "creator_name": "小王",
    "created_at": "2017-01-19 14:05:09 UTC",
    "updated_at": "2017-01-19 14:05:09 UTC",
    "info_remote_ip": "127.0.0.1"
  }
}'
```
