import 'package:flutter/material.dart';
import '../../data/databaseRepository.dart';
import '../../data/profile.dart';
import '../../data/data_initialization.dart';

class CommanderFormScreen extends StatefulWidget {
  final DatabaseRepository repository;
  final Commander? commander;

  const CommanderFormScreen({
    super.key,
    required this.repository,
    this.commander,
  });

  @override
  State<CommanderFormScreen> createState() => _CommanderFormScreenState();
}

class _CommanderFormScreenState extends State<CommanderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _rankController;
  late final TextEditingController _birthplaceController;
  late final TextEditingController _deathplaceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imagePathController;
  late final TextEditingController _imageDescriptionController;
  late final TextEditingController _imageSourceController;

  DateTime? _birthDate;
  DateTime? _deathDate;
  bool _isLoading = false;

  bool get isEditing => widget.commander != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadCommanderData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _rankController = TextEditingController();
    _birthplaceController = TextEditingController();
    _deathplaceController = TextEditingController();
    _descriptionController = TextEditingController();
    _imagePathController = TextEditingController();
    _imageDescriptionController = TextEditingController();
    _imageSourceController = TextEditingController();
  }

  void _loadCommanderData() {
    if (widget.commander != null) {
      final commander = widget.commander!;
      _nameController.text = commander.name;
      _surnameController.text = commander.surname;
      _rankController.text = commander.rank;
      _birthplaceController.text = commander.birthplace ?? '';
      _deathplaceController.text = commander.deathplace ?? '';
      _descriptionController.text = commander.description;
      _imagePathController.text = commander.imagePath ?? '';
      _imageDescriptionController.text = commander.imageDescription ?? '';
      _imageSourceController.text = commander.imageSource ?? '';

      _birthDate = commander.birth;
      _deathDate = commander.death;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _rankController.dispose();
    _birthplaceController.dispose();
    _deathplaceController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();
    _imageDescriptionController.dispose();
    _imageSourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Speichere Kommandant...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SF Pro',
                      color: Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            )
          : _buildForm(),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: _saveCommander,
              backgroundColor: const Color(0xFF283A49),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.save),
              label: Text(
                isEditing ? 'AKTUALISIEREN' : 'SPEICHERN',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro',
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.military_tech, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isEditing
                  ? 'Kommandant bearbeiten'
                  : 'Neuen Kommandanten hinzufügen',
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF283A49),
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        if (isEditing)
          IconButton(
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Kommandant löschen',
          ),
        IconButton(
          onPressed: _resetForm,
          icon: const Icon(Icons.refresh),
          tooltip: 'Formular zurücksetzen',
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEditing) _buildInfoBanner(),

            _buildSection('Persönliche Daten', Icons.person, [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Vorname*',
                      _nameController,
                      required: true,
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Nachname*',
                      _surnameController,
                      required: true,
                      icon: Icons.person_outline,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                'Rang*',
                _rankController,
                required: true,
                icon: Icons.military_tech,
                helperText: 'z.B. SS-Oberführer, Lagerkommandant',
              ),
              const SizedBox(height: 8),
              const Text(
                'Lebensdaten',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF283A49),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      'Geburtsdatum',
                      _birthDate,
                      (date) => setState(() => _birthDate = date),
                      Icons.cake,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Geburtsort',
                      _birthplaceController,
                      icon: Icons.location_on,
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
                      Icons.event_busy,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Sterbeort',
                      _deathplaceController,
                      icon: Icons.location_off,
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 24),

            _buildSection('Beschreibung & Tätigkeiten', Icons.description, [
              _buildTextField(
                'Beschreibung*',
                _descriptionController,
                required: true,
                maxLines: 6,
                helperText:
                    'Detaillierte Beschreibung der Person und ihrer Tätigkeiten während der NS-Zeit',
              ),
            ]),

            const SizedBox(height: 24),

            _buildSection('Bildmaterial', Icons.image, [
              _buildTextField(
                'Bildpfad',
                _imagePathController,
                icon: Icons.folder,
                helperText:
                    'Relativer Pfad zum Bild, z.B. assets/images/commanders/name.jpg',
              ),
              _buildTextField(
                'Bildbeschreibung',
                _imageDescriptionController,
                maxLines: 2,
                icon: Icons.description,
                helperText: 'Beschreibung des Bildes für Barrierefreiheit',
              ),
              _buildTextField(
                'Bildquelle',
                _imageSourceController,
                maxLines: 2,
                icon: Icons.source,
                helperText: 'Quelle und Copyright-Informationen des Bildes',
              ),
            ]),

            const SizedBox(height: 100), // Platz für FAB
          ],
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
                  'Bearbeitung: ${widget.commander!.surname}, ${widget.commander!.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'ID: ${widget.commander!.commander_id}',
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
            color: Colors.black.withOpacity(0.08),
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
                    color: const Color(0xFF283A49).withOpacity(0.1),
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
    IconData? icon,
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
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
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
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectDate(date, onChanged),
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20),
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

  void _resetForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formular zurücksetzen'),
        content: const Text(
          'Möchten Sie alle Eingaben zurücksetzen? Alle nicht gespeicherten Änderungen gehen verloren.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _formKey.currentState?.reset();
              _loadCommanderData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kommandant löschen'),
        content: Text(
          'Möchten Sie den Kommandanten "${widget.commander!.surname}, ${widget.commander!.name}" wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCommander();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCommander() async {
    setState(() => _isLoading = true);

    try {
      await widget.repository.deleteCommander(
        widget.commander!.commander_id.toString(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kommandant erfolgreich gelöscht'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveCommander() async {
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
      final commanderId = isEditing
          ? widget.commander!.commander_id
          : await _getNextCommanderId();

      final commander = CommanderImpl(
        commander_id: commanderId,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        rank: _rankController.text.trim(),
        birth: _birthDate,
        birthplace: _birthplaceController.text.trim().isNotEmpty
            ? _birthplaceController.text.trim()
            : null,
        death: _deathDate,
        deathplace: _deathplaceController.text.trim().isNotEmpty
            ? _deathplaceController.text.trim()
            : null,
        description: _descriptionController.text.trim(),
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
        await widget.repository.updateCommander(commander);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kommandant erfolgreich aktualisiert'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        await widget.repository.createCommander(commander);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kommandant erfolgreich hinzugefügt'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
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

  Future<int> _getNextCommanderId() async {
    try {
      final commanders = await widget.repository.getCommanders();
      if (commanders.isEmpty) return 1;
      return commanders
              .map((c) => c.commander_id)
              .reduce((a, b) => a > b ? a : b) +
          1;
    } catch (e) {
      // Fallback: Timestamp-basierte ID
      return DateTime.now().millisecondsSinceEpoch % 1000000;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
