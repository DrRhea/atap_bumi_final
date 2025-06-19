# Atap Bumi Camping Apps 🏕️

A comprehensive Flutter mobile application for camping equipment rental services, paired with a Laravel backend API.

## 📱 About The Project

Atap Bumi Camping Apps is a full-stack mobile application that allows users to rent camping equipment with ease. The app features a modern UI/UX design and includes both customer and admin functionalities.

### ✨ Key Features

#### Customer Features
- **Equipment Browsing** - Browse and search camping equipment with detailed information
- **User Authentication** - Secure login and registration system
- **Shopping Cart** - Add equipment to cart and manage rental items
- **Rental Management** - Create and track rental orders
- **Payment Integration** - Secure payment processing
- **Address Management** - Manage multiple delivery addresses
- **Live Chat** - Customer support chat system
- **Order History** - View past and current rentals
- **Reviews & Ratings** - Rate and review rented equipment

#### Admin Features
- **Admin Dashboard** - Comprehensive overview of business metrics
- **Rental Management** - Manage customer rental orders
- **Payment Processing** - Approve/reject payments
- **Chat Management** - Respond to customer inquiries
- **Equipment Management** - Add, edit, and manage equipment inventory
- **Reports & Analytics** - Detailed business reports and insights
- **User Management** - Manage customer accounts

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Provider** - State management
- **HTTP** - API communication
- **Shared Preferences** - Local data storage

### Backend (Laravel)
- **Laravel** - PHP web framework
- **MySQL** - Database management
- **Sanctum** - API authentication
- **Eloquent ORM** - Database relationships

## 📂 Project Structure

```
atap_bumi_apps/
├── flutter/                 # Flutter mobile app
│   ├── lib/
│   │   ├── core/            # Core functionality (services, constants)
│   │   ├── models/          # Data models
│   │   ├── providers/       # State management
│   │   ├── screens/         # UI screens
│   │   ├── widgets/         # Reusable widgets
│   │   └── routes/          # App routing
│   └── assets/              # Images and assets
├── backend/                 # Laravel API backend
│   ├── app/
│   │   ├── Http/           # Controllers and middleware
│   │   ├── Models/         # Eloquent models
│   │   └── ...
│   ├── database/           # Migrations and seeders
│   ├── routes/             # API routes
│   └── ...
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- PHP (8.1+)
- Composer
- MySQL
- Android Studio / VS Code

### Backend Setup (Laravel)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd atap_bumi_apps/backend
   ```

2. **Install dependencies**
   ```bash
   composer install
   ```

3. **Environment setup**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Database configuration**
   - Update `.env` file with your database credentials
   ```bash
   php artisan migrate
   php artisan db:seed
   ```

5. **Start the server**
   ```bash
   php artisan serve
   ```

### Frontend Setup (Flutter)

1. **Navigate to Flutter directory**
   ```bash
   cd ../flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Update API configuration**
   - Edit `lib/core/constants/api_constants.dart`
   - Set the correct backend URL

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

*Screenshots will be added here showcasing the app's main features*

## 🔧 Configuration

### Backend Configuration
- Database settings in `.env`
- CORS configuration in `config/cors.php`
- Authentication settings in `config/sanctum.php`

### Frontend Configuration
- API endpoints in `lib/core/constants/api_constants.dart`
- App theme in `lib/core/theme/`

## 🧪 Testing

### Backend Testing
```bash
cd backend
php artisan test
```

### Frontend Testing
```bash
cd flutter
flutter test
```

## 📊 API Documentation

The Laravel backend provides RESTful APIs for:
- Authentication (`/api/v1/auth/*`)
- Equipment management (`/api/v1/equipment/*`)
- Rental operations (`/api/v1/rentals/*`)
- Payment processing (`/api/v1/payments/*`)
- Admin operations (`/api/v1/admin/*`)

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Your Name** - *Initial work* - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Laravel community for the robust backend framework
- All contributors who helped with this project

## 📞 Support

For support, email support@atapbumi.com or join our Slack channel.

---

Made with ❤️ for camping enthusiasts
