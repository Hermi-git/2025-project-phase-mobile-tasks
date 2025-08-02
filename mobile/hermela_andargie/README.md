# 🛍️ hermela_andargie

A simple Flutter eCommerce mobile app built for Task 7 of the 2025 Mobile Project Phase.

## ✨ Features

- 🏠 **Home Screen**: Displays a list of available products with images, categories, prices, and ratings.
- 🔍 **Detail Page**: View detailed information for each product, with support for:
  - Update product
  - Delete product
- ➕ **Add Product**: Add a new product using a form (with validation and image path input).
- ✏️ **Edit Product**: Update existing product details using the same form as add screen.
- 🧭 **Named Routes**: Navigation between pages uses named routes and smooth **fade transitions**.
- 🧠 **State Management**: Uses basic `StatefulWidget` with `setState` for local product updates.
- 📁 **Custom Routes**: All animated route transitions handled via a custom utility.

## 🚀 Getting Started

### Prerequisites

- Flutter 3.19+ installed on your machine.
- Emulator or real device to run the app.

### Run Locally

```bash
git clone https://github.com/Hermi-git/2025-project-phase-mobile-tasks.git
cd mobile/hermela_andargie
flutter pub get
flutter run
📦 Assets Note
Make sure the following images are placed inside your assets/images/ folder:

derby_shoes.jpg

elegant_heels.jpg

sport_running.jpg

Update pubspec.yaml accordingly if you change image paths.

🗂 Folder Structure
lib/
├── models/            # Product model
├── screens/           # Home, Detail, Add/Update screens
├── utils/             # Custom navigation routes
└── main.dart          # Entry point with named route logic