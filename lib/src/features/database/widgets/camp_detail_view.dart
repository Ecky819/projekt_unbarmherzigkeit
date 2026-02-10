import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/profile.dart';
import '../../../data/database_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyles.dart';
import '../../../services/auth_service.dart';
import '../../../features/database/database_screen.dart';
import '../../../features/profiles/login_screen.dart';

class CampDetailScreen extends StatefulWidget {
  final ConcentrationCamp camp;
  final DatabaseRepository? repository;

  const CampDetailScreen({
    super.key,
    required this.camp,
    this.repository,
  });

  @override
  State<CampDetailScreen> createState() => _CampDetailScreenState();
}

class _CampDetailScreenState extends State<CampDetailScreen> {
  final AuthService _authService = AuthService();
  bool _isLoadingRelatedData = false;
  List<SearchResult> _relatedVictims = [];
  List<SearchResult> _relatedCommanders = [];

  @override
  void initState() {
    super.initState();
    _loadRelatedData();
  }

  Future<void> _loadRelatedData() async {
    if (widget.repository == null || !_authService.isLoggedIn) return;

    setState(() {
      _isLoadingRelatedData = true;
    });

    try {
      final searchResult = await widget.repository!.search(
        locationQuery: widget.camp.name,
      );

      if (searchResult.isSuccess && searchResult.data != null) {
        final victims = searchResult.data!
            .where((result) => result.type == 'victim')
            .toList();
        final commanders = searchResult.data!
            .where((result) => result.type == 'commander')
            .toList();

        setState(() {
          _relatedVictims = victims.take(5).toList();
          _relatedCommanders = commanders.take(3).toList();
        });
      }
    } catch (e) {
      // Error loading related data
    } finally {
      setState(() {
        _isLoadingRelatedData = false;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unbekannt';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _calculateOperationDuration() {
    if (widget.camp.dateOpened == null || widget.camp.liberationDate == null) {
      return 'Unbekannt';
    }

    final duration = widget.camp.liberationDate!.difference(
      widget.camp.dateOpened!,
    );
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;
    final days = duration.inDays % 30;

    String result = '';
    if (years > 0) result += '$years Jahr${years != 1 ? 'e' : ''} ';
    if (months > 0) result += '$months Monat${months != 1 ? 'e' : ''} ';
    if (days > 0 && years == 0) result += '$days Tag${days != 1 ? 'e' : ''}';

    return result.trim().isEmpty ? '${duration.inDays} Tage' : result.trim();
  }

  void _handleDatabaseButtonPress() {
    if (_authService.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatabaseScreen(
            repository: widget.repository,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ).then((value) {
        if (_authService.isLoggedIn && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatabaseScreen(
                repository: widget.repository,
              ),
            ),
          );
        }
      });
    }
  }

  void _showFullScreenImage() {
    if (widget.camp.imagePath == null || widget.camp.imagePath!.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Image.asset(
                widget.camp.imagePath!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 50,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== Extracted Widgets =====

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _showFullScreenImage,
      child: Hero(
        tag: 'camp_image_${widget.camp.campId}',
        child: Container(
          constraints: const BoxConstraints(maxHeight: 280),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.camp.imagePath!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
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
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCaption() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.camp.imageDescription != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.camp.imageDescription!,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                  fontFamily: 'SFPro',
                ),
              ),
            ),
          if (widget.camp.imageSource != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Quelle: ${widget.camp.imageSource!}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                  fontFamily: 'SFPro',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Card(
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
            _buildInfoRow(
              'Name:',
              widget.camp.name,
              icon: Icons.label_outline,
            ),
            _buildInfoRow(
              'Ort:',
              widget.camp.location,
              icon: Icons.location_on_outlined,
            ),
            _buildInfoRow(
              'Land:',
              widget.camp.country,
              icon: Icons.flag_outlined,
            ),
            _buildInfoRow(
              'Typ:',
              widget.camp.type,
              icon: Icons.category_outlined,
            ),
            if (widget.camp.commander.isNotEmpty)
              _buildInfoRow(
                'Kommandant:',
                widget.camp.commander,
                icon: Icons.person_outline,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: _authService.authStateChanges,
          builder: (context, snapshot) {
            final isLoggedIn = snapshot.data != null;
            final screenWidth = MediaQuery.of(context).size.width;
            final isWideScreen = screenWidth > 800;
            final hasImage = widget.camp.imagePath != null &&
                widget.camp.imagePath!.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Desktop: Bild links + Infos rechts
                      // Mobile: Bild oben, Infos darunter
                      if (isWideScreen && hasImage)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _buildImageSection(),
                                  if (widget.camp.imageDescription != null ||
                                      widget.camp.imageSource != null)
                                    _buildImageCaption(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 6,
                              child: _buildMainInfoCard(),
                            ),
                          ],
                        )
                      else ...[
                        if (hasImage) ...[
                          _buildImageSection(),
                          if (widget.camp.imageDescription != null ||
                              widget.camp.imageSource != null)
                            _buildImageCaption(),
                        ],
                        _buildMainInfoCard(),
                      ],

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
                              const Text(
                                'Zeitraum',
                                style: AppTextStyles.heading2,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'Eröffnet:',
                                _formatDate(widget.camp.dateOpened),
                                icon: Icons.calendar_today_outlined,
                              ),
                              _buildInfoRow(
                                'Befreit:',
                                _formatDate(widget.camp.liberationDate),
                                icon: Icons.event_available_outlined,
                              ),
                              _buildInfoRow(
                                'Betriebsdauer:',
                                _calculateOperationDuration(),
                                icon: Icons.timer_outlined,
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

                      // Verknüpfte Daten (nur für angemeldete User)
                      if (isLoggedIn &&
                          (_relatedVictims.isNotEmpty ||
                              _relatedCommanders.isNotEmpty)) ...[
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
                                  'Verknüpfte Einträge',
                                  style: AppTextStyles.heading2,
                                ),
                                if (_isLoadingRelatedData)
                                  const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else ...[
                                  if (_relatedVictims.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Registrierte Opfer:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._relatedVictims.map(
                                      (victim) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_outline,
                                              size: 16,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                victim.title,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_relatedVictims.length >= 5)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          '...und weitere',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                  ],
                                  if (_relatedCommanders.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Kommandanten:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._relatedCommanders.map(
                                      (commander) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.military_tech,
                                              size: 16,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                commander.title,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Hinweis für nicht angemeldete User
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
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.map),
                              label: const Text('Zur Karte'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                    color: AppColors.primary),
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
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _handleDatabaseButtonPress,
                              icon: Icon(
                                isLoggedIn
                                    ? Icons.storage
                                    : Icons.lock_outline,
                              ),
                              label: Text(
                                isLoggedIn ? 'Zur Datenbank' : 'Anmelden',
                              ),
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
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.black54),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 100,
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