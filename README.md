# ChatApp

A real-time chat application built using Flutter and Firebase, designed to demonstrate scalable mobile architecture, authentication handling, and cloud-based data synchronization.

✨ Features

🔐 User Authentication (Email & Password)
💬 Real-time messaging using Cloud Firestore
👤 User profile management
🔔 Instant message updates
📱 Responsive UI built with Flutter
☁️ Firebase backend integration


🛠 Tech Stack

Flutter – UI Development
Dart – Programming Language
Firebase Authentication – User management
Cloud Firestore – Real-time database
Firebase Storage – Media handling (if used)

🏗 Architecture Overview
The application follows a real-time event-driven architecture using Firebase services:
Authentication layer handles secure user login & registration
Firestore manages message storage and real-time synchronization
StreamBuilder listens to database updates for instant UI refresh
Proper separation of UI and business logic ensures maintainability
