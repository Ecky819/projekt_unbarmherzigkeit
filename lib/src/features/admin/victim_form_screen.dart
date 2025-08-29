import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/database_repository.dart';
import '../../data/profile.dart';
import '../../data/data_initialization.dart';

class VictimFormScreen extends StatefulWidget {
  final DatabaseRepository repository;
  final Victim? victim;

  const VictimFormScreen({super.key, required this.repository, this.victim});

  @override
  State<VictimFormScreen> createState() => _VictimFormScreenState();
}

class _VictimFormScreenState extends State<VictimFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _surnameController;
  late final TextEditingController _nameController;
  late final TextEditingController _prisonerNumberController;
  late final TextEditingController _birthplaceController;
  late final TextEditingController _deathplaceController;
  late final TextEditingController _nationalityController;
  late final TextEditingController _religionController;
  late final TextEditingController _occupationController;
  late final TextEditingController _cCampController;
  late final TextEditingController _fateController;
  late final TextEditingController _imagePathController;
  late final TextEditingController _imageDescriptionController;
  late final TextEditingController _imageSourceController;

  DateTime? _birthDate;
  DateTime? _deathDate;
  DateTime? _envDate;
  bool _deathCertificate = false;
  bool _isLoading = false;

  bool get isEditing => widget.victim != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadVictimData();
  }

  void _initializeControllers() {
    _surnameController = TextEditingController();
    _nameController = TextEditingController();
    _prisonerNumberController = TextEditingController();
    _birthplaceController = TextEditingController();
    _deathplaceController = TextEditingController();
    _nationalityController = TextEditingController();
    _religionController = TextEditingController();
    _occupationController = TextEditingController();
    _cCampController = TextEditingController();
    _fateController = TextEditingController();
    _imagePathController = TextEditingController();
    _imageDescriptionController = TextEditingController();
    _imageSourceController = TextEditingController();
  }

  void _loadVictimData() {
    if (widget.victim != null) {
      final victim = widget.victim!;
      _surnameController.text = victim.surname;
      _nameController.text = victim.name;
      _prisonerNumberController.text = victim.prisoner_number?.toString() ?? '';
      _birthplaceController.text = victim.birthplace ?? '';
      _deathplaceController.text = victim.deathplace ?? '';
      _nationalityController.text = victim.nationality;
      _religionController.text = victim.religion;
      _occupationController.text = victim.occupation;
      _cCampController.text = victim.c_camp;
      _fateController.text = victim.fate;
      _imagePathController.text = victim.imagePath ?? '';
      _imageDescriptionController.text = victim.imageDescription ?? '';
      _imageSourceController.text = victim.imageSource ?? '';

      _birthDate = victim.birth;
      _deathDate = victim.death;
      _envDate = victim.env_date;
      _deathCertificate = victim.death_certificate;
    }
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _prisonerNumberController.dispose();
    _birthplaceController.dispose();
    _deathplaceController.dispose();
    _nationalityController.dispose();
    _religionController.dispose();
    _occupationController.dispose();
    _cCampController.dispose();
    _fateController.dispose();
    _imagePathController.dispose();
    _imageDescriptionController.dispose();
    _imageSourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      appBar: AppBar(
        title: Text(isEditing ? 'Opfer bearbeiten' : 'Neues Opfer hinzufügen'),
        backgroundColor: const Color(0xFF283A49),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveVictim,
            child: Text(
              'SPEICHERN',
              style: TextStyle(
                color: _isLoading ? Colors.white54 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Speichere Opfer...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SF Pro',
                      color: Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEditing) _buildInfoBanner(),

                    _buildSection('Persönliche Daten', [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Nachname*',
                              _surnameController,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Vorname*',
                              _nameController,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        'Häftlingsnummer',
                        _prisonerNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              'Geburtsdatum',
                              _birthDate,
                              (date) => setState(() => _birthDate = date),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Geburtsort',
                              _birthplaceController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              'Sterbedatum',
                              _deathDate,
                              (date) => setState(() => _deathDate = date),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Sterbeort',
                              _deathplaceController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Nationalität*',
                              _nationalityController,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Religion*',
                              _religionController,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        'Beruf*',
                        _occupationController,
                        required: true,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildSection('Haft und Verfolgung', [
                      _buildTextField(
                        'Konzentrationslager*',
                        _cCampController,
                        required: true,
                      ),
                      _buildDateField(
                        'Einlieferungsdatum',
                        _envDate,
                        (date) => setState(() => _envDate = date),
                      ),
                      _buildTextField(
                        'Schicksal*',
                        _fateController,
                        required: true,
                        maxLines: 3,
                      ),
                      _buildSwitchField(
                        'Sterbeurkunde vorhanden',
                        _deathCertificate,
                        (value) => setState(() => _deathCertificate = value),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildSection('Bildinformationen', [
                      _buildTextField('Bildpfad', _imagePathController),
                      _buildTextField(
                        'Bildbeschreibung',
                        _imageDescriptionController,
                        maxLines: 2,
                      ),
                      _buildTextField(
                        'Bildquelle',
                        _imageSourceController,
                        maxLines: 2,
                      ),
                    ]),

                    const SizedBox(height: 100), // Platz für mögliche FAB
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bearbeitung: ${widget.victim!.surname}, ${widget.victim!.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'ID: ${widget.victim!.victim_id}',
                  style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283A49),
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'SF Pro'),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF283A49), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Dieses Feld ist erforderlich';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectDate(date, onChanged),
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_today, size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          child: Text(
            date != null ? _formatDate(date) : 'Datum auswählen',
            style: TextStyle(
              color: date != null ? Colors.black : Colors.grey[600],
              fontFamily: 'SF Pro',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchField(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontFamily: 'SF Pro'),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFF283A49),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    DateTime? currentDate,
    Function(DateTime?) onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(1920),
      firstDate: DateTime(1800),
      lastDate: DateTime(2020),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF283A49),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF283A49),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  Future<void> _saveVictim() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte füllen Sie alle Pflichtfelder aus'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validiere Daten vor dem Speichern
    final victimData = VictimImpl(
      victim_id: isEditing ? widget.victim!.victim_id : '',
      surname: _surnameController.text.trim(),
      name: _nameController.text.trim(),
      prisoner_number: _prisonerNumberController.text.isNotEmpty
          ? int.tryParse(_prisonerNumberController.text)
          : null,
      birth: _birthDate,
      birthplace: _birthplaceController.text.trim().isNotEmpty
          ? _birthplaceController.text.trim()
          : null,
      death: _deathDate,
      deathplace: _deathplaceController.text.trim().isNotEmpty
          ? _deathplaceController.text.trim()
          : null,
      nationality: _nationalityController.text.trim(),
      religion: _religionController.text.trim(),
      occupation: _occupationController.text.trim(),
      death_certificate: _deathCertificate,
      env_date: _envDate,
      c_camp: _cCampController.text.trim(),
      fate: _fateController.text.trim(),
      imagePath: _imagePathController.text.trim().isNotEmpty
          ? _imagePathController.text.trim()
          : null,
      imageDescription: _imageDescriptionController.text.trim().isNotEmpty
          ? _imageDescriptionController.text.trim()
          : null,
      imageSource: _imageSourceController.text.trim().isNotEmpty
          ? _imageSourceController.text.trim()
          : null,
    );

    // Validiere die Daten
    final validation = validateVictimData(victimData);
    if (!validation.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Validierungsfehler: ${validation.error?.message}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      DatabaseResult<void> result;

      if (isEditing) {
        result = await widget.repository.updateVictim(victimData);
      } else {
        // Generiere neue ID für neues Opfer
        final victimId = await _getNextVictimId();
        final newVictim =
            victimData.copyWith(
                  // Verwende eine neue ID
                )
                as VictimImpl;
        newVictim.victim_id = victimId;

        result = await widget.repository.createVictim(newVictim);
      }

      if (!result.isSuccess) {
        throw result.error?.message ?? 'Unbekannter Fehler beim Speichern';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Opfer erfolgreich aktualisiert'
                  : 'Opfer erfolgreich hinzugefügt',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String> _getNextVictimId() async {
    try {
      final result = await widget.repository.getVictims();
      if (!result.isSuccess || result.data == null) {
        // Fallback: Timestamp-basierte ID
        return DateTime.now().millisecondsSinceEpoch.toString();
      }

      final victims = result.data!;
      if (victims.isEmpty) return '1';

      // Finde die höchste numerische ID
      int maxId = 0;
      for (final victim in victims) {
        final id = int.tryParse(victim.victim_id);
        if (id != null && id > maxId) {
          maxId = id;
        }
      }

      return (maxId + 1).toString();
    } catch (e) {
      // Fallback: Timestamp-basierte ID
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
