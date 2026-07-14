/// ===============================================================
/// USER FORM SCREEN
/// ===============================================================
///
/// Écran moderne d'ajout / modification utilisateur
///
/// Fonctionnalités :
///
/// ✅ Création utilisateur
/// ✅ Édition utilisateur
/// ✅ Upload photo
/// ✅ Validation complète
/// ✅ Responsive
/// ✅ Firebase Firestore
/// ✅ Firebase Storage
/// ✅ UI moderne premium
/// ✅ Architecture scalable
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

class UserFormScreen extends StatefulWidget {

  /// =============================================================
  /// USER
  /// =============================================================

  final Utilisateur? selectedUser;

  const UserFormScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<UserFormScreen> createState() =>
      _UserFormScreenState();
}

class _UserFormScreenState
    extends State<UserFormScreen> {

  /// =============================================================
  /// FORM KEY
  /// =============================================================

  final _formKey = GlobalKey<FormState>();

  /// =============================================================
  /// CONTROLLERS
  /// =============================================================

  late TextEditingController fullNameController;

  late TextEditingController firstNameController;

  late TextEditingController lastNameController;

  late TextEditingController phoneController;

  late TextEditingController emailController;

  late TextEditingController passwordController;

  late TextEditingController cityController;

  late TextEditingController districtController;

  late TextEditingController addressController;

  late TextEditingController walletController;

  late TextEditingController earningsController;

  late TextEditingController spentController;

  /// =============================================================
  /// STATES
  /// =============================================================

  bool loading = false;

  bool isEdit =
  false;

  String gender = 'male';

  String role = 'passenger';

  String status = 'active';

  bool isVerified = false;

  bool kycValidated = false;

  bool phoneVerified = false;

  bool emailVerified = false;

  DateTime? birthDate;

  File? profileImage;

  String? uploadedPhotoUrl;

  final picker = ImagePicker();

  /// =============================================================
  /// INIT
  /// =============================================================

  @override
  void initState() {

    super.initState();

    isEdit = widget.selectedUser != null;

    final user = widget.selectedUser;

    fullNameController = TextEditingController(
      text: user?.fullName ?? '',
    );

    firstNameController = TextEditingController(
          text: user?.firstName ?? '',
        );

    lastNameController = TextEditingController(
          text: user?.lastName ?? '',
        );

    phoneController = TextEditingController(
          text: user?.phone ?? '',
        );

    emailController = TextEditingController(
          text: user?.email ?? '',
        );

    passwordController = TextEditingController();

    cityController = TextEditingController(
          text: user?.city ?? '',
        );

    districtController = TextEditingController(
          text: user?.district ?? '',
        );

    addressController = TextEditingController(
          text: user?.address ?? '',
        );

    walletController = TextEditingController(
          text: user?.walletBalance.toString() ?? '0',
        );

    earningsController = TextEditingController(
          text: user?.totalEarnings.toString() ?? '0',
        );

    spentController = TextEditingController(
          text: user?.totalSpent.toString() ?? '0',
        );

    gender = user?.gender ?? 'Masculin';

    role = user?.role.name ?? 'passenger';

    status = user?.status.name ?? 'active';

    isVerified = user?.isVerified ?? false;

    kycValidated = user?.kycValidated ?? false;

    phoneVerified = user?.phoneVerified ?? false;

    emailVerified = user?.emailVerified ?? false;

    birthDate = user?.birthDate;

    uploadedPhotoUrl = user?.photoUrl;
  }

  /// =============================================================
  /// PICK IMAGE
  /// =============================================================

  Future<void> pickImage() async {

    final picked =
    await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {

      setState(() {
        profileImage =
            File(picked.path);
      });
    }
  }

  /// =============================================================
  /// UPLOAD IMAGE
  /// =============================================================

  Future<String?> uploadProfileImage(
      String uid,
      ) async {

    if (profileImage == null) {
      return uploadedPhotoUrl;
    }

    final ref =
    FirebaseStorage.instance
        .ref()
        .child(
      'users/$uid/profile.jpg',
    );

    await ref.putFile(profileImage!);

    return await ref.getDownloadURL();
  }

  /// =============================================================
  /// SAVE USER
  /// =============================================================

  Future<void> saveUser() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      final usersRef = AdminDataService.usersRef;

      final docRef = isEdit
          ? usersRef.doc(widget.selectedUser!.id)
          : usersRef.doc();

      final uid = docRef.id;

      final photoUrl = await uploadProfileImage(uid);

      /// =========================================================
      /// JSON PAYLOAD
      /// =========================================================

      final payload = {

        'authId': uid,

        'customId': 'USR-${uid.substring(0, 6).toUpperCase()}',

        'password': passwordController.text.trim(),

        'fullName': fullNameController.text,

        'firstName': firstNameController.text.trim(),

        'lastName': lastNameController.text.trim(),

        'phone': phoneController.text.trim(),

        'email': emailController.text.trim(),

        'photoUrl': photoUrl,

        'gender': gender,

        'birthDate': birthDate,

        'city': cityController.text.trim(),

        'district': districtController.text.trim(),

        'address': addressController.text.trim(),

        'latitude': 0.0,

        'longitude': 0.0,

        'role': role,

        'status': status,

        'isVerified': isVerified,

        'kycValidated': kycValidated,

        'phoneVerified': phoneVerified,

        'emailVerified': emailVerified,

        'totalTrips': widget.selectedUser?.totalTrips ?? 0,

        'completedTrips': widget.selectedUser?.completedTrips ?? 0,

        'canceledTrips': widget.selectedUser?.canceledTrips ?? 0,

        'rating': widget.selectedUser?.rating ?? 0.0,

        'ratingCount': widget.selectedUser?.ratingCount ?? 0,

        'ratingTotal': widget.selectedUser?.ratingTotal ?? 0,

        'reviewCount': widget.selectedUser?.reviewCount ?? 0,

        'walletBalance': double.tryParse(
          walletController.text,
        ) ?? 0,

        'totalEarnings': double.tryParse(
          earningsController.text,
        ) ?? 0,

        'totalSpent': double.tryParse(
          spentController.text,
        ) ?? 0,

        'nationalIdUrl': widget.selectedUser?.nationalIdUrl,

        'driverLicenseUrl': widget.selectedUser?.driverLicenseUrl,

        'vehicleDocumentUrl': widget.selectedUser?.vehicleDocumentUrl,

        'createdAt': isEdit
            ? widget.selectedUser!.createdAt
            : Timestamp.fromDate(
          DateTime.now(),
        ),

        'updatedAt': Timestamp.fromDate(
          DateTime.now(),
        ),

        'lastLoginAt': widget.selectedUser?.lastLoginAt,
      };

      /// =========================================================
      /// FIRESTORE
      /// =========================================================

      await docRef.set(
        payload,
        SetOptions(merge: true),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Utilisateur enregistré ✅",
          ),
        ),
      );

      Navigator.pop(context);

    }

    catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            "Erreur : $e",
          ),
        ),
      );

    }

    finally {

      if (mounted) {

        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =============================================================
  /// DATE PICKER
  /// =============================================================

  Future<void> selectBirthDate() async {

    final picked = await showDatePicker(

      context: context,

      initialDate: birthDate ?? DateTime(2000),

      firstDate: DateTime(1950),

      lastDate: DateTime.now(),
    );

    if (picked != null) {

      setState(() {
        birthDate = picked;
      });
    }
  }

  /// =============================================================
  /// BUILD
  /// =============================================================

  @override
  Widget build(BuildContext context) {

    final isDesktop = MediaQuery.of(context)
        .size.width > 900;

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

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

                  padding: const EdgeInsets.all(28),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const SizedBox(height: 40),

                      Text(

                        isEdit

                            ? "Modifier utilisateur"

                            : "Nouvel utilisateur",

                        style:
                        const TextStyle(

                          color: Colors.white,

                          fontSize: 30,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(

                        "Gérez les informations, permissions et données utilisateur depuis une interface moderne.",

                        style: TextStyle(

                          color: Colors.white.withValues(
                            alpha: .7,
                          ),

                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      Container(

                        padding: const EdgeInsets.all(20),

                        decoration:
                        BoxDecoration(

                          color: Colors.white.withValues(
                            alpha: .08,
                          ),

                          borderRadius: BorderRadius.circular(
                            24,
                          ),
                        ),

                        child: Row(

                          children: [

                            CircleAvatar(

                              radius: 28,

                              backgroundColor: AppColors.secondColor,

                              backgroundImage: profileImage != null

                                  ? FileImage(
                                profileImage!,
                              )

                                  : uploadedPhotoUrl != null

                                  ? NetworkImage(
                                uploadedPhotoUrl!,
                              )

                                  : null,

                              child:

                              profileImage ==
                                  null &&
                                  uploadedPhotoUrl ==
                                      null

                                  ? const Icon(
                                Icons.person,
                                color: Colors.white,
                              )

                                  : null,
                            ),

                            const SizedBox(width: 14),

                            Expanded(

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    fullNameController
                                        .text
                                        .isEmpty

                                        ? "Utilisateur"

                                        : fullNameController
                                        .text,

                                    style:
                                    const TextStyle(

                                      color: Colors.white,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(

                                    role.toUpperCase(),

                                    style: TextStyle(

                                      color: Colors
                                          .white
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

                padding:
                EdgeInsets.symmetric(

                  horizontal:
                  isDesktop ? 40 : 18,

                  vertical: 24,
                ),

                child: Center(

                  child: ConstrainedBox(

                    constraints:
                    const BoxConstraints(
                      maxWidth: 1100,
                    ),

                    child: Form(

                      key: _formKey,

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          /// =====================================
                          /// TOP BAR
                          /// =====================================

                          Row(

                            children: [

                              if (!isDesktop)

                                IconButton(

                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.arrow_back,
                                  ),
                                ),

                              const Spacer(),

                              Container(

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors.secondColor .withValues(
                                    alpha: .1,
                                  ),

                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Text(

                                  isEdit

                                      ? "MODE ÉDITION"

                                      : "NOUVEAU",

                                  style:
                                  const TextStyle(
                                    color: AppColors.secondColor,
                                    fontWeight: FontWeight .bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// =====================================
                          /// TITLE
                          /// =====================================

                          Text(

                            isEdit

                                ? "Modifier un utilisateur"

                                : "Créer un utilisateur",

                            style: const TextStyle(

                              fontSize: 34,

                              fontWeight:
                              FontWeight.bold,

                              color:
                              Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(

                            "Ajoutez les informations principales du compte utilisateur et configurez ses accès.",

                            style: TextStyle(

                              color:
                              Colors.grey.shade600,

                              height: 1.5,

                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// =====================================
                          /// PROFILE CARD
                          /// =====================================

                          Container(

                            padding:
                            const EdgeInsets.all(24),

                            decoration:
                            BoxDecoration(

                              color: Colors.white,

                              borderRadius:
                              BorderRadius.circular(
                                28,
                              ),

                              boxShadow: [

                                BoxShadow(

                                  color:
                                  Colors.black
                                      .withValues(
                                    alpha: .04,
                                  ),

                                  blurRadius: 25,

                                  offset:
                                  const Offset(
                                    0,
                                    10,
                                  ),
                                ),
                              ],
                            ),

                            child: Row(

                              children: [

                                InkWell(

                                  borderRadius:
                                  BorderRadius.circular(
                                    100,
                                  ),

                                  onTap: pickImage,

                                  child: CircleAvatar(

                                    radius: 45,

                                    backgroundColor: AppColors.secondColor,

                                    backgroundImage: profileImage != null
                                        ? FileImage(profileImage!)
                                        : uploadedPhotoUrl != null

                                        ? NetworkImage(uploadedPhotoUrl!)
                                        : null,

                                    child: profileImage ==  null &&
                                        uploadedPhotoUrl ==  null

                                        ? const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),

                                const SizedBox(width: 20),

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [

                                      const Text(

                                        "Photo de profil",

                                        style: TextStyle(

                                          fontSize: 18,

                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      Text(

                                        "Ajoutez une photo pour personnaliser le compte utilisateur.",

                                        style: TextStyle(
                                          color:
                                          Colors.grey
                                              .shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// =====================================
                          /// FORM GRID
                          /// =====================================

                          Wrap(

                            spacing: 20,

                            runSpacing: 20,

                            children: [

                              _buildInput(
                                controller: firstNameController,
                                label: "Prénom",
                                icon: Icons.badge,
                              ),

                              _buildInput(
                                controller: lastNameController,
                                label: "Nom",
                                icon: Icons.badge_outlined,
                              ),

                              _buildInput(
                                controller: phoneController,
                                label: "Téléphone",
                                icon: Icons.phone,
                              ),

                              _buildInput(
                                controller:
                                emailController,
                                label: "Email",
                                icon:
                                Icons.email,
                              ),

                              _buildInput(
                                controller:
                                passwordController,
                                label: "Mot de passe",
                                icon:Icons.lock,
                                obscure: true,
                              ),

                              _buildInput(
                                controller:
                                cityController,
                                label: "Ville",
                                icon:
                                Icons.location_city,
                              ),

                              _buildInput(
                                controller:
                                districtController,
                                label: "Quartier",
                                icon:
                                Icons.map,
                              ),

                              _buildInput(
                                controller:
                                addressController,
                                label: "Adresse",
                                icon:
                                Icons.home,
                              ),

                              _buildInput(
                                controller:
                                walletController,
                                label:
                                "Solde Wallet",
                                icon:
                                Icons.wallet,
                              ),

                              _buildInput(
                                controller:
                                earningsController,
                                label:
                                "Total gains",
                                icon:
                                Icons.attach_money,
                              ),

                              _buildInput(
                                controller:
                                spentController,
                                label:
                                "Total dépenses",
                                icon:
                                Icons.money_off,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// =====================================
                          /// OPTIONS
                          /// =====================================

                          Container(

                            padding:
                            const EdgeInsets.all(24),

                            decoration:
                            BoxDecoration(

                              color: Colors.white,

                              borderRadius:
                              BorderRadius.circular(
                                28,
                              ),

                              boxShadow: [

                                BoxShadow(

                                  color:
                                  Colors.black
                                      .withValues(
                                    alpha: .04,
                                  ),

                                  blurRadius: 25,

                                  offset:
                                  const Offset(
                                    0,
                                    10,
                                  ),
                                ),
                              ],
                            ),

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                const Text(

                                  "Configuration",

                                  style: TextStyle(

                                    fontSize: 20,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Wrap(

                                  spacing: 20,

                                  runSpacing: 20,

                                  children: [

                                    _buildDropdown(
                                      value: gender,
                                      label: "Genre",
                                      items: const [
                                        'Masculin',
                                        'Féminin',
                                        'Choisir un genre'
                                      ],
                                      onChanged: (genderValue) {
                                        setState(() {
                                          gender = genderValue!;
                                        });
                                      },
                                    ),

                                    _buildDropdown(
                                      value: role,
                                      label: "Rôle",
                                      items: const [
                                        'passenger',
                                        'driver',
                                        'admin',
                                        'support',
                                      ],
                                      onChanged: (userRole) {
                                        setState(() {
                                          role = userRole!;
                                        });
                                      },
                                    ),

                                    _buildDropdown(
                                      value: status,
                                      label: "Statut",
                                      items: const [
                                        'active',
                                        'blocked',
                                        'pending',
                                      ],
                                      onChanged: (userStatus) {
                                        setState(() {
                                          status = userStatus!;
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                Wrap(

                                  spacing: 12,

                                  runSpacing: 12,

                                  children: [

                                    _buildCheck(
                                      "Compte vérifié",
                                      isVerified,
                                          (v) {
                                        setState(() {
                                          isVerified = v;
                                        });
                                      },
                                    ),

                                    _buildCheck(
                                      "KYC validé",
                                      kycValidated,
                                          (v) {
                                        setState(() {
                                          kycValidated =
                                              v;
                                        });
                                      },
                                    ),

                                    _buildCheck(
                                      "Téléphone vérifié",
                                      phoneVerified,
                                          (v) {
                                        setState(() {
                                          phoneVerified =
                                              v;
                                        });
                                      },
                                    ),

                                    _buildCheck(
                                      "Email vérifié",
                                      emailVerified,
                                          (v) {
                                        setState(() {
                                          emailVerified =
                                              v;
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                InkWell(

                                  onTap:
                                  selectBirthDate,

                                  child: Container(

                                    padding: const EdgeInsets.all(
                                      18,
                                    ),

                                    decoration: BoxDecoration(

                                      color: Colors.grey.shade50,

                                      borderRadius: BorderRadius.circular(
                                        18,
                                      ),

                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),

                                    child: Row(

                                      children: [

                                        const Icon(
                                          Icons.cake,
                                          color: AppColors.secondColor,
                                        ),

                                        const SizedBox(
                                          width: 12,
                                        ),

                                        Expanded(

                                          child: Text(

                                            birthDate == null
                                                ? "Sélectionner une date de naissance"
                                                : DateFormat('dd/MM/yyyy',
                                            ).format(birthDate!),

                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// =====================================
                          /// BUTTON
                          /// =====================================

                          SizedBox(

                            width: double.infinity,

                            height: 60,

                            child: ElevatedButton(
                              onPressed: loading ? null : saveUser,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),

                              child: loading ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:  CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(isEdit
                                    ? "Mettre à jour"
                                    : "Créer l'utilisateur",

                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
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

  /// =============================================================
  /// INPUT
  /// =============================================================

  Widget _buildInput({

    required TextEditingController controller,

    required String label,

    required IconData icon,

    bool obscure = false,

  }) {

    return SizedBox(

      width: 340,

      child: TextFormField(

        controller: controller,

        obscureText: obscure,

        validator: (inputValue) {

          if (inputValue == null || inputValue.trim().isEmpty) {
            return "Merci d'indiquer votre réponse ";
          }

          return null;
        },

        decoration: InputDecoration(

          labelText: label,

          prefixIcon: Icon(
            icon,
            color: AppColors.secondColor,
          ),

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// DROPDOWN
  /// =============================================================

  Widget _buildDropdown({required String value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,

  }) {

    return SizedBox(

      width: 250,

      child: DropdownButtonFormField<String>(

        initialValue: value,

        onChanged: onChanged,

        decoration: InputDecoration(

          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),

        items: items.map((element) {

          return DropdownMenuItem(
            value: element,
            child: Text(element),
          );

        }).toList(),
      ),
    );
  }

  /// =============================================================
  /// CHECKBOX
  /// =============================================================

  Widget _buildCheck(

      String title,

      bool value,

      Function(bool) onChanged,

      ) {

    return InkWell(

      borderRadius: BorderRadius.circular(16),

      onTap: () {

        onChanged(!value);
      },

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        decoration: BoxDecoration(
          color: value
              ? AppColors.secondColor.withValues(
            alpha: .08,
          )
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? AppColors.secondColor
                : Colors.grey.shade200,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(

              value ? Icons.check_circle
                  : Icons.circle_outlined,

              color: value
                  ? AppColors.secondColor
                  : Colors.grey,
            ),

            const SizedBox(width: 10),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: value
                    ? AppColors.secondColor
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}