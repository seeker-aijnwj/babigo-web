/// ===============================================================
/// DRIVER DOCUMENT UPLOAD SCREEN
/// ===============================================================
///
/// Écran moderne permettant :
///
/// ✅ Sélection d’un utilisateur déjà existant
/// ✅ Upload des documents chauffeur
/// ✅ Sauvegarde Firebase Storage
/// ✅ Sauvegarde Firestore
/// ✅ Gestion erreurs
/// ✅ UI moderne / premium
/// ✅ Responsive
/// ✅ Réutilisable
///
/// DOCUMENTS :
/// - Permis Recto
/// - Permis Verso
/// - CNI Recto
/// - CNI Verso
///
/// FIREBASE :
/// ------------
/// Storage:
/// users/{uid}/documents/...
///
/// Firestore:
/// users/{uid}/driver_documents
///
/// ===============================================================

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import '../../../../../app/core/utils/colors.dart';

import '../../../database/models/admin/utilisateur.dart';

import '../../../database/services/admin_data_service.dart';

class AdminDriverDocumentsUploadScreen extends StatefulWidget {

  /// =============================================================
  /// UTILISATEUR CIBLE
  /// =============================================================

  final Utilisateur? selectedUser;

  const AdminDriverDocumentsUploadScreen({
    super.key,
    required this.selectedUser,
  });

  @override
  State<AdminDriverDocumentsUploadScreen> createState() =>
      _AdminDriverDocumentsUploadScreenState();
}

class _AdminDriverDocumentsUploadScreenState
    extends State<AdminDriverDocumentsUploadScreen> {

  /// =============================================================
  /// FORM STATE
  /// =============================================================

  final GlobalKey<_ModernDriverDocumentFormState> _formKey =
  GlobalKey<_ModernDriverDocumentFormState>();

  bool _loading = false;

  bool _documentsComplete = false;

  /// =============================================================
  /// SNACKBAR
  /// =============================================================

  void _showSnack(
      String message, {
        bool error = false,
      }) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// =============================================================
  /// SAVE TO FIREBASE
  /// =============================================================

  Future<void> _uploadDocuments() async {

    final formState = _formKey.currentState;

    if (formState == null) return;

    if (!formState.allDocumentsProvided) {

      _showSnack(
        "Veuillez ajouter tous les documents.",
        error: true,
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      final uid = widget.selectedUser!.id;

      /// =========================================================
      /// UPLOAD STORAGE
      /// =========================================================

      final licenseFrontUrl = await _uploadFile(
        uid: uid,
        file: formState.licenseFront!,
        fileName: 'license_front.jpg',
      );

      final licenseBackUrl = await _uploadFile(
        uid: uid,
        file: formState.licenseBack!,
        fileName: 'license_back.jpg',
      );

      final cniFrontUrl = await _uploadFile(
        uid: uid,
        file: formState.cniFront!,
        fileName: 'cni_front.jpg',
      );

      final cniBackUrl = await _uploadFile(
        uid: uid,
        file: formState.cniBack!,
        fileName: 'cni_back.jpg',
      );

      /// =========================================================
      /// SAVE FIRESTORE
      /// =========================================================

      await AdminDataService.usersRef
          .doc(uid)
          .collection('driver_documents')
          .doc('main')
          .set({
        'licenseFrontUrl': licenseFrontUrl,

        'licenseBackUrl': licenseBackUrl,

        'cniFrontUrl': cniFrontUrl,

        'cniBackUrl': cniBackUrl,

        'validated': false,

        'rejected': false,

        'uploadedAt':
        FieldValue.serverTimestamp(),

        'updatedAt':
        FieldValue.serverTimestamp(),

        'userId': uid,

        'userName': widget.selectedUser!.fullName,
      });

      /// =========================================================
      /// UPDATE USER
      /// =========================================================

      await AdminDataService.usersRef
          .doc(uid)
          .update({

        'driverDocumentsUploaded': true,

        'driverDocumentsPendingValidation': true,
      });

      if (!mounted) return;

      _showSnack(
        "Documents envoyés avec succès ✅",
      );

      Navigator.pop(context);

    }

    catch (e) {

      _showSnack(
        "Erreur : $e",
        error: true,
      );

    }

    finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// =============================================================
  /// STORAGE UPLOAD
  /// =============================================================

  Future<String> _uploadFile({

    required String uid,

    required File file,

    required String fileName,

  }) async {

    final ref = FirebaseStorage.instance
        .ref()
        .child(
      'users/$uid/documents/$fileName',
    );

    final uploadTask = await ref.putFile(file);

    return await uploadTask.ref.getDownloadURL();
  }

  /// =============================================================
  /// BUILD
  /// =============================================================

  @override
  Widget build(BuildContext context) {

    final user = widget.selectedUser;

    final screenWidth =
        MediaQuery.of(context).size.width;

    final isDesktop = screenWidth > 900;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      body: SafeArea(

        child: Row(

          children: [

            /// ===================================================
            /// LEFT PANEL
            /// ===================================================

            if (isDesktop)

              Container(

                width: 320,

                decoration: const BoxDecoration(

                  gradient: LinearGradient(

                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,

                    colors: [

                      Color(0xFF0F172A),

                      Color(0xFF1E293B),
                    ],
                  ),
                ),

                child: Padding(

                  padding: const EdgeInsets.all(30),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const SizedBox(height: 40),

                      const Text(

                        "Documents Chauffeur",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 30,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(

                        "Ajoutez et sécurisez les documents du conducteur pour permettre la validation du compte.",

                        style: TextStyle(

                          color:
                          Colors.white.withValues(alpha: .7),

                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      Container(

                        padding:
                        const EdgeInsets.all(18),

                        decoration: BoxDecoration(

                          color:
                          Colors.white.withValues(alpha: .08),

                          borderRadius:
                          BorderRadius.circular(22),
                        ),

                        child: Row(

                          children: [

                            CircleAvatar(

                              radius: 28,

                              backgroundColor: AppColors.secondColor,

                              child: Text(

                                user!.fullName.substring(0, 1).toUpperCase(),

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    user.fullName,

                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(

                                    user.phone,

                                    style: TextStyle(
                                      color:
                                      Colors.white
                                          .withValues(
                                        alpha: .7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// ===================================================
            /// RIGHT PANEL
            /// ===================================================

            Expanded(

              child: SingleChildScrollView(

                padding: EdgeInsets.symmetric(

                  horizontal:
                  isDesktop ? 40 : 20,

                  vertical: 24,
                ),

                child: Center(

                  child: ConstrainedBox(

                    constraints:
                    const BoxConstraints(
                      maxWidth: 850,
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        /// =========================================
                        /// TOP BAR
                        /// =========================================

                        Row(

                          children: [

                            if (!isDesktop)

                              IconButton(

                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                icon: const Icon(
                                  Icons.arrow_back,
                                ),
                              ),

                            const Spacer(),

                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back),
                              label: Text('Revenir'),
                            ),

                            const Spacer(),

                            Container(

                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),

                              decoration: BoxDecoration(

                                color:
                                Colors.orange.withValues(
                                  alpha: .12,
                                ),

                                borderRadius:
                                BorderRadius.circular(30),
                              ),

                              child: const Row(

                                children: [

                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.orange,
                                    size: 18,
                                  ),

                                  SizedBox(width: 8),

                                  Text(

                                    "Validation requise",

                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        /// =========================================
                        /// TITLE
                        /// =========================================

                        const Text(

                          "Importer les documents",

                          style: TextStyle(

                            fontSize: 32,

                            fontWeight: FontWeight.bold,

                            color: Color(0xFF111827),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(

                          "Tous les documents sont stockés de manière sécurisée et pourront être validés par l’administration.",

                          style: TextStyle(

                            fontSize: 15,

                            color: Colors.grey.shade600,

                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// =========================================
                        /// USER CARD
                        /// =========================================

                        Container(

                          padding:
                          const EdgeInsets.all(20),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(26),

                            boxShadow: [

                              BoxShadow(

                                color: Colors.black
                                    .withValues(alpha: .04),

                                blurRadius: 20,

                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),

                          child: Row(

                            children: [

                              CircleAvatar(

                                radius: 34,

                                backgroundColor: AppColors.secondColor,

                                child: Text(

                                  user!.fullName.substring(0, 1).toUpperCase(),

                                  style: const TextStyle(

                                    color: Colors.white,

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize: 22,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      user.fullName,

                                      style:
                                      const TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(user.email),

                                    const SizedBox(height: 2),

                                    Text(user.phone),
                                  ],
                                ),
                              ),

                              Container(

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),

                                decoration: BoxDecoration(

                                  color: AppColors.secondColor.withValues(
                                    alpha: .1,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: const Text(

                                  "Conducteur",

                                  style: TextStyle(
                                    color: AppColors.secondColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// =========================================
                        /// FORM CARD
                        /// =========================================

                        Container(

                          padding:
                          const EdgeInsets.all(24),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(30),

                            boxShadow: [

                              BoxShadow(

                                color:
                                Colors.black.withValues(
                                  alpha: .04,
                                ),

                                blurRadius: 25,

                                offset:
                                const Offset(0, 10),
                              ),
                            ],
                          ),

                          child:
                          ModernDriverDocumentForm(
                            key: _formKey,

                            onValidationChanged:
                                (valid) {

                              setState(() {

                                _documentsComplete =
                                    valid;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// =========================================
                        /// BUTTON
                        /// =========================================

                        SizedBox(

                          width: double.infinity,

                          height: 60,

                          child: ElevatedButton(

                            onPressed:
                            (_loading ||
                                !_documentsComplete)

                                ? null

                                : _uploadDocuments,

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor: AppColors.secondColor,

                              foregroundColor: Colors.white,

                              elevation: 0,

                              shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                              ),
                            ),

                            child: _loading

                                ? const SizedBox(

                              width: 24,

                              height: 24,

                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )

                                : const Text(

                              "Envoyer les documents",

                              style: TextStyle(

                                fontSize: 17,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// =========================================
                        /// FOOTER
                        /// =========================================

                        Center(

                          child: Text(

                            "Dernière mise à jour : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",

                            style: TextStyle(
                              color:
                              Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// FORMULAIRE MODERNE
/// ===============================================================

class ModernDriverDocumentForm
    extends StatefulWidget {

  final void Function(bool isComplete)?
  onValidationChanged;

  const ModernDriverDocumentForm({
    super.key,
    this.onValidationChanged,
  });

  @override
  State<ModernDriverDocumentForm>
  createState() => _ModernDriverDocumentFormState();
}

class _ModernDriverDocumentFormState
    extends State<ModernDriverDocumentForm> {

  File? licenseFront;

  File? licenseBack;

  File? cniFront;

  File? cniBack;

  final ImagePicker _picker = ImagePicker();

  bool get allDocumentsProvided =>

      licenseFront != null &&
          licenseBack != null &&
          cniFront != null &&
          cniBack != null;

  void _notify() {

    widget.onValidationChanged
        ?.call(allDocumentsProvided);
  }

  Future<void> _pickImage(
      void Function(File file) setter,
      ) async {

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked != null) {

      setState(() {
        setter(File(picked.path));
      });

      _notify();
    }
  }

  Widget _buildUploadCard({

    required String title,

    required String subtitle,

    required IconData icon,

    required File? file,

    required VoidCallback onTap,

  }) {

    return InkWell(

      borderRadius: BorderRadius.circular(24),

      onTap: onTap,

      child: AnimatedContainer(

        duration:
        const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color:file != null
              ? Colors.green.withValues(alpha: .05)
              : Colors.grey.shade50,

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: file != null
                ? Colors.green.withValues(alpha: .4)
                : Colors.grey.shade200,
            width: 1.5,
          ),
        ),

        child: Row(

          children: [

            /// ===============================================
            /// PREVIEW
            /// ===============================================

            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.secondColor.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(18),
              ),

              child:file != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(18,),
                child: Image.file( file, fit: BoxFit.cover,),
              )

                  : Icon(
                icon,
                color: AppColors.secondColor,
                size: 32,
              ),
            ),

            const SizedBox(width: 18),

            /// ===============================================
            /// TEXTS
            /// ===============================================

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(

                    children: [

                      Icon(
                        file != null ? Icons.check_circle : Icons.upload,
                        size: 18,
                        color: file != null ? Colors.green : AppColors.secondColor,
                      ),

                      const SizedBox(width: 8),

                      Text(

                        file != null
                            ? "Document ajouté"
                            : "Ajouter le document",

                        style: TextStyle(
                          color: file != null ? Colors.green : AppColors.secondColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        _buildUploadCard(

          title: "Permis de conduire (Recto)",

          subtitle: "Ajoutez la face avant du permis.",

          icon: Icons.badge,

          file: licenseFront,

          onTap: () {

            _pickImage( (file) => licenseFront = file );
          },
        ),

        const SizedBox(height: 18),

        _buildUploadCard(

          title: "Permis de conduire (Verso)",

          subtitle: "Ajoutez la face arrière du permis.",

          icon: Icons.credit_card,

          file: licenseBack,

          onTap: () {

            _pickImage( (file) => licenseBack = file );
          },
        ),

        const SizedBox(height: 18),

        _buildUploadCard(

          title: "CNI (Recto)",

          subtitle: "Ajoutez la face avant de la carte.",

          icon: Icons.perm_identity,

          file: cniFront,

          onTap: () {
            _pickImage( (file) => cniFront = file );
          },
        ),

        const SizedBox(height: 18),

        _buildUploadCard(

          title: "CNI (Verso)",

          subtitle: "Ajoutez la face arrière de la carte.",

          icon: Icons.document_scanner,

          file: cniBack,

          onTap: () {

            _pickImage( (file) => cniBack = file );
          },
        ),

      ],
    );
  }
}