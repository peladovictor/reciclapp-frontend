class ApiConfig {
  // true = usar backend en la NUBE (Railway)
  // false = usar backend LOCAL (tu Mac)
  static const bool useCloud = true; // ⚠️ pon true si quieres probar la nube

  // 👇 Local (emulador Android -> 10.0.2.2 apunta a tu Mac)
  static const String _localBaseUrl = 'http://10.0.2.2:3000';

  // 👇 Nube (Railway) SIEMPRE con https5
  static const String _cloudBaseUrl =
      'https://proyectobackendreciclapp-production.up.railway.app';

  // 👇 URL base que usará la app
  static String get baseUrl => useCloud ? _cloudBaseUrl : _localBaseUrl;

  // Helper para construir URLs
  static Uri uri(String path) {
    // path tipo '/auth/register'
    return Uri.parse('$baseUrl$path');
  }
}
