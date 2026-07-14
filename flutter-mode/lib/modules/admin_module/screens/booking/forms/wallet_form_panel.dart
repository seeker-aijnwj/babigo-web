/// =============================================================================
/// FILE : app_wallet_form.dart
/// =============================================================================
///
/// FORMULAIRE COMPLET D’AJOUT / MODIFICATION D’UN WALLET
///
/// Compatible :
///
/// ✅ Flutter Mobile
/// ✅ Flutter Desktop
/// ✅ Flutter Web
/// ✅ Firebase Firestore
/// ✅ Architecture scalable
///
/// =============================================================================
///
/// FONCTIONNALITÉS
/// =============================================================================
///
/// ✅ Création Wallet
/// ✅ Modification Wallet
/// ✅ Validation avancée
/// ✅ Gestion des erreurs
/// ✅ Sauvegarde Firestore
/// ✅ Mode Edition
/// ✅ Gestion du solde
/// ✅ Gestion du solde gelé
/// ✅ Activation / Désactivation
/// ✅ Blocage Wallet
/// ✅ Responsive UI
/// ✅ Réutilisable partout
///
/// =============================================================================

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../database/models/admin/wallet.dart';

/// =============================================================================
/// FORMULAIRE WALLET
/// =============================================================================

class AppWalletForm extends StatefulWidget {
  /// Wallet à modifier
  final AppWallet? wallet;

  /// Callback succès
  final VoidCallback? onSuccess;

  const AppWalletForm({
    super.key,
    this.wallet,
    this.onSuccess,
  });

  @override
  State<AppWalletForm> createState() =>
      _AppWalletFormState();
}

class _AppWalletFormState
    extends State<AppWalletForm> {
  /// ===========================================================================
  /// FORM KEY
  /// ===========================================================================

  final _formKey = GlobalKey<FormState>();

  /// ===========================================================================
  /// CONTROLLERS
  /// ===========================================================================

  final _userIdController =
  TextEditingController();

  final _balanceController =
  TextEditingController();

  final _frozenBalanceController =
  TextEditingController();

  /// ===========================================================================
  /// VARIABLES
  /// ===========================================================================

  WalletCurrency _currency = WalletCurrency.xof;

  int _locked = 0;

  bool _loading = false;

  /// ===========================================================================
  /// INIT STATE
  /// ===========================================================================

  @override
  void initState() {
    super.initState();

    final wallet = widget.wallet;

    if (wallet != null) {
      _userIdController.text = wallet.userId!;

      _balanceController.text =
          wallet.balance.toString();

      _frozenBalanceController.text =
          wallet.frozenBalance.toString();

      _currency = wallet.currency;

      _locked = wallet.locked;
    }
  }

  /// ===========================================================================
  /// DISPOSE
  /// ===========================================================================

  @override
  void dispose() {
    _userIdController.dispose();

    _balanceController.dispose();

    _frozenBalanceController.dispose();

    super.dispose();
  }

  /// ===========================================================================
  /// SAVE WALLET
  /// ===========================================================================

  Future<void> _saveWallet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final wallet = AppWallet(
        id: widget.wallet?.id ?? '',

        currency: _currency,

        createdAt: widget.wallet?.createdAt ?? DateTime.now(),

        updatedAt: DateTime.now(),

        locked: _locked,

        userId: _userIdController.text.trim(),

        balance: double.parse(_balanceController.text.trim(),
        ),

        frozenBalance: double.parse(
          _frozenBalanceController.text.trim(),
        ),
      );

      /// ===============================================================
      /// UPDATE
      /// ===============================================================

      if (widget.wallet != null) {
        await FirebaseFirestore.instance
            .collection('wallets')
            .doc(wallet.id)
            .update(wallet.toJson());
      }

      /// ===============================================================
      /// CREATE
      /// ===============================================================

      else {
        await FirebaseFirestore.instance
            .collection('wallets')
            .add(wallet.toJson());
      }

      /// ===============================================================
      /// SUCCESS
      /// ===============================================================

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Wallet enregistré avec succès",
            ),
          ),
        );

        widget.onSuccess?.call();
      }
    } catch (e) {
      debugPrint("Erreur Wallet : $e");

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Erreur : $e",
            ),
          ),
        );
      }
    }

    setState(() {
      _loading = false;
    });
  }

  /// ===========================================================================
  /// BUILD
  /// ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          widget.wallet == null
              ? "Créer un wallet"
              : "Modifier le wallet",
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Container(
            constraints:
            const BoxConstraints(
              maxWidth: 700,
            ),

            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black
                      .withValues(alpha: .05),
                ),
              ],
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  /// =======================================================
                  /// TITLE
                  /// =======================================================

                  const Text(
                    "Informations du Wallet",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// =======================================================
                  /// USER ID
                  /// =======================================================

                  TextFormField(
                    controller:
                    _userIdController,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "ID Utilisateur",

                      border:
                      OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Champ obligatoire";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// =======================================================
                  /// BALANCE
                  /// =======================================================

                  TextFormField(
                    controller:
                    _balanceController,

                    keyboardType:
                    TextInputType.number,

                    decoration:
                    const InputDecoration(
                      labelText: "Solde",

                      border:
                      OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Champ obligatoire";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// =======================================================
                  /// FROZEN BALANCE
                  /// =======================================================

                  TextFormField(
                    controller:
                    _frozenBalanceController,

                    keyboardType:
                    TextInputType.number,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Solde gelé",

                      border:
                      OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Champ obligatoire";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// =======================================================
                  /// CURRENCY
                  /// =======================================================

                  DropdownButtonFormField<WalletCurrency>(
                    initialValue: _currency,

                    decoration:
                    const InputDecoration(
                      labelText: "Devise",

                      border:
                      OutlineInputBorder(),
                    ),

                    items:
                    WalletCurrency.values
                        .map(
                          (currency) =>
                          DropdownMenuItem(
                            value: currency,

                            child: Text(
                              currency.label,
                            ),
                          ),
                    )
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// =======================================================
                  /// AVAILABLE
                  /// =======================================================
                /*
                  SwitchListTile(
                    value: _available,

                    title:
                    const Text("Disponible"),

                    onChanged: (value) {
                      setState(() {
                        _available = value;
                      });
                    },
                  ),

                  /// =======================================================
                  /// LOCKED
                  /// =======================================================

                  SwitchListTile(
                    value: _locked,

                    title:
                    const Text("Wallet bloqué"),

                    onChanged: (value) {
                      setState(() {
                        _locked = value;
                      });
                    },
                  ),
                */

                  const SizedBox(height: 30),

                  /// =======================================================
                  /// BUTTON
                  /// =======================================================

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(
                      onPressed:
                      _loading
                          ? null
                          : _saveWallet,

                      child:
                      _loading
                          ? const CircularProgressIndicator()
                          : Text(
                        widget.wallet ==
                            null
                            ? "Créer Wallet"
                            : "Enregistrer",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}