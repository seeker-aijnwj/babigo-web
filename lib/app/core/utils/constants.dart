// File: lib/app/core/utils/constants.dart
// Fichier pour définir les constantes utilisées dans l'application
// Ce fichier peut être importé dans d'autres fichiers pour utiliser les constantes définies

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

class VehicleUtils {

}