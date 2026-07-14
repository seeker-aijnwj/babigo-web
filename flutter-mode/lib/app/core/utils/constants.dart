// File: lib/app/core/utils/constants.dart
// Fichier pour définir les constantes utilisées dans l'application
// Ce fichier peut être importé dans d'autres fichiers pour utiliser les constantes définies

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../modules/admin_module/database/models/admin/trip_ad.dart';
import 'colors.dart';


class Utils {

  /// Nom de la plateforme
  static final String appName = "BabiGO";

  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  /// Pour vérifier une connexion d'utilisateur
  static final auth = FirebaseAuth.instance;

  /// Pour les requêtes en base de données
  static final db = FirebaseFirestore.instance;

  /// Obtenir une date d'une DateTime
  static String formatDate(DateTime date) {

    String two(int v) {
      return v.toString().padLeft(2, '0');
    }

    return "${two(date.day)}/${two(date.month)}/${date.year}";
  }

  /// Obtenir la date et l'heure d'une DateTime
  static String getDateTimeText(DateTime date){
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}';
  }

  /// Afficher la raison d'une transaction
  static String getTransactionReasonText(String reason){

    switch(reason){

      case 'RESERVATION_FEE':
        return "COÛT DE RESERVATION DE VOTRE PLACE";

      case 'ANNOUNCE_FEE':
        return "COÛT DE PUBLICATION DE VOTRE ANNONCE";

      default: return 'CREDIT INITIAL OFFERT PAR BABIGO';

    }

  }

  static String _getStatusText(TripStatus status) {

    switch (status) {

      case TripStatus.boarding: return "embarquement";

      case TripStatus.cancelled: return "annulé";

      case TripStatus.completed: return "completé";

      case TripStatus.draft: return "brouillon";

      case TripStatus.expired: return "expiré";

      case TripStatus.full: return "terminé";

      case TripStatus.paused: return "à l'arrêt";

      case TripStatus.published: return "programmé";

      case TripStatus.started: return "démarré";

      default: return "tous";
    }
  }

  /// Afficher la raison d'une transaction
  static String getUserRoleText(String roleValue){

    switch(roleValue){

      case 'admin':
      case 'support':
        return '-- -- --';

      case 'driver':
        return 'un conducteur';

      case 'passenger':
        return 'un passager';

      case 'fleetManager':
        return "un gestionnaire de parc/flotte";

      case 'investor':
        return "un investisseur";

      default: return 'un passager';

    }

  }

  static Widget buildSignHeader({bool isLogin = false}) {

    return Column(
      children: [

        Container(
          width: 160,
          height: 160,
          decoration:
          const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0066FF),
          ),
          child: Image.asset(
            "assets/images/icons/appstore.png",
            width: 160,
            height: 160,
          ),
        ),

        Text(
          isLogin ? "Connexion" : "Créer un compte",
          style: TextStyle(
            fontSize: 30,
            color: AppColors.mainColor,
            fontWeight: FontWeight.w900,

          ),
        ),

        const SizedBox(height: 8),

        Text(
          isLogin ? "Entrez vos identifiants pour continuer." : "Rejoignez la communauté BabiGO",
          style: TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }

  static Widget statusRow({
    required IconData icon,
    required String label,
    required bool value,
  }) {

    final color = value ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 18,
            backgroundColor:
            color.withValues(alpha: .10),

            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color:
              color.withValues(alpha: .10),

              borderRadius: BorderRadius.circular(50),
            ),

            child: Text(
              value ? "Valide" : "Non valide",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showAction(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label : action à connecter"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static BoxDecoration cardDecoration() {
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

  // ============================================================================
// REAUTHENTICATION
// ============================================================================

  Future<void> reauthenticate(
      User user,
      String? password,
      ) async {

    final provider =
        user.providerData.first.providerId;

    // --------------------------------------------------
    // EMAIL / PASSWORD
    // --------------------------------------------------

    if (provider == 'password') {

      if (password == null ||
          password.isEmpty) {

        throw Exception(
          "Mot de passe requis",
        );
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(
        credential,
      );

      return;
    }

    // --------------------------------------------------
    // GOOGLE
    // --------------------------------------------------

    if (provider == 'google.com') {

      throw Exception(
        "Reconnectez-vous avec Google avant suppression.",
      );
    }

    // --------------------------------------------------
    // APPLE
    // --------------------------------------------------

    if (provider ==
        'apple.com') {

      throw Exception(
        "Reconnectez-vous avec Apple avant suppression.",
      );
    }
  }

  // ============================================================================
  // DELETE USER DATA
  // ============================================================================
  Future<void> cleanupFirestoreUserData(
      String uid,
      ) async {

    final userRef = db.collection("users").doc(uid);

    await _deleteCollection(
      userRef.collection(
        'vehicles',
      ),
    );

    await _deleteCollection(
      userRef.collection(
        'announces',
      ),
    );

    await _deleteCollection(
      userRef.collection(
        'bookings',
      ),
    );

    await _deleteCollection(
      userRef.collection(
        'notifications',
      ),
    );

    await _deleteCollection(
      userRef.collection(
        'favorites',
      ),
    );

    await userRef.delete();
  }

  // ============================================================================
  // DELETE COLLECTION
  // ============================================================================

  Future<void> _deleteCollection(
      CollectionReference collection,
      ) async {

    const batchSize = 100;

    while (true) {

      final snapshot = await collection
          .limit(batchSize)
          .get();

      if (snapshot.docs.isEmpty) {
        break;
      }

      final batch = db.batch();

      for (final doc
      in snapshot.docs) {

        batch.delete(
          doc.reference,
        );
      }

      await batch.commit();
    }
  }

}

class RoleHint extends StatelessWidget {
  final IconData icon;
  final String label;

  const RoleHint({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


class ImageFallback extends StatelessWidget {
  const ImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1F2937),
      child: const Center(
        child: Icon(
          Icons.directions_car,
          color: Colors.white54,
          size: 52,
        ),
      ),
    );
  }
}

class HeroCarousel extends StatelessWidget {
  final List<String> images;
  final int index;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Widget Function(String src) buildImage;
  final bool compact;

  const HeroCarousel({
    super.key,
    required this.images,
    required this.index,
    required this.pageController,
    required this.onPageChanged,
    required this.buildImage,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 0 : 32),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            allowImplicitScrolling: true,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => _KeepAlive(child: buildImage(images[i])),
          ),
          const _GradientOverlay(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(compact ? 22 : 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandBadge(),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: const Text(
                      "Le covoiturage simple, fiable et local",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: const Text(
                      "BabiGO connecte passagers, conducteurs, flottes, etc. dans une expérience fluide pensée pour la Côte d'Ivoire.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _Dots(count: images.length, index: index),
                  if (compact) const SizedBox(height: 190),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _KeepAlive extends StatefulWidget {
  final Widget child;

  const _KeepAlive({
    required this.child,
  });

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          margin: const EdgeInsets.only(right: 8),
          width: active ? 28 : 9,
          height: 9,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: active ? .95 : .45),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: .58),
            AppColors.mainColor.withValues(alpha: .50),
            Colors.black.withValues(alpha: .68),
          ],
        ),
      ),
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .22)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "BabiGO",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class SuperSectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<SuperAction> actions;

  const SuperSectionScreen({super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      title: title,
      subtitle: subtitle,
      icon: icon,
      children: [
        QuickActions(actions: actions),
        const SizedBox(height: 18),
        SuperCardsGrid(title: title),
      ],
    );
  }
}

class _SuperCardData {
  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
  final Color color;

  const _SuperCardData(this.title, this.subtitle, this.meta, this.icon, this.color);
}

class SuperPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const SuperPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= 900;

      return SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 28 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _PageHeader(title: title, subtitle: subtitle, icon: icon),
              const SizedBox(height: 18),
              ...children,
            ]),
          ),
        ),
      );
    });
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PageHeader({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(18)),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 26, height: 1.1, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, height: 1.35)),
        ])),
      ]),
    );
  }
}

class QuickActions extends StatelessWidget {

  final List<SuperAction> actions;
  const QuickActions({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: Utils.cardDecoration(),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: actions.map((action) {
          final color = action.sensitive
              ? AppColors.danger
              : AppColors.mainColor;

          return ElevatedButton.icon(
            onPressed: () {
              if (action.onTap != null) {
                action.onTap!();
              } else if (action.sensitive) {
                _confirmSensitiveAction(context, action.label);
              } else {
                _showAction(context, action.label);
              }
            },
            icon: Icon(action.icon),
            label: Text(action.label),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MetricGrid extends StatelessWidget {

  final List<MetricData> metrics;
  const MetricGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900 ? 4 : constraints.maxWidth >= 560 ? 2 : 1;

      return GridView.builder(
        itemCount: metrics.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: 118,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final metric = metrics[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: Utils.cardDecoration(),
            child: Row(children: [
              CircleAvatar(backgroundColor: metric.color.withValues(alpha: .1), child: Icon(metric.icon, color: metric.color)),
              const SizedBox(width: 12),
              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(metric.value, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(metric.label, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF64748B))),
              ])),
            ]),
          );
        },
      );
    });
  }
}

class SuperCardsGrid extends StatelessWidget {

  final String title;
  const SuperCardsGrid({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    const cards = [
      _SuperCardData(
          "Contrôle complet", "Accès lecture et action sur ce module.", "Super admin", Icons.verified_user, AppColors.mainColor),
      _SuperCardData(
          "Actions sensibles", "Toute opération critique doit être confirmée.", "Protégé", Icons.lock, AppColors.warning),
      _SuperCardData(
          "Journalisation", "Chaque modification est destinée au journal d'audit.", "Audit", Icons.manage_history, AppColors.success),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900 ? 3 : constraints.maxWidth >= 600 ? 2 : 1;

      return GridView.builder(
        itemCount: cards.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: 176,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final card = cards[index];

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: Utils.cardDecoration(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(backgroundColor: card.color.withValues(alpha: .1), child: Icon(card.icon, color: card.color)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: card.color.withValues(alpha: .1), borderRadius: BorderRadius.circular(99)),
                  child: Text(card.meta, style: TextStyle(color: card.color, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ]),
              const Spacer(),
              Text("$title · ${card.title}", maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(card.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF64748B), height: 1.35)),
            ]),
          );
        },
      );
    });
  }
}

class NoticeBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool danger;

  const NoticeBox({
    super.key,
    required this.icon,
    required this.text,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? AppColors.danger
        : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
                text,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800
                )
            )
        ),
      ]),
    );
  }
}

class SuperAction {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool sensitive;

  const SuperAction(
      this.label,
      this.icon, {
        this.onTap,
        this.sensitive = false,
      });
}

Future<void> _confirmSensitiveAction(BuildContext context, String label) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Action sensible"),
      content: Text("Confirmer l'action : $label ?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirmer")),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    _showAction(context, label);
  }
}

void _showAction(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("$label : action à connecter"),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

class SuperMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;

  const SuperMenuItem(this.title, this.subtitle, this.icon, this.selectedIcon);
}

class MetricData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const MetricData(this.value, this.label, this.icon, this.color);
}

class VehicleUtils {

}