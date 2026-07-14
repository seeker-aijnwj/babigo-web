// ============================================================================
// FILE : screens/verification/fleet_verification_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';

class FleetVerificationScreen extends StatefulWidget {
  const FleetVerificationScreen({
    super.key,
  });

  @override
  State<FleetVerificationScreen> createState() =>
      _FleetVerificationScreenState();
}

class _FleetVerificationScreenState
    extends State<FleetVerificationScreen> {

  final _companyNameController =
  TextEditingController();

  final _registrationNumberController =
  TextEditingController();

  final _taxNumberController =
  TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "Vérification flotte",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SizedBox(height: 12),

          _buildHeader(),

          const SizedBox(height: 24),

          _buildCompanyInformation(),

          const SizedBox(height: 24),

          _buildRequiredDocuments(),

          const SizedBox(height: 32),

          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BabiGOCard(
      child: Column(
        children: const [

          Icon(
            Icons.business,
            size: 70,
          ),

          SizedBox(height: 16),

          Text(
            "Vérification du gestionnaire de flotte",
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          Text(
            "Ajoutez les documents officiels de votre entreprise afin de gérer plusieurs conducteurs et véhicules.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInformation() {
    return BabiGOCard(
      title: "Informations société",
      child: Column(
        children: [

          TextFormField(
            controller: _companyNameController,
            decoration: const InputDecoration(
              labelText: "Nom de l'entreprise",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _registrationNumberController,
            decoration: const InputDecoration(
              labelText: "RCCM",
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _taxNumberController,
            decoration: const InputDecoration(
              labelText: "Numéro fiscal",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocuments() {
    return BabiGOCard(
      title: "Documents obligatoires",
      child: Column(
        children: const [

          ListTile(
            leading: Icon(Icons.description),
            title: Text("Registre de commerce"),
          ),

          ListTile(
            leading: Icon(Icons.approval),
            title: Text("Attestation fiscale"),
          ),

          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text("Document bancaire"),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _loading
            ? null
            : _submitVerification,
        child: _loading
            ? const CircularProgressIndicator()
            : const Text(
          "Envoyer la demande",
        ),
      ),
    );
  }

  Future<void> _submitVerification() async {

    setState(() {
      _loading = true;
    });

    try {

      /// ComplianceService

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Demande envoyée",
            ),
          ),
        );
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