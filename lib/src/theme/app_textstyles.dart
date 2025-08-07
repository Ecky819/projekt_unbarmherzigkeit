import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontWeight: FontWeight.w900,
    fontFamily: 'SF Pro',
    fontSize: 16,
  );

  static const TextStyle heading2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: 'SF Pro',
    fontSize: 14,
    decoration: TextDecoration.underline,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w800,
    color: Color.fromRGBO(84, 95, 113, 1.0),
  );

  static const TextStyle body = TextStyle(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(84, 95, 113, 1.0),
    fontFamily: 'SF Pro',
  );

  static const TextStyle card = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(84, 95, 113, 1.0),
    fontFamily: 'SF Pro',
  );

  static const TextStyle drawerUserName = TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle link = TextStyle(
    fontFamily: 'SF Pro',
    fontSize: 13,
    color: Color.fromRGBO(0, 122, 255, 1.0),
    decoration: TextDecoration.underline,
  );

  static const TextStyle drawerUserEmail = TextStyle(
    fontFamily: 'SF Pro',
    fontSize: 14,
    color: Colors.white,
  );
}
