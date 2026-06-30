// ============================================================================
// FILE : auth/auth_route_manager.dart
// ============================================================================
//
// ROUTEUR CENTRAL BabiGO
//
// ============================================================================

import 'package:babigo/modules/admin_module/auth_side/screens/complete_profile_screen.dart';
import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:babigo/modules/admin_module/database/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../app/core/utils/constants.dart';
import '../../auth_module/screens/signin_screen.dart';
import '../screens/admin_welcome_screen.dart';
import 'screens/validation/account_suspended_screen.dart';
import 'screens/conformity/verify_email_screen.dart';
import '../database/models/admin/utilisateur.dart';
import '../screens/users/admin_driver_main_screen.dart';
import '../screens/users/admin_fleet_manager_main_screen.dart';
import '../screens/users/admin_investor_main_screen.dart';
import '../screens/users/admin_passenger_main_screen.dart';
import '../screens/users/admin_superadmin_main_screen.dart';
import '../screens/users/admin_support_main_screen.dart';
import 'screens/auth_welcome_screen.dart';


class AuthRouteManager {

  AuthRouteManager._();

  static Widget unauthenticated() {
    return const AdminWelcomeScreen();
  }

  static Widget authenticated(User firebaseUser,) {

    return _AuthenticatedRouter(firebaseUser: firebaseUser,);

  }

  // ==========================================================================
  // REDIRECTION PRINCIPALE
  // ==========================================================================

  static Future<void> redirectAfterLogin(
      BuildContext context,
      ) async {

    final user = Utils.auth.currentUser;

    if (user == null) {

      _replace(context, const SignInScreen(),
      );

      return;
    }

    final doc =  await AdminDataService.getUser(user.uid);

    if (!doc.exists) {

      await AuthService.signOut();

      _replace(
        context,
        const SignInScreen(),
      );

      return;
    }

    final data = doc.data()! as Map<String, dynamic>;

    final role = UserRole.values.firstWhere(
          (e) => e.name == data['role'],
      orElse: () => UserRole.passenger,
    );

    switch (role) {

      case UserRole.passenger:

        _replace(
          context,
          const AdminPassengerMainScreen(),
        );
        break;

      case UserRole.driver:

        _replace(
          context,
          const AdminDriverMainScreen(),
        );
        break;

      case UserRole.fleetManager:

        _replace(
          context,
          const AdminFleetManagerMainScreen(),
        );
        break;

      case UserRole.support:

        _replace(
          context,
          const AdminSupportMainScreen(),
        );
        break;

      default:

        await AuthService.signOut();

        _replace(
          context,
          const SignInScreen(),
        );
    }
  }

  // ==========================================================================
  // NAVIGATION
  // ==========================================================================

  static void _replace(
      BuildContext context,
      Widget screen,
      ) {

    Navigator.of(context)
        .pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
          (_) => false,
    );
  }

}

class _AuthenticatedRouter extends StatelessWidget {

  final User firebaseUser;

  const _AuthenticatedRouter({
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context,) {
    return FutureBuilder<DocumentSnapshot>(
      future: AdminDataService.getUser(firebaseUser.uid),
      builder: (context,snapshot,) {

        if (snapshot.connectionState == ConnectionState.waiting) {

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {

          return const AuthWelcomeScreen();

        }

        final user = Utilisateur.fromFirestore(snapshot.data!,);


        if (!firebaseUser.emailVerified) {
          return const VerifyEmailScreen();
        }

        if (user.isSuspended) {
          return const AccountSuspendedScreen(
            type: AccountRestrictionType.suspended
          );
        }

        if (!user.isProfileComplete) {
          return CompleteProfileScreen(
            selectedUser: user,
          );
        }

        switch (user.role) {

          case UserRole.passenger:
            return const AdminPassengerMainScreen();

          case UserRole.driver:
            return const AdminDriverMainScreen();

          case UserRole.fleetManager:
            return const AdminFleetManagerMainScreen();

          case UserRole.admin:
            return const AdminSuperAdminMainScreen();

          case UserRole.support:
            return const AdminSupportMainScreen();

          case UserRole.investor:
            return const AdminInvestorMainScreen();

        }
      },
    );
  }
}


