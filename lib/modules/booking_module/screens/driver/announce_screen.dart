// Cette page permet de créer une annonce de covoiturage.
// Elle utilise un formulaire (AnnounceForm) pour collecter les données.

import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../app/core/utils/colors.dart';
import '../../../../app/widgets/button_component.dart';
// ✅ Ajouts pour le débit wallet et redirection
import '../../../../app/database/services/wallet_service.dart';
import '../../../booking_module/screens/driver/driver_document_upload_screen.dart';
import '../../../booking_module/screens/driver/driver_main_screen.dart';
import '../../../booking_module/widgets/announce_form.dart';
import '../../../booking_module/models/announce_data.dart';
import '../../../booking_module/services/announce_prefill_service.dart';
import '../../../booking_module/models/announce_draft.dart';
import '../../../payment_module/screens/my_wallet_screen.dart';
import '../../../admin_module/database/models/admin/utilisateur.dart';

class AnnounceScreen extends StatefulWidget {

  /// ============================================================
  /// UTILISATEUR SÉLECTIONNÉ
  /// ============================================================
  ///
  /// Cas normal :
  /// -------------
  /// null
  ///
  /// => on utilise FirebaseAuth.instance.currentUser
  ///
  /// Cas support/admin :
  /// -------------------
  /// support sélectionne un utilisateur
  ///
  /// => les annonces seront publiées
  /// pour cet utilisateur.
  ///
  /// ============================================================

  final Utilisateur? selectedUser;

  const AnnounceScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AnnounceScreen> createState() =>
      _AnnounceScreenState();
}

class _AnnounceScreenState extends State<AnnounceScreen> {

  /// ============================================================
  /// FORM DATA
  /// ============================================================

  AnnounceData? _currentData;

  AnnounceData? _initialFromDraft;

  bool _loading = false;

  /// ============================================================
  /// FRAIS D’ANNONCE
  /// ============================================================

  static const int _announceFee = 50;

  @override
  void initState() {

    super.initState();

    /// ==========================================================
    /// RÉCUPÉRATION DRAFT
    /// ==========================================================

    final draft = AnnouncePrefillService().takeDraft();

    if (draft != null) {

      _initialFromDraft = _convertDraftToData(draft);
    }
  }

  /// ============================================================
  /// CONVERSION DRAFT → DATA
  /// ============================================================

  AnnounceData _convertDraftToData(
      AnnounceDraft announceData,
      ) {

    return AnnounceData(

      depart: announceData.depart,

      destination: announceData.destination,

      meetingPlace: announceData.meetingPlace,

      arrivalPlace: announceData.arrivalPlace,

      date: announceData.date,

      time: announceData.time,

      stops: const [],

      seats: announceData.seats,

      price: announceData.price,
    );
  }

  /// ============================================================
  /// DIALOG CONFIRMATION
  /// ============================================================

  Future<bool> _confirmDebitDialog() async {

    return await showDialog<bool>(

      context: context,

      builder: (ctx) => AlertDialog(

        title: const Text(
          "Confirmer l'annonce",
        ),

        content: Text(
          '$_announceFee F. CFA seront débités du porte-monnaie.\n\n'
              'Voulez-vous continuer ?',
        ),

        actions: [

          TextButton(

            onPressed: () {
              Navigator.pop(ctx, false);
            },

            child: const Text("Annuler"),
          ),

          ElevatedButton(

            onPressed: () {
              Navigator.pop(ctx, true);
            },

            child: const Text("Valider"),
          ),
        ],
      ),
    ) ??
        false;
  }

  /// ============================================================
  /// SAVE ANNOUNCE
  /// ============================================================

  Future<void> _saveAndGo() async {

    final data = _currentData;

    /// ==========================================================
    /// VALIDATION
    /// ==========================================================

    if (data == null ||
        !data.isMinimalValid) {

      _toastTop(
        "Veuillez remplir tous les champs obligatoires.",
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      /// ========================================================
      /// UTILISATEUR CIBLE
      /// ========================================================
      ///
      /// Cas 1 :
      /// -------
      /// Support/Admin a sélectionné un user
      ///
      /// Cas 2 :
      /// -------
      /// Utilisateur connecté normal
      ///
      /// ========================================================

      final String userId;

      final String userFirstName;

      final String userLastName;

      final String userName;

      /// ========================================================
      /// CAS SUPPORT / ADMIN
      /// ========================================================

      if (widget.selectedUser != null) {

        userId = widget.selectedUser!.id;

        userFirstName = widget.selectedUser!.firstName;

        userLastName = widget.selectedUser!.lastName;

        userName = widget.selectedUser!.fullName;

      }

      /// ========================================================
      /// CAS NORMAL
      /// ========================================================

      else {

        final firebaseUser =
            FirebaseAuth.instance.currentUser;

        if (firebaseUser == null) {

          _toastTop(
            "Vous devez être connecté.",
          );

          setState(() {
            _loading = false;
          });

          return;
        }

        userId = firebaseUser.uid;

        userName = firebaseUser.displayName ?? "Utilisateur";
      }

      /// ========================================================
      /// CONFIRMATION DÉBIT
      /// ========================================================

      final confirmed = await _confirmDebitDialog();

      if (!confirmed) {

        setState(() {
          _loading = false;
        });

        return;
      }

      /// ========================================================
      /// IDÉMPOTENCE
      /// ========================================================

      final idKey =
          '$userId|ANNOUNCE_FEE|'
          '${data.date}_${data.time}|'
          '${data.depart}|'
          '${data.destination}';

      /// ========================================================
      /// DÉBIT WALLET
      /// ========================================================

      await WalletService.instance.debit(

        uid: userId,

        amount: _announceFee,

        reason: 'ANNOUNCE_FEE',

        tripId: null,

        idempotencyKey: idKey,
      );

      /// ========================================================
      /// LECTURE USER DOC
      /// ========================================================

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final userCustomId = userDoc.data()?['customId'] as String?;

      if (userCustomId == null || userCustomId.isEmpty) {

        _toastTop(
          "Utilisateur invalide.",
        );

        setState(() {
          _loading = false;
        });

        return;
      }

      /// ========================================================
      /// PAYLOAD
      /// ========================================================

      final payload = data.toJson(userId: userId)

        ..addAll({

          'userCustomId': userCustomId,

          'userName': userName,

          'createdAt': FieldValue.serverTimestamp(),

          'updatedAt': FieldValue.serverTimestamp(),

          'reservedSeats': 0,

          'createdBySupport': widget.selectedUser != null,

          'supportGenerated': widget.selectedUser != null,
        });

      /// ========================================================
      /// SAVE FIRESTORE
      /// ========================================================

      final docRef = await AdminDataService.usersRef
          .doc(userId)
          .collection('announces')
          .add(payload);

      /// ========================================================
      /// NUMÉRO ANNONCE
      /// ========================================================

      final number = 'AN-${docRef.id.substring(0, 6).toUpperCase()}';

      await docRef.update({
        'announceNumber': number,
      });

      /// ========================================================
      /// SUCCESS
      /// ========================================================

      if (!mounted) return;

      _toastTop(
        "Annonce publiée ✅ (-$_announceFee FCFA)",
      );

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const DriverDocumentUploadScreen(),
        ),
      );

    }

    /// ==========================================================
    /// ERROR
    /// ==========================================================

    catch (e) {

      final msg = e.toString();

      /// ========================================================
      /// WALLET INSUFFISANT
      /// ========================================================

      if (msg.contains('NEED_TOPUP')) {

        if (!mounted) return;

        _toastTop(
          "Solde insuffisant.",
        );

        await Navigator.of(context).push(

          MaterialPageRoute(

            builder: (_) =>
            const MyWalletScreen(),
          ),
        );
      }

      /// ========================================================
      /// AUTRE ERREUR
      /// ========================================================

      else {

        _toastTop(
          "Erreur : $e",
        );

      }

    }

    finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// ============================================================
  /// TOAST
  /// ============================================================

  void _toastTop(String msg) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),

        backgroundColor:
        Colors.white.withValues(alpha: .95),

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
        ),

        duration: const Duration(
          seconds: 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    /// ==========================================================
    /// UTILISATEUR CIBLE
    /// ==========================================================

    final targetUser = widget.selectedUser;

    return Scaffold(

      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(

        title: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              "Annoncer",

              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            /// ==================================================
            /// INFO USER CIBLE
            /// ==================================================

            if (targetUser != null)

              Text(

                "Pour : ${targetUser.fullName}",

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),

        centerTitle: true,

        leading: IconButton(

          icon: const Icon(Icons.arrow_back),

          onPressed: () {

            context
                .findAncestorStateOfType
            <DriverMainScreenState>()
                ?.navigateToTab(0);
          },
        ),

        backgroundColor: Colors.white,

        foregroundColor: Colors.black,

        elevation: 0,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// ==================================================
            /// CARD USER CIBLE
            /// ==================================================

            if (targetUser != null)

              Container(

                margin:
                const EdgeInsets.only(
                  bottom: 20,
                ),

                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color:
                  Colors.blue.withValues(
                    alpha: .05,
                  ),

                  borderRadius:
                  BorderRadius.circular(16),

                  border: Border.all(
                    color:
                    Colors.blue.withValues(
                      alpha: .2,
                    ),
                  ),
                ),

                child: Row(

                  children: [

                    CircleAvatar(

                      radius: 28,

                      child: Text(
                        "${targetUser.lastName[0]} ${targetUser.firstName[0]}",
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(

                            targetUser.fullName,

                            style: const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            targetUser.phone,
                          ),

                          Text(
                            targetUser.email,
                          ),
                        ],
                      ),
                    ),

                    Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.blue,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(

                        "CLIENT",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            /// ==================================================
            /// FORMULAIRE
            /// ==================================================

            AnnounceForm(

              initialData: _initialFromDraft,

              onChanged: (data) {

                _currentData = data;
              },
            ),

            const SizedBox(height: 24),

            /// ==================================================
            /// BUTTON
            /// ==================================================

            Center(

              child: ButtonComponent(

                txtButton:
                _loading ? "Enregistrement..." : "Valider",

                colorButton: AppColors.secondColor,

                colorText: Colors.white,

                onPressed:
                _loading ? null : _saveAndGo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}