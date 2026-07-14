// ============================================================================
// FILE : auth/screens/complete_profile_screen.dart
// ============================================================================
//
// COMPLÉTION DU PROFIL UTILISATEUR
//
// Utilisé après :
//
// ✓ Inscription Email
// ✓ Google Sign-In
// ✓ Apple Sign-In
//
// Objectif :
//
// Transformer un compte Firebase brut
// en profil BabiGO complet.
//
// Firestore :
//
// users/{uid}
//
// Champs mis à jour :
//
// firstName
// lastName
// phoneNumber
// gender
// birthDate
// city
// municipality
// photoUrl
// role
// profileCompleted
//
// ============================================================================

import 'dart:io';

import 'package:babigo/modules/admin_module/database/models/admin/utilisateur.dart';
import 'package:flutter/material.dart';

import '../../../../app/screens/babigo_scaffold.dart';
import '../../../../app/widgets/babigo_card.dart';

import '../../database/services/auth_service.dart';

enum UserRoleSelection {
  passenger,
  driver,
  fleetManager,
}

class CompleteProfileScreen extends StatefulWidget {

  final Utilisateur? selectedUser;

  const CompleteProfileScreen({
    super.key,
    this.selectedUser
  });

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {

  // ==========================================================================
  // FORM
  // ==========================================================================

  final _formKey = GlobalKey<FormState>();

  // ==========================================================================
  // CONTROLLERS
  // ==========================================================================

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _phoneController =
  TextEditingController();

  final _cityController =
  TextEditingController();

  final _municipalityController =
  TextEditingController();

  // ==========================================================================
  // STATE
  // ==========================================================================

  bool _loading = false;

  File? _profileImage;

  DateTime? _birthDate;

  String? _gender;

  UserRoleSelection _selectedRole =
      UserRoleSelection.passenger;

  final List<String> _genders = [
    "Homme",
    "Femme",
  ];

  @override
  void dispose() {

    _firstNameController.dispose();

    _lastNameController.dispose();

    _phoneController.dispose();

    _cityController.dispose();

    _municipalityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Compléter mon profil",

      child: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(24),

          children: [

            _buildHeader(),

            const SizedBox(height: 24),

            _buildProfilePicture(),

            const SizedBox(height: 20),

            _buildIdentitySection(),

            const SizedBox(height: 20),

            _buildContactSection(),

            const SizedBox(height: 20),

            _buildLocationSection(),

            const SizedBox(height: 20),

            _buildRoleSection(),

            const SizedBox(height: 30),

            _buildSaveButton(),
          ],
        ),
      ),
    );


  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader() {

    return BabiGOCard(
      child: Column(
        children: [

          const Icon(
            Icons.account_circle,
            size: 70,
          ),

          const SizedBox(height: 16),

          const Text(
            "Finalisons votre profil",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Quelques informations supplémentaires nous permettront de personnaliser votre expérience BabiGO.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // PHOTO
  // ==========================================================================

  Widget _buildProfilePicture() {

    return BabiGOCard(
      title: "Photo de profil",

      child: Center(
        child: GestureDetector(
          onTap: _pickProfileImage,

          child: CircleAvatar(
            radius: 60,

            backgroundImage:
            _profileImage != null
                ? FileImage(
              _profileImage!,
            )
                : null,

            child: _profileImage == null
                ? const Icon(
              Icons.camera_alt,
              size: 40,
            )
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {

    // TODO
    // image_picker

  }

  Widget _buildIdentitySection() {

    return BabiGOCard(
      title: "Identité",

      child: Column(
        children: [

          TextFormField(
            controller:
            _firstNameController,

            decoration:
            const InputDecoration(
              labelText: "Prénom",
            ),

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {
                return "Champ obligatoire";
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _lastNameController,

            decoration:
            const InputDecoration(
              labelText: "Nom",
            ),

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {
                return "Champ obligatoire";
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _gender,

            decoration:
            const InputDecoration(
              labelText: "Genre",
            ),

            items: _genders
                .map(
                  (gender) =>
                  DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ),
            )
                .toList(),

            onChanged: (value) {

              setState(() {
                _gender = value;
              });
            },
          ),

          const SizedBox(height: 16),

          ListTile(
            contentPadding:
            EdgeInsets.zero,

            title: Text(
              _birthDate == null
                  ? "Date de naissance"
                  : _birthDate
                  .toString()
                  .split(" ")
                  .first,
            ),

            trailing:
            const Icon(Icons.cake),

            onTap: _selectBirthDate,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {

    return BabiGOCard(
      title: "Contact",

      child: TextFormField(
        controller:
        _phoneController,

        keyboardType:
        TextInputType.phone,

        decoration:
        const InputDecoration(
          labelText:
          "Téléphone",
          prefixIcon:
          Icon(Icons.phone),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {

    return BabiGOCard(
      title: "Localisation",

      child: Column(
        children: [

          TextFormField(
            controller:
            _cityController,

            decoration:
            const InputDecoration(
              labelText: "Ville",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _municipalityController,

            decoration:
            const InputDecoration(
              labelText: "Commune",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSection() {

    return BabiGOCard(
      title: "Je souhaite utiliser BabiGO comme",

      child: Column(
        children: [

          RadioListTile<UserRoleSelection>(
            value:
            UserRoleSelection.passenger,

            groupValue: _selectedRole,

            title: const Text("Passager"),

            subtitle: const Text(
              "Réserver des trajets",
            ),

            onChanged: (value) {

              if (value == null) return;

              setState(() {
                _selectedRole = value;
              });
            },
          ),

          RadioListTile<UserRoleSelection>(
            value: UserRoleSelection.driver,

            groupValue: _selectedRole,

            title: const Text("Conducteur"),

            subtitle: const Text(
              "Publier des trajets",
            ),

            onChanged: (value) {

              if (value == null) return;

              setState(() {
                _selectedRole = value;
              });
            },
          ),

          RadioListTile<UserRoleSelection>(
            value: UserRoleSelection.fleetManager,

            groupValue: _selectedRole,

            title: const Text(
              "Gestionnaire de flotte",
            ),

            subtitle:
            const Text(
              "Gérer plusieurs véhicules",
            ),

            onChanged: (value) {

              if (value == null) return;

              setState(() {
                _selectedRole = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {

    return SizedBox(
      height: 55,

      child: ElevatedButton(
        onPressed:
        _loading
            ? null
            : _saveProfile,

        child: _loading
            ? const CircularProgressIndicator()
            : const Text(
          "Terminer",
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {

      setState(() {
        _loading = true;
      });

      final user = AuthService().currentUser;

      if (user == null) {
        return;
      }

      await AuthService().completeProfile(
        uid: user.uid,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        municipality: _municipalityController.text.trim(),
        gender: _gender,
        birthDate: _birthDate,
        role: _selectedRole.name,
      );

      if (!mounted) return;

      // AuthGuard prendra ensuite le relais

      Navigator.pop(context);

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

  Future<void> _selectBirthDate() async {

    final date =
    await showDatePicker(
      context: context,
      firstDate:
      DateTime(1950),
      lastDate:
      DateTime.now(),
      initialDate:
      DateTime(2000),
    );

    if (date == null) return;

    setState(() {
      _birthDate = date;
    });
  }
}

