# iom2411

A Flutter project for managing class schedules and resources.

## Overview

This project is designed to help students easily manage their class schedules and access resources like Zoom links and Telegram groups. The app provides a clear and organized view of your class routines, with direct access to the necessary communication tools.

## Getting Started

This project is the starting point for a Flutter application focused on education management. Below are some resources to help you if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For more comprehensive guidance, refer to the [Flutter documentation](https://docs.flutter.dev/), which offers tutorials, samples, and a complete API reference.

## Data Sources

### Homepage JSON

The app uses a JSON API to fetch class schedules and other relevant data. Here are the JSON links used in the project:

- [Schedule Data (Link 1)](https://json.link/Th2iPxT1QO)
- [Schedule Data (Link 2)](https://json.link/oJAzmxf0Pv.json)

The structure of the JSON data is as follows:

```json
{
  "schedule": {
    "1": ["FQH-102: 09:00PM to 10:00AM"], // Monday
    "2": ["TAJ-102: 09:00PM to 10:00AM", "DWH-102: 10:00PM to 11:00AM"], // Tuesday
    "3": ["DWH-102: 10:00PM to 11:00AM"], // Wednesday
    "4": ["FQH-102: 09:00PM to 10:00AM", "ARB-102: 10:00PM to 11:00AM"], // Thursday
    "5": [], // Friday - No classes today
    "6": [], // Saturday - No classes today
    "7": ["TAJ-102: 09:00PM to 10:00AM", "ARB-102: 10:00PM to 11:00AM"] // Sunday
  },
  "classLink": "https://iom-edu-bd.zoom.us/my/iom102?omn=96113733230" // Default Zoom link for classes
}
```

### Moshq JSON

For managing group-based classes and links, the following JSON APIs are used:

- [Moshq Data (Link 1)](https://json.link/bSuB3vyOnv)
- [Moshq Data (Link 2)](https://json.link/0ApID97SUn.json)

The JSON structure looks like this:

```json
[
  {
    "group": "01",
    "time": "Monday: 10:15 PM to 11:15 PM & Friday: 10:15 PM to 11:15 PM",
    "telegram": "https://t.me/+d_S1pVWa64dlYzk1",
    "classLink": "https://skyzh.github.io/zoom-url-generator/?jump=true&confno=97425007009&pwd=&uname=Nobody%20-%2051800000000"
  },
  {
    "group": "02",
    "time": "Saturday: 5:15 AM to 8:00 AM & Tuesday: 5:15 AM to 8:00 AM",
    "telegram": "https://t.me/+QqkthWa7co9lMDM1",
    "classLink": "https://skyzh.github.io/zoom-url-generator/?jump=true&confno=96935666518&pwd=&uname="
  },
  {
    "group": "03",
    "time": "Saturday: 7:30 PM to 8:30 PM & Tuesday: 7:30 PM to 8:30 PM",
    "telegram": "https://t.me/+E_NmCQYJ4cphMDk1",
    "classLink": "https://skyzh.github.io/zoom-url-generator/?jump=true&confno=96935666518&pwd=&uname="
  },
  {
    "group": "04",
    "time": "Monday: 7:30 PM to 8:30 PM & Wednesday: 5:15 AM to 8:00 AM",
    "telegram": "https://t.me/+ZWZIP0e8zlg2Mzc1",
    "classLink": "https://skyzh.github.io/zoom-url-generator/?jump=true&confno=96935666518&pwd=&uname="
  },
  {
    "group": "04",
    "time": "Saturday: 9:15 PM to 10:15 PM & Thursday: 5:15 AM to 8:00 AM",
    "telegram": "https://t.me/+GY2mqtFKA1ZiZjk9",
    "classLink": "https://skyzh.github.io/zoom-url-generator/?jump=true&confno=93199683723&pwd=&uname="
  }
]
```

## How to Use

1. **Install Dependencies**: Run `flutter pub get` to install the necessary packages.
2. **Run the App**: Use `flutter run` to launch the app on your device or emulator.
3. **View Schedules**: The app fetches and displays class schedules and other information from the provided JSON APIs.
4. **Join Classes**: Directly join classes via Zoom links and stay updated through Telegram groups.
