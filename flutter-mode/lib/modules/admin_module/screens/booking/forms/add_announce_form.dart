// lib/widgets/announce_form.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:babigo/modules/booking_module/models/announce_data.dart';
import 'package:babigo/modules/trip_module/database/models/place_ref.dart';
import 'package:babigo/modules/trip_module/widgets/place_autocomplete_field.dart';

const Color _background = Color(0xFFF4F7FE);
const Color _primary = Color(0xFF1F6FEB);
const Color _ink = Color(0xFF0F172A);
const Color _muted = Color(0xFF64748B);
const Color _softBorder = Color(0xFFE2E8F0);

class AddAnnounceForm extends StatefulWidget {

  final ValueChanged<AnnounceData> onChanged;
  final AnnounceData? initialData;

  const AddAnnounceForm({
    super.key,
    required this.onChanged,
    this.initialData,
  });

  @override
  State<AddAnnounceForm> createState() => _AddAnnounceFormState();
}

class _AddAnnounceFormState extends State<AddAnnounceForm> {

  final TextEditingController _departController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _meetingController = TextEditingController();
  final TextEditingController _arrivalPlaceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final List<TextEditingController> _stops = [];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  PlaceRef? fromPlace;
  PlaceRef? toPlace;

  List<TextEditingController> get _mainControllers => [
    _departController,
    _destinationController,
    _meetingController,
    _arrivalPlaceController,
    _seatsController,
    _priceController,
  ];

  @override
  void initState() {
    super.initState();
    _hydrateInitialData();

    for (final controller in _mainControllers) {
      controller.addListener(_emitChange);
    }

    if (_stops.isEmpty) {
      _addStopController();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _emitChange();
    });
  }

  void _hydrateInitialData() {
    final data = widget.initialData;
    if (data == null) return;

    _departController.text = data.depart;
    _destinationController.text = data.destination;
    _meetingController.text = data.meetingPlace;
    _arrivalPlaceController.text = data.arrivalPlace;

    _selectedDate = data.date;
    _selectedTime = data.time;

    if (data.date != null) {
      _dateController.text = _formatDate(data.date!);
    }

    if (data.time != null) {
      _timeController.text = _formatTime(data.time!);
    }

    if (data.seats != null) {
      _seatsController.text = data.seats.toString();
    }

    if (data.price != null) {
      _priceController.text = data.price.toString();
    }

    for (final stop in data.stops) {
      if (stop.trim().isNotEmpty) {
        _addStopController(stop);
      }
    }

    _addStopController();
  }

  @override
  void dispose() {
    for (final controller in _mainControllers) {
      controller.removeListener(_emitChange);
      controller.dispose();
    }

    _dateController.dispose();
    _timeController.dispose();

    for (final controller in _stops) {
      controller.dispose();
    }

    super.dispose();
  }

  void _emitChange() {
    if (!mounted) return;

    final stops = _stops
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    widget.onChanged(
      AnnounceData(
        depart: _departController.text.trim(),
        destination: _destinationController.text.trim(),
        meetingPlace: _meetingController.text.trim(),
        arrivalPlace: _arrivalPlaceController.text.trim(),
        date: _selectedDate,
        time: _selectedTime,
        stops: stops,
        seats: int.tryParse(_seatsController.text.trim()),
        price: int.tryParse(_priceController.text.trim()),
      ),
    );
  }

  void _addStopController([String text = ""]) {
    final controller = TextEditingController(text: text);
    controller.addListener(() => _handleStopEdited(controller));
    _stops.add(controller);
  }

  void _handleStopEdited(TextEditingController controller) {
    final isLast = _stops.isNotEmpty && identical(_stops.last, controller);

    if (isLast && controller.text.trim().isNotEmpty) {
      setState(() {
        _addStopController();
      });
    }

    _emitChange();
  }

  void _removeStop(int index) {
    if (_stops.length <= 1) return;

    setState(() {
      final controller = _stops.removeAt(index);
      controller.dispose();

      if (_stops.isEmpty || _stops.last.text.trim().isNotEmpty) {
        _addStopController();
      }
    });

    _emitChange();
  }

  Future<void> _selectDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final initialDate = _selectedDate != null && !_selectedDate!.isBefore(today)
        ? _selectedDate!
        : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 2, today.month, today.day),
      locale: const Locale('fr', 'FR'),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = DateUtils.dateOnly(picked);
      _dateController.text = _formatDate(picked);
    });

    _emitChange();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked == null) return;

    setState(() {
      _selectedTime = picked;
      _timeController.text = _formatTime(picked);
    });

    _emitChange();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isWide),
              const SizedBox(height: 18),
              _buildSection(
                title: "Itinéraire",
                subtitle: "Définissez le trajet principal et les points précis.",
                child: _ResponsiveFields(
                  children: [
                    _buildPlaceField(
                      controller: _departController,
                      label: "Départ",
                      placeholder: "Ex : Treichville, Bouaké...",
                      icon: Icons.location_on_outlined,
                      onSelected: (place) {
                        fromPlace = place;
                        _emitChange();
                      },
                    ),
                    _buildPlaceField(
                      controller: _destinationController,
                      label: "Destination",
                      placeholder: "Ex : Cocody, San-Pédro...",
                      icon: Icons.flag_outlined,
                      onSelected: (place) {
                        toPlace = place;
                        _emitChange();
                      },
                    ),
                    _ModernTextField(
                      controller: _meetingController,
                      label: "Lieu de rencontre",
                      placeholder: "Ex : Gare, station, rond-point...",
                      icon: Icons.location_city_outlined,
                    ),
                    _ModernTextField(
                      controller: _arrivalPlaceController,
                      label: "Lieu de dépôt",
                      placeholder: "Ex : Hyper U, arrêt précis...",
                      icon: Icons.place_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: "Arrêts facultatifs",
                subtitle: "Ajoutez les villes ou quartiers traversés.",
                child: _buildStops(),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: "Date, places et prix",
                subtitle: "Renseignez les informations utiles aux passagers.",
                child: _ResponsiveFields(
                  children: [
                    _ModernTextField(
                      controller: _dateController,
                      label: "Date de départ",
                      placeholder: "Choisir une date",
                      icon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    _ModernTextField(
                      controller: _timeController,
                      label: "Heure de départ",
                      placeholder: "Choisir une heure",
                      icon: Icons.access_time,
                      readOnly: true,
                      onTap: _selectTime,
                    ),
                    _ModernTextField(
                      controller: _seatsController,
                      label: "Nombre de places",
                      placeholder: "Ex : 3",
                      icon: Icons.event_seat_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _ModernTextField(
                      controller: _priceController,
                      label: "Prix par place",
                      placeholder: "Ex : 2500",
                      icon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      suffixText: "F CFA",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 24 : 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.add_road,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nouvelle annonce",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Créez un trajet clair, complet et facile à réserver.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPlaceField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    required ValueChanged<PlaceRef> onSelected,
  }) {
    return _FieldShell(
      child: PlaceAutocompleteField(
        controller: controller,
        label: label,
        placeholder: placeholder,
        prefixIcon: Icon(icon, color: _primary),
        onSelected: onSelected,
      ),
    );
  }

  Widget _buildStops() {
    return Column(
      children: List.generate(_stops.length, (index) {
        final controller = _stops[index];
        final isTrailingEmpty =
            index == _stops.length - 1 && controller.text.trim().isEmpty;

        return Padding(
          padding: EdgeInsets.only(bottom: index == _stops.length - 1 ? 0 : 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FieldShell(
                  child: PlaceAutocompleteField(
                    controller: controller,
                    label: isTrailingEmpty
                        ? "Ajouter un arrêt"
                        : "Arrêt ${index + 1}",
                    placeholder: "Ex : Yopougon, Adjamé, Bassam...",
                    prefixIcon: const Icon(
                      Icons.alt_route,
                      color: _primary,
                    ),
                    onSelected: (place) {
                      controller.text = place.display;
                      _emitChange();
                    },
                  ),
                ),
              ),
              if (!isTrailingEmpty || _stops.length > 1) ...[
                const SizedBox(width: 10),
                Tooltip(
                  message: "Supprimer cet arrêt",
                  child: IconButton.filledTonal(
                    onPressed: () => _removeStop(index),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      backgroundColor: Colors.red.shade50,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    final depart = _departController.text.trim().isEmpty
        ? "Départ"
        : _departController.text.trim();
    final destination = _destinationController.text.trim().isEmpty
        ? "Destination"
        : _destinationController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.route, color: _primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$depart → $destination",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _priceController.text.trim().isEmpty
                ? "Prix à définir"
                : "${_priceController.text.trim()} F CFA",
            style: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveFields({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 720;
        final spacing = useTwoColumns ? 12.0 : 0.0;
        final itemWidth = useTwoColumns
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: children
              .map(
                (child) => SizedBox(
              width: itemWidth,
              child: child,
            ),
          )
              .toList(),
        );
      },
    );
  }
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;

  const _ModernTextField({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        suffixText: suffixText,
        prefixIcon: Icon(icon, color: _primary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _softBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primary, width: 1.4),
        ),
      ),
    );
  }
}

class _FieldShell extends StatelessWidget {
  final Widget child;

  const _FieldShell({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _softBorder),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: _muted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .05),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}