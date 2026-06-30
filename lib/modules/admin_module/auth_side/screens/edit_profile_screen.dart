// ============================================================================
// FILE : auth/screens/edit_profile_screen.dart
// ============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/screens/babigo_scaffold.dart';
import '../../../../app/widgets/babigo_card.dart';

import '../../database/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey =
  GlobalKey<FormState>();

  final _firstNameController =
  TextEditingController();

  final _lastNameController =
  TextEditingController();

  final _phoneController =
  TextEditingController();

  final _cityController =
  TextEditingController();

  final _municipalityController =
  TextEditingController();

  bool _loading = true;

  bool _saving = false;

  File? _newImage;

  String? _photoUrl;

  String? _gender;

  DateTime? _birthDate;

  final List<String> _genders = [
    "Homme",
    "Femme",
  ];

  User? get _user =>
      FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  @override
  void dispose() {

    _firstNameController.dispose();

    _lastNameController.dispose();

    _phoneController.dispose();

    _cityController.dispose();

    _municipalityController.dispose();

    super.dispose();
  }

  Future<void> _loadProfile() async {

    try {

      final doc =
      await AuthService().getCurrentUserDocument();

      final data =
      doc.data();

      if (data == null) return;

      _firstNameController.text =
          data['firstName'] ?? '';

      _lastNameController.text =
          data['lastName'] ?? '';

      _phoneController.text =
          data['phoneNumber'] ?? '';

      _cityController.text =
          data['city'] ?? '';

      _municipalityController.text =
          data['municipality'] ?? '';

      _gender =
      data['gender'];

      _photoUrl =
      data['photoUrl'];

      final birth =
      data['birthDate'];

      if (birth != null) {
        _birthDate =
            birth.toDate();
      }

    } catch (_) {

    } finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {

    return BabiGOScaffold(

      title: "Mon profil",

      child: _loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : Form(
        key: _formKey,

        child: ListView(
          padding:
          const EdgeInsets.all(
            24,
          ),

          children: [

            _buildProfilePhoto(),

            const SizedBox(
              height: 24,
            ),

            _buildIdentityCard(),

            const SizedBox(
              height: 20,
            ),

            _buildContactCard(),

            const SizedBox(
              height: 20,
            ),

            _buildLocationCard(),

            const SizedBox(
              height: 30,
            ),

            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto() {

    return BabiGOCard(

      child: Column(

        children: [

          Stack(

            children: [

              CircleAvatar(
                radius: 60,

                backgroundImage:
                _newImage != null
                    ? FileImage(
                  _newImage!,
                )
                    : (_photoUrl != null
                    ? NetworkImage(
                  _photoUrl!,
                )
                    : null)
                as ImageProvider?,

                child:
                _photoUrl == null &&
                    _newImage == null
                    ? const Icon(
                  Icons.person,
                  size: 60,
                )
                    : null,
              ),

              Positioned(
                bottom: 0,
                right: 0,

                child: GestureDetector(
                  onTap:
                  _pickImage,

                  child: Container(
                    padding:
                    const EdgeInsets.all(
                      10,
                    ),

                    decoration:
                    const BoxDecoration(
                      color:
                      Colors.blue,
                      shape:
                      BoxShape.circle,
                    ),

                    child:
                    const Icon(
                      Icons.edit,
                      color:
                      Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            _user?.email ?? "",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard() {

    return BabiGOCard(

      title: "Informations personnelles",

      child: Column(
        children: [

          TextFormField(
            controller:
            _firstNameController,
            decoration:
            const InputDecoration(
              labelText:
              "Prénom",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _lastNameController,
            decoration:
            const InputDecoration(
              labelText:
              "Nom",
            ),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _gender,

            decoration:
            const InputDecoration(
              labelText:
              "Genre",
            ),

            items: _genders
                .map(
                  (e) =>
                  DropdownMenuItem(
                    value: e,
                    child: Text(e),
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
                  : _birthDate!
                  .toString()
                  .split(" ")
                  .first,
            ),

            trailing:
            const Icon(
              Icons.cake,
            ),

            onTap:
            _selectBirthDate,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {

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
        ),
      ),
    );
  }

  Widget _buildLocationCard() {

    return BabiGOCard(
      title: "Adresse",

      child: Column(
        children: [

          TextFormField(
            controller:
            _cityController,

            decoration:
            const InputDecoration(
              labelText:
              "Ville",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _municipalityController,

            decoration:
            const InputDecoration(
              labelText:
              "Commune",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {

    return SizedBox(
      height: 56,

      child: ElevatedButton(
        onPressed:
        _saving ? null : _saveProfile,

        child: _saving
            ? const CircularProgressIndicator()
            : const Text(
          "Enregistrer",
        ),
      ),
    );
  }

  Future<void> _pickImage() async {

    // image_picker
    // upload Firebase Storage

  }

  Future<void> _selectBirthDate() async {

    final date =
    await showDatePicker(
      context: context,
      initialDate:
      DateTime(2000),
      firstDate:
      DateTime(1950),
      lastDate:
      DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      _birthDate = date;
    });
  }

  Future<void> _saveProfile() async {

    try {

      setState(() {
        _saving = true;
      });

      await AuthService().completeProfile(
        uid: _user!.uid,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        municipality: _municipalityController.text,
        role: "passenger",
        gender: _gender,
        birthDate: _birthDate,
        photoUrl:  _photoUrl,
      );

      if (!mounted) return;

      Navigator.pop(
        context,
      );

    } finally {

      if (mounted) {

        setState(() {
          _saving = false;
        });
      }
    }
  }
}
