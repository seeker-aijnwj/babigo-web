import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSearchScreen extends StatefulWidget {

  final void Function(String depart, String destination, String? date) onSearch;

  const AdminSearchScreen({
    super.key,
    required this.onSearch,
  });

  @override
  State<AdminSearchScreen> createState() => _AdminSearchScreenState();
}

class _AdminSearchScreenState extends State<AdminSearchScreen> {
  final TextEditingController _departController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  static const Color _primary = Color(0xFF1F6FEB);
  static const Color _ink = Color(0xFF0F172A);
  static const Color _muted = Color(0xFF64748B);
  static const Color _border = Color(0xFFE2E8F0);
  static const Color _softBlue = Color(0xFFEFF6FF);

  @override
  void dispose() {
    _departController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    final dep = _departController.text.trim();
    final dest = _destinationController.text.trim();
    final dat = _dateController.text.trim().isEmpty
        ? null
        : _dateController.text.trim();

    if (dep.isEmpty || dest.isEmpty) {
      _showSnack("Veuillez renseigner le départ et la destination.");
      return;
    }

    widget.onSearch(dep, dest, dat);
  }

  void _clearForm() {
    setState(() {
      _departController.clear();
      _destinationController.clear();
      _dateController.clear();
      _selectedDate = null;
    });
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 2),
      locale: const Locale('fr', 'FR'),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isWide ? 24 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroCard(),
                  const SizedBox(height: 18),
                  _buildSearchCard(isWide),
                  const SizedBox(height: 18),
                  _buildHelperCards(isWide),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.admin_panel_settings,
              color: _primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Recherche rapide des trajets disponibles pour assister un passager ou vérifier une réservation.",
              style: TextStyle(
                color: _ink,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(bool isWide) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: "Informations du trajet",
            subtitle: "La date est facultative pour élargir la recherche.",
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: isWide ? 421 : double.infinity,
                child: _ModernInput(
                  controller: _departController,
                  label: "Départ",
                  placeholder: "Ex : Cocody, Plateau...",
                  icon: Icons.location_on_outlined,
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                width: isWide ? 421 : double.infinity,
                child: _ModernInput(
                  controller: _destinationController,
                  label: "Destination",
                  placeholder: "Ex : Yopougon, Aéroport...",
                  icon: Icons.flag_outlined,
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                width: isWide ? 421 : double.infinity,
                child: _ModernInput(
                  controller: _dateController,
                  label: "Date",
                  placeholder: "Toutes les dates",
                  icon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: _pickDate,
                  suffixIcon: _dateController.text.isEmpty
                      ? null
                      : IconButton(
                    tooltip: "Effacer la date",
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                        _dateController.clear();
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          isWide ? _buildWideActions() : _buildMobileActions(),
        ],
      ),
    );
  }

  Widget _buildWideActions() {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: _clearForm,
          icon: const Icon(Icons.refresh),
          label: const Text("Réinitialiser"),
          style: OutlinedButton.styleFrom(
            foregroundColor: _primary,
            side: const BorderSide(color: _primary),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _onSearchPressed,
          icon: const Icon(Icons.search),
          label: const Text("Rechercher"),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _onSearchPressed,
          icon: const Icon(Icons.search),
          label: const Text("Rechercher"),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _clearForm,
          icon: const Icon(Icons.refresh),
          label: const Text("Réinitialiser"),
          style: OutlinedButton.styleFrom(
            foregroundColor: _primary,
            side: const BorderSide(color: _primary),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelperCards(bool isWide) {
    final cards = [
      const _HelperCard(
        icon: Icons.tune,
        title: "Recherche flexible",
        text: "Laissez la date vide pour voir tous les trajets correspondants.",
      ),
      const _HelperCard(
        icon: Icons.verified_user_outlined,
        title: "Contrôle admin",
        text: "Vérifiez les trajets avant d’aider le passager à réserver.",
      ),
    ];

    if (isWide) {
      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 12),
          Expanded(child: cards[1]),
        ],
      );
    }

    return Column(
      children: [
        cards[0],
        const SizedBox(height: 12),
        cards[1],
      ],
    );
  }
}

class _ModernInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const _ModernInput({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: Icon(icon, color: _AdminSearchScreenState._primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _AdminSearchScreenState._border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: _AdminSearchScreenState._primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informations du trajet",
          style: TextStyle(
            color: _AdminSearchScreenState._ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "La date est facultative pour élargir la recherche.",
          style: TextStyle(
            color: _AdminSearchScreenState._muted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _HelperCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _HelperCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _AdminSearchScreenState._softBlue,
            child: Icon(icon, color: _AdminSearchScreenState._primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _AdminSearchScreenState._ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: _AdminSearchScreenState._muted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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