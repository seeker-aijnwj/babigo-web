import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/core/utils/colors.dart';
import '../../../app/core/utils/constants.dart';

class AdminSignUpScreen extends StatefulWidget {

  const AdminSignUpScreen({
    super.key,
  });

  @override
  State<AdminSignUpScreen> createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {

  final _formKey = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _loading = false;
  bool _obscurePassword = true;
  final bool _obscureConfirm = true;

  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _acceptDataPolicy = false;

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _phoneController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            final isDesktop = constraints.maxWidth > 900;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints:
                  const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: isDesktop
                      ? Row(
                    children: [

                      Expanded(
                        child:
                        _buildHeroSection(),
                      ),

                      const SizedBox(
                        width: 24,
                      ),

                      SizedBox(
                        width: 500,
                        child:
                        _buildFormCard(),
                      ),
                    ],
                  ) : Column(
                    children: [

                      _buildHeroSection(),

                      const SizedBox(
                        height: 20,
                      ),

                      _buildFormCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection() {

    return Container(
      padding:
      const EdgeInsets.all(32),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.mainColor,
            Color(0xFF5B8DFF),
          ],
        ),

        borderRadius:
        BorderRadius.circular(32),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Center(
            child: Image.asset(
              'assets/images/icons/appstore.png',
              width: 120,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Rejoignez BabiGO",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Créez votre espace et participez à la mobilité intelligente en Côte d'Ivoire.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          _feature(
            Icons.security,
            "Sécurité avancée",
          ),

          _feature(
            Icons.verified_user,
            "Compte vérifié",
          ),

          _feature(
            Icons.analytics,
            "Suivi en temps réel",
          ),

          _feature(
            Icons.support_agent,
            "Support dédié",
          ),
        ],
      ),
    );
  }

  Widget _feature(IconData icon, String text) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [

          Icon(icon, color: Colors.white,),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {

    return Container(
      padding:
      const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(28),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withValues(alpha: .05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          controlsBuilder: (context, details) {

            return Row(
              children: [

                ElevatedButton.icon(

                  onPressed:
                  _loading
                      ? null
                      : details.onStepContinue,

                  icon: _loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.arrow_forward),

                  label: Text(
                    _currentStep == 2
                        ? "Créer mon compte"
                        : "Continuer",
                  ),
                ),

                const SizedBox(width: 12),

                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text("Retour"),
                  ),
              ],
            );
          },

          onStepContinue: _onStepContinue,

          onStepCancel: _onStepCancel,

          steps: [
            _personalStep(),
            _securityStep(),
            _validationStep(),
          ],
        ),
      ),
    );
  }

  Step _personalStep() {

    return Step(
      title: const Text("Profil"),
      isActive: _currentStep >= 0,

      content: Column(
        children: [

          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: "Prénom",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: "Nom",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Téléphone",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
        ],
      ),
    );
  }

  Step _securityStep() {

    return Step(
      title:
      const Text("Sécurité"),

      content: Column(
        children: [

          TextFormField(
            controller:
            _passwordController,
            obscureText:
            _obscurePassword,
            decoration:
            InputDecoration(
              labelText:
              "Mot de passe",

              suffixIcon:
              IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility
                      : Icons
                      .visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword =
                    !_obscurePassword;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _confirmPasswordController,
            obscureText:
            _obscureConfirm,
            decoration:
            const InputDecoration(
              labelText:
              "Confirmer",
            ),
          ),

          const SizedBox(height: 20),

          _buildPasswordStrength(),
        ],
      ),
    );
  }

  Step _validationStep() {

    return Step(
      title:
      const Text("Validation"),

      content: Column(
        children: [

          CheckboxListTile(
            value: _acceptTerms,
            onChanged: (v) {
              setState(() {
                _acceptTerms =
                    v ?? false;
              });
            },
            title: const Text(
              "J'accepte les Conditions Générales",
            ),
          ),

          CheckboxListTile(
            value: _acceptPrivacy,
            onChanged: (v) {
              setState(() {
                _acceptPrivacy =
                    v ?? false;
              });
            },
            title: const Text(
              "J'accepte la Politique de Confidentialité",
            ),
          ),

          CheckboxListTile(
            value: _acceptDataPolicy,
            onChanged: (v) {
              setState(() {
                _acceptDataPolicy =
                    v ?? false;
              });
            },
            title: const Text(
              "J'autorise le traitement de mes données",
            ),
          ),
        ],
      ),
    );
  }

  double get _passwordStrength {
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      return 0;
    }

    double score = 0;

    if (password.length >= 8) score += .25;

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      score += .25;
    }

    if (RegExp(r'[0-9]').hasMatch(password)) {
      score += .25;
    }

    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]')
        .hasMatch(password)) {
      score += .25;
    }

    return score;
  }

  Widget _buildPasswordStrength() {

    final strength = _passwordStrength;

    String label = "Faible";

    Color color = Colors.red;

    if (strength >= .25) {
      label = "Moyen";
      color = Colors.orange;
    }

    if (strength >= .50) {
      label = "Bon";
      color = Colors.amber;
    }

    if (strength >= .75) {
      label = "Fort";
      color = Colors.green;
    }

    if (strength == 1) {
      label = "Très fort";
      color = Colors.green.shade700;
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        LinearProgressIndicator(
          value: strength,
          minHeight: 8,
          borderRadius:
          BorderRadius.circular(20),
          color: color,
        ),

        const SizedBox(height: 8),

        Text(
          "Sécurité : $label",
          style: TextStyle(
            color: color,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  bool _validateBeforeCreate() {

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {

      _showSnack(
        "Les mots de passe ne correspondent pas.",
      );

      return false;
    }

    if (_passwordStrength < .50) {

      _showSnack(
        "Choisissez un mot de passe plus sécurisé.",
      );

      return false;
    }

    if (!_acceptTerms) {

      _showSnack(
        "Vous devez accepter les CGU.",
      );

      return false;
    }

    if (!_acceptPrivacy) {

      _showSnack(
        "Vous devez accepter la politique de confidentialité.",
      );

      return false;
    }

    if (!_acceptDataPolicy) {

      _showSnack(
        "Vous devez accepter le traitement des données.",
      );

      return false;
    }

    return true;
  }

  Future<void> _createAccount() async {

    if (!_validateBeforeCreate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      final credential = await Utils.auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;

      if (user == null) {
        throw Exception(
          "Utilisateur introuvable.",
        );
      }

      await user.sendEmailVerification();

      await Utils.db.collection("admins").doc(user.uid)
          .set({
        "uid": user.uid,
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        "role": "support",
        "status": "pending",
        "active": true,
        "emailVerified": false,
        "profilePhoto": null,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
        "lastLogin": null,
      });

      if (!mounted) return;

      _showSuccessDialog();

    } on FirebaseAuthException catch (e) {

      _showSnack(
        _firebaseErrorMessage(e),
      );

    } catch (e) {

      _showSnack(
        e.toString(),
      );

    } finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });
      }
    }
  }

  String _firebaseErrorMessage(
      FirebaseAuthException e,
      ) {

    switch (e.code) {

      case 'email-already-in-use':
        return "Cet email existe déjà.";

      case 'invalid-email':
        return "Adresse email invalide.";

      case 'weak-password':
        return "Mot de passe trop faible.";

      case 'network-request-failed':
        return "Connexion internet indisponible.";

      default:
        return e.message ??
            "Erreur inconnue.";
    }
  }

  void _showSuccessDialog() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Row(
            children: [

              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),

              SizedBox(width: 10),

              Text("Compte créé"),
            ],
          ),

          content: const Text(
            "Votre compte a été créé avec succès.\n\n"
                "Un email de vérification vient de vous être envoyé.",
          ),

          actions: [

            FilledButton(
              onPressed: () {

                Navigator.pop(context);

                Navigator.pop(context);
              },
              child: const Text(
                "Continuer",
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  void _onStepContinue() {

    if (_currentStep < 2) {

      setState(() {
        _currentStep++;
      });
    }

    _createAccount();
  }

  void _onStepCancel() {

    if (_currentStep == 0) {
      return;
    }

    setState(() {
      _currentStep--;
    });
  }


}