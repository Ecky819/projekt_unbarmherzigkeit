import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color.fromRGBO(40, 58, 73, 1.0),
      scaffoldBackgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      fontFamily: 'SF Pro',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(40, 58, 73, 1.0),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(40, 58, 73, 1.0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromRGBO(84, 95, 113, 1.0),
        selectedLabelStyle: TextStyle(fontFamily: 'SF Pro'),
        unselectedLabelStyle: TextStyle(fontFamily: 'SF Pro'),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 14,
          color: Color.fromRGBO(84, 95, 113, 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontFamily: 'SF Pro'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
