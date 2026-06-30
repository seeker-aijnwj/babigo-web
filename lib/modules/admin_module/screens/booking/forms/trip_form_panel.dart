import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../database/models/admin/trip_ad.dart';

/// ===============================================================
/// TRIP FORM PANEL
/// ===============================================================
///
/// OBJECTIF
/// ---------
///
/// Formulaire complet pour :
///
/// ✅ Ajouter un trajet
/// ✅ Modifier un trajet
/// ✅ Validation complète
/// ✅ Gestion des erreurs
/// ✅ Sauvegarde Firebase
/// ✅ UI Desktop moderne
/// ✅ Réutilisable partout
///
/// Compatible :
///
/// ✅ Mobile
/// ✅ Desktop
/// ✅ Web
///
/// ===============================================================

/// ===============================================================
/// CALLBACK
/// ===============================================================

typedef OnTripSaved = void Function(
    TripAd trip,
    );

/// ===============================================================
/// TRIP FORM PANEL
/// ===============================================================

class TripFormPanel extends StatefulWidget {

  /// =============================================================
  /// TRAJET EXISTANT
  /// =============================================================

  final TripAd? trip;

  /// =============================================================
  /// CALLBACK SUCCESS
  /// =============================================================

  final OnTripSaved? onSaved;

  const TripFormPanel({
    super.key,
    this.trip,
    this.onSaved,
  });

  @override
  State<TripFormPanel> createState() =>
      _TripFormPanelState();
}

class _TripFormPanelState
    extends State<TripFormPanel> {

  /// =============================================================
  /// FORM KEY
  /// =============================================================

  final _formKey =
  GlobalKey<FormState>();

  /// =============================================================
  /// LOADING
  /// =============================================================

  bool _isLoading = false;

  /// =============================================================
  /// ERROR MESSAGE
  /// =============================================================

  String? _error;

  /// =============================================================
  /// CONTROLLERS
  /// =============================================================

  late TextEditingController
  _driverIdController;

  late TextEditingController
  _vehicleIdController;

  late TextEditingController
  _driverNameController;

  late TextEditingController
  _driverPhoneController;

  late TextEditingController
  _departureCityController;

  late TextEditingController
  _destinationCityController;

  late TextEditingController
  _departureAddressController;

  late TextEditingController
  _destinationAddressController;

  late TextEditingController
  _seatPriceController;

  late TextEditingController
  _packagePriceController;

  late TextEditingController
  _totalSeatsController;

  late TextEditingController
  _descriptionController;

  /// =============================================================
  /// DROPDOWNS
  /// =============================================================

  TripStatus _status =
      TripStatus.published;

  AppNavigationMode _navigationMode =
      AppNavigationMode.map;

  /// =============================================================
  /// SWITCHES
  /// =============================================================

  bool _acceptsPackages = true;

  bool _acceptsWomenOnly = false;

  bool _airConditioned = true;

  bool _petsAllowed = false;

  bool _smokingAllowed = false;

  bool _musicAllowed = true;

  /// =============================================================
  /// DATE
  /// =============================================================

  DateTime _departureDateTime =
  DateTime.now();

  /// =============================================================
  /// INIT
  /// =============================================================

  @override
  void initState() {

    super.initState();

    final trip = widget.trip;

    _driverIdController =
        TextEditingController(
          text: trip?.driverId ?? '',
        );

    _vehicleIdController =
        TextEditingController(
          text: trip?.vehicleId ?? '',
        );

    _driverNameController =
        TextEditingController(
          text: trip?.driverName ?? '',
        );

    _driverPhoneController =
        TextEditingController(
          text: trip?.driverPhone ?? '',
        );

    _departureCityController =
        TextEditingController(
          text: trip?.departureCity ?? '',
        );

    _destinationCityController =
        TextEditingController(
          text: trip?.destinationCity ?? '',
        );

    _departureAddressController =
        TextEditingController(
          text: trip?.departureAddress ?? '',
        );

    _destinationAddressController =
        TextEditingController(
          text: trip?.destinationAddress ?? '',
        );

    _seatPriceController =
        TextEditingController(
          text: trip?.seatPrice
              .toString() ??
              '',
        );

    _packagePriceController =
        TextEditingController(
          text: trip?.packagePrice
              .toString() ??
              '',
        );

    _totalSeatsController =
        TextEditingController(
          text: trip?.totalSeats
              .toString() ??
              '',
        );

    _descriptionController =
        TextEditingController(
          text: trip?.description ?? '',
        );

    if (trip != null) {

      _status = trip.status;

      _navigationMode =
          trip.navigationMode;

      _departureDateTime =
          trip.departureDateTime;

      _acceptsPackages =
          trip.acceptsPackages;

      _acceptsWomenOnly =
          trip.acceptsWomenOnly;

      _airConditioned =
          trip.airConditioned;

      _petsAllowed =
          trip.petsAllowed;

      _smokingAllowed =
          trip.smokingAllowed;

      _musicAllowed =
          trip.musicAllowed;
    }
  }

  /// =============================================================
  /// DISPOSE
  /// =============================================================

  @override
  void dispose() {

    _driverIdController.dispose();

    _vehicleIdController.dispose();

    _driverNameController.dispose();

    _driverPhoneController.dispose();

    _departureCityController.dispose();

    _destinationCityController.dispose();

    _departureAddressController.dispose();

    _destinationAddressController.dispose();

    _seatPriceController.dispose();

    _packagePriceController.dispose();

    _totalSeatsController.dispose();

    _descriptionController.dispose();

    super.dispose();
  }

  /// =============================================================
  /// BUILD
  /// =============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      appBar: AppBar(

        title: Text(

          widget.trip == null
              ? "Nouveau trajet"
              : "Modifier trajet",
        ),
      ),

      body: Form(

        key: _formKey,

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// =================================================
              /// ERROR
              /// =================================================

              if (_error != null)

                Container(

                  margin:
                  const EdgeInsets.only(
                    bottom: 20,
                  ),

                  padding:
                  const EdgeInsets.all(
                    16,
                  ),

                  decoration: BoxDecoration(

                    color:
                    Colors.red.shade50,

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Row(

                    children: [

                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Text(
                          _error!,
                        ),
                      ),
                    ],
                  ),
                ),

              /// =================================================
              /// SECTION CHAUFFEUR
              /// =================================================

              _sectionTitle(
                "Informations chauffeur",
              ),

              _input(
                controller:
                _driverNameController,
                label: "Nom chauffeur",
                icon: Icons.person,
              ),

              _input(
                controller:
                _driverPhoneController,
                label: "Téléphone",
                icon: Icons.phone,
              ),

              _input(
                controller:
                _driverIdController,
                label: "ID Chauffeur",
                icon: Icons.badge,
              ),

              /// =================================================
              /// SECTION TRAJET
              /// =================================================

              _sectionTitle(
                "Informations trajet",
              ),

              _input(
                controller:
                _departureCityController,
                label: "Ville départ",
                icon: Icons.trip_origin,
              ),

              _input(
                controller:
                _destinationCityController,
                label: "Ville arrivée",
                icon: Icons.location_on,
              ),

              _input(
                controller:
                _departureAddressController,
                label: "Adresse départ",
                icon: Icons.map,
              ),

              _input(
                controller:
                _destinationAddressController,
                label: "Adresse arrivée",
                icon: Icons.map_outlined,
              ),

              /// =================================================
              /// DATE
              /// =================================================

              const SizedBox(height: 20),

              ListTile(

                tileColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),

                leading:
                const Icon(Icons.event),

                title: const Text(
                  "Date départ",
                ),

                subtitle: Text(
                  _departureDateTime
                      .toString(),
                ),

                onTap: _pickDate,
              ),

              /// =================================================
              /// PRIX
              /// =================================================

              _sectionTitle(
                "Prix",
              ),

              _input(
                controller:
                _seatPriceController,
                label: "Prix siège",
                icon: Icons.payments,
                keyboard:
                TextInputType.number,
              ),

              _input(
                controller:
                _packagePriceController,
                label: "Prix colis",
                icon: Icons.inventory,
                keyboard:
                TextInputType.number,
              ),

              _input(
                controller:
                _totalSeatsController,
                label: "Nombre places",
                icon: Icons.event_seat,
                keyboard:
                TextInputType.number,
              ),

              /// =================================================
              /// DESCRIPTION
              /// =================================================

              _sectionTitle(
                "Description",
              ),

              TextFormField(

                controller:
                _descriptionController,

                maxLines: 5,

                decoration:
                InputDecoration(

                  labelText:
                  "Description trajet",

                  filled: true,

                  fillColor: Colors.white,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),

              /// =================================================
              /// OPTIONS
              /// =================================================

              _sectionTitle(
                "Options",
              ),

              _switchTile(
                "Accepte colis",
                _acceptsPackages,
                    (v) => setState(() =>
                _acceptsPackages = v),
              ),

              _switchTile(
                "Climatisation",
                _airConditioned,
                    (v) => setState(() =>
                _airConditioned = v),
              ),

              _switchTile(
                "Animaux autorisés",
                _petsAllowed,
                    (v) => setState(() =>
                _petsAllowed = v),
              ),

              _switchTile(
                "Musique autorisée",
                _musicAllowed,
                    (v) => setState(() =>
                _musicAllowed = v),
              ),

              _switchTile(
                "Fumeurs autorisés",
                _smokingAllowed,
                    (v) => setState(() =>
                _smokingAllowed = v),
              ),

              /// =================================================
              /// SAVE BUTTON
              /// =================================================

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton.icon(

                  onPressed: _isLoading
                      ? null
                      : _saveTrip,

                  icon: _isLoading

                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )

                      : const Icon(Icons.save),

                  label: Text(

                    widget.trip == null
                        ? "ENREGISTRER"
                        : "MODIFIER",
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// SECTION TITLE
  /// =============================================================

  Widget _sectionTitle(String title) {

    return Padding(

      padding:
      const EdgeInsets.only(
        top: 24,
        bottom: 14,
      ),

      child: Text(

        title,

        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// =============================================================
  /// INPUT
  /// =============================================================

  Widget _input({

    required TextEditingController
    controller,

    required String label,

    required IconData icon,

    TextInputType keyboard =
        TextInputType.text,
  }) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 14,
      ),

      child: TextFormField(

        controller: controller,

        keyboardType: keyboard,

        validator: (value) {

          if (value == null ||
              value.trim().isEmpty) {

            return "Champ obligatoire";
          }

          return null;
        },

        decoration: InputDecoration(

          labelText: label,

          prefixIcon: Icon(icon),

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// SWITCH TILE
  /// =============================================================

  Widget _switchTile(

      String title,

      bool value,

      Function(bool) onChanged,
      ) {

    return SwitchListTile(

      value: value,

      onChanged: onChanged,

      title: Text(title),

      contentPadding: EdgeInsets.zero,
    );
  }

  /// =============================================================
  /// DATE PICKER
  /// =============================================================

  Future<void> _pickDate() async {

    final date =
    await showDatePicker(

      context: context,

      firstDate: DateTime.now(),

      lastDate:
      DateTime.now().add(
        const Duration(days: 365),
      ),

      initialDate: _departureDateTime,
    );

    if (date == null) return;

    setState(() {

      _departureDateTime = date;
    });
  }

  /// =============================================================
  /// SAVE TRIP
  /// =============================================================

  Future<void> _saveTrip() async {

    /// Validation
    if (!_formKey.currentState!
        .validate()) {

      setState(() {
        _error =
        "Veuillez corriger les erreurs.";
      });

      return;
    }

    try {

      setState(() {

        _isLoading = true;

        _error = null;
      });

      /// =========================================================
      /// CREATE TRIP
      /// =========================================================

      final trip = TripAd(

        id: widget.trip?.id ?? '',

        driverId:
        _driverIdController.text,

        vehicleId:
        _vehicleIdController.text,

        driverName:
        _driverNameController.text,

        driverPhone:
        _driverPhoneController.text,

        departureCity:
        _departureCityController.text,

        destinationCity:
        _destinationCityController.text,

        departureAddress:
        _departureAddressController
            .text,

        destinationAddress:
        _destinationAddressController
            .text,

        seatPrice: double.parse(
          _seatPriceController.text,
        ),

        packagePrice: double.parse(
          _packagePriceController.text,
        ),

        totalSeats: int.parse(
          _totalSeatsController.text,
        ),

        description:
        _descriptionController.text,

        acceptsPackages:
        _acceptsPackages,

        acceptsWomenOnly:
        _acceptsWomenOnly,

        airConditioned:
        _airConditioned,

        petsAllowed:
        _petsAllowed,

        smokingAllowed:
        _smokingAllowed,

        musicAllowed:
        _musicAllowed,

        status: _status,

        navigationMode:
        _navigationMode,

        departureDateTime:
        _departureDateTime,

        createdAt:
        widget.trip?.createdAt ??
            DateTime.now(),

        updatedAt: DateTime.now(),

        vehicleColor: '',

        vehicleModel: '',

        currentSpeedKmH: 0.0,

        vehiclePlateNumber: '',

        driverPhoto: '',

        driverRating: 0.0,

        driverTripsCount: 0,

        departureLatitude: 0.0,

        departureLongitude: 0.0,

        destinationLatitude: 0.0,

        destinationLongitude: 0.0,

        stops: [],

        tracking: null,

        currentLocationLabel: '',

        totalDistanceKm: 0.0,

        estimatedArrival: DateTime.now(),

        reservedSeats: 0,

        passengerIds: [],

        refundedAmount: 0.0,

        pendingAmount: 0.0,

        totalPaidAmount: 0.0,

        totalRevenue: 0.0,
      );

      /// =========================================================
      /// SAVE FIREBASE
      /// =========================================================

      final ref = FirebaseFirestore
          .instance
          .collection('trips');

      if (widget.trip == null) {

        await ref.add(
          trip.toJson(),
        );

      } else {

        await ref
            .doc(widget.trip!.id)
            .update(
          trip.toJson(),
        );
      }

      widget.onSaved?.call(trip);

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
            Text("Trajet enregistré"),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      setState(() {

        _error = e.toString();
      });

    } finally {

      setState(() {

        _isLoading = false;
      });
    }
  }
}