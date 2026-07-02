import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../app/core/themes/admin_light_theme.dart';
import '../database/models/admin/announcement.dart';
import '../database/services/admin_data_service.dart';
import '../screens/booking/operations/announcement_details_panel.dart';

/// ============================================================================
/// ANNOUNCE VIEW
/// ============================================================================
///
///             Interface Desktop inspirée de WhatsApp Desktop.
///
/// ┌───────────────────────────────────┬─────────────────────────────────────┐
/// │                                   │                                     │
/// │      LISTE DES OPERATIONS         │       DÉTAILS DE L'OPERATION        │
/// │                                   │                                     │
/// └───────────────────────────────────┴─────────────────────────────────────┘
///
/// ============================================================================

class AnnounceView extends StatefulWidget {
  const AnnounceView({super.key});

  @override
  State<AnnounceView> createState() =>
      _AnnounceViewState();
}

class _AnnounceViewState extends State<AnnounceView> {

  /// ==========================================================================
  /// CONTROLLERS
  /// ==========================================================================

  /// SEARCH
  final TextEditingController _searchController = TextEditingController();

  /// ==========================================================================
  /// ÉTAT
  /// ==========================================================================

  Announcement? _selectedAnnounce;

  /// ==========================================================================
  /// BUILD
  /// ==========================================================================

  @override
  Widget build(BuildContext context) {

    final isDesktop =
        MediaQuery.of(context).size.width >= 1000;

    return Scaffold(

      backgroundColor: UGOAdminTheme.background,

      body: Row(

        children: [

          /// ===============================================================
          /// ZONE GAUCHE
          /// ===============================================================

          Expanded(
            flex: 4,

            child: Container(

              color: Colors.white,

              child: Column(

                children: [

                  /// HEADER BAR
                  _buildHeader(),

                  /// SEARCH BAR
                  _buildSearchBar(),

                  /// LIST CONTENT
                  Expanded(
                    child: _buildCurrentList(),
                  ),

                ],
              ),
            ),
          ),

          /// ===============================================================
          /// DIVIDER
          /// ===============================================================

          if (isDesktop)
            VerticalDivider(
              width: 1,
              color: Colors.grey.shade300,
            ),

          /// ===============================================================
          /// ZONE DROITE
          /// ===============================================================

          if (isDesktop)
            Expanded(
              flex: 7,

              child: _buildDetailsZone(
                _selectedAnnounce,
              ),
            ),
        ],
      ),
    );
  }



  /// ==========================================================================
  /// HEADER
  /// ==========================================================================

  Widget _buildHeader() {

    return Container(

      padding: const EdgeInsets.all(16),

      child: Row(

        children: [

          const CircleAvatar(
            radius: 22,
            backgroundColor: UGOAdminTheme.primaryBlue,
            child: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  "Annonces",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Gestion des activités",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          /// =====================================================
          /// ACTIONS
          /// =====================================================

          IconButton(
            onPressed: () {
              _showCreateTripDialog();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// SEARCH BAR
  /// ==========================================================================

  Widget _buildSearchBar() {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: TextField(

        controller: _searchController,

        decoration: InputDecoration(

          hintText:
          "Rechercher un trajet ou une annonce...",

          prefixIcon:
          const Icon(Icons.search),

          filled: true,

          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

            borderSide: BorderSide.none,
          ),
        ),

        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  /// =============================================================
  /// CURRENT LIST
  /// =============================================================

  Widget _buildCurrentList() {

    return _buildAnnouncementsList(isDesktop: true);

  }


  /// =============================================================
  /// ZONE DE DROITE
  /// =============================================================

  Widget _buildDetailsZone(Announcement? selectedAnnounce) {

    if (selectedAnnounce != null) {

      return AnnouncementDetailsPanel(
          announcement: selectedAnnounce
      );

    } else {
      return _buildEmptyState();
    }

  }



  /// ==========================================================================
  /// FILTRES
  /// ==========================================================================

  /// ===============================================================
  /// LISTE DES ANNONCES
  /// ===============================================================
  ///
  /// OBJECTIF
  /// ---------
  ///
  /// Afficher tous les annonces provenant de Firebase.
  ///
  /// Cette version :
  ///
  /// ✅ écoute Firestore en temps réel
  /// ✅ convertit Firestore -> Announce_Reservation
  /// ✅ supporte Desktop + Mobile
  /// ✅ gère les erreurs
  /// ✅ sélectionne un trajet
  /// ✅ ouvre les détails du trajet
  /// ✅ UI moderne et fluide
  ///
  /// ===============================================================
  Widget _buildAnnouncementsList({
    required bool isDesktop,
  }) {
    return StreamBuilder<QuerySnapshot>(

      /// ===========================================================
      /// STREAM FIRESTORE
      /// ===========================================================
      ///
      /// Collection :
      /// trips
      ///
      /// Ordre :
      /// les annonces/réservations récentes d'abord
      ///
      stream: AdminDataService.streamReservations(),

      builder: (context, snapshot) {

        /// =========================================================
        /// CHARGEMENT
        /// =========================================================

        if (snapshot.connectionState == ConnectionState.waiting) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// =========================================================
        /// ERREUR
        /// =========================================================

        if (snapshot.hasError) {

          return Center(
            child: Text(
              "Erreur : ${snapshot.error}",
            ),
          );
        }

        /// =========================================================
        /// AUCUNE DONNÉE
        /// =========================================================

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {

          return Center(

            child: Column(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.campaign_outlined,
                  size: 60,
                  color: Colors.grey[300],
                ),

                const SizedBox(height: 12),

                const Text(
                  "Aucune annonce/réservation trouvé(e).",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        /// =========================================================
        /// CONVERSION FIRESTORE -> ANNOUNCEMENT
        /// =========================================================

        List<Announcement> announces = [];

        for (final doc in snapshot.data!.docs) {

          try {

            final announce = Announcement.getAnnounceReservationData(doc);

            announces.add(announce);

          } catch (e) {

            debugPrint(
              "Erreur conversion annonce : $e",
            );
          }
        }

        /// =========================================================
        /// AUCUNE ANNONCE TROUVEE
        /// =========================================================

        if (announces.isEmpty) {

          return const Center(
            child: Text(
              "Aucune annonce trouvée",
            ),
          );
        }

        /// =========================================================
        /// LIST VIEW
        /// =========================================================

        return ListView.separated(

          itemCount: announces.length,

          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: Colors.grey.shade100,
          ),

          itemBuilder: (context, index) {

            final announce = announces[index];

            /// =====================================================
            /// ANNONCE SÉLECTIONNÉE
            /// =====================================================

            final selected = _selectedAnnounce?.id == announce.id;

            /// =====================================================
            /// COULEUR STATUT
            /// =====================================================

            final color = _getStatusColor(
              announce.status.name,
            );

            /// =====================================================
            /// ITEM
            /// =====================================================

            return AnimatedContainer(

              duration: const Duration(
                milliseconds: 200,
              ),

              color: selected
                  ? UGOAdminTheme.primaryBlue
                  .withValues(alpha: .05)
                  : Colors.transparent,

              child: ListTile(

                selected: selected,

                selectedTileColor: UGOAdminTheme.primaryBlue
                    .withValues(alpha: .06),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                /// =================================================
                /// ICÔNE
                /// =================================================

                leading: Container(

                  width: 52,
                  height: 52,

                  decoration: BoxDecoration(

                    color: color.withValues(alpha: .1),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(
                    Icons.route,
                    color: color,
                    size: 24,
                  ),
                ),

                /// =================================================
                /// TITRE
                /// =================================================

                title: Text(

                  announce.announceNumber!,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                /// =================================================
                /// DESCRIPTION
                /// =================================================

                subtitle: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const SizedBox(height: 4),

                    /// Places
                    Text(
                      "${announce.reservedCount}/${announce.seats} places réservées",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                  ],
                ),

                /// =================================================
                /// BADGE STATUT
                /// =================================================

                trailing: Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color: color.withValues(alpha: .1),

                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Text(

                    announce.status.name.toString(),

                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),

                /// =================================================
                /// CLICK
                /// =================================================

                onTap: () {

                  /// ===============================================
                  /// VERSION DESKTOP
                  /// ===============================================

                  if (isDesktop) {

                    setState(() {
                      _selectedAnnounce = announce;
                    });

                  }

                  /// ===============================================
                  /// VERSION MOBILE
                  /// ===============================================

                  else {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => Scaffold(

                          appBar: AppBar(
                            title: Text(
                              announce.announceNumber!,
                            ),
                          ),

                          body: AnnouncementDetailsPanel(
                              announcement: announce
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  /// ==========================================================================
  /// EMPTY STATE
  /// ==========================================================================

  Widget _buildEmptyState() {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            Icons.touch_app,
            size: 70,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          Text(
            "Sélectionnez une opération",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// CREATE TRIP
  /// ==========================================================================

  void _showCreateTripDialog() {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
        Text("Création trajet bientôt"),
      ),
    );
  }

  /// ==========================================================================
  /// STATUS FUNCTIONS
  /// ==========================================================================

  Color _getStatusColor(String status) {

    switch (status) {

      case 'draft': return Colors.black38;

      case 'archived': return Colors.yellow;

      case 'deleted': return Colors.red;

      case "published": return Colors.blue;

      case "started": return Colors.orange;

      case "completed": return Colors.greenAccent;

      case "cancelled": return Colors.red;

      case "full": return Colors.green;

      default: return Colors.grey;
    }
  }

}