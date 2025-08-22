import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    // Reload user data to get most current verification status
    _reloadUserData();
  }

  /// Lädt die aktuellen Benutzerdaten neu
  Future<void> _reloadUserData() async {
    try {
      await _currentUser?.reload();
      final refreshedUser = _authService.currentUser;
      if (mounted && refreshedUser != null) {
        setState(() {
          _currentUser = refreshedUser;
        });
      }
    } catch (e) {
      print('Fehler beim Neuladen der Benutzerdaten: $e');
    }
  }

  String get _userDisplayName {
    if (_currentUser?.displayName != null &&
        _currentUser!.displayName!.isNotEmpty) {
      return _currentUser!.displayName!;
    }
    return _currentUser?.email?.split('@').first ?? 'Unbekannt';
  }

  Widget _buildProfileImage() {
    if (_currentUser?.photoURL != null && _currentUser!.photoURL!.isNotEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFF283A49), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Image.network(
            _currentUser!.photoURL!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF283A49),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF283A49),
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }

  Widget _buildProviderBadge() {
    if (_authService.isGoogleUser) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/google_icon.png', width: 16, height: 16),
            const SizedBox(width: 4),
            const Text(
              'Google',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: const Text(
        'E-Mail',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Verbesserte E-Mail-Verifikation mit Fehlerbehandlung und Cooldown
  Future<void> _sendEmailVerification() async {
    if (_currentUser == null) {
      _showErrorMessage('Kein Benutzer gefunden');
      return;
    }

    if (_currentUser!.emailVerified) {
      _showInfoMessage('Ihre E-Mail-Adresse ist bereits verifiziert.');
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // ActionCodeSettings für bessere Benutzerfreundlichkeit
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://your-app.page.link/emailVerified', // Optional: Deep Link
        handleCodeInApp: false,
        androidPackageName: 'com.example.projekt_unbarmherzigkeit',
        androidInstallApp: false,
        androidMinimumVersion: '12',
      );

      await _currentUser!.sendEmailVerification(actionCodeSettings);

      if (mounted) {
        _showSuccessMessage(
          'Verifizierungs-E-Mail wurde erfolgreich gesendet!\n\n'
          'Bitte überprüfen Sie Ihr E-Mail-Postfach (auch den Spam-Ordner) '
          'und klicken Sie auf den Bestätigungslink.\n\n'
          'Nach der Bestätigung können Sie die App neu starten oder '
          'diese Seite aktualisieren.',
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'too-many-requests':
          errorMessage =
              'Zu viele Anfragen. Bitte warten Sie einen Moment '
              'bevor Sie eine neue Verifizierungs-E-Mail anfordern.';
          break;
        case 'user-disabled':
          errorMessage =
              'Ihr Konto wurde deaktiviert. '
              'Kontaktieren Sie den Support.';
          break;
        case 'invalid-email':
          errorMessage = 'Ungültige E-Mail-Adresse.';
          break;
        default:
          errorMessage =
              'Fehler beim Senden der Verifizierungs-E-Mail: '
              '${e.message}';
      }
      if (mounted) {
        _showErrorMessage(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Ein unerwarteter Fehler ist aufgetreten: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Verbesserte Passwort-Reset-Funktion mit Fehlerbehandlung
  Future<void> _sendPasswordResetEmail() async {
    if (_currentUser == null || _currentUser!.email == null) {
      _showErrorMessage('Keine E-Mail-Adresse gefunden');
      return;
    }

    if (_authService.isGoogleUser) {
      _showInfoMessage(
        'Sie sind mit Google angemeldet. '
        'Passwort-Änderungen erfolgen über Ihr Google-Konto.',
      );
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // ActionCodeSettings für bessere Benutzerfreundlichkeit
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://your-app.page.link/resetPassword', // Optional: Deep Link
        handleCodeInApp: false,
        androidPackageName: 'com.example.projekt_unbarmherzigkeit',
        androidInstallApp: false,
        androidMinimumVersion: '12',
      );

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _currentUser!.email!,
        actionCodeSettings: actionCodeSettings,
      );

      if (mounted) {
        _showSuccessMessage(
          'E-Mail zum Zurücksetzen des Passworts wurde gesendet!\n\n'
          'Bitte überprüfen Sie Ihr E-Mail-Postfach (auch den Spam-Ordner) '
          'und folgen Sie den Anweisungen zum Zurücksetzen Ihres Passworts.\n\n'
          'Die E-Mail wurde an: ${_currentUser!.email}',
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Kein Benutzer mit dieser E-Mail-Adresse gefunden.';
          break;
        case 'invalid-email':
          errorMessage = 'Ungültige E-Mail-Adresse.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Zu viele Anfragen. Bitte warten Sie einen Moment '
              'bevor Sie eine neue E-Mail anfordern.';
          break;
        case 'user-disabled':
          errorMessage =
              'Ihr Konto wurde deaktiviert. '
              'Kontaktieren Sie den Support.';
          break;
        default:
          errorMessage =
              'Fehler beim Senden der Passwort-Reset-E-Mail: '
              '${e.message}';
      }
      if (mounted) {
        _showErrorMessage(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Ein unerwarteter Fehler ist aufgetreten: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Prüft den aktuellen Verifizierungsstatus
  Future<void> _checkVerificationStatus() async {
    if (_currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      await _currentUser!.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (mounted && refreshedUser != null) {
        setState(() {
          _currentUser = refreshedUser;
          _isLoading = false;
        });

        if (refreshedUser.emailVerified) {
          _showSuccessMessage(
            'Glückwunsch! Ihre E-Mail-Adresse wurde erfolgreich verifiziert.',
          );
        } else {
          _showInfoMessage(
            'Ihre E-Mail-Adresse ist noch nicht verifiziert. '
            'Bitte überprüfen Sie Ihr E-Mail-Postfach.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorMessage('Fehler beim Überprüfen des Status: $e');
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abmelden'),
          content: const Text('Möchten Sie sich wirklich abmelden?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Abmelden'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _authService.logout();
        if (mounted) {
          _showSuccessMessage('Sie wurden erfolgreich abgemeldet.');
          setState(() {
            _currentUser = null;
          });
        }
      } catch (e) {
        if (mounted) {
          _showErrorMessage('Fehler beim Abmelden: $e');
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konto löschen'),
          content: const Text(
            'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? '
            'Diese Aktion kann nicht rückgängig gemacht werden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _currentUser?.delete();
        if (mounted) {
          _showSuccessMessage('Ihr Konto wurde erfolgreich gelöscht.');
        }
      } catch (e) {
        if (mounted) {
          _showErrorMessage('Fehler beim Löschen des Kontos: $e');
        }
      }
    }
  }

  /// Hilfsmethoden für Nachrichten
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Profilheader
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profilbild
                  _buildProfileImage(),
                  const SizedBox(height: 16),

                  // Name/E-Mail
                  Text(
                    _userDisplayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF283A49),
                    ),
                  ),

                  if (_currentUser?.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _currentUser!.email!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Provider und Verifizierungsstatus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProviderBadge(),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _currentUser?.emailVerified == true
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _currentUser?.emailVerified == true
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        child: Text(
                          _currentUser?.emailVerified == true
                              ? 'Verifiziert'
                              : 'Nicht verifiziert',
                          style: TextStyle(
                            fontSize: 12,
                            color: _currentUser?.emailVerified == true
                                ? Colors.green[700]
                                : Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Status aktualisieren Button
                  if (!(_currentUser?.emailVerified ?? false)) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _isLoading ? null : _checkVerificationStatus,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh, size: 16),
                      label: Text(
                        _isLoading ? 'Prüfe...' : 'Status aktualisieren',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Kontoeinstellungen
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kontoeinstellungen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF283A49),
                        ),
                      ),
                    ),
                  ),

                  // E-Mail verifizieren (nur für nicht-Google User und nicht verifizierte)
                  if (!_authService.isGoogleUser &&
                      _currentUser?.emailVerified != true)
                    _buildProfileOption(
                      icon: Icons.mark_email_read,
                      title: 'E-Mail verifizieren',
                      subtitle: 'Bestätigen Sie Ihre E-Mail-Adresse',
                      onTap: _isLoading ? null : _sendEmailVerification,
                      isLoading: _isLoading,
                    ),

                  // Passwort ändern (nur für E-Mail-User)
                  if (!_authService.isGoogleUser)
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      title: 'Passwort ändern',
                      subtitle: 'E-Mail zum Zurücksetzen senden',
                      onTap: _isLoading ? null : _sendPasswordResetEmail,
                      isLoading: _isLoading,
                    ),

                  // Konto-Informationen
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'Konto-Informationen',
                    subtitle:
                        'Erstellt: ${_formatDate(_currentUser?.metadata.creationTime)}',
                    onTap: () {
                      _showAccountInfo();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Aktionen
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Aktionen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF283A49),
                        ),
                      ),
                    ),
                  ),

                  // Abmelden
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Abmelden',
                    subtitle: 'Von diesem Gerät abmelden',
                    onTap: _logout,
                  ),

                  // Konto löschen
                  _buildProfileOption(
                    icon: Icons.delete_forever,
                    title: 'Konto löschen',
                    subtitle: 'Konto dauerhaft löschen',
                    onTap: _deleteAccount,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF283A49).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Icon(
                      icon,
                      color: isDestructive
                          ? Colors.red[700]
                          : const Color(0xFF283A49),
                      size: 20,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? Colors.red[700]
                          : onTap == null
                          ? Colors.grey
                          : const Color(0xFF283A49),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (onTap != null && !isLoading)
              Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unbekannt';
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showAccountInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konto-Informationen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentUser?.displayName != null)
                _buildInfoRow('Name:', _currentUser!.displayName!),
              _buildInfoRow('E-Mail:', _currentUser?.email ?? 'Unbekannt'),
              _buildInfoRow('User ID:', _currentUser?.uid ?? 'Unbekannt'),
              _buildInfoRow(
                'Anbieter:',
                _authService.isGoogleUser ? 'Google' : 'E-Mail',
              ),
              _buildInfoRow(
                'Erstellt:',
                _formatDate(_currentUser?.metadata.creationTime),
              ),
              _buildInfoRow(
                'Letzter Login:',
                _formatDate(_currentUser?.metadata.lastSignInTime),
              ),
              _buildInfoRow(
                'E-Mail verifiziert:',
                _currentUser?.emailVerified == true ? 'Ja' : 'Nein',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
