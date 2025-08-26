import 'package:flutter/material.dart';
import '../../data/database_repository.dart';
import '../../data/profile.dart';
import '../../data/data_initialization.dart';

class CampFormScreen extends StatefulWidget {
  final DatabaseRepository repository;
  final ConcentrationCamp? camp;

  const CampFormScreen({super.key, required this.repository, this.camp});

  @override
  State<CampFormScreen> createState() => _CampFormScreenState();
}

class _CampFormScreenState extends State<CampFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _countryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _typeController;
  late final TextEditingController _commanderController;
  late final TextEditingController _imagePathController;
  late final TextEditingController _imageDescriptionController;
  late final TextEditingController _imageSourceController;

  DateTime? _dateOpened;
  DateTime? _liberationDate;
  bool _isLoading = false;

  bool get isEditing => widget.camp != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadCampData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _locationController = TextEditingController();
    _countryController = TextEditingController();
    _descriptionController = TextEditingController();
    _typeController = TextEditingController();
    _commanderController = TextEditingController();
    _imagePathController = TextEditingController();
    _imageDescriptionController = TextEditingController();
    _imageSourceController = TextEditingController();
  }

  void _loadCampData() {
    if (widget.camp != null) {
      final camp = widget.camp!;
      _nameController.text = camp.name;
      _locationController.text = camp.location;
      _countryController.text = camp.country;
      _descriptionController.text = camp.description;
      _typeController.text = camp.type;
      _commanderController.text = camp.commander;
      _imagePathController.text = camp.imagePath ?? '';
      _imageDescriptionController.text = camp.imageDescription ?? '';
      _imageSourceController.text = camp.imageSource ?? '';

      _dateOpened = camp.date_opened;
      _liberationDate = camp.liberation_date;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _countryController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _commanderController.dispose();
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
        title: Text(isEditing ? 'Lager bearbeiten' : 'Neues Lager hinzufügen'),
        backgroundColor: const Color(0xFF283A49),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveCamp,
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
                    _buildSection('Grunddaten', [
                      _buildTextField('Name*', _nameController, required: true),
                      _buildTextField(
                        'Ort*',
                        _locationController,
                        required: true,
                      ),
                      _buildTextField(
                        'Land*',
                        _countryController,
                        required: true,
                      ),
                      _buildTextField('Typ*', _typeController, required: true),
                      _buildTextField(
                        'Kommandant*',
                        _commanderController,
                        required: true,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Zeitraum', [
                      _buildDateField(
                        'Eröffnungsdatum',
                        _dateOpened,
                        (date) => setState(() => _dateOpened = date),
                      ),
                      _buildDateField(
                        'Befreiungsdatum',
                        _liberationDate,
                        (date) => setState(() => _liberationDate = date),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Beschreibung', [
                      _buildTextField(
                        'Beschreibung*',
                        _descriptionController,
                        required: true,
                        maxLines: 5,
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
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

  Future<void> _saveCamp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final campId = isEditing ? widget.camp!.camp_id : await _getNextCampId();

      final camp = ConcentrationCampImpl(
        camp_id: campId,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        country: _countryController.text.trim(),
        description: _descriptionController.text.trim(),
        date_opened: _dateOpened,
        liberation_date: _liberationDate,
        type: _typeController.text.trim(),
        commander: _commanderController.text.trim(),
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
        await widget.repository.updateConcentrationCamp(camp);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lager erfolgreich aktualisiert'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await widget.repository.createConcentrationCamp(camp);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lager erfolgreich hinzugefügt'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
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

  Future<int> _getNextCampId() async {
    final camps = await widget.repository.getConcentrationCamps();
    if (camps.isEmpty) return 1;
    return camps.map((c) => c.camp_id).reduce((a, b) => a > b ? a : b) + 1;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
