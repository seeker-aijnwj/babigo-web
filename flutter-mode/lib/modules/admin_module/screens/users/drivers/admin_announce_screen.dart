/// ============================================================================
/// ANNOUNCE SCREEN - MODERN ADMIN / SUPPORT UI
/// ============================================================================
///
/// OBJECTIF
/// --------
///
/// Cette version modernise complètement l'écran AnnounceScreen
/// avec :
///
/// ✅ UI moderne style Wallet / Banking App
/// ✅ architecture scalable
/// ✅ support Admin / Support
/// ✅ glassmorphism léger
/// ✅ cards élégantes
/// ✅ responsive mobile/tablette/desktop
/// ✅ animations visuelles
/// ✅ sections réutilisables
/// ✅ prêt pour d'autres écrans
///
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/database/services/wallet_service.dart';
import '../../../../booking_module/services/announce_prefill_service.dart';
import '../../../../booking_module/models/announce_draft.dart';
import '../../../../booking_module/models/announce_data.dart';
import '../../../database/models/admin/utilisateur.dart';
import '../../../database/services/admin_data_service.dart';
import '../../booking/forms/add_announce_form.dart';

import 'admin_driver_document_upload_screen.dart';
import '../admin_wallet_screen.dart';


class AdminAnnounceScreen extends StatefulWidget {
  final Utilisateur? selectedUser;

  const AdminAnnounceScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminAnnounceScreen> createState() => _AdminAnnounceScreenState();
}

class _AdminAnnounceScreenState extends State<AdminAnnounceScreen> {

  /// ==========================================================================
  /// FORM DATA
  /// ==========================================================================

  AnnounceData? _currentData;

  AnnounceData? _initialFromDraft;

  bool _loading = false;

  static const int _announceFee = 50;

  /// ==========================================================================
  /// CONTROLLERS
  /// ==========================================================================

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    super.initState();

    /// ============================================================
    /// RÉCUPÉRATION DRAFT
    /// ============================================================

    final draft = AnnouncePrefillService().takeDraft();

    if (draft != null) {
      _initialFromDraft = _convertDraftToData(draft);
    }
  }

  /// ==========================================================================
  /// CONVERT DRAFT
  /// ==========================================================================

  AnnounceData _convertDraftToData(AnnounceDraft announceData,) {

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

  /// ==========================================================================
  /// TOAST
  /// ==========================================================================

  void _toastTop(String msg) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(msg),

        backgroundColor: Colors.black87,

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.all(16),

      ),
    );
  }

  /// ==========================================================================
  /// CONFIRMATION DIALOG
  /// ==========================================================================

  Future<bool> _confirmDebitDialog() async {

    return await showDialog<bool>(

      context: context,

      builder: (ctx) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Confirmation",
          ),

          content: Text(
            "$_announceFee FCFA seront débités "
                "du porte-monnaie pour publier "
                "l'annonce.",
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(ctx, false);
              },

              child: const Text(
                "Annuler",
              ),
            ),

            ElevatedButton(

              onPressed: () {
                Navigator.pop(ctx, true);
              },

              child: const Text(
                "Valider",
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// ==========================================================================
  /// SAVE
  /// ==========================================================================

  Future<void> _saveAndGo() async {

    final data = _currentData;

    if (data == null ||
        !data.isMinimalValid) {

      _toastTop(
        "Veuillez remplir tous les champs.",
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      /// ==========================================================
      /// TARGET USER
      /// ==========================================================

      final String userId;

      final String userName;

      final UserRole userRole;

      if (widget.selectedUser != null) {

        userId = widget.selectedUser!.id;

        userName = widget.selectedUser!.fullName;

        userRole = widget.selectedUser!.role;

      } else {

        final firebaseUser = FirebaseAuth.instance.currentUser;

        if (firebaseUser == null) {

          _toastTop(
            "Utilisateur non connecté.",
          );

          return;
        }

        userId = firebaseUser.uid;

        userName = firebaseUser.displayName ?? "Utilisateur";
      }

      /// ==========================================================
      /// CONFIRMATION
      /// ==========================================================

      final confirmed = await _confirmDebitDialog();

      if (!confirmed) {

        setState(() {
          _loading = false;
        });

        return;
      }

      /// ==========================================================
      /// WALLET
      /// ==========================================================

      final idKey = '$userId|ANNOUNCE|${data.date}';

      await WalletService.instance.debit(

        uid: userId,

        amount: _announceFee,

        reason: 'ANNOUNCE_FEE',

        tripId: null,

        idempotencyKey: idKey,
      );

      /// ==========================================================
      /// USER DOC
      /// ==========================================================

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final userCustomId = userDoc.data()?['customId'];

      if (userCustomId == null) {

        _toastTop(
          "Utilisateur invalide.",
        );

        return;
      }

      /// ==========================================================
      /// PAYLOAD
      /// ==========================================================

      final payload = data.toJson(userId: userId)

        ..addAll({

          'userCustomId': userCustomId,

          'userName': userName,

          'createdAt': FieldValue.serverTimestamp(),

          'updatedAt': FieldValue.serverTimestamp(),

          'reservedSeats': 0,

          'createdBySupport': widget.selectedUser != null,
        });

      /// ==========================================================
      /// SAVE FIRESTORE
      /// ==========================================================

      final docRef = await AdminDataService.usersRef
          .doc(userId)
          .collection('announces')
          .add(payload);

      /// ==========================================================
      /// ANNOUNCE NUMBER
      /// ==========================================================

      final number = 'AN-${docRef.id.substring(0, 6).toUpperCase()}';

      await docRef.update({
        'announceNumber': number,
      });

      if (!mounted) return;

      _toastTop(
        "Annonce publiée avec succès ✅",
      );

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => AdminDriverDocumentsUploadScreen(selectedUser: widget.selectedUser),
        ),
      );

    } catch (e) {

      final msg = e.toString();

      if (msg.contains("NEED_TOPUP")) {

        if (!mounted) return;

        _toastTop(
          "Solde insuffisant.",
        );

        await Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) => AdminWalletScreen(selectedUser: widget.selectedUser),
          ),
        );

      } else {

        _toastTop(
          "Erreur : $e",
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

  @override
  Widget build(BuildContext context) {

    final targetUser = widget.selectedUser;

    final size = MediaQuery.of(context).size;

    final isDesktop = size.width >= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mes notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: targetUser == null
          ? const _CenteredInfo(
        text: 'Vous devez être connecté pour voir vos notifications.',
      )
          : SafeArea(
            child: Row(

              children: [

                /// ================================================================
                /// LEFT PANEL
                /// ================================================================

                Expanded(

                  flex: isDesktop ? 4 : 1,

                  child: SingleChildScrollView(

                    controller: _scrollController,

                    padding:
                    const EdgeInsets.all(24),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        /// ======================================================
                        /// HEADER CARD
                        /// ======================================================

                        Container(

                          width: double.infinity,

                          padding:
                          const EdgeInsets.all(24),

                          decoration: BoxDecoration(

                            gradient:
                            const LinearGradient(

                              colors: [
                                Color(0xFF1F6FEB),
                                Color(0xFF4B8DFF),
                              ],
                            ),

                            borderRadius: BorderRadius.circular(28),
                          ),

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              const Text(

                                "Créer une annonce",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Publiez rapidement "
                                    "un trajet pour vos "
                                    "passagers.",

                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: .9,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              Row(

                                children: [

                                  _buildStatCard(
                                    "Frais",
                                    "$_announceFee FCFA",
                                  ),

                                  const SizedBox(width: 14),

                                  _buildStatCard(
                                    "Statut",
                                    "Brouillon",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// ======================================================
                        /// USER CARD
                        /// ======================================================

                        if (targetUser != null)
                          _buildTargetUserCard(targetUser,),

                        const SizedBox(height: 24),

                        /// ==================================================
                        /// FORM
                        /// ==================================================

                        AddAnnounceForm(

                          initialData: _initialFromDraft,

                          onChanged: (data) {

                            _currentData =
                                data;
                          },
                        ),

                        const SizedBox(height: 28),

                        /// ====================$==================================
                        /// BUTTON
                        /// ======================================================

                        SizedBox(

                          width: double.infinity,

                          height: 60,

                          child: ElevatedButton.icon(

                            onPressed: _loading
                                ? null
                                : _saveAndGo,

                            icon: _loading

                                ? const SizedBox(

                              width: 18,
                              height: 18,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )

                                : const Icon(
                              Icons.check_circle,
                            ),

                            label: Text(

                              _loading
                                  ? "Publication..."
                                  : "Publier l'annonce",

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            style: ElevatedButton.styleFrom(

                              backgroundColor: const Color(0xFF1F6FEB),

                              foregroundColor: Colors.white,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),

                /// ================================================================
                /// RIGHT PANEL DESKTOP
                /// ================================================================

                if (isDesktop)

                  Container(

                    width: 380,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      border: Border(

                        left: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),

                    child: _buildDesktopPreview(),
                  ),
              ],
            ),
          ),
    );
  }

  /// ==========================================================================
  /// TARGET USER CARD
  /// ==========================================================================

  Widget _buildTargetUserCard(
      Utilisateur user,
      ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Colors.blue.shade100,
        ),
      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 30,

            backgroundColor: Colors.blue.shade100,

            child: Text(
              "${user.firstName[0]}${user.lastName[0]}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(user.fullName, style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),
                Text(user.phone),
                Text(user.email),
              ],
            ),
          ),

          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),

            decoration: BoxDecoration(

              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),

            child: Text(

              user.role.name.toUpperCase(),

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// PREVIEW DESKTOP
  /// ==========================================================================

  Widget _buildDesktopPreview() {

    return Padding(

      padding: const EdgeInsets.all(24),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(

            "Aperçu",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 24),

          Container(

            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(24),
            ),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  "Résumé du trajet",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _buildPreviewTile(
                  Icons.location_on,
                  "Départ",
                  _currentData?.depart ??
                      "--",
                ),

                _buildPreviewTile(
                  Icons.flag,
                  "Destination",
                  _currentData?.destination ??
                      "--",
                ),

                _buildPreviewTile(
                  Icons.event,
                  "Date",
                  _currentData?.date
                      ?.toString() ??
                      "--",
                ),

                _buildPreviewTile(
                  Icons.chair,
                  "Places",
                  "${_currentData?.seats ?? '--'}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// PREVIEW TILE
  /// ==========================================================================

  Widget _buildPreviewTile(IconData icon, String title, String value) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 18),

      child: Row(

        children: [

          Container(

            width: 42,
            height: 42,

            decoration: BoxDecoration(

              color: Colors.blue.withValues(alpha: .1),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// SMALL STAT CARD
  /// ==========================================================================

  Widget _buildStatCard(String title,  String value) {

    return Expanded(

      child: Container(

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(

          color: Colors.white.withValues(alpha: .18,),
          borderRadius:  BorderRadius.circular(18),
        ),

        child: Column(

          children: [

            Text( title, style: TextStyle(
                color: Colors.white.withValues(alpha: .8,),
              ),
            ),

            const SizedBox(height: 4),

            Text( value, style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenteredInfo extends StatelessWidget {
  final String text;
  const _CenteredInfo({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }
}
