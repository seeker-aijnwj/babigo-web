import 'package:babigo/app/database/models/vehicle.dart';
import 'package:babigo/modules/vehicle_module/screens/vehicule_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../app/core/themes/admin_light_theme.dart';
import '../database/services/admin_data_service.dart';

/// ============================================================================
/// Vehicle VIEW
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

class VehicleView extends StatefulWidget {
  const VehicleView({super.key});

  @override
  State<VehicleView> createState() =>
      _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView> {

  /// ==========================================================================
  /// CONTROLLERS
  /// ==========================================================================

  /// SEARCH
  final TextEditingController _searchController = TextEditingController();

  /// ==========================================================================
  /// ÉTAT
  /// ==========================================================================

  Vehicle? _selectedVehicle;

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
                _selectedVehicle
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
                  "Opérations",
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
              _showCreateVehicleDialog();
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
    return _buildVehiclesList(isDesktop: true);
  }


  /// =============================================================
  /// ZONE DE DROITE
  /// =============================================================

  Widget _buildDetailsZone(Vehicle? selectedVehicle) {

    if (selectedVehicle != null) {

      return VehicleDetailScreen(
          vehicle: selectedVehicle
      );

    } else {
      return _buildEmptyState();
    }

  }

  /// ==========================================================================
  /// FILTRES
  /// ==========================================================================


  /// ===============================================================
  /// LISTE DES VEHICULES
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
  /// ✅ ouvre les détails du trajetù
  /// ✅ UI moderne et fluide
  ///
  /// ===============================================================
  Widget _buildVehiclesList({
    required bool isDesktop,
  }) {
    return StreamBuilder<QuerySnapshot>(

      /// ===========================================================
      /// STREAM FIRESTORE
      /// ===========================================================
      ///
      /// Collection :
      /// /users/{uid}/vehicles
      ///
      /// Ordre :
      /// les véhicules ajoutées récemment d'abord
      ///
      stream: AdminDataService.streamAllVehicles(),

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
                  Icons.directions_car_outlined,
                  size: 60,
                  color: Colors.grey[300],
                ),

                const SizedBox(height: 12),

                const Text(
                  "Aucun véhicule trouvé",
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
        /// CONVERSION FIRESTORE -> VEHICULE
        /// =========================================================

        List<Vehicle> vehicles = [];

        for (final doc in snapshot.data!.docs) {

          try {

            final vehicle = Vehicle.fromFirestore(doc);

            vehicles.add(vehicle);

          } catch (e) {

            debugPrint(
              "Erreur conversion véhicule : $e",
            );
          }
        }

        /// =========================================================
        /// AUCUN VEHICULE VALIDE
        /// =========================================================

        if (vehicles.isEmpty) {

          return const Center(
            child: Text(
              "Aucun véhicule trouvée",
            ),
          );
        }

        /// =========================================================
        /// LIST VIEW
        /// =========================================================

        return ListView.separated(

          itemCount: vehicles.length,

          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: Colors.grey.shade100,
          ),

          itemBuilder: (context, index) {

            final vehicle = vehicles[index];

            /// =====================================================
            /// VEHICULE SÉLECTIONNÉ
            /// =====================================================

            final selected = _selectedVehicle?.id == vehicle.id;


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

                    color: Colors.yellow.withValues(alpha: .1),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(
                    (vehicle.isAvailable)
                        ? Icons.garage_sharp
                        : Icons.directions_car_filled_rounded,
                    color: Colors.yellow,
                    size: 24,
                  ),
                ),

                /// =================================================
                /// TITRE
                /// =================================================

                title: Text(

                  "Véhicule $index",

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
                      vehicle.seats.toString(),
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

                    color: Colors.yellow.withValues(alpha: .1),

                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Text(

                    "-",

                    style: TextStyle(
                      color: Colors.yellow,
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
                      _selectedVehicle = vehicle;
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
                              "+",
                            ),
                          ),

                          body: VehicleDetailScreen(vehicle: vehicle),
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
  ///
  /// ==========================================================================


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
  /// CREATE Vehicle
  /// ==========================================================================

  void _showCreateVehicleDialog() {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
        Text("Création trajet bientôt"),
      ),
    );
  }

}