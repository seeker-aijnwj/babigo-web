import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../app/core/utils/colors.dart';
import '../database/models/admin/utilisateur.dart';
import '../database/services/admin_data_service.dart';
import '../screens/users/advanced_user_profile.dart';
// ==============================================================================
// 3. VUE PRINCIPALE RH
// ==============================================================================

class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {

  // --- ÉTAT ---
  UserRole? _selectedCategory; // Si null = Affiche le Menu, Sinon = Affiche la Liste
  Utilisateur? _selectedUser;

  // 🔍 Recherche locale
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [

          // -----------------------------------------------------------
          // ZONE 2 : NAVIGATION & LISTES
          // -----------------------------------------------------------
          Expanded(
            flex: 3, // 30% largeur
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [

                  // Contenu dynamique (Menu Catégories OU Liste Utilisateurs)
                  Expanded(
                    // child: _selectedCategory == null
                    //  ? _buildCategoriesMenu()
                    //  : _buildUserFromFirebaseList(_selectedCategory!),
                    child: _getAllUsersList(),
                  ),
                ],
              ),
            ),
          ),

          // -----------------------------------------------------------
          // ZONE 3 : DÉTAILS & ACTIONS
          // -----------------------------------------------------------
          if (isDesktop)
            Expanded(
              flex: 7, // 60% largeur
              child: Container(
                color: const Color(0xFFF0F2F5), // Fond gris très clair
                child: _selectedUser != null
                    ? AdvancedUserProfileWidget(user: _selectedUser!)
                    : _buildEmptyState(),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================================
  // ZONE 2 WIDGETS
  // ============================================================================

  Widget _buildMenuHeader() {
    bool isSubList = _selectedCategory != null;

    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          if (isSubList)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
              onPressed: () => setState(() {
                _selectedCategory = null; // Retour au menu
                _selectedUser = null;     // Désélectionner l'user
              }),
            ),
          Text(
            isSubList ? _getRoleTitle(_selectedCategory!) : "Ressources Humaines",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.darkText
            ),
          ),

        ],
      ),
    );
  }

  // LISTE FILTRÉE
  // ================= ALL USERS LIST FROM FIREBASE =================
  Widget _getAllUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: AdminDataService.streamUsers(),
      builder: (context, snapshot) {

        // ⏳ Chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ❌ Erreur
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erreur : ${snapshot.error}",
            ),
          );
        }

        // 📭 Aucune donnée
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 50,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 10),
                Text(
                  "Aucun utilisateur trouvé.",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        List<Utilisateur> users = [];

        for (final doc in snapshot.data!.docs) {
          try {
            users.add(Utilisateur.fromFirestore(doc));
          } catch (e) {
            debugPrint(
              "Erreur conversion user ${doc.id}: $e",
            );
          }
        }

        // ================= RECHERCHE =================
        final query = _searchController.text
            .trim()
            .toLowerCase();

        if (query.isNotEmpty) {
          users = users.where((user) {
            final fullName = user.fullName.toLowerCase();

            return fullName.contains(query);
          }).toList();
        }

        // 📭 Aucun résultat après filtre
        if (users.isEmpty) {
          return const Center(
            child: Text(
              "Aucun résultat trouvé",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // ================= LISTE =================
        return ListView.separated(
          itemCount: users.length,

          separatorBuilder: (c, i) =>
          const Divider(
            height: 1,
            indent: 70,
          ),

          itemBuilder: (context, index) {
            final user = users[index];

            final isSelected = _selectedUser?.id == user.id;

            final isBlocked = user.status == UserStatus.blocked;

            return ListTile(
              selected: isSelected,

              selectedTileColor: AppColors.primary.withValues(alpha: .1),

              leading: CircleAvatar(
                backgroundColor: isBlocked
                    ? Colors.red.shade100
                    : Colors.grey.shade200,

                child: Icon(
                  switch(user.role) {

                    // TODO: Handle this case.
                    UserRole.admin => Icons.admin_panel_settings,
                    // TODO: Handle this case.
                    UserRole.support => Icons.support_agent,
                    // TODO: Handle this case.
                    UserRole.passenger => Icons.person,
                    // TODO: Handle this case.
                    UserRole.driver => Icons.drive_eta,
                    // TODO: Handle this case.
                    UserRole.fleetManager => Icons.business,
                    // TODO: Handle this case.
                    UserRole.investor => Icons.monetization_on,
                  }
                ),
              ),

              title: Text(
                user.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: Text(
                user.phone,
                style: const TextStyle(fontSize: 12),
              ),

              trailing: isBlocked
                  ? const Chip(
                label: Text(
                  "BLOQUÉ",
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(0),
              )
                  : null,

              onTap: () {
                setState(() {
                  _selectedUser = user;
                  AdvancedUserProfileWidget(user: _selectedUser!);
                });
              },
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // ZONE 3 WIDGETS (DÉTAILS)
  // ============================================================================

  // ============================================================================
  // HELPERS UI
  // ============================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Text(
            "Sélectionnez un utilisateur\npour gérer son compte",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.passenger: return "Passagers";
      case UserRole.driver: return "Chauffeurs";
      case UserRole.support: return "Support";
      case UserRole.admin: return "Administrateurs";
      case UserRole.fleetManager: return "Gestionnaire";
      case UserRole.investor: return "Investisseur";
    }
  }

}