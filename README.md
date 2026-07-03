# Digital Ebook Library 📚

A Full Stack Digital Ebook Library application built with **Ruby on Rails (API)** for the backend and **Flutter** for the frontend.

## Project Structure

This repository contains both the frontend and backend in a monorepo structure.

```text
ebook/
├── backend/                  # Ruby on Rails API (Backend)
│   ├── app/                  # Controllers, Models, and Views
│   │   ├── controllers/api/v1/ebooks_controller.rb  # API endpoints
│   │   └── models/ebook.rb                          # Ebook Model with ActiveStorage
│   ├── config/               # Rails configurations (routes, database)
│   ├── db/migrate/           # Database migrations (SQLite)
│   ├── spec/                 # RSpec Tests for Models & Controllers
│   └── Gemfile               # Ruby dependencies
│
└── lib/                      # Flutter Application (Frontend)
    ├── core/                 # Shared configurations (Network DioClient)
    ├── data/                 # Data layer (Models, Repositories Impl)
    ├── domain/               # Domain layer (Entities, Repository Interfaces)
    ├── presentation/         # UI layer (GetX Controllers, Screens)
    └── main.dart             # Flutter app entry point
```

## Features

**Backend (Ruby on Rails):**
- RESTful JSON API
- SQLite Database
- Active Storage for PDF uploads
- CRUD operations for Ebooks
- Search by title, author, and filename
- RSpec Unit & Controller tests

**Frontend (Flutter):**
- Clean Architecture (Domain, Data, Presentation layers)
- GetX State Management
- Network calls with Dio & Error Interceptors
- PDF Viewer (`flutter_pdfview`)
- File Picker for uploading PDFs (`file_picker`)
- Search with Debounce implementation

---

## How to Run Locally

### 1. Backend Setup (Ruby on Rails)
*Prerequisites: Ruby (3.x) and Bundler must be installed.*

1. Open a terminal and navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install the ruby gems (if you haven't generated the full rails skeleton yet, run `rails new . --api --database=sqlite3 -T --force` first):
   ```bash
   bundle install
   ```
3. Run the database migrations:
   ```bash
   rails db:migrate
   ```
4. Start the Rails server (runs on `http://localhost:3000` by default):
   ```bash
   rails server
   ```

### 2. Frontend Setup (Flutter)
*Prerequisites: Flutter SDK installed.*

1. Open a new terminal and navigate to the project root:
   ```bash
   cd ebook
   ```
2. Fetch flutter packages:
   ```bash
   flutter pub get
   ```
3. Run the Flutter application on your emulator or connected device:
   ```bash
   flutter run
   ```

---

