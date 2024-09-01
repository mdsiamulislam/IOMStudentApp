# IOM2411

A Flutter project for managing class schedules and resources. This app helps students efficiently organize their class schedules and access essential resources such as Zoom links and Telegram groups.

## Overview

The app provides a clear and organized view of class routines, along with direct access to communication tools. It fetches data from various JSON APIs to display schedules, manage class groups, and access lecture notes and recordings.

## Getting Started

To start with this project, you can follow these resources:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/): Comprehensive guidance, tutorials, and API references.

## Data Sources

### Homepage JSON

The app uses the following JSON APIs to fetch class schedules and other relevant data:

- [Schedule Data (Link 1)](https://json.link/Th2iPxT1QO)
- [Schedule Data (Link 2)](https://json.link/oJAzmxf0Pv.json)

**Sample JSON Structure:**

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

For managing group-based classes and links:

- [Moshq Data (Link 1)](https://json.link/bSuB3vyOnv)
- [Moshq Data (Link 2)](https://json.link/0ApID97SUn.json)

**Sample JSON Structure:**

```json
[
  {
    "group": "01",
    "time": "Monday: 10:15 PM to 11:15 PM & Friday: 10:15 PM to 11:15 PM",
    "telegram": "https://t.me/+d_S1pVWa64dlYzk1",
    "classLink": "https://skyzh.github.io/zoom-url-generator/?jump=true&confno=97425007009&pwd=&uname=Nobody%20-%2051800000000"
  },
  ...
]
```

### Lecture Notes JSON

**Sample JSON Structure:**

```json
[
  {
    "subject": "Mathematics",
    "notes": [
      {
        "name": "Lecture 01: Introduction to Algebra",
        "url": "https://example.com/lecture01.pdf"
      },
      ...
    ]
  },
  ...
]
```

### Previous Class Records JSON

**Sample JSON Structure:**

```json
[
  {
    "subject": "Mathematics",
    "records": [
      {
        "title": "Class 01: Introduction to Algebra",
        "url": "https://example.com/class01.mp4"
      },
      ...
    ]
  },
  ...
]
```

### Previous Semester JSON

**Sample JSON Structure:**

```json
[
  {
    "course": "Mathematics",
    "classes": [
      "https://example.com/class01.mp4",
      ...
    ],
    "notes": [
      "https://example.com/note01.pdf",
      ...
    ]
  },
  ...
]
```

## How to Use

1. **Install Dependencies**: Run `flutter pub get` to install the necessary packages.
2. **Run the App**: Use `flutter run` to launch the app on your device or emulator.
3. **View Schedules**: The app fetches and displays class schedules and other information from the provided JSON APIs.
4. **Join Classes**: Directly join classes via Zoom links and stay updated through Telegram groups.

## Contributing

Contributions are welcome! 