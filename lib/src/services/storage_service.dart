import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import '../services/platform_service.dart';

class StorageService {
  // Platform-adaptive Storage
  static Future<void> saveData(String key, String value) async {
    if (PlatformService.isWeb) {
      // Web: LocalStorage
      html.window.localStorage[key] = value;
    } else {
      // Mobile: SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  static Future<String?> getData(String key) async {
    if (PlatformService.isWeb) {
      return html.window.localStorage[key];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  static Future<void> removeData(String key) async {
    if (PlatformService.isWeb) {
      html.window.localStorage.remove(key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    }
  }

  // Download functionality für Web
  static Future<void> downloadFile({
    required List<int> bytes,
    required String fileName,
  }) async {
    if (PlatformService.isWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement()
        ..href = url
        ..download = fileName
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile: Use path_provider and save to downloads
      // Implementation für Mobile Download
    }
  }
}
