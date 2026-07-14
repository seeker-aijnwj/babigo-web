/// ============================================================================
/// FILE : auth/guards/auth_user_guard.dart
///
/// Exemples d'utlisation
///
/// MaterialApp(
///
///   home: AuthGuard(
///
///     child: PassengerHomeScreen(),
///   ),
/// );
/// ou
///
///
/// GoRoute(
///
///   path: "/driver",
///
///   builder: (_, __) {
///
///     return AuthGuard(
///
///       child: DriverDashboardScreen(),
///     );
///   },
/// );
///
///
// ============================================================================

import 'package:flutter/material.dart';
import '../../../../app/core/utils/session_manager.dart';
import '../screens/validation/account_pending_approval_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/conformity/verify_email_screen.dart';

class AuthGuard extends StatelessWidget {

  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build( BuildContext context) {

    final session = SessionManager.instance;

    // ========================================================================
    // CHARGEMENT
    // ========================================================================
    if (session.isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ========================================================================
    // NON CONNECTÉ
    // ========================================================================

    if (!session.isLoggedIn) {

      return const SignInScreen();
    }

    // ========================================================================
    // EMAIL NON VALIDÉ
    // ========================================================================

    if (!session.emailVerified) {

      return const VerifyEmailScreen();
    }

    // ========================================================================
    // COMPTE DÉSACTIVÉ
    // ========================================================================

    if (!session.accountActive) {

      return const AccountPendingApprovalScreen();
    }

    // ========================================================================
    // AUTORISÉ
    // ========================================================================

    return child;
  }
}