import 'package:flutter/foundation.dart';

class WebConfig {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // Firebase Web Konfiguration
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const String firebaseAuthDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
  );

  // Google Maps Web API Key
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );

  // URL Konfiguration
  static const String baseUrl = isProduction
      ? 'https://unbarmherzigkeit.de'
      : 'http://localhost:5000';

  // App Metadaten
  static const String appName = 'Projekt Unbarmherzigkeit';
  static const String appDescription = 'Dokumentation und Gedenken der NS-Zeit';

  // Debugging
  static bool get enableDebugPrint => kDebugMode && !kIsWeb;
  static bool get enableFirebaseDebug => kDebugMode;
}
