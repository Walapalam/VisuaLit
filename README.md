# VisuaLit

## 📌 Overview

VisuaLit is an AI-powered reading companion that enhances the reading experience by generating contextual visualizations, providing text-to-speech (TTS) functionalities, and enabling natural language processing (NLP)-based interactions. The app is built using Flutter for the frontend and Python (FastAPI or ComfyUI) for the backend, ensuring a smooth and interactive user experience.

## 🔧 Features

### 🔹 **Flutter Frontend**

- 📱 **Splash Screen** – Engaging welcome screen
- 🔐 **Upload & Authenticate** – Secure login & book uploads
- 🏠 **Homepage** – Book library & navigation
- 📖 **Reading Page** – AI-enhanced reading experience
- 🔊 **Text-to-Speech** – Listen to books with AI voice
- ⚙ **Settings** – Customize reading preferences

### 🔹 **AI Services (Backend)**

- 🎨 **Image Generation** – AI-generated visualizations for book content
- 🔊 **TTS (Text-to-Speech)** – Convert text into natural-sounding speech
- 🧠 **NLP (Natural Language Processing)** – Smart interactions & recommendations
- 📚 **Dictionary Lookup** – Quick word meanings & translations

## 🏗 Tech Stack

### **Frontend (Flutter & Provider State Management)**

- **Framework:** Flutter
- **State Management:** Provider
- **UI Design:** Figma
- **Language:** Dart

### **Backend (Python & AI Services)**

- **Framework:** FastAPI / Flask / Django
- **AI Pipeline:** ComfyUI for image generation
- **TTS Model:** VITS / Whisper / Bark
- **NLP & Dictionary:** Custom LLM models or Hugging Face APIs
- **Database:** PostgreSQL / Firebase Firestore

## 🔀 Folder Structure

```
VisuaLit/
│── lib/                    # Flutter frontend
│   ├── models/             # Data models
│   ├── providers/          # State management (Provider)
│   ├── screens/            # App screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── reading_screen.dart
│   │   ├── tts_screen.dart
│   │   ├── settings_screen.dart
│   ├── services/           # API calls to backend
│   ├── widgets/            # Reusable UI components
│   ├── main.dart           # Entry point
│
│── backend/                # Python AI services
│   ├── app.py              # Main backend server
│   ├── services/           # AI services (Image Gen, NLP, TTS, etc.)
│   ├── models/             # AI & database models
│   ├── database.py         # Database connection
│
│── assets/                 # Fonts, images, etc.
│── pubspec.yaml            # Flutter dependencies
│── requirements.txt        # Backend dependencies
│── README.md               # Project documentation
```

## 🚀 Installation & Setup

### **1️⃣ Clone the Repository**

```bash
git clone https://github.com/Walapalam/VisuaLit.git
cd VisuaLit
```

### **2️⃣ Setup Frontend (Flutter)**

```bash
flutter pub get
flutter run
```

### **3️⃣ Setup Backend (Python)**

```bash
cd backend
pip install -r requirements.txt
uvicorn app:app --reload
```

## 📅 Project Workflow (Sprints)

🚀 The development is structured into **sprints**:
1️⃣ **Sprint 1:** UI Design (Figma) & Initial Setup
2️⃣ **Sprint 2:** Frontend Development (Flutter Screens & State Management)
3️⃣ **Sprint 3:** Backend AI Integration (TTS, Image Gen, NLP)
4️⃣ **Sprint 4:** Final Integration & Testing


## 📜 License

This project is licensed under the MIT License.

## 📞 Contact

For inquiries, reach out via [GitHub Issues](https://github.com/Walapalam/VisuaLit/issues) or email **[your-email@example.com](mailto\:your-email@example.com)**.

