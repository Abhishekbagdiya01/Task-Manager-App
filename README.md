# Task Manager App

A **simple offline-first Task Manager App** built with **Flutter** for the frontend and **Node.js** with **Express** and **PostgreSQL** for the backend. The app supports **offline data management** with automatic **online synchronization** when the connection is restored. Containerized using **Docker** for easy deployment.

## Tech Stack

### Frontend

- **Flutter**
- State Management: Bloc and Cubit
- HTTP Requests: HTTP package

### Backend

- **Typescript**
- **Node**
- **Express**
- **PostgreSQL**
- **Docker**

### Additional Tools

- Offline Storage: (e.g., sqflite for Flutter)
- Sync Mechanism: Custom implementation or libraries

---

## Features 🚀

- **Offline-First Functionality**: Tasks can be created, updated, and deleted even when offline.
- **Data Synchronization**: Automatically syncs offline data with the server when back online.
- **Task Management**: Add, edit, delete, and mark tasks as completed.
- **Dockerized Backend**: Easily deploy the backend using Docker.

---

## Screenshots 📸

_(SOON WILL BE UPDATE)_

---

## Getting Started ⚙️

### Prerequisites

Ensure you have the following installed:

- Flutter SDK
- Node.js and npm
- Docker and Docker Compose

---

### Backend Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/Abhishekbagdiya01/Task-Manager-App.git
   cd backend
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Run the backend server:

   ```bash
   docker-compose up --build
   ```

4. Backend will be available at:

   ```
   http://localhost:8000
   ```

---

### Frontend Setup

1. Clone the repository:

   ```bash
   cd frontend
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

4. The app will be available on your connected device/emulator.

---

## Folder Structure 📂

### Backend

```
backend/
  src ├── controllers/
      ├── routes/
      ├── models/
      └── index.ts
├── Dockerfile
├── docker-compose.yaml
```

### Frontend

```
frontend/
├── lib/
│   ├── models/
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   └── main.dart
├── pubspec.yaml
└── assets/
```

---

## How It Works 💡

1. **Offline Data Storage**: The app stores tasks locally using sqflite (or relevant package).
2. **Data Sync**: Background service syncs the local database with the server when online.
3. **REST API**: Backend provides task management APIs to store data in PostgreSQL.

---

## License 📜

This project is licensed under the MIT License.
