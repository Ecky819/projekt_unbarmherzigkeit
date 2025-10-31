import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../services/platform_service.dart';
import '../../services/admin_management_service.dart';
import '../../data/database_repository.dart';
import '../../data/firebase_repository.dart';

/// Globaler Service Locator
final getIt = GetIt.instance;

/// Initialisiert alle Dependencies
Future<void> setupServiceLocator() async {
  // ========== Firebase Instanzen ==========
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instance,
  );

  // ========== Core Services ==========

  // LanguageService - Singleton mit Initialisierung
  final languageService = LanguageService();
  await languageService.initialize();
  getIt.registerSingleton<LanguageService>(languageService);

  // PlatformService - Singleton
  getIt.registerLazySingleton<PlatformService>(() => PlatformService());

  // AuthService - Singleton mit Firebase Auth Dependency
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(firebaseAuth: getIt<FirebaseAuth>()),
  );

  // AdminManagementService - Singleton
  getIt.registerLazySingleton<AdminManagementService>(
    () => AdminManagementService(
      firebaseAuth: getIt<FirebaseAuth>(),
      firebaseFunctions: getIt<FirebaseFunctions>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // ========== Repositories ==========

  // DatabaseRepository - Factory (neue Instanz bei jedem Aufruf)
  getIt.registerFactory<DatabaseRepository>(
    () => FirebaseRepository(firestore: getIt<FirebaseFirestore>()),
  );

  // Oder als Singleton, wenn nur eine Instanz benötigt wird:
  // getIt.registerLazySingleton<DatabaseRepository>(
  //   () => FirebaseRepository(
  //     firestore: getIt<FirebaseFirestore>(),
  //   ),
  // );

  debugPrint('✅ Service Locator erfolgreich initialisiert');
}

/// Cleanup für Tests
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
