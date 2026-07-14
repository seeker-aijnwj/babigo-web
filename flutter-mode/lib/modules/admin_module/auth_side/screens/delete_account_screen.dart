// ============================================================================
// FILE : auth/screens/delete_account_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/screens/babigo_scaffold.dart';
import '../../../../app/widgets/babigo_card.dart';

import '../../database/services/auth_service.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({
    super.key,
  });

  @override
  State<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState
    extends State<DeleteAccountScreen> {

  final _passwordController =
  TextEditingController();

  bool _accepted = false;

  bool _loading = false;

  bool _obscurePassword = true;

  User? get user =>
      FirebaseAuth.instance.currentUser;

  @override
  void dispose() {

    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(

      title: "Supprimer mon compte",

      child: ListView(
        padding:
        const EdgeInsets.all(24),

        children: [

          _buildWarningCard(),

          const SizedBox(height: 20),

          _buildConsequencesCard(),

          const SizedBox(height: 20),

          _buildPasswordCard(),

          const SizedBox(height: 20),

          _buildConfirmationCheckbox(),

          const SizedBox(height: 30),

          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {

    return BabiGOCard(

      child: Column(

        children: [

          const Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 80,
          ),

          const SizedBox(height: 20),

          Text(
            "Cette action est irréversible",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme .titleLarge,
          ),

          const SizedBox(height: 12),

          const Text(
            "La suppression du compte entraînera la perte définitive de vos données BabiGO.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConsequencesCard() {

    return BabiGOCard(

      title: "Ce qui sera supprimé",

      child: Column(

        children: [

          _DeleteRow(
            icon: Icons.person,
            text: "Profil utilisateur",
          ),

          _DeleteRow(
            icon: Icons.directions_car,
            text: "Véhicules enregistrés",
          ),

          _DeleteRow(
            icon: Icons.route,
            text: "Annonces de trajet",
          ),

          _DeleteRow(
            icon: Icons.book_online,
            text: "Réservations",
          ),

          _DeleteRow(
            icon: Icons.star,
            text: "Avis et notes",
          ),

          _DeleteRow(
            icon: Icons.photo,
            text: "Photos téléchargées",
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard() {

    final provider =
        user?.providerData.first.providerId;

    if (provider != "password") {

      return BabiGOCard(
        child: const Text(
          "Votre compte utilise une connexion externe (Google ou Apple). Une vérification supplémentaire sera demandée.",
        ),
      );
    }

    return BabiGOCard(

      title: "Confirmation",

      child: TextFormField(

        controller: _passwordController,

        obscureText: _obscurePassword,

        decoration: InputDecoration(

          labelText: "Mot de passe",

          suffixIcon: IconButton(
            onPressed: () {

              setState(() {

                _obscurePassword =
                !_obscurePassword;
              });
            },
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationCheckbox() {

    return CheckboxListTile(

      value: _accepted,

      onChanged: (value) {

        setState(() {
          _accepted =
              value ?? false;
        });
      },

      title: const Text(
          "Je comprends que cette suppression est définitive."
      ),
    );
  }

  Widget _buildDeleteButton() {

    return SizedBox(

      height: 56,

      child: ElevatedButton.icon(

        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          Colors.red,
        ),

        onPressed:
        (!_accepted || _loading)
            ? null
            : _showFinalConfirmation,

        icon: _loading
            ? const SizedBox(
          width: 18,
          height: 18,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : const Icon(
          Icons.delete_forever,
        ),

        label: const Text(
          "Supprimer définitivement",
        ),
      ),
    );
  }

  Future<void>
  _showFinalConfirmation() async {

    final result =
    await showDialog<bool>(
      context: context,

      builder: (_) {

        return AlertDialog(

          title:
          const Text(
            "Dernière confirmation",
          ),

          content:
          const Text(
            "Voulez-vous vraiment supprimer votre compte BabiGO ?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child:
              const Text(
                "Annuler",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
              const Text(
                "Supprimer",
              ),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    await _deleteAccount();
  }

  Future<void> _deleteAccount() async {

    try {

      setState(() {
        _loading = true;
      });

      await AuthService().deleteCurrentAccount();

      if (!mounted) return;

      Navigator.of(context) .pushNamedAndRemoveUntil(
        "/signin", (route) => false,
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context) .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
}

class _DeleteRow extends StatelessWidget {

  final IconData icon;

  final String text;

  const _DeleteRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [

          Icon(icon),

          const SizedBox(width: 12),

          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}





