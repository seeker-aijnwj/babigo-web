import 'package:flutter/material.dart';
import 'admin_search_results_screen.dart';
import 'admin_search_screen.dart';

class AdminSearchTab extends StatefulWidget {
  const AdminSearchTab({super.key});

  @override
  State<AdminSearchTab> createState() => _AdminSearchTabState();
}

class _AdminSearchTabState extends State<AdminSearchTab> {
  bool showResults = false;
  String? depart;
  String? destination;
  String? date;

  void showSearchResults(
      String departureText,
      String destinationText,
      String? dateSearch,
      ) {
    setState(() {
      depart = departureText;
      destination = destinationText;
      date = dateSearch;
      showResults = true;
    });
  }

  void resetSearch() {
    setState(() {
      showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Faire une réservation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,

        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return Column(
                children: [

                  const SizedBox(height: 18),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isDesktop ? 28 : 16,
                        0,
                        isDesktop ? 28 : 16,
                        isDesktop ? 28 : 16,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: showResults
                            ? _buildResultsPanel()
                            : AdminSearchScreen(
                          onSearch: (departure, destination, dateSearch) {
                            showSearchResults(departure, destination, dateSearch);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
  }

  Widget _buildResultsPanel() {
    return _ModernPanel(
      key: const ValueKey("admin-search-results"),
      title: "Résultats de recherche",
      subtitle: _resultSubtitle,
      icon: Icons.route,
      trailing: TextButton.icon(
        onPressed: resetSearch,
        icon: const Icon(Icons.arrow_back),
        label: const Text("Modifier"),
      ),
      child: AdminSearchResultScreen(
        depart: depart ?? "",
        destination: destination ?? "",
        date: date,
        onBack: resetSearch,
      ),
    );
  }

  String get _resultSubtitle {
    final departureText = depart?.trim().isNotEmpty == true ? depart! : "Départ";
    final destinationText =
    destination?.trim().isNotEmpty == true ? destination! : "Destination";
    final dateText = date?.trim().isNotEmpty == true ? " · $date" : "";

    return "$departureText → $destinationText$dateText";
  }

}

class _ModernPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _ModernPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Icon(
                    icon,
                    color: const Color(0xFF1F6FEB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 10),
                  trailing!,
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}