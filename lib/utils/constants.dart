class AppConstants {
  // Storage Keys
  static const String serverUrlKey = 'server_url';
  static const String lastUsedPathKey = 'last_used_path';
  
  // API Endpoints
  static const String healthEndpoint = '/health';
  static const String foldersEndpoint = '/folders';
  static const String filesEndpoint = '/files';
  static const String imageEndpoint = '/image';
  static const String thumbnailEndpoint = '/thumbnail';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Grid Constants
  static const int gridCrossAxisCount = 2;
  static const double gridMainAxisSpacing = 16.0;
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridChildAspectRatio = 0.8;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Network Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error';
  static const String serverErrorMessage = 'Server error occurred';
  static const String invalidUrlMessage = 'Please enter a valid server URL';
  static const String connectionFailedMessage = 'Failed to connect to server';
}