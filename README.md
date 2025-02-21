# Kestrl - Stock Screener App 📈

A powerful mobile application for screening and tracking stocks, built with Flutter.

## 🚀 Quick Start

### Prerequisites

- Flutter version 3.24.3
- Active API key for stock data

### Installation Steps

1. Clone the repository:

```bash
git clone https://github.com/your-username/kestrl.git
cd kestrl
```

2. Configure API Key:

   - Navigate to `lib/constants/constant.dart`
   - Add your API key:

   ```dart
   const String apiKey = 'YOUR_API_KEY';
   ```

3. Install dependencies:
   - Using FVM (recommended):
   ```bash
   fvm install 3.24.3
   fvm flutter pub get
   fvm flutter run
   ```
   - Without FVM:
   ```bash
   flutter pub get
   flutter run
   ```

## 🛠 Technology Stack

- **State Management**: Provider
- **Local Storage**: Hive
  - Supports offline mode
  - Efficient data persistence
- **Network Client**: Dio
  - Robust HTTP networking
  - Built-in interceptors

## 📁 Project Structure

```
lib/
├── constant/      # Global constants and configurations
├── extension/     # Extension methods
├── model/        # Data models and API response structures
├── pages/        # Screen implementations
├── provider/     # State management logic
├── repositories/ # API and data layer services
├── routes/       # Navigation configuration
└── widgets/      # Reusable UI components
```

## 💫 Features

### Stock Listing

- Comprehensive list of available stocks
- Real-time price updates
- Quick search functionality
  ![Stock Listing](https://github.com/user-attachments/assets/5d8e42ab-c217-49c5-b724-213f2c8d4837)

### Advanced Search

- Dynamic search capabilities
- Filter by multiple parameters
- Instant results
  ![Search Interface](https://github.com/user-attachments/assets/3a4f79f2-f5e8-4f4c-b95d-a6ec73b61ab2)
  ![Search Results](https://github.com/user-attachments/assets/b78f884f-2bb4-4bc8-88ec-29ee70d108f4)

### Watchlist Management

- Add/remove stocks to watchlist
- Personalized tracking
- Quick access to favorites
  ![Add to Watchlist](https://github.com/user-attachments/assets/e41dd5f1-c334-42b4-a597-fac6410224ef)
  ![Watchlist View](https://github.com/user-attachments/assets/c6f41639-9b78-4dea-92a3-57750c7d89bc)
  ![Remove from Watchlist](https://github.com/user-attachments/assets/8ea35e14-3add-4297-b836-acfaf11261c4)

### Detailed Stock Analysis

- Comprehensive stock information
- Historical data visualization
- Key metrics and indicators
  ![Stock Details 1](https://github.com/user-attachments/assets/fb7d9390-82cf-494f-8989-85900486994b)
  ![Stock Details 2](https://github.com/user-attachments/assets/9ef18ac8-bb43-403c-a2f8-11c4b8e021bd)

## 📱 Screenshots Showcase

For more screenshots and UI examples, check the [Screenshots](/screenshots) directory.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to all contributors who have helped shape Kestrl
- Special thanks to the Flutter community for their valuable packages
