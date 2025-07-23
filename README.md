<h1 align="center">📱 UniChat</h1>
<p align="center">
  A modern and anonymous group chat app tailored for university students.
</p>

<p align="center">
  <img src="assets/images/white.png" width="400"/>
```
  <img src="assets/images/black.png" width="400"/>
</p>

---

## 🚀 Features

- 🔐 Secure login & register system (light/dark mode)
- 💬 Real-time group messaging
- 🕵️ Anonymous messages (only visible to admin/doctor)
- 👨‍🏫 Group with roles: Doctor, Admins, Members
- 📁 Attachments per subject (added by doctor)
- 📊 Poll system inside the group
- 🌙 Light & Dark theme support
- 📱 Responsive and modern UI

---

## 🛠️ Tech Stack

| Technology | Description |
|------------|-------------|
| Flutter | UI Development |
| Firebase Auth | User Authentication |
| Cloud Firestore | Real-time Database |
| Firebase Storage | File Attachments |
| Provider | State Management |
| Cloudinary | Image Uploading |

---

## 📸 Screenshots

| Splash | Register | Login (Light) | Login (Dark) |
|:--:|:--:|:--:|:--:|
| ![](assets/screens/splash.png) | ![](assets/screens/register.png) | ![](assets/screens/loginLight.png) | ![](assets/screens/loginNight.png) |

| Message Select (Light) | Message Select (Dark) | Chat (Light) | Chat (Dark) | Admin Panel |
|:--:|:--:|:--:|:--:|:--:|
| ![](assets/screens/selecteLight.png) | ![](assets/screens/selecteNight.png) | ![](assets/screens/chatScreenLight.png) | ![](assets/screens/chatScreenNight.png) | ![](assets/screens/admin.png) |





---

## 🧠 Project Structure
> The full folder structure for the `lib/` directory can be found [here](./lib_tree.txt)
```bash
lib/
├── app/                  # App starter and widget wrapper
│   └── uni_chat.dart
├── build/                # Reusable Widgets (grouped by feature)
│   ├── account_widgets/
│   ├── admin_widgets/
│   ├── auth_widgets/
│   ├── chat_widgets/
│   ├── home_widgets/
│   ├── build_pages.dart
│   └── nav_bar_circle.dart
├── core/
│   ├── consts/           # Constants (colors, strings, etc.)
│   └── themes/           # App theme (light/dark)
├── models/               # Data models
│   ├── messageRegister.dart
│   ├── mode_model.dart
│   ├── selected_Index.dart
│   └── user_model.dart
├── screens/              # App Screens (UI pages)
│   ├── account/
│   ├── admins/
│   ├── auth/
│   ├── chat/
│   ├── home/
│   ├── settings/
│   └── splash/
├── services/             # Firebase and APIs
│   └── cloudinary_service.dart
├── providers/            # State management (Provider)
│   └── reply_provider.dart
└── main.dart


## ▶️ Getting Started

1. Clone the repo
```bash
git clone https://github.com/username/uni_chat.git
cd uni_chat

flutter pub get

flutter run


