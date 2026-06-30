// ============================================================================
// FILE : auth/auth_user_guard.dart
// ============================================================================
//
// GARDE D'AUTHENTIFICATION PRINCIPALE
//
// Responsable de :
//
// ✓ Etat FirebaseAuth
// ✓ Chargement Utilisateur
// ✓ Vérification email
// ✓ Vérification profil
// ✓ Vérification suspension
// ✓ Vérification suppression
// ✓ Redirection automatique
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../database/services/auth_service.dart';
import '../auth_route_manager.dart';

class AuthUserGuard extends StatelessWidget {


  const AuthUserGuard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges(),
      builder: (context, snapshot) {

        // Chargement Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthLoadingScreen();
        }

        final firebaseUser = snapshot.data;

        // Pas connecté
        if (firebaseUser == null) {
          return AuthRouteManager.unauthenticated();
        }

        // Connecté
        return AuthRouteManager.authenticated(
          firebaseUser,
        );
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {

  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [

            CircularProgressIndicator(),

            SizedBox(height: 24),

            Text(
              "Chargement...",
            ),
          ],
        ),
      ),
    );
  }
}