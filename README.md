
<div align="center">

<img src="https://github.com/user-attachments/assets/a3291f14-b2d2-4bea-bab5-d5738ca99865" alt="Journali — Your thoughts, your story" width="100%">

<br>

**SwiftUI · SwiftData · MVVM**

</div>

<br>

## Overview

Journali is a personal journaling app for iPhone, designed to make daily reflection simple and distraction-free.

Create and organize journal entries, revisit meaningful moments, and build a consistent writing habit. Entries are stored locally using SwiftData, with no account or internet connection required.

## Features

- **Write & Edit** — Create and update journal entries.
- **Search & Sort** — Search by title or content, and sort by date or bookmarks.
- **Bookmark** — Keep meaningful entries easy to find.
- **Swipe to Delete** — Remove entries with confirmation.
- **Unsaved Changes Protection** — Confirm before discarding edits.
- **Daily Reminder** — A local notification scheduled for 9 PM, subject to notification permissions.

## App Preview

<div align="center">

| Main Page | New Journal |
|:---:|:---:|
|  <img width="220"  alt="Screenshot 2026-11-18 at 8 58 02 AM" src="https://github.com/user-attachments/assets/fd33b92b-eb90-40af-8a8f-e8ed6523be60" /> | <img width="220"  alt="Screenshot 2026-11-18 at 8 55 42 AM" src="https://github.com/user-attachments/assets/b3edfa0e-1f64-4fda-b90d-e74480cf3073" /> |

</div>

## Architecture

Journali follows the **Model–View–ViewModel (MVVM)** pattern, with a separate Services layer.

| Layer | Responsibility |
|:---|:---|
| **Model** | Defines journal data using SwiftData. |
| **View** | Displays the interface and handles interactions. |
| **ViewModel** | Manages state, validation, and journal operations. |
| **Service** | Handles notification permissions and scheduling. |

Journal input is managed by `JournalEditorViewModel`. On save, `MainView` passes the entry to `JournalViewModel`, which handles persistence through SwiftData.

## Tech Stack

**Swift · SwiftUI · SwiftData · Combine · UserNotifications**

## Project Structure

```text
Journali/
├── App/
│   └── JournaliApp.swift
├── Models/
│   └── Journal.swift
├── Views/
│   ├── SplashView.swift
│   ├── MainView.swift
│   └── JournalEditorView.swift
├── ViewModels/
│   ├── JournalViewModel.swift
│   └── JournalEditorViewModel.swift
├── Services/
│   └── Notification.swift
├── AppIcon.icon
└── Assets.xcassets
```

## Getting Started

1. Clone or download the repository.
2. Open `Journali.xcodeproj` in Xcode.
3. Select a compatible iPhone simulator or device.
4. Press `⌘R` to build and run.

---

## Author

**Wajen Almatrfi**

An independently designed and developed iOS project focused on simplicity, thoughtful interactions, and maintainable architecture.

*2026 · Journali*
