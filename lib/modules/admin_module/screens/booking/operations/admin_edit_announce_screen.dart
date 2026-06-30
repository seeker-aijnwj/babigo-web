import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/core/utils/colors.dart';
import '../../../../booking_module/models/announce_data.dart';
import '../../../../booking_module/widgets/announce_form.dart';

class AdminEditAnnounceScreen extends StatefulWidget {
  /// users/{uid}/announces/{announceId}
  final DocumentReference annonceRef;

  const AdminEditAnnounceScreen({
    super.key,
    required this.annonceRef,
  });

  @override
  State<AdminEditAnnounceScreen> createState() =>
      _AdminEditAnnounceScreenState();
}

class _AdminEditAnnounceScreenState
    extends State<AdminEditAnnounceScreen> {

  /// ==========================================================
  /// ETAT
  /// ==========================================================

  AnnounceData? _currentData;

  bool _saving = false;

  /// ==========================================================
  /// SNACKBAR MODERNE
  /// ==========================================================

  void _showMessage(String message) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(message),

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.all(16),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  /// ==========================================================
  /// FIRESTORE -> ANNOUNCEDATA
  /// ==========================================================

  AnnounceData _mapFirestoreToData(
      Map<String, dynamic> data,
      ) {

    DateTime? date;
    TimeOfDay? time;

    final departureAt = data['departureAt'];

    if (departureAt is Timestamp) {

      final dt = departureAt.toDate();

      date = DateTime(
        dt.year,
        dt.month,
        dt.day,
      );

      time = TimeOfDay(
        hour: dt.hour,
        minute: dt.minute,
      );
    }

    final stopsRaw = data['stops'];

    final List<String> stops =
    stopsRaw is List
        ? stopsRaw.map((e) => e.toString()).toList()
        : [];

    return AnnounceData(

      depart:
      data['depart']?.toString() ??
          data['departure']?.toString() ??
          '',

      destination:
      data['destination']?.toString() ??
          '',

      meetingPlace:
      data['meetingPlace']?.toString() ??
          '',

      arrivalPlace:
      data['arrivalPlace']?.toString() ??
          '',

      stops: stops,

      date: date,

      time: time,

      seats: data['seats'] is int
          ? data['seats']
          : int.tryParse(
        data['seats']?.toString() ?? '',
      ),

      price: data['price'] is int
          ? data['price']
          : int.tryParse(
        data['price']?.toString() ?? '',
      ),
    );
  }

  /// ==========================================================
  /// ANNOUNCEDATA -> UPDATE MAP
  /// ==========================================================

  Map<String, dynamic> _buildUpdatePayload(
      AnnounceData announceData,
      ) {

    Timestamp? departureAt;

    String? timeText;

    if (
    announceData.date != null &&
        announceData.time != null
    ) {

      final dateTime = DateTime(

        announceData.date!.year,

        announceData.date!.month,

        announceData.date!.day,

        announceData.time!.hour,

        announceData.time!.minute,
      );

      departureAt =
          Timestamp.fromDate(dateTime);

      timeText =
      '${announceData.time!.hour.toString().padLeft(2, '0')}:'
          '${announceData.time!.minute.toString().padLeft(2, '0')}';
    }

    return {

      'depart': announceData.depart,

      'destination':
      announceData.destination,

      'meetingPlace':
      announceData.meetingPlace,

      'arrivalPlace':
      announceData.arrivalPlace,

      'stops': announceData.stops,

      'seats': announceData.seats,

      'price': announceData.price,

      'departureAt': departureAt,

      'timeText': timeText,

      'updatedAt':
      FieldValue.serverTimestamp(),
    };
  }

  /// ==========================================================
  /// SAVE
  /// ==========================================================

  Future<void> _save() async {

    if (_currentData == null) {

      _showMessage(
        "Veuillez compléter le formulaire.",
      );

      return;
    }

    if (_currentData!.depart.isEmpty ||
        _currentData!.destination.isEmpty) {

      _showMessage(
        "Départ et destination obligatoires.",
      );

      return;
    }

    try {

      setState(() {
        _saving = true;
      });

      await widget.annonceRef.update(
        _buildUpdatePayload(
          _currentData!,
        ),
      );

      if (!mounted) return;

      _showMessage(
        "Annonce mise à jour avec succès.",
      );

      Navigator.pop(context, true);

    }

    on FirebaseException catch (e) {

      _showMessage(
        e.message ??
            "Erreur Firebase",
      );

    }

    catch (e) {

      _showMessage(
        "Erreur : $e",
      );

    }

    finally {

      if (mounted) {

        setState(() {
          _saving = false;
        });
      }
    }
  }

  /// ==========================================================
  /// HEADER
  /// ==========================================================

  Widget _buildHeader() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          colors: [

            AppColors.mainColor,

            AppColors.mainColor.withValues(
              alpha: .75,
            ),
          ],
        ),

        borderRadius:
        const BorderRadius.only(

          bottomLeft:
          Radius.circular(28),

          bottomRight:
          Radius.circular(28),
        ),
      ),

      child: const Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(height: 10),

          Text(

            "Modifier l'annonce",

            style: TextStyle(

              color: Colors.white,

              fontSize: 24,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          Text(

            "Modifiez les informations du trajet.",

            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(

      stream:
      widget.annonceRef.snapshots(),

      builder: (
          context,
          snapshot,
          ) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(

            body: Center(
              child:
              CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {

          return Scaffold(

            body: Center(

              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        }

        if (!snapshot.hasData ||
            !snapshot.data!.exists) {

          return const Scaffold(

            body: Center(

              child: Text(
                "Annonce introuvable",
              ),
            ),
          );
        }

        final firestoreData =
        snapshot.data!.data()
        as Map<String, dynamic>;

        final initialData =
        _mapFirestoreToData(
          firestoreData,
        );

        _currentData ??=
            initialData;

        return Scaffold(

          backgroundColor: AppColors.backgroundColor,

          body: Column(

            children: [

              _buildHeader(),

              Expanded(

                child: SingleChildScrollView(

                  padding: const EdgeInsets.all(20),

                  child: Card(

                    elevation: 0,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(20),

                      child: AnnounceForm(
                        initialData: _currentData,
                        onChanged: (value) {

                          _currentData = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton.extended(

            backgroundColor: AppColors.secondColor,

            onPressed: _saving ? null : _save,

            icon: _saving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )

                : const Icon(
              Icons.save,
              color: Colors.white,
            ),

            label: Text(
              _saving ? "Enregistrement..." : "Enregistrer",

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}