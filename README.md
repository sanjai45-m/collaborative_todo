# 📝 Real-time Collaborative Todo List

A real-time collaborative Todo list built with Flutter that lets multiple users manage tasks together with live updates via WebSocket.

## ✨ Features

- **Real-time Sync** - Changes appear instantly for all users via WebSocket
- **Task Management** - Create, edit, delete, and update task status
- **Status Tracking** - Pending, In Progress, Completed with color coding
- **User Info** - Each task shows who created and last updated it
- **Live Chart** - Pie chart showing task distribution by status
- **Export Reports** - Generate and share PDF reports
- **Device Recognition** - No login needed, uses unique device ID

## 📸 Screenshots

| Todo List | Drawer | Status Chart |
|-----------|--------|--------------|
| | | |

## 🏗️ Tech Stack

- **Frontend**: Flutter with Provider for state management
- **Backend**: Node.js, WebSocket, Neon DB (PostgreSQL)
- **Real-time**: WebSocket for instant updates

## 📦 Packages Used

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.1 | State management |
| `web_socket_channel` | ^2.4.0 | WebSocket connection |
| `fl_chart` | ^0.66.0 | Status chart |
| `device_info_plus` | ^9.1.0 | Device ID for user tracking |
| `pdf` | ^3.10.7 | PDF report generation |
| `share_plus` | ^7.2.1 | Sharing reports |
| `uuid` | ^4.3.3 | Generate task IDs |
| `intl` | ^0.18.1 | Date formatting |
| `path_provider` | ^2.1.1 | File system access |

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0 or higher)
- Node.js (18 or higher) for backend (optional)

### Frontend Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/collaborative-todo.git
cd collaborative-todo

# Install dependencies
flutter pub get

# Update WebSocket URL in lib/providers/todo_provider.dart
# For production (Render): 'wss://collaborative-todo-backend-c4p6.onrender.com'
# For Android emulator: 'ws://10.0.2.2:3000'
# For iOS simulator: 'ws://localhost:3000'
# For physical device: 'ws://192.168.1.x:3000' (use your computer's IP)

# Run the app
flutter run