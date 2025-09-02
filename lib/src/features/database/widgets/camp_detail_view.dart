import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyles.dart';
import '../../../services/auth_service.dart';
import '../../../features/database/database_screen.dart';
import '../../../features/profiles/login_screen.dart';

class CampDetailScreen extends StatefulWidget {
  final ConcentrationCamp camp;

  const CampDetailScreen({super.key, required this.camp});

  @override
  State<CampDetailScreen> createState() => _CampDetailScreenState();
}

class _CampDetailScreenState extends State<CampDetailScreen> {
  final AuthService _authService = AuthService();

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unbekannt';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _handleDatabaseButtonPress() {
    // Prüfe ob User angemeldet ist
    if (_authService.isLoggedIn) {
      // User ist angemeldet - navigiere zur Datenbank
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DatabaseScreen()),
      );
    } else {
      // User ist nicht angemeldet - zeige Login Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ).then((value) {
        // Nach dem Login-Screen prüfen, ob User jetzt angemeldet ist
        if (_authService.isLoggedIn && mounted) {
          // Wenn erfolgreich angemeldet, zur Datenbank navigieren
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DatabaseScreen()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generiere den Titel aus Typ und Name
    final String appBarTitle = widget.camp.type.isNotEmpty
        ? '${widget.camp.type} ${widget.camp.name}'
        : widget.camp.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          final isLoggedIn = snapshot.data != null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bild-Sektion (falls vorhanden)
                if (widget.camp.imagePath != null &&
                    widget.camp.imagePath!.isNotEmpty)
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.camp.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.secondary,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // Hauptinformationen Card
                Card(
                  elevation: 2,
                  color: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Allgemeine Informationen',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Name:', widget.camp.name),
                        _buildInfoRow('Ort:', widget.camp.location),
                        _buildInfoRow('Land:', widget.camp.country),
                        _buildInfoRow('Typ:', widget.camp.type),
                        _buildInfoRow('Kommandant:', widget.camp.commander),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Zeitraum Card
                Card(
                  elevation: 2,
                  color: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Zeitraum', style: AppTextStyles.heading2),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Eröffnet:',
                          _formatDate(widget.camp.dateOpened),
                        ),
                        _buildInfoRow(
                          'Befreit:',
                          _formatDate(widget.camp.liberationDate),
                        ),
                        if (widget.camp.operationDuration != null)
                          _buildInfoRow(
                            'Betriebsdauer:',
                            '${widget.camp.operationDuration!.inDays} Tage',
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Beschreibung Card
                if (widget.camp.description.isNotEmpty)
                  Card(
                    elevation: 2,
                    color: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Beschreibung',
                            style: AppTextStyles.heading2,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.camp.description,
                            style: AppTextStyles.body,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bildinformationen (falls vorhanden)
                if (widget.camp.imageDescription != null ||
                    widget.camp.imageSource != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    color: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bildinformationen',
                            style: AppTextStyles.heading2,
                          ),
                          const SizedBox(height: 12),
                          if (widget.camp.imageDescription != null)
                            _buildInfoRow(
                              'Beschreibung:',
                              widget.camp.imageDescription!,
                            ),
                          if (widget.camp.imageSource != null)
                            _buildInfoRow('Quelle:', widget.camp.imageSource!),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Hinweis auf weitere Informationen - nur für nicht angemeldete User
                if (!isLoggedIn)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.accent,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Für detaillierte Informationen zu Opfern und Kommandanten melden Sie sich bitte an.',
                            style: AppTextStyles.body,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Zurück zur Karte Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.map),
                        label: const Text('Zur Karte'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Zur Datenbank Button - mit dynamischem Verhalten
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handleDatabaseButtonPress,
                        icon: Icon(
                          isLoggedIn ? Icons.storage : Icons.lock_outline,
                        ),
                        label: Text(isLoggedIn ? 'Zur Datenbank' : 'Anmelden'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoggedIn
                              ? AppColors.secondary
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
