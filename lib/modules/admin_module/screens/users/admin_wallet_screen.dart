import 'dart:ui';

import 'package:babigo/modules/admin_module/database/models/admin/transaction.dart';
import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:babigo/modules/payment_module/services/chariow_payment_service.dart';

import '../../../../app/core/utils/colors.dart';
import '../../../../app/core/utils/constants.dart';
import '../../database/models/admin/utilisateur.dart';

/// ===============================================================
/// WALLET SCREEN
/// ===============================================================
///
/// OBJECTIF
/// ---------
///
/// Écran Wallet moderne inspiré :
///
/// ✅ fintech
/// ✅ Revolut
/// ✅ Orange Money
/// ✅ Wave
/// ✅ Binance
///
/// Avec :
///
/// ✅ Carte Wallet premium
/// ✅ Solde animé
/// ✅ Historique
/// ✅ Recharge rapide
/// ✅ UI Desktop + Mobile
/// ✅ Responsive
/// ✅ Glassmorphism
/// ✅ Dégradés modernes
/// ✅ Actions rapides
/// ✅ Firebase realtime
///
/// ===============================================================

class AdminWalletScreen extends StatefulWidget {

  final Utilisateur? selectedUser;

  const AdminWalletScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminWalletScreen> createState() => _AdminWalletScreenState();
}

class _AdminWalletScreenState extends State<AdminWalletScreen> {

  /// =============================================================
  /// LOADING
  /// =============================================================

  bool _busy = false;

  /// =============================================================
  /// SNACK
  /// =============================================================

  void _snack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(text),

        behavior: SnackBarBehavior.floating,

        backgroundColor: Colors.black87,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// =============================================================
  /// TOP UP
  /// =============================================================

  Future<void> _topUp({
    required int amount,
    required String operator,
  }) async {

    setState(() {
      _busy = true;
    });

    try {

      await ChariowPaymentService.instance.pay(
        amount: amount,
      );

      _snack(
        "Paiement lancé avec $operator",
      );

    } catch (e) {

      _snack(
        "Erreur : $e",
      );

    } finally {

      if (mounted) {

        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    /// ===========================================================
    /// UID
    /// ===========================================================

    final uid = widget.selectedUser != null

        ? widget.selectedUser!.id

        : FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {

      return const Scaffold(

        body: Center(
          child: Text(
            "Utilisateur non connecté",
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;

    final isDesktop = size.width >= 900;

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7FE),

      body: StreamBuilder<DocumentSnapshot>(

        stream: AdminDataService.walletsRef.doc(uid).snapshots(),

        builder: (context, snapshot) {

          /// =====================================================
          /// LOADING
          /// =====================================================

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          /// =====================================================
          /// DATA
          /// =====================================================

          final data = snapshot.data?.data() as Map<String, dynamic>?;

          final balance = data?['available'] ?? 0;

          final frozen = data?['frozenBalance'] ?? 0;

          return SafeArea(

            child: Row(

              children: [

                /// =================================================
                /// LEFT SIDE (DESKTOP)
                /// =================================================

                if (isDesktop)

                  Container(

                    width: 280,

                    color: Colors.white,

                    child: Column(

                      children: [

                        const SizedBox(height: 24),

                        _buildProfileCard(),

                        const SizedBox(height: 24),

                        _buildMenuItem(
                          icon: Icons.account_balance_wallet,
                          title: "Portefeuille",
                          selected: true,
                        ),

                        _buildMenuItem(
                          icon: Icons.history,
                          title: "Historique",
                        ),

                        _buildMenuItem(
                          icon: Icons.swap_horiz,
                          title: "Transactions",
                        ),

                        _buildMenuItem(
                          icon: Icons.settings,
                          title: "Paramètres",
                        ),

                        /*
                        _buildMenuItem(
                          icon: Icons.settings,
                          title: "Paramètres",
                          onTap: Navigator.pop(context),
                        ), */

                      ],
                    ),
                  ),

                /// =================================================
                /// MAIN CONTENT
                /// =================================================

                Expanded(

                  child: SingleChildScrollView(

                    padding: EdgeInsets.all(
                      isDesktop ? 28 : 16,
                    ),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        /// ==============$=============================
                        /// TITLE
                        /// ===========================================

                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                const Text(

                                  "Portefeuille",

                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(

                                  "Gérez votre argent facilement",

                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back),
                              label: Text('Revenir'),
                            ),

                            Container(

                              padding:
                              const EdgeInsets.all(12),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: const Icon(
                                Icons.notifications_none,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        /// ===========================================
                        /// WALLET CARD
                        /// ===========================================

                        _buildWalletCard(
                          balance: balance,
                          frozen: frozen,
                        ),

                        const SizedBox(height: 28),

                        /// ===========================================
                        /// QUICK ACTIONS
                        /// ===========================================

                        const Text(

                          "Recharge rapide",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        GridView.count(

                          crossAxisCount: isDesktop ? 4 : 2,

                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          mainAxisSpacing: 16,

                          crossAxisSpacing: 16,

                          childAspectRatio: 1.15,

                          children: [

                            _buildOperatorCard(
                              operator: "Wave",
                              asset: "assets/images/operators/wave.png",
                              color: const Color(0xFF00B8D4),
                            ),

                            _buildOperatorCard(
                              operator: "Orange",
                              asset: "assets/images/operators/orange.png",
                              color: Colors.orange,
                            ),

                            _buildOperatorCard(
                              operator: "MTN",
                              asset: "assets/images/operators/mtn.png",
                              color: Colors.yellow.shade700,
                            ),

                            _buildOperatorCard(
                              operator: "Moov",
                              asset: "assets/images/operators/moov.png",
                              color: Colors.blue,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        /// ===========================================
                        /// RECENT TRANSACTIONS
                        /// ===========================================

                        const Text(

                          "Transactions récentes",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildRecentTransactions(uid),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// =============================================================
  /// PROFILE CARD
  /// =============================================================

  Widget _buildProfileCard() {

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: const Color(0xFF1F6FEB),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(

        children: [

          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFF1F6FEB),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  widget.selectedUser?.fullName ?? "Utilisateur",

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(

                  "Premium Account",

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =============================================================
  /// MENU ITEM
  /// =============================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool selected = false,
    VoidCallback? onTap,
  }) {

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),

      decoration: BoxDecoration(

        color: selected
            ? const Color(0xFF1F6FEB)
            : Colors.transparent,

        borderRadius: BorderRadius.circular(14),
      ),

      child: ListTile(

        leading: Icon( icon,
          color: selected
              ? Colors.white
              : Colors.black87,
        ),

        title: Text(

          title,

          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),

        onTap: () { onTap; },
      ),
    );
  }

  /// =============================================================
  /// WALLET CARD
  /// =============================================================

  Widget _buildWalletCard({
    required dynamic balance,
    required dynamic frozen,
  }) {

    return ClipRRect(

      borderRadius: BorderRadius.circular(28),

      child: BackdropFilter(

        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),

        child: Container(

          width: double.infinity,

          padding: const EdgeInsets.all(28),

          decoration: BoxDecoration(

            gradient: const LinearGradient(

              colors: [
                AppColors.mainColor,
                Color(0xFF5B8DFF),
              ],
            ),

            borderRadius: BorderRadius.circular(28),
          ),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  const Text("BabiGO Wallet",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 1.5,
                    ),
                  ),

                  Container(

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(

                      color: Colors.white.withValues(
                        alpha: .15,
                      ),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(

                "$balance F. CFA",

                style: const TextStyle(
                  fontSize: 38,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(

                "Solde gelé : $frozen F. CFA",

                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 28),

              Row(

                children: [

                  Expanded(

                    child: ElevatedButton.icon(

                      onPressed: () {},

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1F6FEB),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(Icons.add),

                      label: const Text("Recharger"),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(

                    child: OutlinedButton.icon(

                      onPressed: () {},

                      style: OutlinedButton.styleFrom(

                        foregroundColor: Colors.white,

                        side: const BorderSide(
                          color: Colors.white,
                        ),

                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(Icons.history),

                      label: const Text("Historique"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// OPERATOR CARD
  /// =============================================================

  Widget _buildOperatorCard({
    required String operator,
    required String asset,
    required Color color,
  }) {

    return InkWell(

      borderRadius: BorderRadius.circular(22),

      onTap: _busy
          ? null
          : () async {

        final amount = await _showAmountDialog(
          operator,
        );

        if (amount != null) {

          _topUp(
            amount: amount,
            operator: operator,
          );
        }
      },

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: [

            BoxShadow(
              color: Colors.black.withValues(
                alpha: .04,
              ),
              blurRadius: 12,
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),

              child: Image.asset(asset,
                height: 34,
                errorBuilder:
                    (_, _, _) =>
                    Icon(
                      Icons.payments,
                      color: color,
                    ),
              ),
            ),

            const SizedBox(height: 14),

            Text(operator,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text("Recharger",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =============================================================
  /// TRANSACTIONS
  /// =============================================================

  Widget _buildRecentTransactions(
      String uid,
      ) {

    return StreamBuilder<QuerySnapshot>(

      stream: AdminDataService.streamFewUserTransactions(uid),

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

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.swap_horiz,
                  size: 60,
                  color: Colors.grey[300],
                ),

                const SizedBox(height: 12),

                const Text(
                  "Aucune transaction trouvé(e).",
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

        List<AppTransaction> appTransactions = [];

        for (final doc in snapshot.data!.docs) {

          try {

            final appTransaction = AppTransaction.getTransactionData(doc);
            appTransactions.add(appTransaction);

          } catch (e) {

            debugPrint(
              "Erreur conversion transaction : $e",
            );
          }
        }

        /// =========================================================
        /// AUCUNE ANNONCE TROUVEE
        /// =========================================================

        if (appTransactions.isEmpty) {

          return const Center(
            child: Text(
              "Aucune transaction trouvée",
            ),
          );
        }

        return Container(

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(22),
          ),

          child: Column(

            children: appTransactions.map((appTransaction) {

              return ListTile(

                leading: CircleAvatar(

                  backgroundColor: appTransaction.type == 'CREDIT'
                      ? const Color(0xFF39BD62).withValues(alpha: .1)
                      : const Color(0xFFF55142).withValues(alpha: .1),

                  child: Icon(

                    appTransaction.type == 'CREDIT'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,

                    color: appTransaction.type == 'CREDIT'
                        ? const Color(0xFF39BD62)
                        : const Color(0xFFF55142),
                  ),
                ),

                title: Text(
                  Utils.getTransactionReasonText(appTransaction.reason),
                ),

                subtitle: Text(
                  appTransaction.type == 'CREDIT'
                      ? 'Dépot fait le ${Utils.getDateTimeText(appTransaction.createdAt)}'
                      : 'Retrait',
                ),

                trailing: Text(

                  "${appTransaction.amount} francs CFA",

                  style: TextStyle(

                    color: appTransaction.type == 'CREDIT'
                        ? Colors.green
                        : Colors.red,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              );

            }).toList(),
          ),
        );
      },
    );
  }

  /// =============================================================
  /// DIALOG AMOUNT
  /// =============================================================

  Future<int?> _showAmountDialog(String operator) {

    final controller = TextEditingController();

    return showDialog<int>(

      context: context,

      builder: (ctx) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: Text(
            "Recharge $operator",
          ),

          content: TextField(

            controller: controller,

            keyboardType: TextInputType.number,

            decoration: InputDecoration(

              hintText: "Montant F. CFA",

              filled: true,

              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(ctx);
              },

              child: const Text("Annuler"),
            ),

            ElevatedButton(

              onPressed: () {

                final amount = int.tryParse(controller.text);

                if (amount != null && amount > 0) {

                  Navigator.pop(ctx, amount);
                }
              },

              child: const Text("Valider"),
            ),
          ],
        );
      },
    );
  }
}