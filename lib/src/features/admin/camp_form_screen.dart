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

      _dateOpened = camp.dateOpened;
      _liberationDate = camp.liberationDate;
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
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Speichere Lager...',
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

                    _buildSection('Grunddaten', Icons.location_city, [
                      _buildTextField('Name*', _nameController, required: true),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Ort*',
                              _locationController,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Land*',
                              _countryController,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Typ*',
                              _typeController,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Kommandant*',
                              _commanderController,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildSection('Zeitraum', Icons.calendar_today, [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              'Eröffnungsdatum',
                              _dateOpened,
                              (date) => setState(() => _dateOpened = date),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateField(
                              'Befreiungsdatum',
                              _liberationDate,
                              (date) => setState(() => _liberationDate = date),
                            ),
                          ),
                        ],
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildSection('Beschreibung', Icons.description, [
                      _buildTextField(
                        'Beschreibung*',
                        _descriptionController,
                        required: true,
                        maxLines: 5,
                        helperText:
                            'Detaillierte Beschreibung des Lagers und seiner Geschichte',
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildSection('Bildinformationen', Icons.image, [
                      _buildTextField(
                        'Bildpfad',
                        _imagePathController,
                        helperText:
                            'Relativer Pfad zum Bild, z.B. assets/images/camps/name.jpg',
                      ),
                      _buildTextField(
                        'Bildbeschreibung',
                        _imageDescriptionController,
                        maxLines: 2,
                        helperText:
                            'Beschreibung des Bildes für Barrierefreiheit',
                      ),
                      _buildTextField(
                        'Bildquelle',
                        _imageSourceController,
                        maxLines: 2,
                        helperText:
                            'Quelle und Copyright-Informationen des Bildes',
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
                  'Bearbeitung: ${widget.camp!.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'ID: ${widget.camp!.campId}',
                  style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF283A49).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF283A49), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF283A49),
                    fontFamily: 'SF Pro',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'SF Pro'),
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperMaxLines: 2,
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

  Future<void> _saveCamp() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte füllen Sie alle Pflichtfelder aus'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final campId = isEditing ? widget.camp!.campId : await _getNextCampId();

      final camp = ConcentrationCampImpl(
        campId: campId,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        country: _countryController.text.trim(),
        description: _descriptionController.text.trim(),
        dateOpened: _dateOpened,
        liberationDate: _liberationDate,
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

      // Validiere die Daten
      final validation = validateCampData(camp);
      if (!validation.isSuccess) {
        throw validation.error?.message ?? 'Validierungsfehler';
      }

      DatabaseResult<void> result;

      if (isEditing) {
        result = await widget.repository.updateConcentrationCamp(camp);
      } else {
        result = await widget.repository.createConcentrationCamp(camp);
      }

      if (!result.isSuccess) {
        throw result.error?.message ?? 'Unbekannter Fehler beim Speichern';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Lager erfolgreich aktualisiert'
                  : 'Lager erfolgreich hinzugefügt',
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

  Future<String> _getNextCampId() async {
    try {
      final result = await widget.repository.getConcentrationCamps();
      if (!result.isSuccess || result.data == null) {
        return DateTime.now().millisecondsSinceEpoch.toString();
      }

      final camps = result.data!;
      if (camps.isEmpty) return '1';

      // Finde die höchste numerische ID
      int maxId = 0;
      for (final camp in camps) {
        final id = int.tryParse(camp.campId);
        if (id != null && id > maxId) {
          maxId = id;
        }
      }

      return (maxId + 1).toString();
    } catch (e) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
