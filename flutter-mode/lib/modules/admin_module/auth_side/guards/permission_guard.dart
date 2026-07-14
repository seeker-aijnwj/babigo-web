// ============================================================================
// FILE : auth/guards/permission_guard.dart
// ============================================================================

/// ============================================================================
/// PERMISSION GUARD
/// ============================================================================
///
/// Il pose cette question à l'utilisateur : As-tu le droit d'effectuer cette action ?
/// Vérifie que l'utilisateur possède un rôle autorisé.
///
/// Exemples d'utilisation
///
/// ✓ Conducteur connecté
/// ✗ Véhicule non validé
///
/// => impossible de publier une annonce
///
/// ✓ Conducteur connecté
/// ✗ Véhicule non validé
///
/// => impossible de publier une annonce
///
/// ✓ Conducteur
/// ✓ Profil complété
/// ✓ Email vérifié
/// ✓ Compte approuvé
/// ✓ Véhicule validé
///
/// => accès complet
///
///
/// PermissionGuard(
///   child: AddTripScreen(),
/// );
///
/// PermissionGuard(
///   child: AddVehicleScreen(),
/// );
///
/// PermissionGuard(
///   child: PaymentScreen(),
/// );
///
/// PermissionGuard(
///   child: ChatScreen(),
/// );
///
/// ============================================================================

import 'package:flutter/material.dart';

import '../../../../app/core/utils/session_manager.dart';
import '../screens/validation/account_pending_approval_screen.dart';
import '../screens/complete_profile_screen.dart';
import '../screens/conformity/email_verification_required_screen.dart';
import '../screens/validation/account_suspended_screen.dart';

class PermissionGuard extends StatelessWidget {

  final Widget child;

  final bool requireEmailVerified;

  final bool requireCompletedProfile;

  final bool requireApprovedAccount;

  final bool requireActiveAccount;

  const PermissionGuard({
    super.key,
    required this.child,
    this.requireEmailVerified = true,
    this.requireCompletedProfile = true,
    this.requireApprovedAccount = true,
    this.requireActiveAccount = true,
  });

  @override
  Widget build(BuildContext context) {

    final user = SessionManager.instance.currentUser;

    if (user == null) {

      return const SizedBox();
    }

    // EMAIL

    if (requireEmailVerified && !user.emailVerified) {

      return const EmailVerificationRequiredScreen();
    }

    // PROFIL

    if (requireCompletedProfile && !user.isProfileComplete) {

      return const CompleteProfileScreen();
    }

    // APPROBATION

    if (requireApprovedAccount && !user.isApproved) {

      return const AccountPendingApprovalScreen();
    }

    // SUSPENSION

    if (requireActiveAccount && user.isSuspended) {

      return const AccountSuspendedScreen(type: AccountRestrictionType.suspended,);
    }

    return child;
  }
}


/**
 *
 * // ============================================================================
    // FILE : auth/guards/permission_guard.dart
    // ============================================================================

    import 'package:flutter/material.dart';

    import '../../services/auth_service.dart';
    import '../../models/user/user_model.dart';

    class PermissionGuard extends StatelessWidget {

      final String permission;

      final Widget child;

      const PermissionGuard({
        super.key,
        required this.permission,
        required this.child,
      });

      bool _hasPermission(UserModel user) {

        return user.permissions.contains(
          permission,
        );
      }

      @override
      Widget build(BuildContext context) {

        return StreamBuilder<UserModel?>(
          stream: AuthService.instance.currentUserStream,
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final user = snapshot.data!;

            if (!_hasPermission(user)) {
              return Scaffold(
                body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Accès refusé",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Vous ne disposez pas de la permission : $permission",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return child;
        },
      );
      }
    }
 *
 */