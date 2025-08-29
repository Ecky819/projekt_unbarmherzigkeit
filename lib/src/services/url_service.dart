import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import '../services/platform_service.dart';

class UrlService {
  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (PlatformService.isWeb) {
      // Web: Neue Tab öffnen
      html.window.open(url, '_blank');
    } else {
      // Mobile: URL Launcher
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static Future<void> openEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await openUrl(uri.toString());
  }

  static Future<void> openPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await openUrl(uri.toString());
  }

  // Deep Linking für Web
  static void updateWebUrl(String path) {
    if (PlatformService.isWeb) {
      html.window.history.pushState(null, '', path);
    }
  }
}
