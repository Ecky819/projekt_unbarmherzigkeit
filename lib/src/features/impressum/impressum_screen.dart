import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      appBar: AppBar(
        title: const Text(
          'Impressum',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF283A49),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Information Section
            _buildSection(
              title: 'App-Information',
              children: [
                _buildInfoRow(
                  label: 'App Name',
                  value: '#Projekt Unbarmherzigkeit',
                ),
                _buildInfoRow(label: 'Version', value: '1.0.0'),
                _buildInfoRow(
                  label: 'Zweck',
                  value:
                      'Dokumentation und Erinnerung an die Opfer der NS-Zeit',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Responsible Section
            _buildSection(
              title: 'Verantwortlich nach § 5 TMG',
              children: [
                _buildTextBlock(
                  text: '''
[Ihr Name oder Organisation]
[Straße und Hausnummer]
[PLZ Ort]
Deutschland

E-Mail: kontakt@beispiel.de
Telefon: +49 (0) 123 456789
''',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Contact Section
            _buildSection(
              title: 'Kontakt',
              children: [
                _buildClickableRow(
                  label: 'E-Mail',
                  value: 'kontakt@beispiel.de',
                  onTap: () => _launchUrl('mailto:kontakt@beispiel.de'),
                ),
                _buildClickableRow(
                  label: 'Website',
                  value: 'www.beispiel.de',
                  onTap: () => _launchUrl('https://www.beispiel.de'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Data Protection Section
            _buildSection(
              title: 'Datenschutz',
              children: [
                _buildTextBlock(
                  text:
                      'Die Nutzung unserer App ist grundsätzlich ohne Angabe personenbezogener Daten möglich. '
                      'Soweit personenbezogene Daten (beispielsweise Name, Anschrift oder E-Mail-Adressen) '
                      'erhoben werden, erfolgt dies, soweit möglich, stets auf freiwilliger Basis.',
                ),
                const SizedBox(height: 16),
                _buildLinkButton(
                  text: 'Datenschutzerklärung anzeigen',
                  onTap: () =>
                      _launchUrl('https://www.beispiel.de/datenschutz'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Legal Notice Section
            _buildSection(
              title: 'Rechtlicher Hinweis',
              children: [
                _buildTextBlock(
                  text:
                      'Diese App dient ausschließlich zu Bildungs- und Dokumentationszwecken. '
                      'Die historischen Daten wurden sorgfältig recherchiert und geprüft. '
                      'Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte '
                      'können wir jedoch keine Gewähr übernehmen.',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Copyright Section
            _buildSection(
              title: 'Urheberrecht',
              children: [
                _buildTextBlock(
                  text:
                      'Die durch die Seitenbetreiber erstellten Inhalte und Werke in dieser App '
                      'unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, '
                      'Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes '
                      'bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Credits Section
            _buildSection(
              title: 'Danksagungen',
              children: [
                _buildTextBlock(
                  text:
                      'Besonderer Dank gilt allen Historikern, Archivaren und Institutionen, '
                      'die bei der Recherche und Dokumentation unterstützt haben.',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Technical Implementation
            _buildSection(
              title: 'Technische Umsetzung',
              children: [
                _buildInfoRow(label: 'Framework', value: 'Flutter 3.35.1+'),
                _buildInfoRow(label: 'Backend', value: 'Firebase'),
                _buildInfoRow(
                  label: 'Entwicklung',
                  value: '[Ihr Entwicklerteam]',
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Last Update
            Center(
              child: Text(
                'Stand: Januar 2026',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock({required String text}) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade300, fontSize: 14, height: 1.6),
    );
  }

  Widget _buildLinkButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.open_in_new, color: Colors.blue, size: 16),
          ],
        ),
      ),
    );
  }
}
