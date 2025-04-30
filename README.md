# 🛒 Sales Order App

A powerful **Flutter-based sales order application** supporting both **offline and online** functionality. Designed for field agents and sales teams, it ensures seamless order management, even in areas with limited connectivity. Built with the latest **Flutter** 3.29.3 and **Dart** SDKs 3.7.2.

---

## 🚀 Key Features

### 🌐 Connectivity & Offline Support
- Offline order creation and storage using **SQLite**
- Seamless API sync with **Dio** when online
- Detect network status changes with **connectivity_plus**
- Offline-safe authentication using **GetStorage**

### 📍 Location & Mapping
- Real-time location tracking via **geolocator**
- Address resolution using **geocoding**
- Integrated maps using **google_maps_flutter**

### 🧭 State & Configuration
- Reactive state management using **GetX**
- Persistent local storage with **get_storage**
- Environment variable management with **envied**
- Code updates with **shorebird_code_push**

### 🎨 Modern UI & UX
- Animated splash screen via **flutter_native_splash**
- Beautiful Lottie animations (**lottie**)
- Smooth skeleton loading with **shimmer**
- Slick onboarding/intro with **smooth_page_indicator**
- Dropdown filters/search using **dropdown_search**
- Modern icons via **iconsax**

### 🔐 Security & Tokens
- JWT handling with **dart_jsonwebtoken**
- Data hashing/encryption using **crypto**

### 📊 Reports & Insights
- Graphs and charts powered by **fl_chart**

### ✉️ Utility & Communication
- Send emails from the app using **mailer**
- Launch URLs (e.g., websites, emails) using **url_launcher**
- Clipboard utilities for easy copy-paste (**clipboard**)

---

## 📦 Tech Stack

| Tool                   | Purpose                                |
|------------------------|----------------------------------------|
| **Flutter**            | Cross-platform development             |
| **Dart**               | Programming language                   |
| **GetX**               | State management and routing           |
| **Dio**                | API client                             |
| **Sqflite**            | Local database                         |
| **Geolocator**         | Location tracking                      |
| **Lottie**             | Animated assets                        |
| **Shimmer**            | Loading effects                        |
| **Fl_Chart**           | Graphs & analytics                     |
| **GetStorage**         | Lightweight key-value storage          |
| **Envied**             | Environment config handling            |
| **Shorebird**          | Code push without Play Store updates   |

---

## 📂 Folder Structure (Suggested)

lib/
├── controllers/         # GetX Controllers
├── models/              # Data Models
├── services/            # API, DB, Auth, Location
├── views/               # Screens and UI Widgets
├── utils/               # Utilities & helpers
├── main.dart            # App Entry Point
