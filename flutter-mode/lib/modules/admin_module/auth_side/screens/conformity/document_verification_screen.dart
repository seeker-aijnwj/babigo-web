// ============================================================================
// FILE : screens/verification/document_verification_screen.dart
// ============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';
import '../../../database/services/kyc_service.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({
    super.key,
  });

  @override
  State<DocumentVerificationScreen> createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {

  File? _identityCard;

  File? _drivingLicence;

  File? _vehicleRegistration;

  File? _insurance;

  File? _technicalInspection;

  bool _loading = false;

  final KycService _kycService = KycService();

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Documents",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _buildHeader(),

          const SizedBox(height: 20),

          _buildDocumentTile(
            title: "Carte d'identité",
            icon: Icons.badge,
            file: _identityCard,
            onTap: () => _pickIdentityCard(),
          ),

          _buildDocumentTile(
            title: "Permis de conduire",
            icon: Icons.drive_eta,
            file: _drivingLicence,
            onTap: () => _pickDrivingLicence(),
          ),

          _buildDocumentTile(
            title: "Carte grise",
            icon: Icons.description,
            file: _vehicleRegistration,
            onTap: () => _pickVehicleRegistration(),
          ),

          _buildDocumentTile(
            title: "Assurance",
            icon: Icons.shield,
            file: _insurance,
            onTap: () => _pickInsurance(),
          ),

          _buildDocumentTile(
            title: "Visite technique",
            icon: Icons.fact_check,
            file: _technicalInspection,
            onTap: () => _pickTechnicalInspection(),
          ),

          const SizedBox(height: 30),

          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {

    return const BabiGOCard(
      child: Column(
        children: [

          Icon(
            Icons.verified_user,
            size: 80,
          ),

          SizedBox(height: 12),

          Text(
            "Vérification des documents",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Téléversez les documents requis pour sécuriser votre compte et débloquer toutes les fonctionnalités.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile({
    required String title,
    required IconData icon,
    required File? file,
    required VoidCallback onTap,
  }) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: BabiGOCard(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(
            file == null
                ? "Document non ajouté"
                : "Document prêt",
          ),
          trailing: Icon(
            file == null
                ? Icons.upload_file
                : Icons.check_circle,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _loading
            ? null
            : _submitDocuments,
        child: _loading
            ? const CircularProgressIndicator()
            : const Text(
          "Envoyer les documents",
        ),
      ),
    );
  }

  Future<void> _pickIdentityCard() async {
    _identityCard = await _pickFile();
    setState(() {});
  }

  Future<void> _pickDrivingLicence() async {
    _drivingLicence = await _pickFile();
    setState(() {});
  }

  Future<void> _pickVehicleRegistration() async {
    _vehicleRegistration = await _pickFile();
    setState(() {});
  }

  Future<void> _pickInsurance() async {
    _insurance = await _pickFile();
    setState(() {});
  }

  Future<void> _pickTechnicalInspection() async {
    _technicalInspection = await _pickFile();
    setState(() {});
  }

  Future<File?> _pickFile() async {

    final result = await FilePicker.pickFiles();

    if (result == null) {
      return null;
    }

    return File(
      result.files.single.path!,
    );
  }

  Future<void> _submitDocuments() async {

    setState(() {
      _loading = true;
    });

    try {

      /**
      await _kycService.submitDocuments(
        identityCard: _identityCard,
        drivingLicence: _drivingLicence,
        vehicleRegistration:
        _vehicleRegistration,
        insurance: _insurance,
        technicalInspection:
        _technicalInspection,
      );
          **/

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Documents envoyés",
            ),
          ),
        );

        Navigator.pop(context);
      }
    } finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });
      }
    }
  }
}