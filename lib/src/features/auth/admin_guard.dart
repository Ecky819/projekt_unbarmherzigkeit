import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

enum AdminLevel { moderator, admin, super_ }

class AdminGuard extends StatelessWidget {
  final Widget child;
  final String? redirectMessage;
  final AdminLevel minRequiredLevel;
  final List<String>? requiredActions;

  const AdminGuard({
    super.key,
    required this.child,
    this.redirectMessage,
    this.minRequiredLevel = AdminLevel.moderator,
    this.requiredActions,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color.fromRGBO(233, 229, 221, 1.0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Admin-Berechtigung wird überprüft...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SF Pro',
                      color: Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Error State
        if (snapshot.hasError) {
          return _AdminErrorScreen(
            error: snapshot.error.toString(),
            onRetry: () {
              // Clear cache and trigger rebuild
              authService.clearClaimsCache();
            },
          );
        }

        // User ist nicht angemeldet
        if (snapshot.data == null) {
          return _AdminLoginRequiredScreen();
        }

        // Async Admin-Check mit FutureBuilder
        return FutureBuilder<bool>(
          future: _checkAdminAccess(authService),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color.fromRGBO(233, 229, 221, 1.0),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF283A49)),
                      SizedBox(height: 16),
                      Text(
                        'Berechtigungen werden geprüft...',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SF Pro',
                          color: Color(0xFF283A49),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (adminSnapshot.hasError) {
              return _AdminErrorScreen(
                error: adminSnapshot.error.toString(),
                onRetry: () {
                  authService.clearClaimsCache();
                },
              );
            }

            final hasAccess = adminSnapshot.data ?? false;

            if (hasAccess) {
              return child;
            } else {
              return FutureBuilder<Map<String, dynamic>>(
                future: authService.getAdminStatus(),
                builder: (context, statusSnapshot) {
                  return _AdminDeniedScreen(
                    user: snapshot.data!,
                    message:
                        redirectMessage ??
                        'Sie haben keine ausreichende Admin-Berechtigung für diese Funktion.',
                    adminStatus: statusSnapshot.data,
                    requiredLevel: minRequiredLevel,
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<bool> _checkAdminAccess(AuthService authService) async {
    try {
      // Basis Admin-Check
      if (!(await authService.isAdmin)) {
        return false;
      }

      // Level-basierte Berechtigung prüfen
      final claims = await authService.getCustomClaims();
      final userAdminLevel = claims['adminLevel']?.toString();

      switch (minRequiredLevel) {
        case AdminLevel.super_:
          if (userAdminLevel != 'super') return false;
          break;
        case AdminLevel.admin:
          if (!['admin', 'super'].contains(userAdminLevel)) return false;
          break;
        case AdminLevel.moderator:
          if (!['moderator', 'admin', 'super'].contains(userAdminLevel))
            return false;
          break;
      }

      // Aktions-basierte Berechtigung prüfen (falls spezifiziert)
      if (requiredActions != null) {
        for (final action in requiredActions!) {
          if (!(await authService.canPerformAdminAction(action))) {
            return false;
          }
        }
      }

      return true;
    } catch (e) {
      print('Fehler beim Admin-Access-Check: $e');
      return false;
    }
  }
}

class _AdminErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _AdminErrorScreen({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red[400], size: 64),
              const SizedBox(height: 24),
              const Text(
                'Fehler beim Laden der Admin-Berechtigung',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283A49),
                  fontFamily: 'SF Pro',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[700],
                  fontFamily: 'SF Pro',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Erneut versuchen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283A49),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Zurück'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminLoginRequiredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login, color: const Color(0xFF283A49), size: 64),
              const SizedBox(height: 24),
              const Text(
                'Anmeldung erforderlich',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283A49),
                  fontFamily: 'SF Pro',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Sie müssen sich anmelden, um auf das Admin-Panel zuzugreifen.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF283A49),
                  fontFamily: 'SF Pro',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigation zur Login-Seite
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Anmelden'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283A49),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Zurück'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminDeniedScreen extends StatelessWidget {
  final User user;
  final String message;
  final Map<String, dynamic>? adminStatus;
  final AdminLevel requiredLevel;

  const _AdminDeniedScreen({
    required this.user,
    required this.message,
    this.adminStatus,
    required this.requiredLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, color: Colors.red[400], size: 64),
              const SizedBox(height: 24),
              const Text(
                'Zugriff verweigert',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283A49),
                  fontFamily: 'SF Pro',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF283A49),
                  fontFamily: 'SF Pro',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (adminStatus != null) _buildAccessInfoCard(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Kontakt zu Administrator aufnehmen
                      _showContactAdminDialog(context);
                    },
                    icon: const Icon(Icons.contact_support),
                    label: const Text('Admin kontaktieren'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283A49),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Zurück'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessInfoCard() {
    final isAdmin = adminStatus?['isAdmin'] == true;
    final currentLevel = adminStatus?['adminLevel']?.toString() ?? 'user';
    final requiredLevelString = requiredLevel
        .toString()
        .split('.')
        .last
        .replaceAll('_', '');

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ihre aktuellen Berechtigungen:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF283A49),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('E-Mail', user.email ?? 'Unbekannt'),
            _buildInfoRow('Status', isAdmin ? 'Admin' : 'Normaler Benutzer'),
            if (isAdmin) _buildInfoRow('Admin-Level', currentLevel),
            _buildInfoRow('Benötigtes Level', requiredLevelString),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.red[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isAdmin
                          ? 'Ihr Admin-Level "$currentLevel" ist nicht ausreichend für diese Funktion.'
                          : 'Sie benötigen Admin-Rechte für diese Funktion.',
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF283A49), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Administrator kontaktieren'),
        content: const Text(
          'Wenn Sie der Meinung sind, dass Sie Admin-Rechte benötigen, '
          'wenden Sie sich bitte an den Systemadministrator. '
          'Geben Sie dabei Ihre E-Mail-Adresse und den gewünschten Zugriff an.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}
