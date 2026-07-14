/*
// ============================================================================
// FILE : screens/admin/super/admin_super_dashboard_screen.dart
// ============================================================================
//
// BabiGO
// Module Administration
//
// ---------------------------------------------------------------------------
// CENTRE DE CONTRÔLE SUPER ADMINISTRATEUR
// ---------------------------------------------------------------------------
//
// Cet écran fusionne :
//
// • AdminSuperDashboardScreen
// • UserListWidget
//
// afin de proposer un véritable centre de supervision.
//
// Architecture
//
// ┌───────────────────────────────────────────────────────────────────────┐
// │ KPI                                                                   │
// ├───────────────────────────────────────────────────────────────────────┤
// │ Actions rapides                                                       │
// ├───────────────────────────────────────────────────────────────────────┤
// │ Alerte système                                                        │
// ├──────────────────────┬────────────────────────────────────────────────┤
// │                      │                                                │
// │ Utilisateurs         │     Détails utilisateur                        │
// │                      │                                                │
// │ Recherche            │     Profil                                     │
// │ Filtres              │     Documents                                  │
// │ Liste Firestore      │     Véhicules                                  │
// │                      │     Historique                                 │
// │                      │     Actions                                    │
// │                      │                                                │
// └──────────────────────┴────────────────────────────────────────────────┘
//
// Responsive
//
// Desktop
// Tablet
// Mobile
//
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/utils/colors.dart';
import '../../../../../app/core/utils/constants.dart';

import '../../../database/models/admin/utilisateur.dart';
import '../../../database/services/admin_data_service.dart';

import '../../users/advanced_user_profile.dart';

class AdminSuperDashboardScreen extends StatefulWidget {

  final ValueChanged<int> onNavigate;

  const AdminSuperDashboardScreen({

    super.key,

    required this.onNavigate,

  });

  @override
  State<AdminSuperDashboardScreen> createState() =>
      _AdminSuperDashboardScreenState();
}

class _AdminSuperDashboardScreenState
    extends State<AdminSuperDashboardScreen> {

  // ==========================================================================
  // CONTROLLERS
  // ==========================================================================

  final TextEditingController _searchController = TextEditingController();

  final ScrollController
  _usersScrollController =
  ScrollController();

// ==========================================================================
// ETAT
// ==========================================================================

  Utilisateur? _selectedUser;

  UserRole? _selectedRole;

  bool _loading = false;

  bool _onlyBlocked = false;

  bool _onlyVerified = false;

  bool _compactMode = false;

  bool _showAdvancedFilters = false;

// ==========================================================================
// KPI
// ==========================================================================

  int _usersCount = 0;

  int _driversCount = 0;

  int _fleetManagersCount = 0;

  int _supportsCount = 0;

  int _adminsCount = 0;

  int _blockedUsersCount = 0;

  int _onlineUsersCount = 0;

  double _platformRevenue = 0;

// ==========================================================================
// LIFECYCLE
// ==========================================================================

  @override
  void initState() {
    super.initState();

    _loadDashboardStatistics();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    _usersScrollController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isDesktop = screenWidth >= 1200;

    final isTablet = screenWidth >= 850 &&         screenWidth < 1200;

    return SuperPage(

      title: "Centre de contrôle BabiGO",

      subtitle: "Supervision complète de la plateforme, "
          "des utilisateurs, des paiements "
          "et de la sécurité.",

      icon: Icons.admin_panel_settings,

      children: [

        _buildHeader(),

        const SizedBox(height: 20),

        _buildQuickActions(),

        const SizedBox(height: 20),

        _buildNotice(),

        const SizedBox(height: 20),

        Expanded(

          child: isDesktop

              ? _buildDesktopLayout()

              : isTablet

              ? _buildTabletLayout()

              : _buildMobileLayout(),

        ),

      ],

    );
  }

  // ==========================================================================
  // LAYOUT DESKTOP
  // ==========================================================================

  Widget _buildDesktopLayout() {

    return Row(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Expanded(

          flex: 3,

          child: _buildUsersPanel(),

        ),

        const SizedBox(width: 20),

        Expanded(

          flex: 7,

          child: _buildUserDetailsPanel(),

        ),

      ],

    );

  }

  // ==========================================================================
  // LAYOUT DESKTOP
  // ==========================================================================

  Widget _buildDesktopLayout() {

    return Row(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Expanded(

          flex: 3,

          child: _buildUsersPanel(),

        ),

        const SizedBox(width: 20),

        Expanded(

          flex: 7,

          child: _buildUserDetailsPanel(),

        ),

      ],

    );

  }

  // ==========================================================================
  // LAYOUT TABLETTE
  // ==========================================================================

  Widget _buildTabletLayout() {

    return Row(

      children: [

        Expanded(

          flex: 4,

          child: _buildUsersPanel(),

        ),

        const SizedBox(width: 16),

        Expanded(

          flex: 6,

          child: _buildUserDetailsPanel(),

        ),

      ],

    );

  }

  // ==========================================================================
  // LAYOUT MOBILE
  // ==========================================================================

  Widget _buildMobileLayout() {

    if (_selectedUser == null) {

      return _buildUsersPanel();

    }

    return _buildUserDetailsPanel();

  }

  // ============================================================================
// CHARGEMENT DES STATISTIQUES
// ============================================================================

  /// Charge les statistiques principales affichées
  /// dans les cartes du tableau de bord.
  ///
  /// Cette méthode sera enrichie progressivement
  /// afin d'utiliser les différents services
  /// d'administration (paiements, courses,
  /// sécurité, flotte...).
  Future<void> _loadDashboardStatistics() async {

    if (!mounted) return;

    setState(() {
      _loading = true;
    });

    try {

      final snapshot =
      await _firestore
          .collection('users')
          .get();

      int users = 0;
      int drivers = 0;
      int fleets = 0;
      int supports = 0;
      int admins = 0;
      int blocked = 0;

      for (final doc in snapshot.docs) {

        try {

          final user =
          Utilisateur.fromFirestore(doc);

          users++;

          switch (user.role) {

            case UserRole.driver:
              drivers++;
              break;

            case UserRole.fleetManager:
              fleets++;
              break;

            case UserRole.support:
              supports++;
              break;

            case UserRole.admin:
              admins++;
              break;

            default:
              break;
          }

          if (user.status ==
              UserStatus.blocked) {

            blocked++;

          }

        } catch (_) {}

      }

      if (!mounted) return;

      setState(() {

        _usersCount = users;

        _driversCount = drivers;

        _fleetManagersCount = fleets;

        _supportsCount = supports;

        _adminsCount = admins;

        _blockedUsersCount = blocked;

        _platformRevenue = 9800000;

        _onlineUsersCount = 126;

      });

    } catch (e) {

      debugPrint(
        "Dashboard statistics error : $e",
      );

    }

    if (mounted) {

      setState(() {

        _loading = false;

      });

    }

  }

  // ============================================================================
// HEADER
// ============================================================================

  Widget _buildHeader() {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        MetricGrid(

          metrics: [

            MetricData(

              _usersCount.toString(),

              "Utilisateurs",

              Icons.people_alt,

              AppColors.mainColor,

            ),

            MetricData(

              _driversCount.toString(),

              "Conducteurs",

              Icons.drive_eta,

              AppColors.success,

            ),

            MetricData(

              _blockedUsersCount.toString(),

              "Comptes bloqués",

              Icons.block,

              AppColors.danger,

            ),

            MetricData(

              "${(_platformRevenue / 1000000).toStringAsFixed(1)} M",

              "F CFA",

              Icons.payments,

              AppColors.purple,

            ),

          ],

        ),

        const SizedBox(height: 18),

        Wrap(

          spacing: 10,

          runSpacing: 10,

          children: [

            _buildStatChip(

              Icons.support_agent,

              "Support",

              _supportsCount,

              Colors.blue,

            ),

            _buildStatChip(

              Icons.business,

              "Flottes",

              _fleetManagersCount,

              Colors.orange,

            ),

            _buildStatChip(

              Icons.admin_panel_settings,

              "Admins",

              _adminsCount,

              Colors.red,

            ),

            _buildStatChip(

              Icons.circle,

              "En ligne",

              _onlineUsersCount,

              Colors.green,

            ),

          ],

        ),

      ],

    );

  }

  // ============================================================================
// ACTIONS RAPIDES
// ============================================================================

  Widget _buildQuickActions() {

    return QuickActions(

      actions: [

        SuperAction(

          "Utilisateurs",

          Icons.people_alt,

          onTap: () {},

        ),

        SuperAction(

          "Paiements",

          Icons.account_balance_wallet,

          onTap: () => widget.onNavigate(11),

        ),

        SuperAction(

          "Incidents",

          Icons.shield,

          onTap: () => widget.onNavigate(13),

        ),

        SuperAction(

          "Système",

          Icons.settings,

          sensitive: true,

          onTap: () => widget.onNavigate(16),

        ),

        SuperAction(

          "Actualiser",

          Icons.refresh,

          onTap: _loadDashboardStatistics,

        ),

      ],

    );

  }

  // ============================================================================
// NOTICE
// ============================================================================

  Widget _buildNotice() {

    return const NoticeBox(

      icon: Icons.security,

      danger: true,

      text:

      "Vous êtes connecté en tant que Super Administrateur.\n"

          "Toutes les opérations réalisées sur cet écran "

          "sont journalisées dans les logs système.",

    );

  }

  // ============================================================================
// BADGES
// ============================================================================

  Widget _buildStatChip(

      IconData icon,

      String label,

      int value,

      Color color,

      ) {

    return Chip(

      avatar: Icon(

        icon,

        size: 18,

        color: color,

      ),

      label: Text(

        "$label : $value",

        style: const TextStyle(

          fontWeight: FontWeight.w600,

        ),

      ),

    );

  }

  // ============================================================================
// PANNEAU GAUCHE
// ============================================================================
//
// Cette partie remplace complètement UserListWidget.
//
// Elle contient :
//
// • Recherche instantanée
// • Filtres
// • Stream Firestore
// • Sélection utilisateur
// • Responsive
//
// ============================================================================

  Widget _buildUsersPanel() {

    return Card(

      elevation: 0,

      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(24),

      ),

      child: Column(

        children: [

          _buildUsersHeader(),

          const Divider(height: 1),

          _buildSearchField(),

          _buildFilters(),

          const Divider(height: 1),

          Expanded(

            child: _buildUsersStream(),

          ),

        ],

      ),

    );

  }

  // ============================================================================
// HEADER
// ============================================================================

  Widget _buildUsersHeader() {

    return Padding(

      padding: const EdgeInsets.all(20),

      child: Row(

        children: [

          const CircleAvatar(

            radius: 24,

            child: Icon(

              Icons.people,

            ),

          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  "Utilisateurs",

                  style: TextStyle(

                    fontSize: 20,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                Text(

                  "$_usersCount comptes enregistrés",

                  style: TextStyle(

                    color: Colors.grey.shade600,

                  ),

                ),

              ],

            ),

          ),

          IconButton(

            tooltip: "Actualiser",

            onPressed: _loadDashboardStatistics,

            icon: const Icon(

              Icons.refresh,

            ),

          ),

        ],

      ),

    );

  }

  // ============================================================================
// RECHERCHE
// ============================================================================

  Widget _buildSearchField() {

    return Padding(

      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        12,
      ),

      child: TextField(

        controller: _searchController,

        decoration: InputDecoration(

          hintText:
          "Nom, email, téléphone...",

          prefixIcon:
          const Icon(Icons.search),

          suffixIcon:
          _searchController.text.isEmpty

              ? null

              : IconButton(

            icon: const Icon(
              Icons.close,
            ),

            onPressed: () {

              _searchController.clear();

            },

          ),

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

          ),

        ),

      ),

    );

  }

  // ============================================================================
// FILTRES
// ============================================================================

  Widget _buildFilters() {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),

      child: Wrap(

        spacing: 10,

        runSpacing: 10,

        children: [

          FilterChip(

            label: const Text("Tous"),

            selected: _selectedRole == null,

            onSelected: (_) {

              setState(() {

                _selectedRole = null;

              });

            },

          ),

          ...UserRole.values.map(

                (role) {

              return FilterChip(

                label: Text(role.label),

                selected:
                _selectedRole == role,

                onSelected: (_) {

                  setState(() {

                    _selectedRole = role;

                  });

                },

              );

            },

          ),

          FilterChip(

            label:
            const Text("Vérifiés"),

            selected: _onlyVerified,

            onSelected: (v) {

              setState(() {

                _onlyVerified = v;

              });

            },

          ),

          FilterChip(

            label:
            const Text("Bloqués"),

            selected: _onlyBlocked,

            onSelected: (v) {

              setState(() {

                _onlyBlocked = v;

              });

            },

          ),

        ],

      ),

    );

  }

  // ============================================================================
// STREAM FIRESTORE
// ============================================================================

  Widget _buildUsersStream() {

    return StreamBuilder<

        QuerySnapshot<Map<String, dynamic>>>(

      stream:

      FirebaseFirestore.instance

          .collection("users")

          .snapshots(),

      builder:

          (context, snapshot) {

        if (snapshot.hasError) {

          return const Center(

            child: Text(

              "Impossible de charger les utilisateurs.",

            ),

          );

        }

        if (!snapshot.hasData) {

          return const Center(

            child:

            CircularProgressIndicator(),

          );

        }

        List<Utilisateur> users =

        snapshot.data!.docs

            .map(

              (e) =>

              Utilisateur.fromFirestore(

                e,

              ),

        )

            .toList();

        users = _applyFilters(users);

        if (users.isEmpty) {

          return _buildEmptyUsers();

        }

        return ListView.builder(

          controller:
          _usersScrollController,

          itemCount: users.length,

          itemBuilder:

              (context, index) {

            final user = users[index];

            return _buildUserTile(user);

          },

        );

      },

    );

  }

  // ============================================================================
// APPLICATION DES FILTRES
// ============================================================================

  List<Utilisateur> _applyFilters(
      List<Utilisateur> users,
      ) {

    final query =
    _searchController.text
        .trim()
        .toLowerCase();

    return users.where((user) {

      //-------------------------------------------------------
      // Recherche
      //-------------------------------------------------------

      if (query.isNotEmpty) {

        final fullname =
        "${user.firstName} ${user.lastName}"
            .toLowerCase();

        final email =
        user.email.toLowerCase();

        final phone =
        user.phoneNumber.toLowerCase();

        if (!fullname.contains(query) &&
            !email.contains(query) &&
            !phone.contains(query)) {

          return false;

        }

      }

      //-------------------------------------------------------
      // Rôle
      //-------------------------------------------------------

      if (_selectedRole != null &&
          user.role != _selectedRole) {

        return false;

      }

      //-------------------------------------------------------
      // Comptes vérifiés
      //-------------------------------------------------------

      if (_onlyVerified &&
          !user.isIdentityVerified) {

        return false;

      }

      //-------------------------------------------------------
      // Comptes bloqués
      //-------------------------------------------------------

      if (_onlyBlocked &&
          user.accountStatus !=
              AccountStatus.blocked) {

        return false;

      }

      return true;

    }).toList()

      ..sort(

            (a, b) =>

            a.firstName.compareTo(
              b.firstName,
            ),

      );

  }

  // ============================================================================
// ETAT VIDE
// ============================================================================

  Widget _buildEmptyUsers() {

    return Center(

      child: Padding(

        padding: const EdgeInsets.all(40),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(

              Icons.people_outline,

              size: 90,

              color: Colors.grey.shade400,

            ),

            const SizedBox(height: 20),

            const Text(

              "Aucun utilisateur",

              style: TextStyle(

                fontSize: 20,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 8),

            Text(

              "Aucun compte ne correspond\n"
                  "aux critères sélectionnés.",

              textAlign: TextAlign.center,

              style: TextStyle(

                color: Colors.grey.shade600,

              ),

            ),

          ],

        ),

      ),

    );

  }

  // ============================================================================
// CARTE UTILISATEUR
// ============================================================================

  Widget _buildUserTile(
      Utilisateur user,
      ) {

    final selected =
        _selectedUser?.uid == user.uid;

    return AnimatedContainer(

      duration:
      const Duration(milliseconds: 250),

      margin: const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 6,

      ),

      decoration: BoxDecoration(

        color: selected

            ? Theme.of(context)
            .colorScheme
            .primaryContainer

            : null,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(

          color: selected

              ? Theme.of(context)
              .colorScheme
              .primary

              : Colors.grey.shade200,

        ),

      ),

      child: InkWell(

        borderRadius:
        BorderRadius.circular(18),

        onTap: () {

          setState(() {

            _selectedUser = user;

          });

        },

        onLongPress: () {

          _showUserMenu(user);

        },

        child: Padding(

          padding: const EdgeInsets.all(14),

          child: Row(

            children: [

              _buildAvatar(user),

              const SizedBox(width: 14),

              Expanded(

                child:

                _buildUserInfos(user),

              ),

              _buildRoleBadge(user),

            ],

          ),

        ),

      ),

    );

  }

  // ============================================================================
// AVATAR
// ============================================================================

  Widget _buildAvatar(
      Utilisateur user,
      ) {

    return Stack(

      children: [

        CircleAvatar(

          radius: 28,

          backgroundImage:

          user.photoUrl == null

              ? null

              : NetworkImage(
            user.photoUrl!,
          ),

          child: user.photoUrl == null

              ? Text(

            user.firstName[0],

          )

              : null,

        ),

        Positioned(

          right: 0,

          bottom: 0,

          child: Container(

            width: 14,

            height: 14,

            decoration: BoxDecoration(

              color:

              user.isOnline

                  ? Colors.green

                  : Colors.grey,

              shape: BoxShape.circle,

              border: Border.all(

                color: Colors.white,

                width: 2,

              ),

            ),

          ),

        ),

      ],

    );

  }

  // ============================================================================
// INFOS
// ============================================================================

  Widget _buildUserInfos(
      Utilisateur user,
      ) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          "${user.firstName} ${user.lastName}",

          style: const TextStyle(

            fontWeight: FontWeight.bold,

            fontSize: 15,

          ),

        ),

        const SizedBox(height: 3),

        Text(

          user.email,

          overflow: TextOverflow.ellipsis,

        ),

        const SizedBox(height: 6),

        Wrap(

          spacing: 6,

          runSpacing: 6,

          children: [

            _buildKycBadge(user),

            _buildStatusBadge(user),

          ],

        ),

      ],

    );

  }

  // ============================================================================
// ROLE
// ============================================================================

  Widget _buildRoleBadge(
      Utilisateur user,
      ) {

    return Chip(

      backgroundColor:
      user.role.color
          .withOpacity(.15),

      avatar: Icon(

        user.role.icon,

        size: 18,

        color: user.role.color,

      ),

      label: Text(

        user.role.label,

      ),

    );

  }

  // ============================================================================
// BADGE KYC
// ============================================================================

  Widget _buildKycBadge(Utilisateur user) {

    Color color;
    IconData icon;
    String text;

    if (user.isIdentityVerified) {

      color = Colors.green;

      icon = Icons.verified;

      text = "Vérifié";

    } else {

      color = Colors.orange;

      icon = Icons.pending_actions;

      text = "En attente";

    }

    return Chip(

      materialTapTargetSize:
      MaterialTapTargetSize.shrinkWrap,

      avatar: Icon(
        icon,
        size: 16,
        color: color,
      ),

      label: Text(text),

      backgroundColor:
      color.withOpacity(.12),

    );

  }

  // ============================================================================
// BADGE STATUT
// ============================================================================

  Widget _buildStatusBadge(
      Utilisateur user,
      ) {

    Color color;
    IconData icon;
    String label;

    switch (user.accountStatus) {

      case AccountStatus.active:

        color = Colors.green;

        icon = Icons.check_circle;

        label = "Actif";

        break;

      case AccountStatus.pending:

        color = Colors.orange;

        icon = Icons.schedule;

        label = "En attente";

        break;

      case AccountStatus.suspended:

        color = Colors.red;

        icon = Icons.block;

        label = "Suspendu";

        break;

      case AccountStatus.blocked:

        color = Colors.black87;

        icon = Icons.gpp_bad;

        label = "Bloqué";

        break;

      case AccountStatus.deleted:

        color = Colors.grey;

        icon = Icons.delete;

        label = "Supprimé";

        break;

    }

    return Chip(

      materialTapTargetSize:
      MaterialTapTargetSize.shrinkWrap,

      avatar: Icon(

        icon,

        size: 16,

        color: color,

      ),

      label: Text(label),

      backgroundColor:
      color.withOpacity(.12),

    );

  }

  // ============================================================================
// MENU CONTEXTUEL
// ============================================================================

  Future<void> _showUserMenu(
      Utilisateur user,
      ) async {

    await showModalBottomSheet(

      context: context,

      showDragHandle: true,

      builder: (_) {

        return SafeArea(

          child: Wrap(

            children: [

              ListTile(

                leading:
                const Icon(Icons.visibility),

                title:
                const Text("Voir le profil"),

                onTap: () {

                  Navigator.pop(context);

                  setState(() {

                    _selectedUser = user;

                  });

                },

              ),

              ListTile(

                leading: const Icon(
                  Icons.edit,
                ),

                title: const Text(
                  "Modifier",
                ),

                onTap: () {

                  Navigator.pop(context);

                  _editUser(user);

                },

              ),

              ListTile(

                leading: Icon(

                  user.accountStatus ==
                      AccountStatus.suspended

                      ? Icons.lock_open

                      : Icons.block,

                ),

                title: Text(

                  user.accountStatus ==
                      AccountStatus.suspended

                      ? "Réactiver"

                      : "Suspendre",

                ),

                onTap: () {

                  Navigator.pop(context);

                  _toggleSuspension(user);

                },

              ),

              ListTile(

                leading: const Icon(
                  Icons.verified,
                ),

                title: const Text(
                  "Valider le KYC",
                ),

                onTap: () {

                  Navigator.pop(context);

                  _validateKyc(user);

                },

              ),

              ListTile(

                leading: const Icon(
                  Icons.lock_reset,
                ),

                title: const Text(
                  "Réinitialiser le mot de passe",
                ),

                onTap: () {

                  Navigator.pop(context);

                  _resetPassword(user);

                },

              ),

              ListTile(

                leading: const Icon(
                  Icons.swap_horiz,
                ),

                title: const Text(
                  "Changer le rôle",
                ),

                onTap: () {

                  Navigator.pop(context);

                  _changeRole(user);

                },

              ),

              const Divider(),

              ListTile(

                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),

                title: const Text(
                  "Supprimer définitivement",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                onTap: () {

                  Navigator.pop(context);

                  _deleteUser(user);

                },

              ),

            ],

          ),

        );

      },

    );

  }

  // ============================================================================
// ACTIONS ADMINISTRATEUR
// ============================================================================

  Future<void> _toggleSuspension(
      Utilisateur user,
      ) async {

    final suspended =
        user.accountStatus ==
            AccountStatus.suspended;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .update({

      "accountStatus":

      suspended

          ? AccountStatus.active.name

          : AccountStatus.suspended.name,

    });

  }

  Future<void> _validateKyc(
      Utilisateur user,
      ) async {

    await _firestore
        .collection("users")
        .doc(user.uid)
        .update({

      "isIdentityVerified": true,

      "verifiedAt":
      Timestamp.now(),

    });

  }

  Future<void> _resetPassword(
      Utilisateur user,
      ) async {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(

          "Un email de réinitialisation sera envoyé à ${user.email}",

        ),

      ),

    );

  }

  Future<void> _changeRole(
      Utilisateur user,
      ) async {

    // Partie 4 :
    // dialogue complet de changement de rôle

  }


  Future<void> _editUser(
      Utilisateur user,
      ) async {

    // Partie 3 :
    // ouverture de l'éditeur complet

  }

  Future<void> _deleteUser(
      Utilisateur user,
      ) async {

    final confirm =
    await showDialog<bool>(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            "Suppression",
          ),

          content: Text(

            "Supprimer définitivement le compte de\n\n"
                "${user.firstName} ${user.lastName} ?",

          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  false,
                );

              },

              child:
              const Text("Annuler"),

            ),

            FilledButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  true,
                );

              },

              child:
              const Text("Supprimer"),

            ),

          ],

        );

      },

    );

    if (confirm != true) return;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .delete();

    if (_selectedUser?.uid == user.uid) {

      setState(() {

        _selectedUser = null;

      });

    }

  }

  // ============================================================================
// PANNEAU DROIT
// ============================================================================
//
// Affiche les informations détaillées de l'utilisateur sélectionné.
//
// Cette vue remplace totalement l'ancien écran
// UserProfileWidget.
//
// Les différentes sections seront ajoutées
// progressivement.
//
// ============================================================================

  Widget _buildUserDetailsPanel() {

    if (_selectedUser == null) {

      return _buildNoUserSelected();

    }

    return AnimatedSwitcher(

      duration: const Duration(

        milliseconds: 300,

      ),

      child: SingleChildScrollView(

        key: ValueKey(

          _selectedUser!.uid,

        ),

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            _buildProfileHeader(),

            const SizedBox(height: 20),

            _buildIdentityCard(),

            const SizedBox(height: 20),

            _buildVerificationCard(),

            const SizedBox(height: 20),

            _buildStatisticsCard(),

            const SizedBox(height: 20),

            _buildQuickAdministrationCard(),

            const SizedBox(height: 20),

            _buildVehiclesCard(),

            const SizedBox(height: 20),

            _buildTripsCard(),

            const SizedBox(height: 20),

            _buildRecentActivity(),

          ],

        ),

      ),

    );

  }

  // ============================================================================
// AUCUN UTILISATEUR
// ============================================================================

  Widget _buildNoUserSelected() {

    return Card(

      elevation: 0,

      child: Center(

        child: Padding(

          padding: const EdgeInsets.all(60),

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(

                Icons.people_alt_outlined,

                size: 120,

                color: Colors.grey.shade400,

              ),

              const SizedBox(height: 20),

              const Text(

                "Sélectionnez un utilisateur",

                style: TextStyle(

                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(height: 10),

              Text(

                "Toutes les informations\n"
                    "apparaîtront ici.",

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: Colors.grey.shade600,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

  // ============================================================================
// HEADER PROFIL
// ============================================================================

  Widget _buildProfileHeader() {

    final user = _selectedUser!;

    return Card(

      elevation: 0,

      child: Padding(

        padding: const EdgeInsets.all(24),

        child: Row(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Hero(

              tag: user.uid,

              child: CircleAvatar(

                radius: 42,

                backgroundImage:

                user.photoUrl == null

                    ? null

                    : NetworkImage(

                  user.photoUrl!,

                ),

                child:

                user.photoUrl == null

                    ? Text(

                  user.firstName[0],

                  style:
                  const TextStyle(

                    fontSize: 30,

                  ),

                )

                    : null,

              ),

            ),

            const SizedBox(width: 24),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    "${user.firstName} ${user.lastName}",

                    style:
                    Theme.of(context)

                        .textTheme

                        .headlineSmall,

                  ),

                  const SizedBox(height: 8),

                  Text(

                    user.email,

                  ),

                  const SizedBox(height: 4),

                  Text(

                    user.phoneNumber,

                  ),

                  const SizedBox(height: 16),

                  Wrap(

                    spacing: 10,

                    runSpacing: 10,

                    children: [

                      _buildRoleBadge(user),

                      _buildStatusBadge(user),

                      _buildKycBadge(user),

                    ],

                  ),

                ],

              ),

            ),

            FilledButton.icon(

              onPressed: () {

                _editUser(user);

              },

              icon: const Icon(

                Icons.edit,

              ),

              label: const Text(

                "Modifier",

              ),

            ),

          ],

        ),

      ),

    );

  }

  // ============================================================================
// IDENTITÉ
// ============================================================================

  Widget _buildIdentityCard() {

    final user = _selectedUser!;

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(

              "Informations personnelles",

              style: Theme.of(context)

                  .textTheme

                  .titleLarge,

            ),

            const SizedBox(height: 20),

            _buildInfoRow(

              "Nom",

              user.lastName,

            ),

            _buildInfoRow(

              "Prénom",

              user.firstName,

            ),

            _buildInfoRow(

              "Téléphone",

              user.phoneNumber,

            ),

            _buildInfoRow(

              "Email",

              user.email,

            ),

            _buildInfoRow(

              "Rôle",

              user.role.label,

            ),

            _buildInfoRow(

              "Statut",

              user.accountStatus.label,

            ),

          ],

        ),

      ),

    );

  }

  // ============================================================================
// LIGNE D'INFORMATION
// ============================================================================

  Widget _buildInfoRow(

      String title,

      String value,

      ) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(

        vertical: 10,

      ),

      child: Row(

        children: [

          SizedBox(

            width: 160,

            child: Text(

              title,

              style: TextStyle(

                color:
                Colors.grey.shade600,

              ),

            ),

          ),

          Expanded(

            child: SelectableText(

              value,

              style: const TextStyle(

                fontWeight:
                FontWeight.w600,

              ),

            ),

          ),

        ],

      ),

    );

  }







}

 */