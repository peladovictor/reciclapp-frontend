import 'dart:io';

class ApiConfig {
  // FALSE → usar backend local (npm run start)
  // TRUE  → usar backend en Railway
  static const bool useCloud = true;

  // Local (cambia la IP si usas la de tu red)
  static const String _localBaseUrlAndroid = 'http://10.0.2.2:3000';
  static const String _localBaseUrliOS = 'http://127.0.0.1:3000';
  // si prefieres, puedes usar: 'http://TU_IP_DE_LA_RED:3000'

  // Nube
  static const String _cloudBaseUrl =
      'https://proyectobackendreciclapp-production.up.railway.app';

  static String get _localBaseUrl =>
      Platform.isAndroid ? _localBaseUrlAndroid : _localBaseUrliOS;

  // URL base final
  static String get baseUrl => useCloud ? _cloudBaseUrl : _localBaseUrl;

  static Uri uri(String path) => Uri.parse('$baseUrl$path');
}
