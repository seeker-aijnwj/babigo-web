import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../app/core/utils/colors.dart';
import '../../../database/models/admin/utilisateur.dart';

class AdminDriverNotificationsScreen extends StatefulWidget {

  /// ============================================================
  /// UTILISATEUR CIBLE
  /// ============================================================
  ///
  /// null
  /// -> utilisateur connecté
  ///
  /// non null
  /// -> support/admin consulte un utilisateur
  ///
  /// ============================================================

  final Utilisateur? selectedUser;

  const AdminDriverNotificationsScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminDriverNotificationsScreen> createState() =>
      _AdminDriverNotificationsScreenState();
}

class _AdminDriverNotificationsScreenState
    extends State<AdminDriverNotificationsScreen> {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String? _targetUserId;

  @override
  void initState() {

    super.initState();

    _targetUserId =
        widget.selectedUser?.id ??
            FirebaseAuth.instance.currentUser?.uid;
  }

  /// ============================================================
  /// QUERY
  /// ============================================================

  Query<Map<String, dynamic>> _notificationsQuery() {

    return _firestore.collection('users')
        .doc(_targetUserId)
        .collection('notifications')
        .orderBy('createdAt', descending: true,);
  }

  /// ============================================================
  /// MARK ALL READ
  /// ============================================================

  Future<void> _markAllAsRead() async {

    if (_targetUserId == null) return;

    final batch = FirebaseFirestore.instance.batch();

    final unread = await _firestore.collection('users')
        .doc(_targetUserId)
        .collection('notifications')
        .where('isRead', isEqualTo: false,)
        .get();

    for (final doc in unread.docs) {

      batch.update(doc.reference,
        {
          'isRead': true,
          'updatedAt':
          FieldValue.serverTimestamp(),
        },
      );
    }

    await batch.commit();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          "Toutes les notifications ont été marquées comme lues",
        ),
      ),
    );
  }

  /// ============================================================
  /// MARK ONE READ
  /// ============================================================

  Future<void> _markAsRead(
      DocumentSnapshot doc,
      ) async {

    final data =
    doc.data() as Map<String, dynamic>?;

    if (data == null) return;

    final isRead = data['isRead'] == true;

    if (isRead) return;

    await doc.reference.update({

      'isRead': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ============================================================
  /// DATE
  /// ============================================================

  String _relativeDate(
      Timestamp? timestamp,
      ) {

    if (timestamp == null) {
      return "";
    }

    final date = timestamp.toDate();

    final now = DateTime.now();

    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return "À l'instant";
    }

    if (diff.inHours < 1) {
      return "${diff.inMinutes} min";
    }

    if (diff.inDays < 1) {
      return "${diff.inHours} h";
    }

    if (diff.inDays < 7) {
      return "${diff.inDays} j";
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  /// ============================================================
  /// HEADER
  /// ============================================================

  Widget _buildHeader() {

    return Container(

      padding:
      const EdgeInsets.all(24),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          colors: [

            AppColors.mainColor,

            AppColors.mainColor.withValues(
              alpha: .75,
            ),
          ],
        ),

        borderRadius: const BorderRadius.only(

          bottomLeft: Radius.circular(32),

          bottomRight: Radius.circular(32),
        ),
      ),

      child: SafeArea(

        bottom: false,

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                IconButton(

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),

                const Expanded(

                  child: Text(
                    "Notifications",

                    textAlign: TextAlign.center,

                    style: TextStyle(

                      color: Colors.white,

                      fontWeight: FontWeight.bold,

                      fontSize: 22,
                    ),
                  ),
                ),

                IconButton(

                  onPressed: _markAllAsRead,

                  icon: const Icon(
                    Icons.done_all,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Centre de notifications",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Consultez toutes les alertes et événements récents",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================================
  /// USER CARD
  /// ============================================================

  Widget _buildSelectedUserCard() {

    final user = widget.selectedUser;

    if (user == null) {
      return const SizedBox();
    }

    return Container(

      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(
              alpha: .05,
            ),

            blurRadius: 20,
          ),
        ],
      ),

      child: Row(

        children: [

          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.mainColor,

            child: Text(

              user.fullName.substring(0, 1).toUpperCase(),

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  user.fullName,

                  style: const TextStyle(

                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(user.phone),
                Text(user.email),
              ],
            ),
          ),

          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: AppColors.mainColor,

              borderRadius: BorderRadius.circular(
                30,
              ),
            ),

            child: const Text(
              "CLIENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_targetUserId == null) {

      return const Scaffold(

        body: Center(

          child: Text(
            "Utilisateur introuvable",
          ),
        ),
      );
    }

    return Scaffold(

      backgroundColor: AppColors.backgroundColor,

      body: Column(

        children: [

          _buildHeader(),

          _buildSelectedUserCard(),

          Expanded(

            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _notificationsQuery().snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {

                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.notifications_off,

                          size: 80,

                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        const Text(

                          "Aucune notification",

                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final unread = docs.where((e) {

                      return (e.data()['isRead'] as bool?) != true;

                    }).length;

                return Column(

                  children: [

                    Padding(

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      child: Row(

                        children: [

                          Expanded(

                            child:
                            _StatCard(

                              title:
                              "Total",

                              value: docs.length.toString(),

                              icon: Icons.notifications,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(

                            child:
                            _StatCard(

                              title:
                              "Non lues",

                              value: unread.toString(),

                              icon: Icons.circle_notifications_sharp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Expanded(

                      child: ListView.builder(

                        padding: const EdgeInsets.all(16),

                        itemCount: docs.length,

                        itemBuilder: (context, index) {

                          final doc = docs[index];

                          final data = doc.data();

                          final isRead = data['isRead'] == true;

                          return InkWell(

                            onTap: () {

                              _markAsRead(doc,);
                            },

                            child: Container(

                              margin: const EdgeInsets.only(
                                bottom: 14,
                              ),

                              padding: const EdgeInsets.all(
                                18,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),

                                boxShadow: [

                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: .05,
                                    ),

                                    blurRadius: 10,
                                  ),
                                ],
                              ),

                              child:
                              Row(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  CircleAvatar(

                                    backgroundColor: isRead
                                        ? Colors.grey.shade200
                                        : AppColors.mainColor.withValues(alpha:.15,),

                                    child: Icon(isRead
                                          ? Icons.notifications
                                          : Icons.notifications_active,

                                      color: isRead ? Colors.grey : AppColors.mainColor,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  Expanded(

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        Text(
                                          data['title'] ?? 'Notification',

                                          style: TextStyle(

                                            fontWeight: isRead
                                                ? FontWeight.w600
                                                : FontWeight.bold,

                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 6,
                                        ),

                                        Text(
                                          data['message'] ?? data['body'] ??
                                              '',
                                        ),

                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Text(
                                          _relativeDate(data['createdAt']
                                            as Timestamp?,
                                          ),

                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: .05,
            ),

            blurRadius: 12,
          ),
        ],
      ),

      child: Column(

        children: [

          Icon(icon,
            color: AppColors.mainColor,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(title),
        ],
      ),
    );
  }
}