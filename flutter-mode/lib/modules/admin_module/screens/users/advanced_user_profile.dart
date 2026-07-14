/// ===============================================================
/// Widget professionnel d'affichage détaillé d'un utilisateur.
///
/// OBJECTIF :
/// ----------
///
/// Centraliser toute l’UI utilisateur dans un widget réutilisable.
///
/// Ce widget pourra être utilisé dans :
///
/// - UsersPage
/// - Dashboard
/// - SupportPage
/// - RideDetailsPage
/// - PaymentDetailsPage
/// - FleetPage
/// - Dialogs
/// - Drawer Desktop
/// - Modal Desktop
///
///
/// POURQUOI StatefulWidget ?
/// -------------------------
///
/// Même si actuellement ce widget affiche surtout des données,
/// nous choisissons StatefulWidget car :
///
/// ✅ possibilité future de :
///
/// - charger données dynamiquement
/// - afficher loading states
/// - modifier utilisateur en live
/// - gérer expansion panels
/// - upload photo
/// - refresh utilisateur
/// - afficher onglets
/// - écouter Firebase temps réel
/// - animations
/// - actions admin
///
///
/// Ce choix évite de devoir tout refactoriser plus tard.
///
/// ===============================================================
import 'package:babigo/modules/admin_module/screens/users/admin_fleet_manager_main_screen.dart';
import 'package:flutter/material.dart';
import '../../../../app/core/utils/colors.dart';
import '../../database/models/admin/utilisateur.dart';
import '../../widgets/recent_announces_section.dart';
import 'admin_driver_main_screen.dart';

// Actions
import 'admin_passenger_main_screen.dart';
import 'admin_superadmin_main_screen.dart';
import 'admin_support_main_screen.dart';
import 'admin_wallet_screen.dart';
import 'drivers/user_form_screen.dart';


class AdvancedUserProfileWidget extends StatefulWidget {

  /// ===========================================================
  /// UTILISATEUR À AFFICHER
  /// ===========================================================

  final Utilisateur user;

  /// ===========================================================
  /// CALLBACKS OPTIONNELS
  /// ===========================================================

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  final VoidCallback? onBlock;

  final VoidCallback? onMessage;

  final VoidCallback? onPayments;

  final VoidCallback? onTrips;

  /// ===========================================================
  /// CONSTRUCTEUR
  /// ===========================================================

  const AdvancedUserProfileWidget({
    super.key,
    required this.user,
    this.onEdit,
    this.onDelete,
    this.onBlock,
    this.onMessage,
    this.onPayments,
    this.onTrips,
  });

  @override
  State<AdvancedUserProfileWidget> createState() =>
      _AdvancedUserProfileWidgetState();
}

class _AdvancedUserProfileWidgetState
    extends State<AdvancedUserProfileWidget> {

  /// ===========================================================
  /// GETTER UTILISATEUR
  /// ===========================================================

  Utilisateur get user => widget.user;

  /// ===========================================================
  /// BUILD
  /// ===========================================================

  @override
  Widget build(BuildContext context) {

    final bool isBlocked =
        user.status == UserStatus.blocked;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // =====================================================
          // HEADER UTILISATEUR
          // =====================================================

          _buildHeader(isBlocked),

          const SizedBox(height: 24),

          // =====================================================
          // INFORMATIONS PERSONNELLES
          // =====================================================

          _buildSection(
            title: "Informations personnelles",
            icon: Icons.person,

            children: [

              _buildInfoTile(
                Icons.badge,
                "Nom complet",
                user.fullName,
              ),

              _buildInfoTile(
                Icons.person_outline,
                "Prénom",
                user.firstName,
              ),

              _buildInfoTile(
                Icons.person_2_outlined,
                "Nom",
                user.lastName,
              ),

              _buildInfoTile(
                Icons.email_outlined,
                "Email",
                user.email,
              ),

              _buildInfoTile(
                Icons.phone,
                "Téléphone",
                user.phone,
              ),

              _buildInfoTile(
                Icons.wc,
                "Genre",
                user.gender,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // LOCALISATION
          // =====================================================

          _buildSection(
            title: "Localisation",
            icon: Icons.location_on,

            children: [

              _buildInfoTile(
                Icons.location_city,
                "Ville",
                user.city,
              ),

              _buildInfoTile(
                Icons.map,
                "Commune",
                user.district,
              ),

              _buildInfoTile(
                Icons.home,
                "Adresse",
                user.address,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // ANNONCES
          // =====================================================

          RecentAnnouncesSection(selectedUser: user),

          const SizedBox(height: 20),

          // =====================================================
          // STATISTIQUES
          // =====================================================

          _buildStatsSection(),

          const SizedBox(height: 20),

          // =====================================================
          // FINANCES
          // =====================================================

          _buildFinanceSection(),

          const SizedBox(height: 20),

          // =====================================================
          // DOCUMENTS
          // =====================================================

          _buildDocumentsSection(),

          const SizedBox(height: 20),

          // =====================================================
          // ACTIONS ADMIN
          // =====================================================

          _buildActionsSection(isBlocked),
        ],
      ),
    );
  }

  /// ===========================================================
  /// HEADER
  /// ===========================================================

  Widget _buildHeader(bool isBlocked) {

    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          // =====================================================
          // AVATAR
          // =====================================================

          CircleAvatar(
            radius: 55,

            backgroundColor: isBlocked
                ? Colors.red.shade100
                : AppColors.primary.withValues(alpha: .1),

            backgroundImage:
                user.photoUrl.isNotEmpty
                    ? NetworkImage(user.photoUrl)
                    : null,

            child: user.photoUrl.isEmpty
                ? Text(
                    user.initials,

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                      color: isBlocked
                          ? Colors.red
                          : AppColors.primary,
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 24),

          // =====================================================
          // INFOS
          // =====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  user.fullName,

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  user.role.name.toUpperCase(),

                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 14),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,

                  children: [

                    _buildTag(
                      Icons.verified,
                      user.isVerified
                          ? "Vérifié"
                          : "Non vérifié",

                      user.isVerified
                          ? Colors.green
                          : Colors.orange,
                    ),

                    _buildTag(
                      Icons.shield,
                      user.kycValidated
                          ? "KYC validé"
                          : "KYC non validé",

                      user.kycValidated
                          ? Colors.green
                          : Colors.red,
                    ),

                    _buildTag(
                      Icons.lock,
                      isBlocked
                          ? "Compte bloqué"
                          : "Compte actif",

                      isBlocked
                          ? Colors.red
                          : Colors.green,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ===========================================================
  /// SECTION GÉNÉRIQUE
  /// ===========================================================

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,
                color: AppColors.primary,
              ),

              const SizedBox(width: 10),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }

  /// ===========================================================
  /// TILE INFO
  /// ===========================================================

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
  ) {

    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: Icon(icon),

      title: Text(label),

      subtitle: Text(value),
    );
  }

  /// ===========================================================
  /// TAG
  /// ===========================================================

  Widget _buildTag(
    IconData icon,
    String label,
    Color color,
  ) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 16,
            color: color,
          ),

          const SizedBox(width: 6),

          Text(
            label,

            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ===========================================================
  /// SECTION STATS
  /// ===========================================================

  Widget _buildStatsSection() {

    return _buildSection(
      title: "Statistiques",
      icon: Icons.analytics,

      children: [

        Row(
          children: [

            Expanded(
              child: _buildStatCard(
                "Trajets",
                "${user.totalTrips}",
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: _buildStatCard(
                "Complétés",
                "${user.completedTrips}",
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: _buildStatCard(
                "Note",
                "${user.rating}",
              ),
            ),
          ],
        )
      ],
    );
  }

  /// ===========================================================
  /// STAT CARD
  /// ===========================================================

  Widget _buildStatCard(
    String title,
    String value,
  ) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [

          Text(title),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ===========================================================
  /// FINANCES
  /// ===========================================================

  Widget _buildFinanceSection() {

    return _buildSection(
      title: "Finances",
      icon: Icons.account_balance_wallet,

      children: [

        _buildInfoTile(
          Icons.wallet,
          "Portefeuille",
          "${user.walletBalance} FCFA",
        ),

        _buildInfoTile(
          Icons.trending_up,
          "Revenus",
          "${user.totalEarnings} FCFA",
        ),

        _buildInfoTile(
          Icons.shopping_cart,
          "Dépenses",
          "${user.totalSpent} FCFA",
        ),
      ],
    );
  }

  /// ===========================================================
  /// DOCUMENTS
  /// ===========================================================

  Widget _buildDocumentsSection() {

    return _buildSection(
      title: "Documents",
      icon: Icons.folder,

      children: [

        _buildInfoTile(
          Icons.badge,
          "CNI",
          user.nationalIdUrl.isNotEmpty
              ? "Disponible"
              : "Non fourni",
        ),

        _buildInfoTile(
          Icons.drive_eta,
          "Permis",
          user.driverLicenseUrl.isNotEmpty
              ? "Disponible"
              : "Non fourni",
        ),
      ],
    );
  }

  /// ===========================================================
  /// ACTIONS ADMIN
  /// ===========================================================

  Widget _buildActionsSection(bool isBlocked) {

    return _buildSection(
      title: "Actions administratives",
      icon: Icons.admin_panel_settings,

      children: [

        Wrap(
          spacing: 16,
          runSpacing: 16,

          children: [


            // Option Conducteur : Aspect Conducteur
            ElevatedButton.icon(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminDriverMainScreen(selectedUser: user),
                  ),
                );
              },
              icon: const Icon(Icons.local_taxi),
              label: const Text("Mode Conducteur"),
            ),

            // Option Passager : Aspect Passager
            ElevatedButton.icon(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminPassengerMainScreen(selectedUser: user),
                  ),
                );
              },
              icon: const Icon(Icons.airline_seat_recline_extra_outlined),
              label: const Text("Mode Passager"),
            ),

            // Ajouter un utilisateur
            ElevatedButton.icon(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserFormScreen(),
                  ),
                );
              },

              icon: const Icon(Icons.person_add),

              label: const Text("Nouveau"),
            ),

            // Option Gestionnaire de flotte : Aspect Gestionnaire
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminFleetManagerMainScreen(selectedUser: user,),
                  ),
                );
              },
              icon: const Icon(Icons.person_pin_outlined),
              label: const Text("Mode Gestionnaire"),
            ),

            // Option Support : Aspect Support
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminSupportMainScreen(selectedUser: user,),
                  ),
                );
              },
              icon: const Icon(Icons.support_agent),
              label: const Text("Mode Support"),
            ),

            // Option Admin : Aspect Admin
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminSuperAdminMainScreen(selectedUser: user,),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings_rounded),
              label: const Text("Mode Admin"),
            ),

            // Modifier les informations de l'utilisateur
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserFormScreen(selectedUser: user,),
                  ),
                );
              },

              icon: const Icon(Icons.edit_note),

              label: const Text("Editer les infos"),
            ),

            // Accéder à son portefeuille
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminWalletScreen(selectedUser: user,),
                  ),
                );
              },

              /*
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),*/

              icon: const Icon(Icons.account_balance_wallet),

              label: const Text("Portefeuille"),
            ),

            // Envoyer un message
            ElevatedButton.icon(
              onPressed: widget.onMessage,
              icon: const Icon(Icons.message),
              label: const Text("Message"),
            ),

            ElevatedButton.icon(
              onPressed: widget.onPayments,
              icon: const Icon(Icons.payment),
              label: const Text("Paiements"),
            ),

            ElevatedButton.icon(
              onPressed: widget.onTrips,
              icon: const Icon(Icons.alt_route),
              label: const Text("Trajets"),
            ),

            // Option Administrateur : Bloquer / Débloquer
            ElevatedButton.icon(
              onPressed: widget.onBlock,
              icon: Icon(
                isBlocked ? Icons.lock_open : Icons.block,
              ),
              label: Text(
                isBlocked ? "Débloquer" : "Bloquer",
              ),
            ),

            // Option Administrateur : Supprimer (l'afficher que dans la corbeille)
            ElevatedButton.icon(
              onPressed: widget.onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(Icons.delete),
              label: const Text("Supprimer"),
            ),

          ],
        )
      ],
    );
  }
}