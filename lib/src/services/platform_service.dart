import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformService {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (isAndroid || isIOS);
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isDesktop => !kIsWeb && (isWindows || isMacOS || isLinux);
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;

  // Responsive Breakpoints
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  // Platform-specific Features
  static bool get canUseGoogleMaps => isMobile;
  static bool get canUseNativeStorage => isMobile;
  static bool get canUseBiometrics => isMobile;
  static bool get canUseCamera => isMobile || (isWeb && hasWebCamera());

  static bool hasWebCamera() {
    // Check for web camera availability
    return kIsWeb; // Simplified - würde MediaDevices API prüfen
  }
}
