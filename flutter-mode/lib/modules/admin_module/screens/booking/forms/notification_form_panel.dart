/// =============================================================================
/// FILE : app_notification_form.dart
/// =============================================================================
///
/// MODÈLE + FORMULAIRE COMPLET DE GESTION DES NOTIFICATIONS
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
/// ✅ Création notification
/// ✅ Modification notification
/// ✅ Lecture notification
/// ✅ Gestion payload dynamique
/// ✅ Notification liée à un trajet
/// ✅ Notification liée à un utilisateur
/// ✅ Gestion type notification
/// ✅ Validation
/// ✅ Sauvegarde Firestore
/// ✅ UI responsive
/// ✅ Réutilisable partout
///
/// =============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../database/models/admin/notification.dart';

/// =============================================================================
/// FORMULAIRE NOTIFICATION
/// =============================================================================

class AppNotificationForm
    extends StatefulWidget {
  /// Notification à modifier
  final AppNotification? notification;

  /// Callback succès
  final VoidCallback? onSuccess;

  const AppNotificationForm({
    super.key,
    this.notification,
    this.onSuccess,
  });

  @override
  State<AppNotificationForm> createState() =>
      _AppNotificationFormState();
}

class _AppNotificationFormState
    extends State<AppNotificationForm> {
  /// ===========================================================================
  /// FORM KEY
  /// ===========================================================================

  final _formKey = GlobalKey<FormState>();

  /// ===========================================================================
  /// CONTROLLERS
  /// ===========================================================================

  final _titleController =
  TextEditingController();

  final _messageController =
  TextEditingController();

  final _userIdController =
  TextEditingController();

  final _tripIdController =
  TextEditingController();

  final _senderController =
  TextEditingController();

  final _payloadController =
  TextEditingController();

  /// ===========================================================================
  /// VARIABLES
  /// ===========================================================================

  NotificationType _notifType =
      NotificationType.tripInProgress;

  bool _isRead = false;

  bool _loading = false;

  /// ===========================================================================
  /// INIT
  /// ===========================================================================

  @override
  void initState() {
    super.initState();

    final notif = widget.notification;

    if (notif != null) {
      _titleController.text = notif.title;

      _messageController.text =
          notif.message;

      _userIdController.text =
          notif.userId;

      _tripIdController.text =
          notif.tripId;

      _senderController.text =
          notif.senderName;

      _payloadController.text =
          const JsonEncoder.withIndent(
            '  ',
          ).convert(notif.payload);

      _notifType = notif.notifType;

      _isRead = notif.isRead;
    }
  }

  /// ===========================================================================
  /// DISPOSE
  /// ===========================================================================

  @override
  void dispose() {
    _titleController.dispose();

    _messageController.dispose();

    _userIdController.dispose();

    _tripIdController.dispose();

    _senderController.dispose();

    _payloadController.dispose();

    super.dispose();
  }

  /// ===========================================================================
  /// SAVE
  /// ===========================================================================

  Future<void> _saveNotification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      Map<String, dynamic> payload = {};

      /// Parse payload JSON
      if (_payloadController
          .text
          .trim()
          .isNotEmpty) {
        payload = jsonDecode(
          _payloadController.text.trim(),
        );
      }

      final notification = AppNotification(
        id: widget.notification?.id ?? '',

        createdAt:
        widget.notification?.createdAt ??
            DateTime.now(),

        updatedAt: DateTime.now(),

        message:
        _messageController.text.trim(),

        payload: payload,

        isRead: _isRead,

        title:
        _titleController.text.trim(),

        tripId:
        _tripIdController.text.trim(),

        userId:
        _userIdController.text.trim(),

        type: PublicationType.notification,

        notifType: _notifType,

        senderName:
        _senderController.text.trim(),
      );

      /// UPDATE
      if (widget.notification != null) {
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(notification.id)
            .update(notification.toJson());
      }

      /// CREATE
      else {
        await FirebaseFirestore.instance
            .collection('notifications')
            .add(notification.toJson());
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Notification enregistrée",
            ),
          ),
        );

        widget.onSuccess?.call();
      }
    } catch (e) {
      debugPrint(
        "Erreur notification : $e",
      );

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
      appBar: AppBar(
        title: Text(
          widget.notification == null
              ? "Nouvelle notification"
              : "Modifier notification",
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Container(
            constraints:
            const BoxConstraints(
              maxWidth: 850,
            ),

            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
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
                  const Text(
                    "Informations Notification",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// TITLE
                  TextFormField(
                    controller:
                    _titleController,

                    decoration:
                    const InputDecoration(
                      labelText: "Titre",
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

                  /// MESSAGE
                  TextFormField(
                    controller:
                    _messageController,

                    maxLines: 5,

                    decoration:
                    const InputDecoration(
                      labelText: "Message",
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

                  /// USER ID
                  TextFormField(
                    controller:
                    _userIdController,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Utilisateur ID",
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TRIP ID
                  TextFormField(
                    controller:
                    _tripIdController,

                    decoration:
                    const InputDecoration(
                      labelText: "Trip ID",
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SENDER
                  TextFormField(
                    controller:
                    _senderController,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Nom expéditeur",
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TYPE
                  DropdownButtonFormField<
                      NotificationType>(
                    value: _notifType,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Type Notification",
                      border:
                      OutlineInputBorder(),
                    ),

                    items:
                    NotificationType.values
                        .map(
                          (type) =>
                          DropdownMenuItem(
                            value: type,

                            child: Text(
                              type.label,
                            ),
                          ),
                    )
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        _notifType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// PAYLOAD
                  TextFormField(
                    controller:
                    _payloadController,

                    maxLines: 8,

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Payload JSON",

                      hintText:
                      '{ "tripId": "123" }',

                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// READ
                  SwitchListTile(
                    value: _isRead,

                    title:
                    const Text("Notification lue"),

                    onChanged: (value) {
                      setState(() {
                        _isRead = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed:
                      _loading
                          ? null
                          : _saveNotification,

                      child:
                      _loading
                          ? const CircularProgressIndicator()
                          : Text(
                        widget.notification ==
                            null
                            ? "Créer Notification"
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