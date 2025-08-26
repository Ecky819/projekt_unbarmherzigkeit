import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/database_repository.dart';
import '../../data/profile.dart';
import '../../data/data_initialization.dart';

class VictimFormScreen extends StatefulWidget {
  final DatabaseRepository repository;
  final Victim? victim; // null für neues Opfer, Victim für Bearbeitung

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
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('Persönliche Daten', [
                      _buildTextField(
                        'Nachname*',
                        _surnameController,
                        required: true,
                      ),
                      _buildTextField(
                        'Vorname*',
                        _nameController,
                        required: true,
                      ),
                      _buildTextField(
                        'Häftlingsnummer',
                        _prisonerNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      _buildDateField(
                        'Geburtsdatum',
                        _birthDate,
                        (date) => setState(() => _birthDate = date),
                      ),
                      _buildTextField('Geburtsort', _birthplaceController),
                      _buildDateField(
                        'Sterbedatum',
                        _deathDate,
                        (date) => setState(() => _deathDate = date),
                      ),
                      _buildTextField('Sterbeort', _deathplaceController),
                      _buildTextField(
                        'Nationalität*',
                        _nationalityController,
                        required: true,
                      ),
                      _buildTextField(
                        'Religion*',
                        _religionController,
                        required: true,
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
                  ],
                ),
              ),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283A49),
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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
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
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          child: Text(
            date != null ? _formatDate(date) : 'Datum auswählen',
            style: TextStyle(
              color: date != null ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchField(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF283A49),
          ),
        ],
      ),
    );
  }

  // Alternative _selectDate Methode für victim_form_screen.dart
  // Ersetze die bestehende _selectDate Methode mit dieser:

  Future<void> _selectDate(
    DateTime? currentDate,
    Function(DateTime?) onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(1920),
      firstDate: DateTime(1800),
      lastDate: DateTime(2020),
      // ENTFERNE locale und deutsche Texte vorerst
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final victimId = isEditing
          ? widget.victim!.victim_id
          : await _getNextVictimId();

      final victim = VictimImpl(
        victim_id: victimId,
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

      if (isEditing) {
        await widget.repository.updateVictim(victim);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opfer erfolgreich aktualisiert'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await widget.repository.createVictim(victim);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opfer erfolgreich hinzugefügt'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true); // true bedeutet Erfolg
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<int> _getNextVictimId() async {
    final victims = await widget.repository.getVictims();
    if (victims.isEmpty) return 1;
    return victims.map((v) => v.victim_id).reduce((a, b) => a > b ? a : b) + 1;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
