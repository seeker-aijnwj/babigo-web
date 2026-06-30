// ============================================================================
// FILE : auth/screens/forgot_password_screen.dart
// ============================================================================
//
// ÉCRAN DE RÉINITIALISATION DE MOT DE PASSE
//
// Fonctionnalités :
//
// ✓ Firebase Auth
// ✓ Validation email
// ✓ UX moderne
// ✓ Gestion erreurs
// ✓ Loading
// ✓ Responsive
// ✓ Compatible Mobile / Web / Desktop
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../app/screens/babigo_scaffold.dart';
import '../../../../app/widgets/babigo_card.dart';

import '../../database/services/auth_service.dart';
import 'reset_password_success_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _formKey =
  GlobalKey<FormState>();

  final _emailController =
  TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // ENVOI EMAIL
  // ==========================================================================

  Future<void> _sendResetLink() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {

      setState(() {
        _loading = true;
      });

      await AuthService.sendPasswordResetEmail(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResetPasswordSuccessScreen(
                email:
                _emailController.text.trim(),
              ),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Mot de passe oublié",

      child: Form(
        key: _formKey,

        child: ListView(
          padding:
          const EdgeInsets.all(24),

          children: [

            const SizedBox(height: 30),

            BabiGOCard(
              child: Column(
                children: [

                  const Icon(
                    Icons.lock_reset,
                    size: 90,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Réinitialiser votre mot de passe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Entrez votre adresse email afin de recevoir un lien sécurisé de réinitialisation.",
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color:
                      Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller:
                    _emailController,

                    keyboardType:
                    TextInputType.emailAddress,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Adresse email",
                      prefixIcon:
                      Icon(Icons.email),
                    ),

                    validator: (value) {

                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Veuillez saisir votre email";
                      }

                      final regex = RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      );

                      if (!regex.hasMatch(
                        value.trim(),
                      )) {
                        return "Email invalide";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      onPressed:
                      _loading
                          ? null
                          : _sendResetLink,

                      child: _loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        "Envoyer le lien",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}