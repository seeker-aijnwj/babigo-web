```dart
// 🔍 Recherche locale
final TextEditingController _searchController =
    TextEditingController();


// ================= USERS LIST =================
Widget _buildUserList(UserRole role) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role.name)
        .orderBy('createdAt', descending: true)
        .snapshots(),
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
                "Aucun ${_getRoleTitle(role).toLowerCase()} trouvé.",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      // 🔥 Conversion Firestore → AppUser
      List<AppUser> users = snapshot.data!.docs
          .map((doc) => AppUser.fromFirestore(doc))
          .toList();

      // ================= RECHERCHE =================
      final query = _searchController.text
          .trim()
          .toLowerCase();

      if (query.isNotEmpty) {
        users = users.where((user) {
          final fullName = user.name.toLowerCase();

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

          final isSelected =
              _selectedUser?.id == user.id;

          final isBlocked =
              user.status.toLowerCase() == 'bloqué';

          return ListTile(
            selected: isSelected,

            selectedTileColor:
                HrColors.primary.withValues(alpha: .1),

            leading: CircleAvatar(
              backgroundColor: isBlocked
                  ? Colors.red.shade100
                  : Colors.grey.shade200,

              child: Text(
                user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : '?',

                style: TextStyle(
                  color: isBlocked
                      ? Colors.red
                      : Colors.grey.shade700,
                ),
              ),
            ),

            title: Text(
              user.name,
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
              });
            },
          );
        },
      );
    },
  );
}
```

⚠️ N’oublie pas d’ajouter un champ de recherche dans ton UI :

```dart
TextField(
  controller: _searchController,
  onChanged: (_) => setState(() {}),
  decoration: InputDecoration(
    hintText: "Rechercher par nom ou prénom",
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

Et les imports :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
```

Row(
  children: [

    // =========================================
    // LISTE UTILISATEURS
    // =========================================

    Expanded(
      flex: 2,
      child: _buildUsersList(),
    ),

    // =========================================
    // PROFIL UTILISATEUR
    // =========================================

    Expanded(
      flex: 3,

      child: _selectedUser == null
          ? const Center(
              child: Text(
                "Sélectionnez un utilisateur",
              ),
            )

          : AdvancedUserProfileWidget(
              user: _selectedUser!,

              onEdit: () {
                _showEditUserDialog(
                  _selectedUser!,
                );
              },

              onDelete: () {
                _deleteUser(
                  _selectedUser!,
                );
              },

              onBlock: () {
                _toggleUserStatus(
                  _selectedUser!,
                );
              },
            ),
    ),
  ],
)



---------------------


lib/
│
├── app/
│   ├── core/
│   │   ├── constants/
│   │   │   └── cinetpay_constants.dart
│   │   ├── network/
│   │   │   └── dio_client.dart
│   │   ├── services/
│   │   │   ├── cinetpay_service.dart
│   │   │   ├── payment_service.dart
│   │   │   ├── wallet_service.dart
│   │   │   └── transaction_service.dart
│   │   ├── utils/
│   │   │   ├── payment_validator.dart
│   │   │   └── currency_formatter.dart
│   │   └── themes/
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── payment_transaction.dart
│   │   │   ├── wallet.dart
│   │   │   ├── payment_response.dart
│   │   │   ├── payment_customer.dart
│   │   │   └── cinetpay_payment_request.dart
│   │   │
│   │   └── repositories/
│   │       ├── payment_repository.dart
│   │       ├── wallet_repository.dart
│   │       └── transaction_repository.dart
│   │
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── payment_provider.dart
│   │   │   ├── wallet_provider.dart
│   │   │   └── checkout_provider.dart
│   │   │
│   │   ├── pages/
│   │   │   ├── payment/
│   │   │   │   ├── payment_page.dart
│   │   │   │   ├── payment_success_page.dart
│   │   │   │   ├── payment_failed_page.dart
│   │   │   │   ├── payment_pending_page.dart
│   │   │   │   └── wallet_page.dart
│   │   │
│   │   └── widgets/
│   │       ├── payment/
│   │       │   ├── payment_method_card.dart
│   │       │   ├── payment_summary_card.dart
│   │       │   ├── payment_status_badge.dart
│   │       │   ├── wallet_balance_card.dart
│   │       │   └── transaction_tile.dart
│
└── main.dart

J’ai généré une architecture complète et professionnelle d’intégration CinetPay pour Flutter + Firebase avec :

* structure complète des dossiers
* modèles Dart
* services CinetPay
* repositories
* providers
* pages UI
* WebView paiement
* wallet system
* transactions Firestore
* sécurité recommandée
* flow complet de paiement
* exemples Firestore
* commentaires détaillés dans chaque fichier

Le tout est prêt à être intégré dans ton application Desktop/Mobile/Web de covoiturage en Côte d’Ivoire.
